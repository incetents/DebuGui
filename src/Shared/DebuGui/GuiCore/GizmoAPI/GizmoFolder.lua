
-- Modules
local Utility = require(script.Parent.Parent.Parent.Utility)

-- Module
local GizmoFolder = {}

local function UpdateVisual(API, Gui, State)
	if State then
		Gui.ScrollingFrame.Visible = true
		local Height = 0
		for __, Gizmo in ipairs(API.GizmosArray) do
			Height += Gizmo.Gui.AbsoluteSize.Y
		end
		Gui.Size = UDim2.new(1, 0, 0, Height + 24)
		Gui.ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, Height)
		Gui.DropDownBtn.Text = 'v'
	else
		Gui.ScrollingFrame.Visible = false
		Gui.Size = UDim2.new(1, 0, 0, 24)
		Gui.DropDownBtn.Text = '>'
	end
end

--
function GizmoFolder.new(Gui, Name, ParentAPI, IsOpenRef)

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
	local API = GizmoAPI.new(Gui.ScrollingFrame, ParentAPI)

	-- Button Press
	Gui.DropDownBtn.MouseButton1Down:Connect(function()
		IsOpen = not IsOpen
		ParentAPI.UpdateAllGizmos()
	end)

	-- Update
	UpdateVisual(API, Gui, IsOpen)

	-- Listen
	API.ListenForNewGizmos(function()
		-- Update Children first
		for __, Gizmo in ipairs(API.GizmosArray) do
			if Gizmo.Update then
				Gizmo.Update()
			end
		end
		-- Update self afterwards
		UpdateVisual(API, Gui, IsOpen)
		-- Update Parent
		ParentAPI.UpdateAllGizmos()
	end)

	-- Functionality
	function API.Update()
		UpdateVisual(API, Gui, IsOpen)
	end
	function API.SetName(NewName)
		Gui.TextName.Text = NewName
		return API
	end
	function API.SetNameColor(NewNameColor)
		Gui.TextName.TextColor3 = NewNameColor
		return API
	end
	function API.SetColor(NewColor)
		Gui.Line.BackgroundColor3 = NewColor
		Gui.SideLine.BackgroundColor3 = NewColor
		return API
	end

	-- Return API
    return API

end

-- End
return GizmoFolder