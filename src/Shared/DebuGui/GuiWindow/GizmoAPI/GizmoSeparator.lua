-- © 2021 Emmanuel Lajeunesse

-- Modules
local Utility = require(script.Parent.Parent.Parent.Utility)

-- Base
local GizmoBase = require(script.Parent.GizmoBase)

-- Constants
local VERTICAL_PADDING = 6

-- Module
local GizmoSeparator = {}

--
function GizmoSeparator.new(Gui, Name, ParentAPI, Color, Height)

    -- Defaults
    Color = Color or Color3.fromRGB(59, 60, 120)
    Height = Height or 24

    -- Sanity
    Utility.QuickTypeAssert(Name, 'string')
    Utility.QuickTypeAssert(Color, 'Color3')
    Utility.QuickTypeAssert(Height, 'number')

    -- Init Values
    Gui.Line.Text = Name
    Gui.Line.BackgroundColor3 = Color
    Gui.Size = UDim2.new(1, 0, 0, Height)

    -- API
    local API = GizmoBase.New()

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
		Gui.Size = UDim2.new(1, 0, 0, NewHeight + VERTICAL_PADDING)

		-- Modify Canvas Height based on change in height
		if Utility.IsFolderVisible(ParentAPI, true) then
			local DeltaHeight = (NewHeight + VERTICAL_PADDING) - OCHeight
			Utility.ModifyCanvasHeight(ParentAPI._MasterAPI._GuiParent, DeltaHeight)
		end
		return API
    end

    -- End
    return API
end

-- End
return GizmoSeparator