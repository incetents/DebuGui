
-- Module
local DebuGui = {
	-- Module Constants
	SLIDERPARAM_UPDATE_ON_MOVEMENT = false;
	SLIDERPARAM_UPDATE_ON_RELEASE = true;
}

-- Services
--local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")
local Players = game:GetService("Players")

-- Ignore self if Server
if RunService:IsServer() then
	error("! DebuGui can only be used Client-Side")
	return {}
end

-- Modules
local GuiWindow = require(script.GuiWindow)
local Utility = require(script.Utility)

-- Defines --
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild('PlayerGui')
--local ScreenGuiReference = ReplicatedStorage.DebuGui_UI
local ScreenGuiReference = StarterGui.DebuGui_UI
ScreenGuiReference.MasterFrame.DrawFrame:ClearAllChildren()

-- Module Data
DebuGui.ScreenGuis = {}
DebuGui.ScreenGuiCount = 0
DebuGui.MinimizeOrder = {} -- Array of Guis that are minimized

----------------
-- Public API --
----------------
function DebuGui.GetWindow(GuiName)
	if DebuGui.ScreenGuis[GuiName] then
		return DebuGui.ScreenGuis[GuiName].API
	end
	return nil
end

function DebuGui.NewWindow(GuiName, InitData)
	-- Assert
	Utility.QuickTypeAssert(GuiName, 'string')

	-- Double Check
	if DebuGui.ScreenGuis[GuiName] then
		warn('Gui already exists with the name ('..GuiName..')')
		return
	end

	-- Data
	DebuGui.ScreenGuis[GuiName] = {}

	-- Create New Gui
	local ScreenGui = ScreenGuiReference:Clone()
	ScreenGui.Parent = PlayerGui
	ScreenGui.Name = 'DebuGui_'..GuiName

	-- Create Gui API
	local API = GuiWindow.New(DebuGui, ScreenGui, InitData)

	-- Store
	DebuGui.ScreenGuis[GuiName].ScreenGui = ScreenGui
	DebuGui.ScreenGuis[GuiName].API = API
	DebuGui.ScreenGuiCount += 1

	return API
end

return DebuGui