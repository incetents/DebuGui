-- © 2023 Emmanuel Lajeunesse

-- Module
local GizmoSimpleText = {}

-- Modules
local GizmoBase = require(script.Parent.GizmoBase)
local Utility = require(script.Parent.Parent.Parent.Utility)

----------------
-- Public API --
----------------
function GizmoSimpleText.new(Gui, UniqueName, ParentAPI, DefaultValue)

    -- Defaults
    DefaultValue = DefaultValue or ''

    -- Sanity
    Utility.QuickTypeAssert(DefaultValue, 'string')

    -- Setup
    Gui.TextBox.Text = DefaultValue

	-- Defines
    local API = GizmoBase.New(UniqueName, ParentAPI)

	----------------
	-- Public API --
	----------------
    function API.Validate(Input)
		if API._DeadCheck() then return nil end
        local Str = tostring(Input)
        if Str then
            Gui.TextBox.Text = Str
            API._Input = Str
            return true
        else
            Gui.TextBox.Text = API._Input
            return false
        end
    end

	function API.SetValueTextColor(NewColor)
		if API._DeadCheck() then return nil end
		Gui.TextBox.TextColor3 = NewColor
		return API
	end

    return API
end

return GizmoSimpleText