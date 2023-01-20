-- © 2023 Emmanuel Lajeunesse

-- Modules
local Utility = require(script.Parent.Parent.Parent.Utility)

-- Base
local GizmoBase = require(script.Parent.GizmoBase)

-- Module
local GizmoEmpty = {}

--
function GizmoEmpty.new(Gui, Name, ParentAPI, Height)

	-- Defaults
	Height = Height or 24

	-- Sanity
	Utility.QuickTypeAssert(Name, 'string')
	Utility.QuickTypeAssert(Height, 'number')

	-- Init Values
	Gui.Size = UDim2.new(1, 0, 0, Height)

	-- API
	local API = GizmoBase.New()

	-- Private API --
	API.Validate = nil
	API.Listen = nil
	API.Set = nil

	-- Public API --
	function API.SetHeight(NewHeight)
		if API._DeadCheck() then return nil end
		-- Modify Gui Size
		local OCHeight = Gui.Size.Y.Offset
		Gui.Size = UDim2.new(1, 0, 0, NewHeight)

		-- Modify Canvas Height based on change in height
		if Utility.IsFolderVisible(ParentAPI, true) then
			local DeltaHeight = (NewHeight) - OCHeight
			Utility.ModifyCanvasHeight(ParentAPI._MasterAPI._GuiParent, DeltaHeight)
		end
		return API
    end

    -- End
    return API
end

return GizmoEmpty