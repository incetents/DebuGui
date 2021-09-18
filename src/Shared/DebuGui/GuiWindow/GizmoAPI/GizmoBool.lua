-- Module
local GizmoBool = {}

-- Modules
local GizmoBase = require(script.Parent.GizmoBase)
local Utility = require(script.Parent.Parent.Parent.Utility)

-- Constants
local COLOR_DARK = Color3.fromRGB(43, 43, 43)

----------------
-- Public API --
----------------
function GizmoBool.new(Gui, Name, DefaultValue)
    -- Defaults
    if DefaultValue == nil then
		DefaultValue = false
	end

    -- Sanity
    Utility.QuickTypeAssert(Name, 'string')
    Utility.QuickTypeAssert(DefaultValue, 'boolean')

    -- Setup
    Gui.TextName.Text = Name

	-- Defines
    local API = GizmoBase.New()
	local IsReadOnly = false
    local DefaultColor = Gui.CheckBoxBG.CheckBoxFG.BackgroundColor3

    ----------------
	-- Public API --
	----------------
    function API.Validate(Input)
		if API._DeadCheck() then return nil end
        local IsTrue = (Input == true)
        if IsTrue then
            Gui.CheckBoxBG.CheckBoxFG.BackgroundColor3 = DefaultColor
            Gui.CheckBoxBG.CheckBoxFG.Checkmark.Visible = true
        else
            Gui.CheckBoxBG.CheckBoxFG.BackgroundColor3 = COLOR_DARK
            Gui.CheckBoxBG.CheckBoxFG.Checkmark.Visible = false
        end
        API._LastInput = IsTrue
        return true
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

    function API.SetCheckboxColor(NewColor)
		if API._DeadCheck() then return nil end
        if API._LastInput == true then
            Gui.CheckBoxBG.CheckBoxFG.BackgroundColor3 = NewColor
        end
        DefaultColor = NewColor
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
			Gui.CheckBoxBG.CheckBoxFG.Checkmark.TextTransparency = 0.5
			Gui.CheckBoxBG.CheckBoxFG.BackgroundTransparency = 0.45
		else
			Gui.CheckBoxBG.CheckBoxFG.Checkmark.TextTransparency = 0.0
			Gui.CheckBoxBG.CheckBoxFG.BackgroundTransparency = 0.0
		end
		return API
	end

    -- Update Values
    API._AddConnection(Gui.CheckBoxBG.CheckBoxFG.MouseButton1Down:Connect(function()

		if IsReadOnly then
			return
		end

        local Success = API.Validate(not API._LastInput)
		
		if Success and API._Listener then
			API._Listener(API._LastInput)
		end

    end))

    -- Call Validate on Default Value
    API.Validate(DefaultValue)

    return API
end

return GizmoBool