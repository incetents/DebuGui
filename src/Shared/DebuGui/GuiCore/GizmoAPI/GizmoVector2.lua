
-- Modules
local Utility = require(script.Parent.Parent.Parent.Utility)

-- Base
local GizmoBase = require(script.Parent.GizmoBase)

-- Module
local GizmoVector2 = {}

--
function GizmoVector2.new(Gui, Name, DefaultValue, ClearTextOnFocus, DecimalAmount)

	-- Defaults
	DefaultValue = DefaultValue or Vector2.new(0, 0)
	if ClearTextOnFocus == nil then
		ClearTextOnFocus = false
	end

	-- Sanity
	Utility.QuickTypeAssert(Name, 'string')
	Utility.QuickTypeAssert(DefaultValue, 'Vector2')
	Utility.QuickTypeAssert(ClearTextOnFocus, 'boolean')
	if DecimalAmount ~= nil then
		Utility.QuickTypeAssert(DecimalAmount, 'number')
		DecimalAmount = math.floor(DecimalAmount)
	end
	
	-- Init Values
	Gui.TextName.Text = Name
	Gui.TextBox1.Text = DefaultValue.x
	Gui.TextBox2.Text = DefaultValue.y
	Gui.TextBox1.ClearTextOnFocus = ClearTextOnFocus
	Gui.TextBox2.ClearTextOnFocus = ClearTextOnFocus

	-- Data
	local IsReadOnly = false

	-- API
	local API = GizmoBase.new()

	-- Public API --
	function API.Validate(InputA, InputB)
		if API._DeadCheck() then return nil end

		local _x = tonumber(InputA)
		local _y = tonumber(InputB)

		if _x and _y then
			if DecimalAmount then
				local Mod = (10 ^ DecimalAmount)
				_x = math.round(_x * Mod) / Mod
				_y = math.round(_y * Mod) / Mod
			end
			Gui.TextBox1.Text = _x
			Gui.TextBox2.Text = _y
			API._LastInput = Vector2.new(_x, _y)
			return true
		else
			if not _x then
				Gui.TextBox1.Text = API._LastInput.X
			end
			if not _y then
				Gui.TextBox2.Text = API._LastInput.Y
			end
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
		Gui.TextBox1.BackgroundColor3 = NewColor
		Gui.TextBox2.BackgroundColor3 = NewColor
		return API
	end
	function API.SetValueTextColor(NewColor)
		if API._DeadCheck() then return nil end
		Gui.TextBox1.TextColor3 = NewColor
		Gui.TextBox2.TextColor3 = NewColor
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
			Gui.TextBox1.TextEditable = false
			Gui.TextBox2.TextEditable = false
			Gui.TextBox1.TextTransparency = 0.5
			Gui.TextBox2.TextTransparency = 0.5
		else
			Gui.TextBox1.TextEditable = true
			Gui.TextBox2.TextEditable = true
			Gui.TextBox1.TextTransparency = 0.0
			Gui.TextBox2.TextTransparency = 0.0
		end
		return API
	end

	-- Update Values
	API._AddConnection(Gui.TextBox1.FocusLost:Connect(function(__) -- enterPressed

		if IsReadOnly then
			return
		end

		local Success = API.Validate(Gui.TextBox1.Text, API._LastInput.Y)
		
		if Success and API._Listener then
			API._Listener(API._LastInput)
		end

	end))
	API._AddConnection(Gui.TextBox2.FocusLost:Connect(function(__) -- enterPressed

		if IsReadOnly then
			return
		end

		local Success = API.Validate(API._LastInput.X, Gui.TextBox2.Text)
		
		if Success and API._Listener then
			API._Listener(API._LastInput)
		end

	end))

	-- Call Validate on Default Value
	API.Validate(DefaultValue.X, DefaultValue.Y)

	-- End
	return API
end

-- End
return GizmoVector2