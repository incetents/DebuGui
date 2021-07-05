
-- Modules
local Utility = require(script.Parent.Parent.Utility)

-- Base
local GizmoBase = require(script.Parent.GizmoBase)

-- Module
local GizmoInteger = {}

--
function GizmoInteger.new(Gui, Name, DefaultValue, ClearTextOnFocus)

	-- Defaults
	DefaultValue = DefaultValue or '0'
	ClearTextOnFocus = ClearTextOnFocus or false

	-- Sanity
	Utility.QuickTypeAssert(Name, 'string')
	Utility.QuickTypeAssert(DefaultValue, 'string')
	Utility.QuickTypeAssert(ClearTextOnFocus, 'boolean')

	-- Init Values
	Gui.TextName.Text = Name
	Gui.TextBox.Text = DefaultValue
	Gui.TextBox.ClearTextOnFocus = ClearTextOnFocus

	-- Data
	local IsReadOnly = false

	-- API
	local API = GizmoBase.new()
	
	-- Functionality
	function API.Validate(Input)
		local NumberInput = tonumber(Input)
		if NumberInput then
			NumberInput = math.round(NumberInput)
			Gui.TextBox.Text = NumberInput
			API.LastInput = NumberInput
			return true, NumberInput
		else
			Gui.TextBox.Text = API.LastInput
			return false
		end
	end
	function API.SetName(NewName)
		Gui.TextName.Text = NewName
		return API
	end
	function API.SetNameColor(NewNameColor)
		Gui.TextName.TextColor3 = NewNameColor
		return API
	end
	function API.SetValueColor(NewColor)
		Gui.TextBox.BackgroundColor3 = NewColor
		return API
	end
	function API.SetValueTextColor(NewColor)
		Gui.TextBox.TextColor3 = NewColor
		return API
	end
	function API.IsReadOnly()
		return IsReadOnly
	end
	function API.ReadOnly(State)
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
   Gui.TextBox.FocusLost:Connect(function(enterPressed)

	   local Success, Result = API.Validate(Gui.TextBox.Text)
	   if Success then
		   if API.Listener then
			   API.Listener(Result)
		   end
	   end

   end)

   -- Call Validate on Default Value
   API.Validate(DefaultValue)

   -- End
   return API
end

-- End
return GizmoInteger