-- Module
local GizmoListPicker = {}

-- Modules
local GizmoBase = require(script.Parent.GizmoBase)
local Utility = require(script.Parent.Parent.Parent.Utility)

----------------
-- Public API --
----------------
function GizmoListPicker.new(Gui, Name, ParentAPI, DefaultChoice, Choices)

    -- Defaults
    DefaultChoice = DefaultChoice or ''

    -- Sanity
    Utility.QuickTypeAssert(Name, 'string')
    Utility.QuickTypeAssert(DefaultChoice, 'string')
    Utility.QuickTypeAssert(Choices, 'table')
	if not table.find(Choices, DefaultChoice) then
		error('Choice ('..DefaultChoice..') not found in Choices for '..Name)
	end

    -- Setup
    Gui.TextName.Text = Name

	-- Defines
    local API = GizmoBase.New()

	----------------
	-- Public API --
	----------------
    function API.Validate(Input)
		if Input == nil then return nil end
		if API._DeadCheck() then return nil end
        local Str = tostring(Input)
        if Str and table.find(Choices, Str) then
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

	----------------------
	-- Selection Button --
	----------------------
	API._AddConnection(Gui.ModalButton.MouseButton1Down:Connect(function()
		ParentAPI._CreateModal(API, API._Input, Choices)
	end))
	API._AddConnection(Gui.TextBox.FocusLost:Connect(function(__) -- enterPressed
        local Success = API.Validate(Gui.TextBox.Text)

		if Success and API._Listener then
			API._Listener(API._Input)
		end

    end))

	API.Validate(DefaultChoice)

    return API
end

return GizmoListPicker