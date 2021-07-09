
-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TextService = game:GetService("TextService")

-- Constants
local MIN_GUI_WIDTH = 60
local MIN_GUI_HEIGHT = 80
local TITLEBAR_HEIGHT = 20
local TITLEBAR_ICONSIZE = 20
local TITLEBAR_WIDTH_PADDING_TOTAL = 8

-- Layout References
local VerticalLayout = ReplicatedStorage.VerticalLayout 

-- Modules
local Dragger = require(script.Parent.Dragger)
local GizmoAPI = require(script.GizmoAPI)
local Utility = require(script.Parent.Utility)

-- Module
local GuiCore = {}

function GuiCore.new(DebuGui, ScreenGuiRef, InitData)

	-- Defaults
	InitData.X = InitData.X or 100
	InitData.Y = InitData.Y or 100
	InitData.Width = InitData.Width or 300
	InitData.Height = InitData.Height or 300
	InitData.Title = InitData.Title or ""

	-- Ref
	local ScreenGui = ScreenGuiRef
	ScreenGui.Enabled = true
	local Master = ScreenGui.Master

	-- Data
	local IsVisible = true
	local IsMinimized = false
	local SizeBeforeMinimized = nil
	local PosBeforeMinimized = nil
	local SizeBeforeHidden = nil
	local TitleSize = TextService:GetTextSize(InitData.Title, Master.TopBar.Title.TextSize, Master.TopBar.Title.Font, Master.TopBar.Title.AbsoluteSize)

	-- DEBUG SETUP
	Master.Core:ClearAllChildren()

	-- Setup
	Master.Position = UDim2.fromOffset(InitData.X, InitData.Y)
	Master.Size = UDim2.fromOffset(InitData.Width, InitData.Height)
	Master.TopBar.Title.Text = InitData.Title
	VerticalLayout:Clone().Parent = Master.Core

	---------------
	-- Functions --
	---------------

	local function UpdateVisibility()

		if not IsVisible or IsMinimized then
			Master.Core.Visible = false
			Master.ResizeBtn.Visible = false
			Master.ResizeBtn.Active = false
		else
			Master.Core.Visible = true
			Master.ResizeBtn.Visible = true
			Master.ResizeBtn.Active = false
		end

	end

	local function SetMinimized(State)

		-- Abort if no change
		if State == IsMinimized then return end

		-- Pre Data
		if not IsMinimized then
			PosBeforeMinimized = Master.AbsolutePosition
			SizeBeforeMinimized = Master.AbsoluteSize
		end

		-- Data
		IsMinimized = not IsMinimized

		-- Text
		if IsMinimized then
			Master.TopBar.MinimizeBtn.Text = '+'
		else
			Master.TopBar.MinimizeBtn.Text = '-'
		end

		-- Pos/Size
		if IsMinimized then
			Master.Position = UDim2.new(0, 0, 1, -TITLEBAR_HEIGHT)
			Master.Size = UDim2.new(0, TitleSize.X + TITLEBAR_ICONSIZE * 2 + TITLEBAR_WIDTH_PADDING_TOTAL, 0, TITLEBAR_HEIGHT)
		else
			Master.Position = UDim2.fromOffset(PosBeforeMinimized.X, PosBeforeMinimized.Y) 
			Master.Size = UDim2.fromOffset(SizeBeforeMinimized.X, SizeBeforeMinimized.Y)
		end

		-- Visibility
		UpdateVisibility()

		-- Let Parent organize their positions
		if IsMinimized then
			DebuGui._AddMinimzed(ScreenGui)
		else
			DebuGui._RemoveMinimized(ScreenGui)
		end
	end
	local function ToggleMinimized()
		SetMinimized(not IsMinimized)
	end

	local function SetVisible(State)

		-- Abort if no change
		if State == IsVisible then return end
		
		-- Pre Data
		if IsVisible then
			SizeBeforeHidden = Master.AbsoluteSize
		end

		-- Data
		IsVisible = not IsVisible

		-- Text
		if IsVisible then
			Master.TopBar.DropDownBtn.Text = 'v'
		else
			Master.TopBar.DropDownBtn.Text = '>'
		end

		-- Pos/Size
		if IsVisible then
			Master.Size = UDim2.fromOffset(SizeBeforeHidden.X, SizeBeforeHidden.Y)
		else
			Master.Size = UDim2.new(0, Master.AbsoluteSize.X, 0, TITLEBAR_HEIGHT)
		end

		-- Visibility
		UpdateVisibility()
	end
	local function ToggleVisibility()
		SetVisible(not IsVisible)
	end


	--------------
	-- Dragging --
	--------------

	-- Drag Position of Master
	local MasterPos;
	local TitleDragger = Dragger.new(Master.TopBar.Title)
	TitleDragger.OnDragStart(function()
		if not IsMinimized then
			DebuGui._BringGuiForward(ScreenGui)
			MasterPos = Master.AbsolutePosition
		end
	end)
	TitleDragger.OnDrag(function(Delta)
		if not IsMinimized then
			Master.Position = UDim2.fromOffset(MasterPos.X + Delta.X, MasterPos.Y + Delta.Y)
		end
	end)
	-- Drag Center of Core
	local CoreDragger = Dragger.new(Master.DragCore)
	CoreDragger.OnDragStart(function()
		if IsVisible and not IsMinimized then
			DebuGui._BringGuiForward(ScreenGui)
			MasterPos = Master.AbsolutePosition
		end
	end)
	CoreDragger.OnDrag(function(Delta)
		if IsVisible and not IsMinimized then
			Master.Position = UDim2.fromOffset(MasterPos.X + Delta.X, MasterPos.Y + Delta.Y)
		end
	end)

	-- Drag ResizeBtn to Resize
	local MasterSize;
	local ResizeDragger = Dragger.new(Master.ResizeBtn)
	ResizeDragger.OnDragStart(function()
		DebuGui._BringGuiForward(ScreenGui)
		if IsVisible and not IsMinimized then
			MasterSize = Master.AbsoluteSize
		end
	end)
	ResizeDragger.OnDrag(function(Delta)
		if IsVisible and not IsMinimized then
			local NewWidth = math.max(MasterSize.X + Delta.X, MIN_GUI_WIDTH)
			local NewHeight = math.max(MasterSize.Y + Delta.Y, MIN_GUI_HEIGHT)
			Master.Size = UDim2.fromOffset(NewWidth, NewHeight)
		end
	end)

	-------------
	-- Buttons --
	-------------

	-- Toggle Visibility
	Master.TopBar.DropDownBtn.MouseButton1Down:Connect(function()
		DebuGui._BringGuiForward(ScreenGui)
		ToggleVisibility()
	end)

	-- Toggle Minimize Mode
	Master.TopBar.MinimizeBtn.MouseButton1Down:Connect(function()
		DebuGui._BringGuiForward(ScreenGui)
		ToggleMinimized()
	end)

	-----------------
	-- Core Gizmos --
	-----------------
	local API = GizmoAPI.new(Master.Core)

	-- Custom API
	function API.Enable()
		ScreenGui.Enabled = true
	end
	function API.Disable()
		ScreenGui.Enabled = false
	end

	function API.Show()
		SetVisible(true)
		return API
	end
	function API.Hide()
		SetVisible(false)
		return API
	end
	function API.IsVisible()
		return IsVisible
	end
	function API.ToggleVisibility()
		ToggleVisibility()
		return API
	end

	--
	function API.Minimize()
		SetMinimized(true)
		return API
	end
	function API.Maximize()
		SetMinimized(false)
		return API
	end
	function API.IsMinimized()
		return IsMinimized
	end
	function API.ToggleMinimized()
		ToggleMinimized()
		return API
	end

	--
	function API.SetTopBarColor(NewColor)
		Utility.QuickTypeAssert(NewColor, 'Color3')
		Master.TopBar.BackgroundColor3 = NewColor
		return API
	end
	function API.SetScrollbarWidth(Width)
		Utility.QuickTypeAssert(Width, 'number')
		Master.Core.ScrollBarThickness = Width
		return API
	end
	function API.SetScrollbarColor(NewColor)
		Utility.QuickTypeAssert(NewColor, 'Color3')
		Master.Core.ScrollBarImageColor3 = NewColor
		return API
	end

	--
	return API

end

--
return GuiCore 