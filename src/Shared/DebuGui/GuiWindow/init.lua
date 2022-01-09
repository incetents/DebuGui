-- © 2021 Emmanuel Lajeunesse

-- Module
local GuiWindow = {}

-- Services
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
local DISPLAY_ORDER_MINIMUM = 100 -- All Guis will start with this number and increment further

-- Defines
local VerticalLayout = Instance.new('UIListLayout')
VerticalLayout.FillDirection = Enum.FillDirection.Vertical
VerticalLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
VerticalLayout.SortOrder = Enum.SortOrder.LayoutOrder
VerticalLayout.VerticalAlignment = Enum.VerticalAlignment.Top

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

	-- Private Data
	local MasterFrame = ScreenGui.MasterFrame
	local API = GizmoAPI.New(MasterFrame.DrawFrame)
	local IsVisible = true
	local IsMinimized = false
	local SizeBeforeMinimized = nil
	local PosBeforeMinimized = nil
	local SizeBeforeHidden = nil
	local TitleSize = TextService:GetTextSize(InitData.Title, MasterFrame.TopBar.Title.TextSize, MasterFrame.TopBar.Title.Font, MasterFrame.TopBar.Title.AbsoluteSize)
	local Dragger_MasterPos;
	local Dragger_MasterSize;
	local TitleDragger = Dragger.new(MasterFrame.TopBar.Title)
	local CoreDragger = Dragger.new(MasterFrame.DragCore)
	local ResizeDragger = Dragger.new(MasterFrame.ResizeBtn)

	-- Setup
	ScreenGui.DisplayOrder = DISPLAY_ORDER_MINIMUM + DebuGui.ScreenGuiCount
	ScreenGui.Enabled = true
	MasterFrame.Position = UDim2.fromOffset(InitData.X, InitData.Y)
	MasterFrame.Size = UDim2.fromOffset(InitData.Width, InitData.Height)
	MasterFrame.TopBar.Title.Text = InitData.Title
	VerticalLayout:Clone().Parent = MasterFrame.DrawFrame

	----------------------
	-- Helper Functions --
	----------------------

	local function UpdateVisibility()
		if not IsVisible or IsMinimized then
			MasterFrame.DrawFrame.Visible = false
			MasterFrame.ResizeBtn.Visible = false
			MasterFrame.ResizeBtn.Active = false
		else
			MasterFrame.DrawFrame.Visible = true
			MasterFrame.ResizeBtn.Visible = true
			MasterFrame.ResizeBtn.Active = false
		end
	end

	local function SetMinimized(State)
		-- Abort if no change
		if State == IsMinimized then return end

		-- Pre Data
		if not IsMinimized then
			PosBeforeMinimized = MasterFrame.AbsolutePosition
			SizeBeforeMinimized = MasterFrame.AbsoluteSize
		end

		-- Data
		IsMinimized = not IsMinimized

		-- Minimize
		if IsMinimized then
			-- Text
			MasterFrame.TopBar.MinimizeBtn.Text = '+'

			-- Find X Position at end of Minimized List
			local XOffset = 0
			for __, Gui in ipairs(DebuGui.MinimizeOrder) do
				XOffset += Gui.MasterFrame.AbsoluteSize.X
			end
			-- Placed Minimized Position
			MasterFrame.Position = UDim2.new(0, XOffset, 1, -TITLEBAR_HEIGHT)

			-- Size
			MasterFrame.Size = UDim2.new(0, TitleSize.X + TITLEBAR_ICONSIZE * 2 + TITLEBAR_WIDTH_PADDING_TOTAL, 0, TITLEBAR_HEIGHT)

			-- Store Window in Minimized Array
			table.insert(DebuGui.MinimizeOrder, ScreenGui)

			-- Close Any Modals opened
			API._ModalChoiceSelected(nil)

		-- Maximize
		else
			-- Text
			MasterFrame.TopBar.MinimizeBtn.Text = '-'
			-- Pos
			MasterFrame.Position = UDim2.fromOffset(PosBeforeMinimized.X, PosBeforeMinimized.Y)
			-- Size
			MasterFrame.Size = UDim2.fromOffset(SizeBeforeMinimized.X, SizeBeforeMinimized.Y)

			-- Remove Window from Minimize List
			local Index = Utility.FindArrayIndexByValue(DebuGui.MinimizeOrder, ScreenGui)
			table.remove(DebuGui.MinimizeOrder, Index)

			-- Reorder all Minimized windows
			local XOffset = 0
			for __, Gui in ipairs(DebuGui.MinimizeOrder) do
				Gui.MasterFrame.Position = UDim2.new(
					0, XOffset,
					Gui.MasterFrame.Position.Y.Scale, Gui.MasterFrame.Position.Y.Offset
				)
				XOffset += Gui.MasterFrame.AbsoluteSize.X
			end
		end

		-- Visibility
		UpdateVisibility()
	end

	local function SetVisible(State)
		-- Abort if no change
		if State == IsVisible then return end

		-- Pre Data
		if IsVisible then
			if IsMinimized then
				SizeBeforeHidden = SizeBeforeMinimized
			else
				SizeBeforeHidden = MasterFrame.AbsoluteSize
			end
		end

		-- Data
		IsVisible = not IsVisible

		-- Close Any Modals opened
		if not IsVisible then
			API._ModalChoiceSelected(nil)
		end

		-- Text
		if IsVisible then
			MasterFrame.TopBar.DropDownBtn.Text = 'v'
		else
			MasterFrame.TopBar.DropDownBtn.Text = '>'
		end

		-- Pos/Size
		if IsVisible then
			MasterFrame.Size = UDim2.fromOffset(SizeBeforeHidden.X, SizeBeforeHidden.Y)
		else
			MasterFrame.Size = UDim2.fromOffset(MasterFrame.AbsoluteSize.X, TITLEBAR_HEIGHT)
		end

		-- Visibility
		UpdateVisibility()
	end

	--------------
	-- Draggers --
	--------------

	-- Drag Position of MasterFrame
	TitleDragger.OnDragStart(function()
		if not IsMinimized then
			API.BringGuiForward(ScreenGui)
			Dragger_MasterPos = MasterFrame.AbsolutePosition
		end
	end)
	TitleDragger.OnDrag(function(Delta)
		if not IsMinimized then
			MasterFrame.Position = UDim2.fromOffset(Dragger_MasterPos.X + Delta.X, Dragger_MasterPos.Y + Delta.Y)
		end
	end)

	-- Drag Center of DrawFrame
	CoreDragger.OnDragStart(function()
		if IsVisible and not IsMinimized then
			API.BringGuiForward(ScreenGui)
			Dragger_MasterPos = MasterFrame.AbsolutePosition
		end
	end)
	CoreDragger.OnDrag(function(Delta)
		if IsVisible and not IsMinimized then
			MasterFrame.Position = UDim2.fromOffset(Dragger_MasterPos.X + Delta.X, Dragger_MasterPos.Y + Delta.Y)
		end
	end)

	-- Drag ResizeBtn to Resize
	ResizeDragger.OnDragStart(function()
		API.BringGuiForward(ScreenGui)
		if IsVisible and not IsMinimized then
			Dragger_MasterSize = MasterFrame.AbsoluteSize
		end
	end)
	ResizeDragger.OnDrag(function(Delta)
		if IsVisible and not IsMinimized then
			local NewWidth = math.max(Dragger_MasterSize.X + Delta.X, MIN_GUI_WIDTH)
			local NewHeight = math.max(Dragger_MasterSize.Y + Delta.Y, MIN_GUI_HEIGHT)
			MasterFrame.Size = UDim2.fromOffset(NewWidth, NewHeight)
		end
	end)

	-------------
	-- Buttons --
	-------------

	-- Toggle Visibility
	MasterFrame.TopBar.DropDownBtn.MouseButton1Down:Connect(function()
		API.BringGuiForward(ScreenGui)
		SetVisible(not IsVisible)
	end)

	-- Toggle Minimize Mode
	MasterFrame.TopBar.MinimizeBtn.MouseButton1Down:Connect(function()
		API.BringGuiForward(ScreenGui)
		SetMinimized(not IsMinimized)
	end)

	-- Modal Lock closes Modal
	MasterFrame.ModalLock.MouseButton1Down:Connect(function()
		API._ModalChoiceSelected(nil)
	end)

	----------------
	-- Public API --
	----------------

	-- Make Gui appear in front of all other Guis
	function API.BringGuiForward(ChosenGui)

		local IDName = string.sub(ChosenGui.Name, 9) -- Ignoring 'DebuGui_' prefix

		-- Safety Check
		if not DebuGui.ScreenGuis[IDName] then
			return
		end

		-- All Guis in front of it go back 1 step
		for __, Data in pairs(DebuGui.ScreenGuis) do
			if Data.ScreenGui.DisplayOrder > ChosenGui.DisplayOrder then
				Data.ScreenGui.DisplayOrder -= 1
			end
		end
		-- Gui becomes largest display order
		ChosenGui.DisplayOrder = DISPLAY_ORDER_MINIMUM + DebuGui.ScreenGuiCount - 1
	end

	function API.GetScreenGui()
		return ScreenGui
	end

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
		return IsVisible
	end

	function API.ToggleVisibility()
		SetVisible(not IsVisible)
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
		SetMinimized(not IsMinimized)
		return API
	end

	function API.SetTopBarColor(NewColor)
		Utility.QuickTypeAssert(NewColor, 'Color3')
		MasterFrame.TopBar.BackgroundColor3 = NewColor
		return API
	end

	function API.SetScrollbarWidth(Width)
		Utility.QuickTypeAssert(Width, 'number')
		MasterFrame.DrawFrame.ScrollBarThickness = Width
		return API
	end

	function API.SetScrollbarColor(NewColor)
		Utility.QuickTypeAssert(NewColor, 'Color3')
		MasterFrame.DrawFrame.ScrollBarImageColor3 = NewColor
		return API
	end

	return API
end

return GuiWindow