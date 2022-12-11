-- © 2022 Emmanuel Lajeunesse

-- Module
local GizmoString = {}

-- Modules
local GizmoBase = require(script.Parent.GizmoBase)
local Utility = require(script.Parent.Parent.Parent.Utility)

----------------
-- Public API --
----------------
function GizmoString.new(Gui, Name, DefaultValue, ClearTextOnFocus)

    -- Defaults
    DefaultValue = DefaultValue or ''
    if ClearTextOnFocus == nil then
		ClearTextOnFocus = false
	end

    -- Sanity
    Utility.QuickTypeAssert(Name, 'string')
    Utility.QuickTypeAssert(DefaultValue, 'string')
    Utility.QuickTypeAssert(ClearTextOnFocus, 'boolean')

    -- Setup
    Gui.TextName.Text = Name
    Gui.TextBox.Text = DefaultValue
    Gui.TextBox.ClearTextOnFocus = ClearTextOnFocus

	-- Defines
	local IsReadOnly = false
    local API = GizmoBase.New()

	----------------
	-- Public API --
	----------------
    function API.Validate(Input)
		if API._DeadCheck() then return false end
		if Input == API._Input then return false end
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

	function API.SetValueBGColor(NewColor)
		if API._DeadCheck() then return nil end
		Gui.TextBox.BackgroundColor3 = NewColor
		return API
	end

	function API.SetValueTextColor(NewColor)
		if API._DeadCheck() then return nil end
		Gui.TextBox.TextColor3 = NewColor
		return API
	end

	function API.IsReadOnly()
		if API._DeadCheck() then return nil end
		return IsReadOnly
	end

	function API.SetReadOnly(State)
		if API._DeadCheck() then return nil end
		-- Set
		if State == nil then
			IsReadOnly = true
		else
			IsReadOnly = State
		end
		-- Apply
		if IsReadOnly then
			Gui.TextBox.TextEditable = false
			Gui.TextBox.TextTransparency = 0.5
			Gui.TextName.TextTransparency = 0.5
		else
			Gui.TextBox.TextEditable = true
			Gui.TextBox.TextTransparency = 0.0
			Gui.TextName.TextTransparency = 0.0
		end
		return API
	end

    -- Update Values
    API._AddConnection(Gui.TextBox.FocusLost:Connect(function(__) -- enterPressed
       	if IsReadOnly then
			return
	    end

		if API.Validate(Gui.TextBox.Text) then
			API.TriggerListeners()
		end
    end))

	-- Validate default
	API.Validate(DefaultValue)

    return API
end

return GizmoString