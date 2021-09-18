
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

-- Constants
local DISPLAY_ORDER_MINIMUM = 100 -- All Guis will start with this number and increment further

-- Global Data
local ScreenGuis = {}
local ScreenGuiCount = 0
local MinimizeOrder = {} -- Array of Guis that are minimized

-- Public API --

function DebuGui.Get(GuiName)
	if ScreenGuis[GuiName] then
		return ScreenGuis[GuiName].API
	end
	return nil
end

function DebuGui.New(GuiName, InitData)

	-- Assert
	Utility.QuickTypeAssert(GuiName, 'string')

	-- Double Check
	if ScreenGuis[GuiName] then
		warn('Gui already exists with the name ('..GuiName..')')
		return
	end

	-- API
	function DebuGui._BringGuiForward(ChosenGui)
		-- All Guis in front of it go back 1 step
		for __, Data in pairs(ScreenGuis) do
			if Data.ScreenGui.DisplayOrder > ChosenGui.DisplayOrder then
				Data.ScreenGui.DisplayOrder -= 1
			end
		end
		-- Gui becomes largest display order
		ChosenGui.DisplayOrder = DISPLAY_ORDER_MINIMUM + ScreenGuiCount - 1
	end
	function DebuGui._AddMinimzed(ChosenGui)

		-- Add Minimize Window to end of the list
		local XOffset = 0
		for __, Gui in ipairs(MinimizeOrder) do
			XOffset += Gui.Master.AbsoluteSize.X
		end
		ChosenGui.Master.Position = UDim2.new(
			0, ChosenGui.Master.Position.X.Offset + XOffset,
			ChosenGui.Master.Position.Y.Scale, ChosenGui.Master.Position.Y.Offset
		)

		-- Store Window
		table.insert(MinimizeOrder, ChosenGui)
	end
	function DebuGui._RemoveMinimized(ChosenGui)

		-- Remove Window
		local Index = Utility.FindArrayIndexByValue(MinimizeOrder, ChosenGui)
		table.remove(MinimizeOrder, Index)

		-- Reorder windows
		local XOffset = 0
		for __, Gui in ipairs(MinimizeOrder) do
			Gui.Master.Position = UDim2.new(
				0, XOffset,
				Gui.Master.Position.Y.Scale, Gui.Master.Position.Y.Offset
			)
			XOffset += Gui.Master.AbsoluteSize.X
		end

	end

	-- Create New Gui Logic
	local ScreenGui = SCREENGUI:Clone()
	ScreenGui.Parent = PlayerGui
	ScreenGui.Name = GuiName
	ScreenGui.DisplayOrder = DISPLAY_ORDER_MINIMUM + ScreenGuiCount
	local API = GuiCore.new(DebuGui, ScreenGui, InitData)

	-- Store
	ScreenGuis[GuiName] = {
		ScreenGui = ScreenGui,
		API = API
	}
	ScreenGuiCount += 1

	--
	return API

end
--

return DebuGui