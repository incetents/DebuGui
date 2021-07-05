
-- Modules
local Utility = require(script.Parent.Parent.Utility)

-- Base
local GizmoBase = require(script.Parent.GizmoBase)

-- Constants
local COLOR_DARK = Color3.fromRGB(43, 43, 43)

-- Module
local GizmoBool = {}

--
function GizmoBool.new(Gui, Name, DefaultValue)

    -- Defaults
    DefaultValue = DefaultValue or false

    -- Sanity
    Utility.QuickTypeAssert(Name, 'string')
    Utility.QuickTypeAssert(DefaultValue, 'boolean')
    
    -- Init Values
    Gui.TextName.Text = Name
    local DefaultColor = Gui.CheckBoxBG.CheckBoxFG.BackgroundColor3

	-- Data
	local IsReadOnly = false

    -- API
    local API = GizmoBase.new()
    

    -- Functionality
    function API.Validate(Input)
        local IsTrue = (Input == true)
        if IsTrue then
            Gui.CheckBoxBG.CheckBoxFG.BackgroundColor3 = DefaultColor
            Gui.CheckBoxBG.CheckBoxFG.Checkmark.Visible = true
        else
            Gui.CheckBoxBG.CheckBoxFG.BackgroundColor3 = COLOR_DARK
            Gui.CheckBoxBG.CheckBoxFG.Checkmark.Visible = false
        end
        API.LastInput = IsTrue
        return true, IsTrue
    end
    function API.SetName(NewName)
        Gui.TextName.Text = NewName
        return API
    end
    function API.SetNameColor(NewNameColor)
        Gui.TextName.TextColor3 = NewNameColor
        return API
    end
    function API.SetCheckboxColor(NewColor)
        if API.LastInput == true then
            Gui.CheckBoxBG.CheckBoxFG.BackgroundColor3 = NewColor
        end
        DefaultColor = NewColor
        return API
    end
	function API.IsReadOnly()
		return IsReadOnly
	end
	function API.ReadOnly(State)
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
    Gui.CheckBoxBG.CheckBoxFG.MouseButton1Down:Connect(function()

		if IsReadOnly then
			return
		end

        local Success, Result = API.Validate(not API.LastInput)
        if Success then
            if API.Listener then
                API.Listener(Result)
            end
        end

    end)

    -- Call Validate on Default Value
    API.Validate(DefaultValue)

    -- End
    return API
end

-- End
return GizmoBool