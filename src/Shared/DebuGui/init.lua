
-- Module
local DebuGui = {}

-- Helper Functions
local function QuickTypeAssert(Object, Type)
    assert(typeof(Object) == Type, "Invalid Type, expected "..Type.." type, got ("..typeof(Object)..")")
end

-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

-- Ignore self if Server
if RunService:IsServer() then
    error("DebuGui can only be used on the Client")
    return {}
end

-- References
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild('PlayerGui')
local SCREENGUI = ReplicatedStorage.DebuGui_UI

-- Global Data
local ScreenGuis = {}

--
function DebuGui.new(GuiName)

    -- Assert
    QuickTypeAssert(GuiName, 'string')

    -- Double Check
    if ScreenGuis[GuiName] then
        warn('Gui already exists with the name ('..GuiName..')')
        return
    end

    --
    local NewGui = SCREENGUI:Clone()
    NewGui.Parent = PlayerGui

end
--

return DebuGui