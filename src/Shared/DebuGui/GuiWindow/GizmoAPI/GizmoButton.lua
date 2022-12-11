-- © 2022 Emmanuel Lajeunesse

-- Module
local GizmoButton = {}

-- Services
local TextService = game:GetService("TextService")

-- Modules
local GizmoBase = require(script.Parent.GizmoBase)
local Utility = require(script.Parent.Parent.Parent.Utility)

-- Constants
local PADDING = 10
local MINSIZE = 100

---------------------
-- Herlp Functions --
---------------------
local function GetTextSize(TextButton)
	local NameSize = TextService:GetTextSize(
		TextButton.Text,
		TextButton.TextSize,
		TextButton.Font,
		Vector2.new(math.huge, TextButton.TextSize)
	)
	return UDim2.new(0, math.max(MINSIZE, NameSize.X + PADDING), 1, -4)
end

----------------
-- Public API --
----------------
function GizmoButton.new(Gui, Name)
    -- Sanity
    Utility.QuickTypeAssert(Name, 'string')
    
    -- Setup
    Gui.TextButton.Text = Name
	Gui.TextButton.Size = GetTextSize(Gui.TextButton)

	-- Defines
    local API = GizmoBase.New()
	local IsReadOnly = false

	----------------
	-- Public API --
	----------------
    function API.SetName(NewName)
		if API._DeadCheck() then return nil end
        Gui.TextButton.Text = NewName
		Gui.TextButton.Size = GetTextSize(Gui.TextButton)
		return API
    end
    function API.SetNameColor(NewNameColor)
		if API._DeadCheck() then return nil end
        Gui.TextButton.TextColor3 = NewNameColor
		return API
    end
    function API.SetColor(NewColor)
		if API._DeadCheck() then return nil end
        Gui.TextButton.BackgroundColor3 = NewColor
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
			Gui.TextButton.BackgroundTransparency = 0.5
			Gui.TextButton.TextTransparency = 0.5
		else
			Gui.TextButton.BackgroundTransparency = 0.0
			Gui.TextButton.TextTransparency = 0.0
		end
		return API
	end

    -- Update Values
    API._AddConnection(Gui.TextButton.MouseButton1Down:Connect(function(__) -- enterPressed
		if IsReadOnly then
			return
		end

        API.TriggerListeners()
    end))

    return API
end

return GizmoButton