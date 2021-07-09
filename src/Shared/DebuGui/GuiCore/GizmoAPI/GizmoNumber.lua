
-- Modules
local Utility = require(script.Parent.Parent.Parent.Utility)

-- Base
local GizmoBase = require(script.Parent.GizmoBase)

-- Module
local GizmoNumber = {}

--
function GizmoNumber.new(Gui, Name, DefaultValue, ClearTextOnFocus)

	-- Defaults
	DefaultValue = tonumber(DefaultValue) or 0
	if ClearTextOnFocus == nil then
		ClearTextOnFocus = false
	end

	-- Sanity
	Utility.QuickTypeAssert(Name, 'string')
	Utility.QuickTypeAssert(DefaultValue, 'number')
	Utility.QuickTypeAssert(ClearTextOnFocus, 'boolean')
	
	-- Init Values
	Gui.TextName.Text = Name
	Gui.TextBox.Text = DefaultValue
	Gui.TextBox.ClearTextOnFocus = ClearTextOnFocus

	-- Data
	local IsReadOnly = false

	-- API
	local API = GizmoBase.new()

	-- Public API --
	function API.Validate(Input)
		if API._DeadCheck() then return nil end
		local NumberInput = tonumber(Input)
		if NumberInput then
			Gui.TextBox.Text = NumberInput
			API.LastInput = NumberInput
			return true, NumberInput
		else
			Gui.TextBox.Text = API.LastInput
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
	function API.SetValueColor(NewColor)
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
	function API.ReadOnly(State)
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
		else
			Gui.TextBox.TextEditable = true
			Gui.TextBox.TextTransparency = 0.0
		end
		return API
	end

	-- Update Values
	API._AddConnection(Gui.TextBox.FocusLost:Connect(function(__) -- enterPressed

		if IsReadOnly then
			return
		end

		local Success, Result = API.Validate(Gui.TextBox.Text)
		if Success then
			if API.Listener then
				API.Listener(Result)
			end
		end

	end))

	-- Call Validate on Default Value
	API.Validate(DefaultValue)

	-- End
	return API
end

-- End
return GizmoNumber