-- Module
local GuiWindow = {}

-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TextService = game:GetService("TextService")
local GuiService = game:GetService("GuiService")

-- Modules
local Dragger = require(script.Parent.Dragger)
local GizmoAPI = require(script.GizmoAPI)
local Utility = require(script.Parent.Utility)

-- Constants
local MIN_GUI_WIDTH = 60
local MIN_GUI_HEIGHT = 72
local TITLEBAR_HEIGHT = 20
local TITLEBAR_ICONSIZE = 20
local TITLEBAR_WIDTH_PADDING_TOTAL = 8
-- Constants
local DISPLAY_ORDER_MINIMUM = 100 -- All Guis will start with this number and increment further


-- Defines
local VerticalLayout = ReplicatedStorage.VerticalLayout 

----------------------
-- Helper Functions --
----------------------

-- Make Gui appear in front of all other Guis
local function BringGuiForward(DebuGui, ChosenGui)
	-- All Guis in front of it go back 1 step
	for __, Data in pairs(DebuGui.ScreenGuis) do
		if Data.ScreenGui.DisplayOrder > ChosenGui.DisplayOrder then
			Data.ScreenGui.DisplayOrder -= 1
		end
	end
	-- Gui becomes largest display order
	ChosenGui.DisplayOrder = DISPLAY_ORDER_MINIMUM + DebuGui.ScreenGuiCount - 1
end

----------------
-- Public API --
----------------
function GuiWindow.New(DebuGui, ScreenGui, InitData)

	-- Defaults
	InitData.X = InitData.X or 100
	InitData.Y = (InitData.Y or 100) - GuiService:GetGuiInset().Y
	InitData.Width = InitData.Width or 300
	InitData.Height = InitData.Height or 300
	InitData.Title = InitData.Title or ""

	-- Ref
	ScreenGui.DisplayOrder = DISPLAY_ORDER_MINIMUM + DebuGui.ScreenGuiCount
	ScreenGui.Enabled = true
	local Master = ScreenGui.Master

	-- Data
	local API = GizmoAPI.New(Master.Core)
	API._IsVisible = true

	-- Private Data
	local IsMinimized = false
	local SizeBeforeMinimized = nil
	local PosBeforeMinimized = nil
	local SizeBeforeHidden = nil
	local TitleSize = TextService:GetTextSize(InitData.Title, Master.TopBar.Title.TextSize, Master.TopBar.Title.Font, Master.TopBar.Title.AbsoluteSize)

	-- Setup
	Master.Position = UDim2.fromOffset(InitData.X, InitData.Y)
	Master.Size = UDim2.fromOffset(InitData.Width, InitData.Height)
	Master.TopBar.Title.Text = InitData.Title
	VerticalLayout:Clone().Parent = Master.Core

	----------------------
	-- Helper Functions --
	----------------------
	local function UpdateVisibility()
		if not API._IsVisible or IsMinimized then
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

		-- Let Parent organize their positions
		if IsMinimized then
			-- Add Minimize Window to end of the list
			local XOffset = 0
			for __, Gui in ipairs(DebuGui.MinimizeOrder) do
				XOffset += Gui.Master.AbsoluteSize.X
			end
			-- Placed Minimized Position
			Master.Position = UDim2.new(
				0, Master.Position.X.Offset + XOffset,
				Master.Position.Y.Scale, Master.Position.Y.Offset
			)

			-- Store Window
			table.insert(DebuGui.MinimizeOrder, ScreenGui)
		else
			-- Remove Window from Minimize List
			local Index = Utility.FindArrayIndexByValue(DebuGui.MinimizeOrder, ScreenGui)
			table.remove(DebuGui.MinimizeOrder, Index)

			-- Reorder all minimized windows
			local XOffset = 0
			for __, Gui in ipairs(DebuGui.MinimizeOrder) do
				Gui.Master.Position = UDim2.new(
					0, XOffset,
					Gui.Master.Position.Y.Scale, Gui.Master.Position.Y.Offset
				)
				XOffset += Gui.Master.AbsoluteSize.X
			end
		end

		-- Visibility
		UpdateVisibility()
	end

	local function ToggleMinimized()
		SetMinimized(not IsMinimized)
	end

	local function SetVisible(State)

		-- Abort if no change
		if State == API._IsVisible then return end
		
		-- Pre Data
		if API._IsVisible then
			SizeBeforeHidden = Master.AbsoluteSize
		end

		-- Data
		API._IsVisible = not API._IsVisible

		-- Text
		if API._IsVisible then
			Master.TopBar.DropDownBtn.Text = 'v'
		else
			Master.TopBar.DropDownBtn.Text = '>'
		end

		-- Pos/Size
		if API._IsVisible then
			Master.Size = UDim2.fromOffset(SizeBeforeHidden.X, SizeBeforeHidden.Y)
		else
			Master.Size = UDim2.new(0, Master.AbsoluteSize.X, 0, TITLEBAR_HEIGHT)
		end

		-- Visibility
		UpdateVisibility()
	end

	local function ToggleVisibility()
		SetVisible(not API._IsVisible)
	end

	--------------
	-- Draggers --
	--------------

	-- Drag Position of Master
	local MasterPos;
	local TitleDragger = Dragger.new(Master.TopBar.Title)
	TitleDragger.OnDragStart(function()
		if not IsMinimized then
			BringGuiForward(DebuGui, ScreenGui)
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
		if API._IsVisible and not IsMinimized then
			BringGuiForward(DebuGui, ScreenGui)
			MasterPos = Master.AbsolutePosition
		end
	end)
	CoreDragger.OnDrag(function(Delta)
		if API._IsVisible and not IsMinimized then
			Master.Position = UDim2.fromOffset(MasterPos.X + Delta.X, MasterPos.Y + Delta.Y)
		end
	end)

	-- Drag ResizeBtn to Resize
	local MasterSize;
	local ResizeDragger = Dragger.new(Master.ResizeBtn)
	ResizeDragger.OnDragStart(function()
		BringGuiForward(DebuGui, ScreenGui)
		if API._IsVisible and not IsMinimized then
			MasterSize = Master.AbsoluteSize
		end
	end)
	ResizeDragger.OnDrag(function(Delta)
		if API._IsVisible and not IsMinimized then
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
		BringGuiForward(DebuGui, ScreenGui)
		ToggleVisibility()
	end)

	-- Toggle Minimize Mode
	Master.TopBar.MinimizeBtn.MouseButton1Down:Connect(function()
		BringGuiForward(DebuGui, ScreenGui)
		ToggleMinimized()
	end)

	-----------------
	-- Core Gizmos --
	-----------------

	-- Private API --
	function API._RecalculateCanvasHeight()
		local Height = 0
		for __, Data in ipairs(API._GizmosArray) do
			Height += Data.Gui.AbsoluteSize.Y
		end
		Master.Core.CanvasSize = UDim2.fromOffset(0, Height)
	end
	function API._AddToCanvasSize(Amount)
		Master.Core.CanvasSize = UDim2.fromOffset(0, Master.Core.CanvasSize.Y.Offset + Amount)
	end

	-- Public API --
	function API.Destroy()
		API.RemoveAll()
		ScreenGui:Destroy()
	end

	function API.Enable()
		ScreenGui.Enabled = true
		return API
	end
	function API.Disable()
		ScreenGui.Enabled = false
		return API
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
		return API._IsVisible
	end

	function API.ToggleVisibility()
		ToggleVisibility()
		return API
	end

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

	return API

end

return GuiWindow 