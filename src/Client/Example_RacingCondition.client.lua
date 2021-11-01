-- © 2021 Emmanuel Lajeunesse

-- Roblox Services --
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Module
local DebuGui = require(ReplicatedStorage.DebuGui)

-- Get Existing Window
local Gui1 = DebuGui.WaitForWindow('Core')

-- This should end up at the bottom after everything from example 1 is finished
Gui1.AddBool('NewWindowBool', true).SetName('Racing Condition Test')