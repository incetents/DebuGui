-- © 2021 Emmanuel Lajeunesse

-- Module
local GizmoColorSlider = {}

-- Modules
local GizmoBase = require(script.Parent.GizmoBase)
local Utility = require(script.Parent.Parent.Parent.Utility)
local Dragger = require(script.Parent.Parent.Parent.Dragger)

-- Constants
local MODES = {
	RGB = 1,
	RGBINT = 2,
	HSV = 3
}

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

local function GetColor255(val)
	return math.round(val * 255.0)
end

local function DecimalRounding(val, DecimalAmount)
	if DecimalAmount then
		local Mod = (10 ^ DecimalAmount)
		val = math.round(val * Mod) / Mod
	end
	return val
end

local function RGBColorIndexToDisplayText(ColorIndex)
	if ColorIndex == 1 then
		return 'R: '
	elseif ColorIndex == 2 then
		return 'G: '
	else
		return 'B: '
	end 
end
local function HSVColorIndexToDisplayText(ColorIndex)
	if ColorIndex == 1 then
		return 'H: '
	elseif ColorIndex == 2 then
		return 'S: '
	else
		return 'V: '
	end 
end

----------------
-- Public API --
----------------
function GizmoColorSlider.new(Gui, Name, DefaultColor, UpdateOnlyOnDragEnd, Mode, DecimalAmount)

	-- Defaults
	DefaultColor = DefaultColor or Color3.fromRGB(255, 255, 255)

	-- Sanity
	Utility.QuickTypeAssert(Name, 'string')
	Utility.QuickTypeAssert(DefaultColor, 'Color3')

	-- Defines
	local ValueDragger_1 = Dragger.new(Gui.TextBox1.DragRange.Dragger)
	local ValueDragger_2 = Dragger.new(Gui.TextBox2.DragRange.Dragger)
	local ValueDragger_3 = Dragger.new(Gui.TextBox3.DragRange.Dragger)
	local IsReadOnly = false
	local API = GizmoBase.New()

	-- Setup
	Gui.TextName.Text = Name

	-- RGB stored
	API._Input = DefaultColor
	API._AddDragger(ValueDragger_1)
	API._AddDragger(ValueDragger_2)
	API._AddDragger(ValueDragger_3)

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
		else
			Gui.TextBox.DragRange.Dragger.Selectable = true
			Gui.TextBox.DragRange.Dragger.AutoButtonColor = true
			Gui.TextBox.DragRange.Dragger.BackgroundTransparency = 0.7
		end
		return API
	end

	-- Validate
	function API.Validate(Input)
		if API._DeadCheck() then return false end
		if Input == API._Input then return false end
		if typeof(Input) ~= 'Color3' then
			warn('GizmoColorSlider Given non Color Parameter')
			return false
		end

		API._Input = Input
		Gui.ColorDisplayer.BackgroundColor3 = Input

		if Mode == MODES.RGB then
			Gui.TextBox1.Text = 'R: '..tostring(GetColor255(API._Input.R))
			Gui.TextBox2.Text = 'G: '..tostring(GetColor255(API._Input.G))
			Gui.TextBox3.Text = 'B: '..tostring(GetColor255(API._Input.B))
			UpdateDraggerPositionFromValue(Gui.TextBox1.DragRange.Dragger, API._Input.R, 0, 1)
			UpdateDraggerPositionFromValue(Gui.TextBox2.DragRange.Dragger, API._Input.G, 0, 1)
			UpdateDraggerPositionFromValue(Gui.TextBox3.DragRange.Dragger, API._Input.B, 0, 1)
			
		elseif Mode == MODES.RGBINT then
			Gui.TextBox1.Text = 'R: '..tostring(DecimalRounding(API._Input.R, DecimalAmount))
			Gui.TextBox2.Text = 'G: '..tostring(DecimalRounding(API._Input.G, DecimalAmount))
			Gui.TextBox3.Text = 'B: '..tostring(DecimalRounding(API._Input.B, DecimalAmount))
			UpdateDraggerPositionFromValue(Gui.TextBox1.DragRange.Dragger, API._Input.R, 0, 1)
			UpdateDraggerPositionFromValue(Gui.TextBox2.DragRange.Dragger, API._Input.G, 0, 1)
			UpdateDraggerPositionFromValue(Gui.TextBox3.DragRange.Dragger, API._Input.B, 0, 1)

		elseif Mode == MODES.HSV then
			local H, S, V = Color3.toHSV(API._Input)
			Gui.TextBox1.Text = 'H: '..tostring(GetColor255(H))
			Gui.TextBox2.Text = 'S: '..tostring(GetColor255(S))
			Gui.TextBox3.Text = 'V: '..tostring(GetColor255(V))
			UpdateDraggerPositionFromValue(Gui.TextBox1.DragRange.Dragger, H, 0, 1)
			UpdateDraggerPositionFromValue(Gui.TextBox2.DragRange.Dragger, S, 0, 1)
			UpdateDraggerPositionFromValue(Gui.TextBox3.DragRange.Dragger, V, 0, 1)
		end

		return true
	end

	---------------------
	-- Helper Function --
	---------------------
	local function Dragger_OnDrag(TextBox, ColorIndex)
		if API._DeadCheck() then return end
		if IsReadOnly then return end

		-- Move Button to correct Position
		local ButtonPositionT = InverseLerp(
			Mouse.X,
			TextBox.DragRange.AbsolutePosition.X,
			TextBox.DragRange.AbsolutePosition.X + TextBox.DragRange.AbsoluteSize.X
		)
		ButtonPositionT = math.clamp(ButtonPositionT, 0, 1)
		TextBox.DragRange.Dragger.Position = UDim2.fromScale(ButtonPositionT, 0)

		-- Calculate value from position
		local Value = GetValueFromDraggerPosition(TextBox.DragRange.Dragger, 0, 1)
		
		-- Calculate Result in RGB
		if Mode == MODES.RGB or Mode == MODES.RGBINT then

			-- Value
			if ColorIndex == 1 then
				API._Input = Color3.new(Value, API._Input.G, API._Input.B)
	
			elseif ColorIndex == 2 then
				API._Input = Color3.new(API._Input.R, Value, API._Input.B)
	
			else
				API._Input = Color3.new(API._Input.R, API._Input.G, Value)
			end

			-- Text
			if Mode == MODES.RGB then
				TextBox.Text = RGBColorIndexToDisplayText(ColorIndex)..tostring(GetColor255(Value))
			
			elseif Mode == MODES.RGBINT then
				TextBox.Text = RGBColorIndexToDisplayText(ColorIndex)..tostring(DecimalRounding(Value, DecimalAmount))
			end

		elseif Mode == MODES.HSV then

			-- Value
			local H, S, V = Color3.toHSV(API._Input)
			if ColorIndex == 1 then
				H = Value
			elseif ColorIndex == 2 then
				S = Value
			else
				V = Value
			end
			API._Input = Color3.fromHSV(H, S, V)

			-- Text
			TextBox.Text = HSVColorIndexToDisplayText(ColorIndex)..tostring(GetColor255(Value))
		end

		-- Color Displayer
		Gui.ColorDisplayer.BackgroundColor3 = API._Input

		-- Trigger Listeners if updating per drag
		if not UpdateOnlyOnDragEnd and API._Listener then
			API._Listener(API._Input)
		end
	end

	-- Draggers
	ValueDragger_1.OnDrag(function()
		Dragger_OnDrag(Gui.TextBox1, 1)
	end)
	ValueDragger_2.OnDrag(function()
		Dragger_OnDrag(Gui.TextBox2, 2)
	end)
	ValueDragger_3.OnDrag(function()
		Dragger_OnDrag(Gui.TextBox3, 3)
	end)

	-- Drag End
	if UpdateOnlyOnDragEnd then
		ValueDragger_1.OnDragEnd(function()
			if API._Listener then
				API._Listener(API._Input)
			end
		end)
		ValueDragger_2.OnDragEnd(function()
			if API._Listener then
				API._Listener(API._Input)
			end
		end)
		ValueDragger_3.OnDragEnd(function()
			if API._Listener then
				API._Listener(API._Input)
			end
		end)
	end

	-- Validate Default
	API.Validate(DefaultColor)

	return API
end

return GizmoColorSlider