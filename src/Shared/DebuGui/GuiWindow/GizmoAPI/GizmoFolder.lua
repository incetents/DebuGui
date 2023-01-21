-- © 2023 Emmanuel Lajeunesse

-- Module
local GizmoFolder = {}

-- Modules
local Utility = require(script.Parent.Parent.Parent.Utility)

----------------------
-- Helper Functions --
----------------------
local function UpdateVisual(API, Gui)
	if API.IsVisible() then
		Gui.DropDownBtn.Text = 'v'
		Gui.ScrollingFrame.Visible = true
		local CanvasHeight = 0
		for _, Gizmo in ipairs(API._GizmosArray) do
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
function GizmoFolder.new(Gui, UniqueName, MasterAPI, ParentAPI, StartOpen)

	-- Sanity
	StartOpen = StartOpen or false
	Utility.QuickTypeAssert(UniqueName, 'string')
	Utility.QuickTypeAssert(StartOpen, 'boolean')

	-- Setup
	Gui.TextName.Text = UniqueName
	Gui.Line.BackgroundColor3 = Color3.fromRGB(59, 60, 120); -- Default Folder Color
	Gui.SideLine.BackgroundColor3 = Color3.fromRGB(59, 60, 120); -- Default Folder Color

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
		for _, Gizmo in ipairs(API._GizmosArray) do
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
		API._IsDestroyed = true
		Gui:Destroy()
		-- Destroy Children too
		for _, Gizmo in ipairs(API._GizmosArray) do
			Gizmo._Destroy()
		end
	end

	function API._DeadCheck()
		if API._IsDestroyed then
			warn("Warning! Accessing Removed Gizmo ("..API.Name..")")
			return true
		end
		return false
	end

	----------------
	-- Public API --
	----------------
	function API.SetName(NewName)
		if API._DeadCheck() then return nil end
		Utility.QuickTypeAssert(NewName, 'string')
		Gui.TextName.Text = NewName
		return API
	end

	function API.SetNameColor(NewNameColor)
		if API._DeadCheck() then return nil end
		Utility.QuickTypeAssert(NewNameColor, 'Color3')
		Gui.TextName.TextColor3 = NewNameColor
		return API
	end

	function API.SetColor(NewColor)
		if API._DeadCheck() then return nil end
		Utility.QuickTypeAssert(NewColor, 'Color3')
		Gui.Line.BackgroundColor3 = NewColor
		Gui.SideLine.BackgroundColor3 = NewColor
		return API
	end

	function API.GetColor()
		if API._DeadCheck() then return nil end
		return Gui.Line.BackgroundColor3
	end

	function API.IsVisible()
		if API._DeadCheck() then return false end
		return IsVisible
	end

	function API.Destroy()
		assert(ParentAPI, 'No Parent API to destroy this Gizmo')
		if API._DeadCheck() then return nil end
		-- Needs to call parent to remove itself
		ParentAPI.Remove(UniqueName)
	end

	-- Special Init
	API._UpdateVisual() -- Special Init

    return API
end

return GizmoFolder