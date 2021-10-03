-- Module
local GizmoText = {}

-- Modules
local GizmoBase = require(script.Parent.GizmoBase)
local Utility = require(script.Parent.Parent.Parent.Utility)

----------------
-- Public API --
----------------
function GizmoText.new(Gui, Name, DefaultValue)

    -- Defaults
    DefaultValue = DefaultValue or ''

    -- Sanity
    Utility.QuickTypeAssert(Name, 'string')
    Utility.QuickTypeAssert(DefaultValue, 'string')

    -- Setup
    Gui.TextName.Text = Name
    Gui.TextBox.Text = DefaultValue

	-- Defines
    local API = GizmoBase.New()

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

	function API.SetName(NewName)
		if API._DeadCheck() then return nil end
		Gui.TextName.Text = NewName
		return API
	end

	function API.SetNameColor(NewNameColor)
		if API._DeadCheck() then return nil end
		Gui.TextName.TextColor3 = NewNameColor
		return API
	end

	function API.SetValueTextColor(NewColor)
		if API._DeadCheck() then return nil end
		Gui.TextBox.TextColor3 = NewColor
		return API
	end

    return API
end

return GizmoText