-- © 2021 Emmanuel Lajeunesse

-- Module
local GizmoListPicker = {}

-- Modules
local GizmoBase = require(script.Parent.GizmoBase)
local Utility = require(script.Parent.Parent.Parent.Utility)

----------------
-- Public API --
----------------
function GizmoListPicker.new(Gui, Name, ParentAPI, DefaultChoice, Choices, AllowNoChoice, ClearTextOnFocus)

	-- Defaults
	if ClearTextOnFocus == nil then
		ClearTextOnFocus = false
	end
	if AllowNoChoice == nil then
		AllowNoChoice = false
	end

    -- Sanity
    Utility.QuickTypeAssert(Name, 'string')
	if DefaultChoice then
		Utility.QuickTypeAssert(DefaultChoice, 'string')
	end
    Utility.QuickTypeAssert(Choices, 'table')
	for _, Value in ipairs(Choices) do
		if typeof(Value) ~= 'string' then
			error('a choice was not a string in Choices for '..Name)
		end
	end
	if DefaultChoice and not table.find(Choices, DefaultChoice) then
		error('Choice ('..DefaultChoice..') not found in Choices for '..Name)
	end
	if #Choices == 0 then
		error('No choices given for '..Name)
	end
	if not AllowNoChoice and not DefaultChoice then
		DefaultChoice = Choices[1]
	end

    -- Setup
    Gui.TextName.Text = Name
	Gui.TextBox.ClearTextOnFocus = ClearTextOnFocus

	-- Defines
    local API = GizmoBase.New()

	----------------
	-- Public API --
	----------------
    function API.Validate(Input)
		if API._DeadCheck() then return nil end
		-- Possibility of nil
		if AllowNoChoice then
			if Input == nil or Input == '' then
				Gui.TextBox.Text = ''
				if API._Input == nil then
					return false
				else
					API._Input = nil
					return true
				end
			end
		end
		-- Check Choice
		if Input == API._Input then return false end
        local Str = tostring(Input)
        if Str and table.find(Choices, Str) then
            Gui.TextBox.Text = Str
            API._Input = Str
            return true
		elseif AllowNoChoice then
			if API._Input ~= nil then
				Gui.TextBox.Text = API._Input
			else
				Gui.TextBox.Text = ''
			end
			return false
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

	function API.AddChoice(Choice)
		if API._DeadCheck() then return nil end
		if typeof(Choice) ~= 'string' then
			error('Choice is not of type string')
		end
		table.insert(Choices, Choice)
		return API
	end

	function API.RemoveChoice(Choice)
		if API._DeadCheck() then return nil end
		if typeof(Choice) ~= 'string' then
			error('Choice is not of type string')
		end
		local ChoiceIndex = table.find(Choices, Choice)
		if ChoiceIndex then
			table.remove(Choices, Choice)
			-- Check if current selection is gone
			if API._Input == Choice then
				API.Validate(Choices[1])
			end
		end
		return API
	end

	function API.ChangeChoices(NewChoices)
		if API._DeadCheck() then return nil end
		if typeof(NewChoices) ~= 'table' then
			error('Choices is not of type table')
		end
		Choices = NewChoices
		-- Check if current choice doesn't exist in new choices set
		local ChoiceIndex = table.find(Choices, API._Input)
		if not ChoiceIndex then
			API.Validate(Choices[1])
		end
		return API
	end

	----------------------
	-- Selection Button --
	----------------------
	API._AddConnection(Gui.ModalButton.MouseButton1Down:Connect(function()
		ParentAPI._CreateModal(Name..' :', API, API._Input, Choices)
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