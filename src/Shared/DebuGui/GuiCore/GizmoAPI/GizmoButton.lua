
-- Services
local TextService = game:GetService("TextService")

-- Modules
local Utility = require(script.Parent.Parent.Parent.Utility)

-- Base
local GizmoBase = require(script.Parent.GizmoBase)

-- Constants
local PADDING = 10
local MINSIZE = 100

-- Module
local GizmoButton = {}

-- Global Functions
local function GetTextSize(TextButton)
	local NameSize = TextService:GetTextSize(
		TextButton.Text,
		TextButton.TextSize,
		TextButton.Font,
		TextButton.Parent.AbsoluteSize
	)
	return UDim2.new(0, math.max(MINSIZE, NameSize.X + PADDING), 1, -4)
end

--
function GizmoButton.new(Gui, Name)

    -- Sanity
    Utility.QuickTypeAssert(Name, 'string')
    
    -- Init Values
    Gui.TextButton.Text = Name
	Gui.TextButton.Size = GetTextSize(Gui.TextButton)

	--
	local IsReadOnly = false

    -- API
    local API = GizmoBase.new()

	-- Public API --
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

        if API._Listener then
            API._Listener()
        end

    end))

    -- End
    return API
end

-- End
return GizmoButton