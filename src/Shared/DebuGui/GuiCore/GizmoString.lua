
-- Modules
local Utility = require(script.Parent.Parent.Utility)

-- Module
local GizmoString = {}

--
function GizmoString.new(Gui, Name, DefaultValue, ClearTextOnFocus)

    -- Defaults
    DefaultValue = DefaultValue or ''
    ClearTextOnFocus = ClearTextOnFocus or false

    -- Sanity
    Utility.QuickTypeAssert(Name, 'string')
    Utility.QuickTypeAssert(DefaultValue, 'string')
    Utility.QuickTypeAssert(ClearTextOnFocus, 'boolean')
    
    -- Init Values
    Gui.TextName.Text = Name
    Gui.TextButton.TextBox.Text = DefaultValue
    Gui.TextButton.TextBox.ClearTextOnFocus = ClearTextOnFocus

    -- Data
    local Listener = nil

    -- Update Values
    Gui.TextButton.TextBox.FocusLost:Connect(function(enterPressed)
        if Listener then
            Listener(Gui.TextButton.TextBox.Text)
        end
    end)

    -- API
    local API = {}

    -- Functionality
    function API.Listen(func)
        Listener = func
    end

    -- End
    return API
end

-- End
return GizmoString