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
--Gui.Minimize()

-- Settings
Gui.AddColorSliderRGBInt('Folder Color', DebuGui.GetConstants().DEFAULT_FOLDER_COLOR, nil, true).Listen(function(NewColor)
	Gui.GetFolder('Scene Objects').SetColor(NewColor)
	Gui.GetFolder('Scene Lighting').SetColor(NewColor)
end)

-- Objects
local Gui_Objects = Gui.AddFolder('Scene Objects', false)

Gui_Objects.AddSeparator('BLOCK')

Gui_Objects.AddColorSliderHSV('Block Color', Color3.fromRGB(255, 255, 255)).Listen(function(NewColor)
	workspace.SceneObject_Block.Color = NewColor
end)
Gui_Objects.AddNumberSlider('Block Transparency', 0.0, 0.0, 1.0, 1).Listen(function(NewNumber)
	workspace.SceneObject_Block.Transparency = NewNumber
end)
Gui_Objects.AddBool('Block CanCollide', true).Listen(function(NewBool)
	workspace.SceneObject_Block.CanCollide = NewBool
end)
Gui_Objects.AddVector3('Block Orientation', Vector3.new(0, 0, 0)).Listen(function(NewVec3)
	print(NewVec3)
	workspace.SceneObject_Block.Orientation = NewVec3
end)

Gui_Objects.AddSeparator('SPHERE')

Gui_Objects.AddColorSliderHSV('Sphere Color', Color3.fromRGB(255, 255, 255)).Listen(function(NewColor)
	workspace.SceneObject_Sphere.Color = NewColor
end)

Gui_Objects.AddSeparator('CYLINDER')

Gui_Objects.AddColorSliderHSV('Cylinder Color', Color3.fromRGB(255, 255, 255)).Listen(function(NewColor)
	workspace.SceneObject_Cylinder.Color = NewColor
end)

-- Lighting --
local Gui_Lighting = Gui.AddFolder('Scene Lighting', false)

Gui_Lighting.AddColorSliderRGB('Ambient', Lighting.Ambient).Listen(function(NewColor)
	Lighting.Ambient = NewColor
end)

Gui_Lighting.AddNumberSlider('Brightness', Lighting.Brightness, 0, 10, 3).Listen(function(NewNumber)
	Lighting.Brightness = NewNumber
end)

Gui_Lighting.AddColorSliderRGBInt('ColorShift_Bottom', Lighting.ColorShift_Bottom).Listen(function(NewColor)
	Lighting.ColorShift_Bottom = NewColor
end)

Gui_Lighting.AddColorSliderRGBInt('ColorShift_Top', Lighting.ColorShift_Bottom).Listen(function(NewColor)
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

Gui_Lighting.AddColorSliderRGBInt('OutdoorAmbient', Lighting.OutdoorAmbient).Listen(function(NewColor)
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