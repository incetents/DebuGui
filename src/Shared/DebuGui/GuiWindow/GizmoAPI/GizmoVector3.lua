-- © 2022 Emmanuel Lajeunesse

-- Module
local GizmoVector3 = {}

-- Modules
local GizmoBase = require(script.Parent.GizmoBase)
local Utility = require(script.Parent.Parent.Parent.Utility)

----------------
-- Public API --
----------------
function GizmoVector3.new(Gui, Name, DefaultValue, DecimalAmount, ClearTextOnFocus)
	-- Defaults
	DefaultValue = DefaultValue or Vector3.new(0, 0, 0)
	if ClearTextOnFocus == nil then
		ClearTextOnFocus = false
	end

	-- Sanity
	Utility.QuickTypeAssert(Name, 'string')
	Utility.QuickTypeAssert(DefaultValue, 'Vector3')
	Utility.QuickTypeAssert(ClearTextOnFocus, 'boolean')
	if DecimalAmount ~= nil then
		Utility.QuickTypeAssert(DecimalAmount, 'number')
		DecimalAmount = math.floor(DecimalAmount)
	end

	-- Setup
	Gui.TextName.Text = Name
	Gui.TextBox1.Text = DefaultValue.X
	Gui.TextBox2.Text = DefaultValue.Y
	Gui.TextBox3.Text = DefaultValue.Z
	Gui.TextBox1.ClearTextOnFocus = ClearTextOnFocus
	Gui.TextBox2.ClearTextOnFocus = ClearTextOnFocus
	Gui.TextBox3.ClearTextOnFocus = ClearTextOnFocus

	-- Defines
	local API = GizmoBase.New()
	local IsReadOnly = false

	-- Public API --
	function API.Validate(InputA, InputB, InputC)
		if API._DeadCheck() then return false end

		local _x = tonumber(InputA)
		local _y = tonumber(InputB)
		local _z = tonumber(InputC)

		if _x and _y and _z then
			-- Check if values not changed
			if API._Input
				and typeof(API._Input) == 'Vector3'
				and math.abs(tonumber(InputA) - API._Input.X) < 1e-10
				and math.abs(tonumber(InputB) - API._Input.Y) < 1e-10
				and math.abs(tonumber(InputC) - API._Input.Z) < 1e-10
			then
				return false
			end
			if DecimalAmount then
				local Mod = (10 ^ DecimalAmount)
				_x = math.round(_x * Mod) / Mod
				_y = math.round(_y * Mod) / Mod
				_z = math.round(_z * Mod) / Mod
			end
			Gui.TextBox1.Text = _x
			Gui.TextBox2.Text = _y
			Gui.TextBox3.Text = _z
			API._Input = Vector3.new(_x, _y, _z)
			return true
		else
			if not _x then
				Gui.TextBox1.Text = API._Input.X
			end
			if not _y then
				Gui.TextBox2.Text = API._Input.Y
			end
			if not _z then
				Gui.TextBox3.Text = API._Input.Z
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
		Gui.TextBox3.BackgroundColor3 = NewColor
		return API
	end

	function API.SetValueTextColor(NewColor)
		if API._DeadCheck() then return nil end
		Gui.TextBox1.TextColor3 = NewColor
		Gui.TextBox2.TextColor3 = NewColor
		Gui.TextBox3.TextColor3 = NewColor
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
			Gui.TextBox3.TextEditable = false
			Gui.TextBox1.TextTransparency = 0.5
			Gui.TextBox2.TextTransparency = 0.5
			Gui.TextBox3.TextTransparency = 0.5
			Gui.TextName.TextTransparency = 0.5
		else
			Gui.TextBox1.TextEditable = true
			Gui.TextBox2.TextEditable = true
			Gui.TextBox3.TextEditable = true
			Gui.TextBox1.TextTransparency = 0.0
			Gui.TextBox2.TextTransparency = 0.0
			Gui.TextBox3.TextTransparency = 0.0
			Gui.TextName.TextTransparency = 0.0
		end
		return API
	end

	-- Update Values
	API._AddConnection(Gui.TextBox1.FocusLost:Connect(function(__) -- enterPressed
		if IsReadOnly then
			return
		end

		if API.Validate(Gui.TextBox1.Text, API._Input.Y, API._Input.Z) then
			API.TriggerListeners()
		end
	end))
	API._AddConnection(Gui.TextBox2.FocusLost:Connect(function(__) -- enterPressed
		if IsReadOnly then
			return
		end

		if API.Validate(API._Input.X, Gui.TextBox2.Text, API._Input.Z) then
			API.TriggerListeners()
		end
	end))
	API._AddConnection(Gui.TextBox3.FocusLost:Connect(function(__) -- enterPressed
		if IsReadOnly then
			return
		end

		if API.Validate(API._Input.X, API._Input.Y, Gui.TextBox3.Text) then
			API.TriggerListeners()
		end
	end))

	-- Call Validate on Default Value
	API.Validate(DefaultValue.X, DefaultValue.Y, DefaultValue.Z)

	return API
end

return GizmoVector3