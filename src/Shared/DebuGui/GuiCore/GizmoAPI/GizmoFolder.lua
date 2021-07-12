
-- Modules
local Utility = require(script.Parent.Parent.Parent.Utility)

--
-- local BugWorkAroundFlag = 1

-- Module
local GizmoFolder = {}

local function UpdateVisual(API, Gui, State, FrameHeightLimit)
	if State then
		Gui.ScrollingFrame.Visible = true
		local CanvasHeight = 0
		for __, Gizmo in ipairs(API._GizmosArray) do
			CanvasHeight += Gizmo.Gui.AbsoluteSize.Y
		end
		local FrameHeight = FrameHeightLimit or CanvasHeight
		Gui.Size = UDim2.new(1, 0, 0, FrameHeight + 24)
		Gui.ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, CanvasHeight)
		Gui.DropDownBtn.Text = 'v'
	else
		Gui.ScrollingFrame.Visible = false
		Gui.Size = UDim2.new(1, 0, 0, 24)
		Gui.DropDownBtn.Text = '>'
	end
end

--
function GizmoFolder.new(Gui, Name, MasterAPI, ParentAPI, IsOpenRef)

	-- Defaults
	if IsOpenRef == nil then
		IsOpenRef = false
	end

	-- Sanity
	Utility.QuickTypeAssert(Name, 'string')
	Utility.QuickTypeAssert(IsOpenRef, 'boolean')

	-- Setup
	Gui.TextName.Text = Name

	-- Data
	local IsOpen = IsOpenRef
	local GizmoAPI = require(script.Parent)
	local API = GizmoAPI.new(Gui.ScrollingFrame, MasterAPI, ParentAPI)
	local FrameHeightLimit = nil;

	-- Reference To Master
	-- local ScreenGui = Gui.Parent.Parent
	-- while not ScreenGui:IsA('ScreenGui') do
	-- 	ScreenGui = ScreenGui.Parent
	-- end

	-- Button Press
	Gui.DropDownBtn.MouseButton1Down:Connect(function()
		IsOpen = not IsOpen
		ParentAPI._UpdateAllGizmos()
		MasterAPI._RecalculateCanvasHeight()
		-- Bug workaround, force update of canvasframe by moving it 1 pixel
		-- ScreenGui.Master.Position = UDim2.fromOffset(
		-- 	ScreenGui.Master.Position.X.Offset + BugWorkAroundFlag,
		-- 	ScreenGui.Master.Position.Y.Offset
		-- )
		-- BugWorkAroundFlag = -BugWorkAroundFlag
	end)

	-- Update
	UpdateVisual(API, Gui, IsOpen, FrameHeightLimit)

	-- Private API
	API._ListenForNewGizmos(function()
		-- Update Children first
		for __, Gizmo in ipairs(API._GizmosArray) do
			if Gizmo.Update then
				Gizmo._Update()
			end
		end
		-- Update self afterwards
		UpdateVisual(API, Gui, IsOpen)
		-- Update Parent
		ParentAPI._UpdateAllGizmos()
	end)
	function API._Update()
		UpdateVisual(API, Gui, IsOpen, FrameHeightLimit)
	end

	-- Public API
	function API.SetName(NewName)
		Utility.QuickTypeAssert(NewName, 'string')
		Gui.TextName.Text = NewName
		return API
	end
	function API.SetNameColor(NewNameColor)
		Utility.QuickTypeAssert(NewNameColor, 'Color3')
		Gui.TextName.TextColor3 = NewNameColor
		return API
	end
	function API.SetColor(NewColor)
		Utility.QuickTypeAssert(NewColor, 'Color3')
		Gui.Line.BackgroundColor3 = NewColor
		Gui.SideLine.BackgroundColor3 = NewColor
		return API
	end
	function API.SetScrollbarColor(NewColor)
		Utility.QuickTypeAssert(NewColor, 'Color3')
		Gui.ScrollingFrame.ScrollBarImageColor3 = NewColor
		return API
	end
	function API.SetScrollbarWidth(Width)
		Utility.QuickTypeAssert(Width, 'number')
		Gui.ScrollingFrame.ScrollBarThickness = Width
		return API
	end
	function API.SetFrameHeightLimit(Amount)
		Utility.QuickTypeAssert(Amount, 'number')
		FrameHeightLimit = Amount
		UpdateVisual(API, Gui, IsOpen, FrameHeightLimit)
		return API
	end
	function API.RemoveFrameHeightLimit()
		FrameHeightLimit = nil;
		UpdateVisual(API, Gui, IsOpen, FrameHeightLimit)
		return API
	end
	function API.GetFrameHeightLimit()
		return FrameHeightLimit
	end

	-- Return API
    return API

end

-- End
return GizmoFolder