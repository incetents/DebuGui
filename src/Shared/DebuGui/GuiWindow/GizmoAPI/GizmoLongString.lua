-- © 2021 Emmanuel Lajeunesse

-- Module
local GizmoLongString = {}

-- Modules
local GizmoBase = require(script.Parent.GizmoBase)
local Utility = require(script.Parent.Parent.Parent.Utility)

----------------
-- Public API --
----------------
function GizmoLongString.new(Gui, Name, ParentAPI, DefaultValue, Height)

	-- Defaults
	DefaultValue = DefaultValue or ''
	Height = Height or 48

	-- Sanity
	Utility.QuickTypeAssert(Name, 'string')
	Utility.QuickTypeAssert(DefaultValue, 'string')
	Utility.QuickTypeAssert(Height, 'number')

	-- Setup
	Gui.TextName.Text = Name
	Gui.TextBox.Text = DefaultValue
	Gui.Size = UDim2.new(1, 0, 0, Height)

	-- Data
	local IsReadOnly = false
	local API = GizmoBase.New()

	----------------
	-- Public API --
	----------------
	function API.Validate(Input)
		if API._DeadCheck() then return nil end
		local Str = tostring(Input)
		if Str then
			Gui.TextBox.Text = Str
			API._Input = Str
			return true
		else
			Gui.TextBox.Text = API._Input
			return false
		end
	end

	function API.SetName(NewName)
		if API._DeadCheck() then return nil end
		Gui.TextName.Text = NewName
		return API
	end

	function API.SetNameColor(NewNameColor)
		if API._DeadCheck() then return nil end
		Gui.TextName.TextColor3 = NewNameColor
		return API
	end

	function API.SetValueBGColor(NewColor)
		if API._DeadCheck() then return nil end
		Gui.TextBox.BackgroundColor3 = NewColor
		return API
	end

	function API.SetValueTextColor(NewColor)
		if API._DeadCheck() then return nil end
		Gui.TextBox.TextColor3 = NewColor
		return API
	end

	function API.IsReadOnly()
		if API._DeadCheck() then return nil end
		return IsReadOnly
	end

	function API.SetReadOnly(State)
		if API._DeadCheck() then return nil end
		-- Set
		if State == nil then
			IsReadOnly = true
		else
			IsReadOnly = State
		end
		-- Apply
		if IsReadOnly then
			Gui.TextBox.TextEditable = false
			Gui.TextBox.TextTransparency = 0.5
			Gui.TextName.TextTransparency = 0.5
		else
			Gui.TextBox.TextEditable = true
			Gui.TextBox.TextTransparency = 0.0
			Gui.TextName.TextTransparency = 0.0
		end
		return API
	end

	function API.SetHeight(NewHeight)
		if API._DeadCheck() then return nil end
		-- Modify Gui Size
		local OCHeight = Gui.Size.Y.Offset
        Gui.Size = UDim2.new(1, 0, 0, NewHeight)

		-- Modify Canvas Height based on change in height
		if Utility.IsFolderVisible(ParentAPI, true) then
			local DeltaHeight = NewHeight - OCHeight
			Utility.ModifyCanvasHeight(ParentAPI._MasterAPI._GuiParent, DeltaHeight)
		end
	end

	function API.SetHeightBasedOnLineCount(LineCount)
		local YOffset = Gui.TextBox.Size.Y.Offset
		API.SetHeight(-YOffset + LineCount * Gui.TextBox.TextSize)
	end

	-- Update Values
	API._AddConnection(Gui.TextBox.FocusLost:Connect(function(__) -- enterPressed
		if IsReadOnly then
			return
		end

		if API.Validate(Gui.TextBox.Text) then
			API.TriggerListeners()
		end
	end))

	-- Setup
	API.Validate(DefaultValue)

	return API
end

return GizmoLongString