-- © 2023 Emmanuel Lajeunesse

-- Module
local DebuGui = {}

-- Services
local RunService = game:GetService("RunService")
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
local ScreenGuiReference = script.DebuGui_UI

-- Module Data
DebuGui.ScreenGuis = {}
DebuGui.ScreenGuiCount = 0
DebuGui.MinimizeOrder = {} -- Array of Guis that are minimized
DebuGui.DisplayOrderMinimum = 10000 -- All Guis will start with this number and increment further

----------------
-- Public API --
----------------
function DebuGui.GetWindow(GuiName)
	if DebuGui.ScreenGuis[GuiName] then
		return DebuGui.ScreenGuis[GuiName].API
	end
	return nil
end

function DebuGui.WaitForWindow(GuiName, TimeOutTime)
	-- Wait a specific amount of time
	if TimeOutTime and typeof(TimeOutTime) == 'number' then
		local FailTime = os.clock() + TimeOutTime;
		while not DebuGui.ScreenGuis[GuiName] and os.clock() < FailTime do
			task.wait()
		end
		return DebuGui.GetWindow(GuiName)

	-- Yield forever until window is available
	else
		while not DebuGui.ScreenGuis[GuiName] do
			task.wait(1)
		end
		return DebuGui.ScreenGuis[GuiName].API
	end
end

function DebuGui.SetDisplayOrderMinimum(NewDisplayOrderMinimum)
	-- Fix
	for _, Data in pairs(DebuGui.ScreenGuis) do
		Data.ScreenGui.DisplayOrder -= DebuGui.DisplayOrderMinimum
		Data.ScreenGui.DisplayOrder += NewDisplayOrderMinimum
	end
	-- Value Change
	DebuGui.DisplayOrderMinimum = NewDisplayOrderMinimum
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

function DebuGui.GetDefaultWindowTopBarColor()
	return Color3.fromRGB(64, 103, 157);
end

function DebuGui.GetDefaultFolderColor()
	return Color3.fromRGB(59, 60, 120);
end

return DebuGui