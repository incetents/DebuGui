-- Module
local GizmoNumber = {}

-- Modules
local GizmoBase = require(script.Parent.GizmoBase)
local Utility = require(script.Parent.Parent.Parent.Utility)

----------------
-- Public API --
----------------
function GizmoNumber.new(Gui, Name, DefaultValue, ClearTextOnFocus, DecimalAmount)

	-- Defaults
	DefaultValue = tonumber(DefaultValue) or 0
	if ClearTextOnFocus == nil then
		ClearTextOnFocus = false
	end

	-- Sanity
	Utility.QuickTypeAssert(Name, 'string')
	Utility.QuickTypeAssert(DefaultValue, 'number')
	Utility.QuickTypeAssert(ClearTextOnFocus, 'boolean')
	if DecimalAmount ~= nil then
		Utility.QuickTypeAssert(DecimalAmount, 'number')
		DecimalAmount = math.floor(DecimalAmount)
	end
	
	-- Setup
	Gui.TextName.Text = Name
	Gui.TextBox.Text = DefaultValue
	Gui.TextBox.ClearTextOnFocus = ClearTextOnFocus

	-- Defines
	local API = GizmoBase.New()
	local IsReadOnly = false

	----------------
	-- Public API --
	----------------
	function API.Validate(Input)
		if API._DeadCheck() then return nil end
		local NumberInput = tonumber(Input)
		if NumberInput then
			if DecimalAmount then
				local Mod = (10 ^ DecimalAmount)
				NumberInput = math.round(NumberInput * Mod) / Mod
			end
			Gui.TextBox.Text = NumberInput
			API._LastInput = NumberInput
			return true
		else
			Gui.TextBox.Text = API._LastInput
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

		local Success = API.Validate(Gui.TextBox.Text)
		
		if Success and API._Listener then
			API._Listener(API._LastInput)
		end
	end))

	-- Call Validate on Default Value
	API.Validate(DefaultValue)

	return API
end

return GizmoNumber