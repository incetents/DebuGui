-- © 2021 Emmanuel Lajeunesse

-- Module
local GizmoFolder = {}

-- Modules
local Constants = require(script.Parent.Parent.Parent.Constants)
local Utility = require(script.Parent.Parent.Parent.Utility)

----------------------
-- Helper Functions --
----------------------
local function UpdateVisual(API, Gui)
	if API.IsVisible() then
		Gui.DropDownBtn.Text = 'v'
		Gui.ScrollingFrame.Visible = true
		local CanvasHeight = 0
		for __, Gizmo in ipairs(API._GizmosArray) do
			CanvasHeight += Gizmo.Gui.AbsoluteSize.Y
		end
		Gui.Size = UDim2.new(1, 0, 0, CanvasHeight + 24)
	else
		Gui.DropDownBtn.Text = '>'
		Gui.ScrollingFrame.Visible = false
		Gui.Size = UDim2.new(1, 0, 0, 24)
	end
end

----------------
-- Public API --
----------------
function GizmoFolder.new(Gui, Name, MasterAPI, ParentAPI, StartOpen)

	-- Sanity
	Utility.QuickTypeAssert(Name, 'string')
	Utility.QuickTypeAssert(StartOpen, 'boolean')

	-- Setup
	Gui.TextName.Text = Name
	Gui.Line.BackgroundColor3 = Constants.DEFAULT_FOLDER_COLOR
	Gui.SideLine.BackgroundColor3 = Constants.DEFAULT_FOLDER_COLOR

	-- Defines
	local GizmoAPI = require(script.Parent)
	local API = GizmoAPI.New(Gui.ScrollingFrame, MasterAPI, ParentAPI)
	local IsVisible = StartOpen

	------------
	-- Button --
	------------
	Gui.DropDownBtn.MouseButton1Down:Connect(function()
		IsVisible = not IsVisible
		local OCHeight = Gui.AbsoluteSize.Y
		ParentAPI._UpdateAllGizmos()
		if Utility.IsFolderVisible(API, false) then
			local DeltaHeight = Gui.AbsoluteSize.Y - OCHeight
			Utility.ModifyCanvasHeight(MasterAPI._GuiParent, DeltaHeight)
		end
	end)

	-----------------
	-- Private API --
	-----------------
	function API._NewGizmoAdded()
		-- Update Children first
		for __, Gizmo in ipairs(API._GizmosArray) do
			if Gizmo._UpdateVisual then
				Gizmo._UpdateVisual()
			end
		end

		-- Update self afterwards
		UpdateVisual(API, Gui)

		-- Update Parent
		ParentAPI._UpdateAllGizmos()
	end

	function API._UpdateVisual()
		UpdateVisual(API, Gui)
	end

	function API._Destroy()
		Gui:Destroy()
		-- Destroy Children too
		for _, Gizmo in ipairs(API._GizmosArray) do
			Gizmo._Destroy()
		end
	end

	----------------
	-- Public API --
	----------------
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

	function API.GetColor()
		return Gui.Line.BackgroundColor3
	end

	function API.IsVisible()
		return IsVisible
	end

	-- Special Init
	API._UpdateVisual() -- Special Init

    return API
end

return GizmoFolder