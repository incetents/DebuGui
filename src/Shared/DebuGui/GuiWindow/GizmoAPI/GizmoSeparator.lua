-- © 2023 Emmanuel Lajeunesse

-- Modules
local Utility = require(script.Parent.Parent.Parent.Utility)

-- Base
local GizmoBase = require(script.Parent.GizmoBase)

-- Module
local GizmoSeparator = {}

--
function GizmoSeparator.new(Gui, UniqueName, ParentAPI, Color, Height)

    -- Defaults
    Color = Color or Color3.fromRGB(59, 60, 120)
    Height = Height or 24

    -- Sanity
    Utility.QuickTypeAssert(UniqueName, 'string')
    Utility.QuickTypeAssert(Color, 'Color3')
    Utility.QuickTypeAssert(Height, 'number')

    -- Init Values
    Gui.Line.Text = UniqueName
    Gui.Line.BackgroundColor3 = Color
    Gui.Size = UDim2.new(1, 0, 0, Height)

    -- API
    local API = GizmoBase.New(UniqueName, ParentAPI)

	-- Private API --
	API.Validate = nil
	API.Listen = nil
	API.Set = nil

    -- Public API --
	function API.SetNameColor(NewColor)
		if API._DeadCheck() then return nil end
		Gui.Line.TextColor3 = NewColor
		return API
	end

    function API.SetFrameColor(NewColor)
		if API._DeadCheck() then return nil end
        Gui.Line.BackgroundColor3 = NewColor
		return API
    end

    function API.SetName(NewText)
		if API._DeadCheck() then return nil end
        Gui.Line.Text = NewText
		return API
    end

    function API.SetHeight(NewHeight)
		if API._DeadCheck() then return nil end
		-- Modify Gui Size
		local OCHeight = Gui.Size.Y.Offset
		local VerticalPadding = (Gui.AbsoluteSize.Y - Gui.Line.AbsoluteSize.Y)
		Gui.Size = UDim2.new(1, 0, 0, NewHeight + VerticalPadding)

		-- Modify Canvas Height based on change in height
		if Utility.IsFolderVisible(ParentAPI, true) then
			local DeltaHeight = (NewHeight + VerticalPadding) - OCHeight
			Utility.ModifyCanvasHeight(ParentAPI._MasterAPI._GuiParent, DeltaHeight)
		end
		return API
    end

    -- End
    return API
end

-- End
return GizmoSeparator