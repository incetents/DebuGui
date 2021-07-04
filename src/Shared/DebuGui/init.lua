
-- Module
local DebuGui = {}

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
local GuiCore = require(script.GuiCore)
local Utility = require(script.Utility)

-- Global Data
local ScreenGuis = {}

--
function DebuGui.new(GuiName, PosX, PosY, Width, Height)

    -- Assert
    Utility.QuickTypeAssert(GuiName, 'string')

    -- Double Check
    if ScreenGuis[GuiName] then
        warn('Gui already exists with the name ('..GuiName..')')
        return
    end

    -- Create New Gui Logic
    local ScreenGui = SCREENGUI:Clone()
    ScreenGui.Parent = PlayerGui
    local NewGui = GuiCore.new(ScreenGui, PosX, PosY, Width, Height)

    -- Store
    ScreenGuis[GuiName] = NewGui

    --
    return NewGui

end
--

return DebuGui