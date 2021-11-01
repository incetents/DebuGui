-- © 2021 Emmanuel Lajeunesse

-- Module
local GizmoNumberSlider = {}

-- Modules
local GizmoBase = require(script.Parent.GizmoBase)
local Utility = require(script.Parent.Parent.Parent.Utility)
local Dragger = require(script.Parent.Parent.Parent.Dragger)

-- Defines
local Mouse = game:GetService("Players").LocalPlayer:GetMouse()

----------------------
-- Helper Functions --
----------------------
local function InverseLerp(v, a, b)
	return (v - a) / (b - a)
end

local function Lerp(a, b, t)
	return (1 - t) * a + t * b;
end

local function UpdateDraggerPositionFromValue(DraggerUI, Value, MinValue, MaxValue)
	local t = InverseLerp(Value, MinValue, MaxValue)
	DraggerUI.Position = UDim2.fromScale(t, 0)
end

local function GetValueFromDraggerPosition(DraggerUI, MinValue, MaxValue)
	return Lerp(MinValue, MaxValue, DraggerUI.Position.X.Scale)
end

----------------
-- Public API --
----------------
function GizmoNumberSlider.new(Gui, Name, DefaultValue, MinValue, MaxValue, DecimalAmount, UpdateOnlyOnDragEnd)

	-- Defaults
	MinValue = tonumber(MinValue) or 0
	MaxValue = tonumber(MaxValue) or 0
	DefaultValue = tonumber(DefaultValue) or 0

	-- Sanity
	if MinValue > MaxValue then
		warn('Warning! NumberSlider Min is larger than Max')
		MinValue = MaxValue
	end
	Utility.QuickTypeAssert(Name, 'string')
	Utility.QuickTypeAssert(DefaultValue, 'number')
	Utility.QuickTypeAssert(MinValue, 'number')
	Utility.QuickTypeAssert(MaxValue, 'number')
	if DecimalAmount ~= nil then
		Utility.QuickTypeAssert(DecimalAmount, 'number')
		DecimalAmount = math.floor(DecimalAmount)
	end

	-- Defines
	local ValueDragger = Dragger.new(Gui.TextBox.DragRange.Dragger)
	local IsReadOnly = false
	local API = GizmoBase.New()

	-- Setup
	Gui.TextName.Text = Name

	API._AddDragger(ValueDragger)

	----------------
	-- Public API --
	----------------
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
			Gui.TextBox.DragRange.Dragger.Selectable = false
			Gui.TextBox.DragRange.Dragger.AutoButtonColor = false
			Gui.TextBox.DragRange.Dragger.BackgroundTransparency = 0.9
			Gui.TextBox.TextTransparency = 0.5
			Gui.TextName.TextTransparency = 0.5
		else
			Gui.TextBox.DragRange.Dragger.Selectable = true
			Gui.TextBox.DragRange.Dragger.AutoButtonColor = true
			Gui.TextBox.DragRange.Dragger.BackgroundTransparency = 0.7
			Gui.TextBox.TextTransparency = 0.0
			Gui.TextName.TextTransparency = 0.0
		end
		return API
	end

	function API.SetMinValue(NewMinValue)
		if API._DeadCheck() then return nil end
		Utility.QuickTypeAssert(NewMinValue, 'number')

		MinValue = math.round(tonumber(NewMinValue))

		-- Internal Update
		API._Input = math.clamp(API._Input, MinValue, MaxValue)
		Gui.TextBox.Text = tostring(API._Input)
		UpdateDraggerPositionFromValue(Gui.TextBox.DragRange.Dragger, API._Input, MinValue, MaxValue)

		return API
	end

	function API.SetMaxValue(NewMaxValue)
		if API._DeadCheck() then return nil end
		Utility.QuickTypeAssert(NewMaxValue, 'number')

		MaxValue = math.round(tonumber(NewMaxValue))

		-- Internal Update
		API._Input = math.clamp(API._Input, MinValue, MaxValue)
		Gui.TextBox.Text = tostring(API._Input)
		UpdateDraggerPositionFromValue(Gui.TextBox.DragRange.Dragger, API._Input, MinValue, MaxValue)

		return API
	end

	function API.Validate(Input)
		if API._DeadCheck() then return false end
		if Input == API._Input then return false end
		if typeof(Input) ~= 'number' then
			warn('GizmoNumberSlider Given non Color Parameter')
			return false
		end
		Input = math.clamp(Input, MinValue, MaxValue)
		Gui.TextBox.Text = Input
		UpdateDraggerPositionFromValue(Gui.TextBox.DragRange.Dragger, Input, MinValue, MaxValue)
		API._Input = Input

		return true
	end

	-- Dragger
	ValueDragger.OnDrag(function()
		if API._DeadCheck() then return end
		if IsReadOnly then return end

		-- Move Button to correct Position
		local ButtonPositionT = InverseLerp(
			Mouse.X,
			Gui.TextBox.DragRange.AbsolutePosition.X,
			Gui.TextBox.DragRange.AbsolutePosition.X + Gui.TextBox.DragRange.AbsoluteSize.X
		)
		ButtonPositionT = math.clamp(ButtonPositionT, 0, 1)
		Gui.TextBox.DragRange.Dragger.Position = UDim2.fromScale(ButtonPositionT, 0)

		-- Calculate value from position
		API._Input = GetValueFromDraggerPosition(Gui.TextBox.DragRange.Dragger, MinValue, MaxValue)
		if DecimalAmount then
			local Mod = (10 ^ DecimalAmount)
			API._Input = math.round(API._Input * Mod) / Mod
		end

		-- Text
		Gui.TextBox.Text = API._Input

		-- Trigger Listeners
		if not UpdateOnlyOnDragEnd then
			API.TriggerListeners()
		end
	end)

	-- Drag End
	if UpdateOnlyOnDragEnd then
		ValueDragger.OnDragEnd(function()
			API.TriggerListeners()
		end)
	end

	-- Validate Default
	API.Validate(DefaultValue)

	return API
end

return GizmoNumberSlider