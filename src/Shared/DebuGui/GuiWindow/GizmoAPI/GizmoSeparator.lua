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
function GizmoSeparator.new(Gui, Name, MasterAPI, Color, Text, Height)

    -- Defaults
    Color = Color or Color3.fromRGB(59, 60, 120)
    Text = Text or ''
    Height = Height or 24

    -- Sanity
    Utility.QuickTypeAssert(Name, 'string')
    Utility.QuickTypeAssert(Color, 'Color3')
    Utility.QuickTypeAssert(Text, 'string')
    Utility.QuickTypeAssert(Height, 'number')
    
    -- Init Values
    Gui.Line.Text = Text
    Gui.Line.BackgroundColor3 = Color
    Gui.Size = UDim2.new(1, 0, 0, Height)

    -- API
    local API = GizmoBase.New()

	-- Private API --
	API.Validate = nil
	API.Listen = nil
	API.Set = nil

    -- Public API --
    function API.SetColor(NewColor)
		if API._DeadCheck() then return nil end
        Gui.Line.BackgroundColor3 = NewColor
    end
    function API.SetName(NewText)
		if API._DeadCheck() then return nil end
        Gui.Line.Text = NewText
    end
    function API.SetHeight(NewHeight)
		if API._DeadCheck() then return nil end
		local OCHeight = Gui.Size.Y.Offset
        Gui.Size = UDim2.new(1, 0, 0, NewHeight + VERTICAL_PADDING)
		local DeltaHeight = (NewHeight + VERTICAL_PADDING) - OCHeight
		-- Fix canvas height based on change in height
		Utility.ModifyCanvasHeight(MasterAPI._GuiParent, DeltaHeight)
    end

    -- End
    return API
end

-- End
return GizmoSeparator