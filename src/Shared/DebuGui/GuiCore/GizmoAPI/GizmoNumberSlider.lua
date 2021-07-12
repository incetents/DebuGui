
-- Modules
local Utility = require(script.Parent.Parent.Parent.Utility)
local Dragger = require(script.Parent.Parent.Parent.Dragger)

-- Ref
local Mouse = game:GetService("Players").LocalPlayer:GetMouse()

-- Base
local GizmoBase = require(script.Parent.GizmoBase)

-- Module
local GizmoNumberSlider = {}

-- Global Functions
local function InverseLerp(v, a, b)
	return (v - a) / (b - a)
end
local function Lerp(a, b, t)
	return (1 - t) * a + t * b;
end

local function UpdateDraggerPositionFromValue(SliderGui, Value, MinValue, MaxValue)
	local t = InverseLerp(Value, MinValue, MaxValue)
	SliderGui.TextBox.DragRange.Dragger.Position = UDim2.fromScale(t, 0)
end
local function GetValueFromDraggerPosition(SliderGui, MinValue, MaxValue)
	return Lerp(MinValue, MaxValue, SliderGui.TextBox.DragRange.Dragger.Position.X.Scale)
end

--
function GizmoNumberSlider.new(Gui, Name, DefaultValue, MinValue, MaxValue, DecimalAmount)

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
	DefaultValue = math.clamp(DefaultValue, MinValue, MaxValue)
	
	-- Init Values
	Gui.TextName.Text = Name
	Gui.TextBox.Text = DefaultValue
	UpdateDraggerPositionFromValue(Gui, DefaultValue, MinValue, MaxValue)

	-- Data
	local ValueDragger = Dragger.new(Gui.TextBox.DragRange.Dragger)
	local IsReadOnly = false

	-- API
	local API = GizmoBase.new()
	API._LastInput = DefaultValue

	-- Private API --
	function API._OnDestroy()
		ValueDragger.Destroy()
	end

	-- Public API --
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
		else
			Gui.TextBox.DragRange.Dragger.Selectable = true
			Gui.TextBox.DragRange.Dragger.AutoButtonColor = true
			Gui.TextBox.DragRange.Dragger.BackgroundTransparency = 0.7
		end
		return API
	end

	-- Dragger
	ValueDragger.OnDrag(function()
		if API._DeadCheck() then return nil end

		if IsReadOnly then
			return
		end

		-- Move Button to correct Position
		local ButtonPositionT = InverseLerp(
			Mouse.X,
			Gui.TextBox.DragRange.AbsolutePosition.X,
			Gui.TextBox.DragRange.AbsolutePosition.X + Gui.TextBox.DragRange.AbsoluteSize.X
		)
		ButtonPositionT = math.clamp(ButtonPositionT, 0, 1)
		Gui.TextBox.DragRange.Dragger.Position = UDim2.fromScale(ButtonPositionT, 0)

		-- Calculate value from position
		API._LastInput = GetValueFromDraggerPosition(Gui, MinValue, MaxValue)
		if DecimalAmount then
			local Mod = (10 ^ DecimalAmount)
			API._LastInput = math.round(API._LastInput * Mod) / Mod
		end

		-- Text
		Gui.TextBox.Text = API._LastInput

		-- Listeners
		if API._Listener then
			API._Listener(API._LastInput)
		end

	end)

	-- End
	return API
end

-- End
return GizmoNumberSlider