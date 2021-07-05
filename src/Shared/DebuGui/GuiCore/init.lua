
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

-- Gizmo UI References
local GizmoUI_TextBox = ReplicatedStorage.GizmoUI_TextBox
local GizmoUI_CheckBox = ReplicatedStorage.GizmoUI_CheckBox
local GizmoUI_Button = ReplicatedStorage.GizmoUI_Button
local GizmoUI_Separator = ReplicatedStorage.GizmoUI_Separator

-- Modules
local Dragger = require(script.Parent.Dragger)
local GizmoString = require(script.GizmoString)
local GizmoInteger = require(script.GizmoInteger)
local GizmoNumber = require(script.GizmoNumber)
local GizmoBool = require(script.GizmoBool)
local GizmoButton = require(script.GizmoButton)
local GizmoSeparator = require(script.GizmoSeparator)

-- Global Functions
local function UpdateLayout(GizmosArray)
	for i, GizmoData in ipairs(GizmosArray) do
		if i % 2 == 0 then
			GizmoData.Gui.BackgroundColor3 = Color3.new(1, 1, 1)
		else
			GizmoData.Gui.BackgroundColor3 = Color3.new(0, 0, 0)
		end
	end
end

-- Module
local GuiCore = {}

function GuiCore.new(ScreenGuiRef, InitData)

	-- Defaults
	InitData.X = InitData.X or 100
	InitData.Y = InitData.Y or 100
	InitData.Width = InitData.Width or 300
	InitData.Height = InitData.Height or 300
	InitData.Title = InitData.Title or ""
	InitData.ThemeColor = InitData.ThemeColor or Color3.fromRGB(64, 103, 157)

	-- Ref
	local ScreenGui = ScreenGuiRef
	ScreenGui.Enabled = true
	local Master = ScreenGui.Master

	-- Data
	local GizmosTable = {}
	local GizmosArray = {}
	local IsVisible = true
	local IsMinimized = false
	local SizeBeforeMinimized = nil
	local PosBeforeMinimized = nil
	local TitleSize = TextService:GetTextSize(InitData.Title, Master.TopBar.Title.TextSize, Master.TopBar.Title.Font, Master.TopBar.Title.AbsoluteSize)

	-- DEBUG SETUP
	Master.Core:ClearAllChildren()

	-- Setup
	Master.Position = UDim2.fromOffset(InitData.X, InitData.Y)
	Master.Size = UDim2.fromOffset(InitData.Width, InitData.Height)
	Master.TopBar.Title.Text = InitData.Title
	Master.TopBar.BackgroundColor3 = InitData.ThemeColor
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
	local function ToggleMinimize()
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
	end
	local function ToggleVisibility()

		-- Data
		IsVisible = not IsVisible

		-- Text
		if IsVisible then
			Master.TopBar.DropDownBtn.Text = 'v'
		else
			Master.TopBar.DropDownBtn.Text = '>'
		end

		-- Visibility
		UpdateVisibility()
	end

	--------------
	-- Dragging --
	--------------

	-- Drag Position of Master
	local MasterPos;
	local MasterDragger = Dragger.new(Master.TopBar.Title)
	MasterDragger.OnDragStart(function()
		if not IsMinimized then
			MasterPos = Master.AbsolutePosition
		end
	end)
	MasterDragger.OnDrag(function(Delta)
		if not IsMinimized then
			Master.Position = UDim2.fromOffset(MasterPos.X + Delta.X, MasterPos.Y + Delta.Y)
		end
	end)
	-- Drag Center of Core
	local CoreDragger = Dragger.new(Master.DragCore)
	CoreDragger.OnDragStart(function()
		if not IsMinimized then
			MasterPos = Master.AbsolutePosition
		end
	end)
	CoreDragger.OnDrag(function(Delta)
		if not IsMinimized then
			Master.Position = UDim2.fromOffset(MasterPos.X + Delta.X, MasterPos.Y + Delta.Y)
		end
	end)

	-- Drag ResizeBtn to Resize
	local MasterSize;
	local ResizeDragger = Dragger.new(Master.ResizeBtn)
	ResizeDragger.OnDragStart(function()
		if not IsMinimized then
			MasterSize = Master.AbsoluteSize
		end
	end)
	ResizeDragger.OnDrag(function(Delta)
		if not IsMinimized then
			local NewWidth = math.max(MasterSize.X + Delta.X, MIN_GUI_WIDTH)
			local NewHeight = math.max(MasterSize.Y + Delta.Y, MIN_GUI_HEIGHT)
			Master.Size = UDim2.fromOffset(NewWidth, NewHeight)
		end
	end)

	-------------
	-- Buttons --
	-------------

	-- Toggle Visibility
	Master.TopBar.DropDownBtn.MouseButton1Down:Connect(ToggleVisibility)

	-- Toggle Minimize Mode
	Master.TopBar.MinimizeBtn.MouseButton1Down:Connect(ToggleMinimize)

	------------
	-- Gizmos --
	------------

	local function AddGizmo(GIZMO_UI, GIZMO_CLASS, UniqueName, ...)

		-- Doop Check
		if GizmosTable[UniqueName] then
			warn('Gizmo already exists ('..UniqueName..')')
			return
		end

		-- New UI
		local GizmoUI = GIZMO_UI:Clone()
		GizmoUI.Parent = Master.Core
		GizmoUI.Name = UniqueName

		-- System
		local GizmoSystem = GIZMO_CLASS.new(GizmoUI, UniqueName, ...)

		-- API Defaults
		GizmoSystem.Name = UniqueName
		GizmoSystem.Gui = GizmoUI

		-- Store
		GizmosTable[UniqueName] = GizmoSystem
		table.insert(GizmosArray, GizmoSystem)

		-- Update UI
		UpdateLayout(GizmosArray)

		-- Return API
		return GizmoSystem
	end

	-- Exposing API
	local API = {}

	--
	function API.AddString(UniqueName, DefaultValue, ClearTextOnFocus)
		-- Return API to User
		return AddGizmo(GizmoUI_TextBox, GizmoString, UniqueName, DefaultValue, ClearTextOnFocus)
	end
	--
	function API.AddInteger(UniqueName, DefaultValue, ClearTextOnFocus)
		-- Return API to User
		return AddGizmo(GizmoUI_TextBox, GizmoInteger, UniqueName, DefaultValue, ClearTextOnFocus)
	end
	--
	function API.AddNumber(UniqueName, DefaultValue, ClearTextOnFocus)
		-- Return API to User
		return AddGizmo(GizmoUI_TextBox, GizmoNumber, UniqueName, DefaultValue, ClearTextOnFocus)
	end
	--
	function API.AddBool(UniqueName, DefaultValue)
		-- Return API to User
		return AddGizmo(GizmoUI_CheckBox, GizmoBool, UniqueName, DefaultValue)
	end
	--
	function API.AddButton(UniqueName)
		-- Return API to User
		return AddGizmo(GizmoUI_Button, GizmoButton, UniqueName)
	end
	--
	function API.AddSeparator(UniqueName, Color, Text, Height)
		-- Return API to User
		return AddGizmo(GizmoUI_Separator, GizmoSeparator, UniqueName, Color, Text, Height)
	end

	--
	return API
end

--
return GuiCore 