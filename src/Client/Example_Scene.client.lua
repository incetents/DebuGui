-- © 2021 Emmanuel Lajeunesse

-- Roblox Services --
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Lighting = game:GetService("Lighting")

-- Module --
local DebuGui = require(ReplicatedStorage.DebuGui)

-- Create New Window
local Gui = DebuGui.NewWindow('Scene', {
	Title = 'Scene Modifier',
	X = 250,
	Y = 30,
	Width = 600,
	Height = 520,
})
Gui.Minimize()

-- Lighting --
local Gui_Lighting = Gui.AddFolder('Scene Lighting', true)

Gui_Lighting.AddColorSliderRGB('Ambient', Lighting.Ambient).Listen(function(NewColor)
	Lighting.Ambient = NewColor
end)

Gui_Lighting.AddNumberSlider('Brightness', Lighting.Brightness, 0, 10, 3).Listen(function(NewNumber)
	Lighting.Brightness = NewNumber
end)

Gui_Lighting.AddColorSliderRGB('ColorShift_Bottom', Lighting.ColorShift_Bottom).Listen(function(NewColor)
	Lighting.ColorShift_Bottom = NewColor
end)

Gui_Lighting.AddColorSliderRGB('ColorShift_Top', Lighting.ColorShift_Bottom).Listen(function(NewColor)
	Lighting.ColorShift_Bottom = NewColor
end)

Gui_Lighting.AddNumberSlider('EnvironmentDiffuseScale', Lighting.EnvironmentDiffuseScale, 0, 1, 3).Listen(function(NewNumber)
	Lighting.EnvironmentDiffuseScale = NewNumber
end)

Gui_Lighting.AddNumberSlider('EnvironmentSpecularScale', Lighting.EnvironmentSpecularScale, 0, 1, 3).Listen(function(NewNumber)
	Lighting.EnvironmentSpecularScale = NewNumber
end)

Gui_Lighting.AddBool('GlobalShadows', Lighting.GlobalShadows).Listen(function(NewBool)
	Lighting.GlobalShadows = NewBool
end)

Gui_Lighting.AddColorSliderRGB('OutdoorAmbient', Lighting.OutdoorAmbient).Listen(function(NewColor)
	Lighting.OutdoorAmbient = NewColor
end)

Gui_Lighting.AddNumberSlider('ShadowSoftness', Lighting.ShadowSoftness, 0, 1, 3).Listen(function(NewNumber)
	Lighting.ShadowSoftness = NewNumber
end)

Gui_Lighting.AddNumberSlider('ClockTime', Lighting.ClockTime, 0, 24, 3).Listen(function(NewNumber)
	Lighting.ClockTime = NewNumber
end)

Gui_Lighting.AddNumberSlider('GeographicLatitude', Lighting.GeographicLatitude, 0, 360, 1).Listen(function(NewNumber)
	Lighting.GeographicLatitude = NewNumber
end)

Gui_Lighting.AddNumberSlider('ExposureCompensation', Lighting.ExposureCompensation, -3, 3, 3).Listen(function(NewNumber)
	Lighting.ExposureCompensation = NewNumber
end)