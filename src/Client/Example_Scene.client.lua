-- © 2023 Emmanuel Lajeunesse

-- Roblox Services --
local Chat = game:GetService("Chat")
local Debris = game:GetService("Debris")
local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local StarterPlayer = game:GetService("StarterPlayer")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Module --
local DebuGui = require(ReplicatedStorage.DebuGui)

-- Defines
local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera
local Humanoid = nil
local Mouse = LocalPlayer:GetMouse()
local RNG = Random.new()

-- Create New Window
local Gui = DebuGui.NewWindow('Scene', {
	Title = 'Scene Modifier',
	X = 250,
	Y = 30,
	Width = 600,
	Height = 520,
})
Gui.Minimize()

-- Humanoid
local function UpdateHumanoid(Character)
	Humanoid = Character:WaitForChild('Humanoid')
	Humanoid.StateChanged:Connect(function(_, NewState)
		-- If Jumping
		if NewState == Enum.HumanoidStateType.Jumping then
			local JumpCounterGui = Gui.Get("Player Settings").Get('Jump Counter')
			local NewValue = tonumber(JumpCounterGui:GetValue()) + 1
			JumpCounterGui.SetValue(NewValue)
		end
	end)
end
-- Mouse
Mouse.Button1Down:Connect(function()
	local ClickCounterGui = Gui.Get("Click Counter")
	local NewValue = tonumber(ClickCounterGui:GetValue()) + 1
	ClickCounterGui.SetValue(NewValue)
end)

LocalPlayer.CharacterAdded:Connect(function(Character)
	UpdateHumanoid(Character)
end)
if LocalPlayer.Character then
	UpdateHumanoid(LocalPlayer.Character)
end

-- Settings
Gui.AddColorSliderRGBInt('Folder Color', DebuGui.GetConstants().DEFAULT_FOLDER_COLOR, nil, true).Listen(function(NewColor)
	Gui.GetFolder('Chat').SetColor(NewColor)
	Gui.GetFolder('Object Spawning').SetColor(NewColor)
	Gui.GetFolder('Player Settings').SetColor(NewColor)
	Gui.GetFolder('Scene Objects').SetColor(NewColor)
	Gui.GetFolder('Scene Lighting').SetColor(NewColor)
end)

Gui.AddInteger('Click Counter', 0).SetReadOnly()
Gui.AddText('_Info1', '(Does not count for clicking inside DebuGui)')
	.SetName('^')
	.SetValueTextColor(Color3.fromRGB(100, 100, 100))

-- Fake Chat
local Gui_Chat = Gui.AddFolder('Chat', false)

Gui_Chat.AddLongString('Chat', 'Insert Text Here', true)
	.SetHeightBasedOnLineCount(4)

Gui_Chat.AddButton('Send').Listen(function()
	Chat:Chat(LocalPlayer.Character, Gui_Chat.Get('Chat').GetValue())
end)

-- Spawn Items
local Gui_Spawner = Gui.AddFolder('Object Spawning', false)

Gui_Spawner.AddButton('Spawn Sphere').Listen(function()
	local Object = Instance.new('Part')
	Object.Shape = Enum.PartType.Ball
	Object.Parent = Workspace.Scene
	Object.Anchored = false
	Object.CanCollide = true
	Object.Color = Color3.fromRGB(240, 100, 100)
	Object.Position = LocalPlayer.Character.PrimaryPart.Position + Vector3.new(Camera.CFrame.LookVector.X, 0, Camera.CFrame.LookVector.Z).Unit * 3.0
	Object.Size = Vector3.new(3, 3, 3)
	Debris:AddItem(Object, 5)
end)

Gui_Spawner.AddButton('Spawn Block').Listen(function()
	local Object = Instance.new('Part')
	Object.Shape = Enum.PartType.Block
	Object.Parent = Workspace.Scene
	Object.Anchored = false
	Object.CanCollide = true
	Object.Color = Color3.fromRGB(100, 240, 100)
	Object.Position = LocalPlayer.Character.PrimaryPart.Position + Vector3.new(Camera.CFrame.LookVector.X, 0, Camera.CFrame.LookVector.Z).Unit * 3.0
	Object.Size = Vector3.new(3, 3, 3)
	Object.Orientation = Vector3.new(RNG:NextNumber(0, 180), RNG:NextNumber(0, 180), RNG:NextNumber(0, 180))
	Debris:AddItem(Object, 5)
end)

Gui_Spawner.AddButton('Spawn Cylinder').Listen(function()
	local Object = Instance.new('Part')
	Object.Shape = Enum.PartType.Cylinder
	Object.Parent = Workspace.Scene
	Object.Anchored = false
	Object.CanCollide = true
	Object.Color = Color3.fromRGB(100, 100, 240)
	Object.Position = LocalPlayer.Character.PrimaryPart.Position + Vector3.new(Camera.CFrame.LookVector.X, 0, Camera.CFrame.LookVector.Z).Unit * 3.0
	Object.Size = Vector3.new(3, 3, 3)
	Object.Orientation = Vector3.new(RNG:NextNumber(0, 180), RNG:NextNumber(0, 180), RNG:NextNumber(0, 180))
	Debris:AddItem(Object, 5)
end)

Gui_Spawner.AddButton('Spawn Platform').Listen(function()
	local Object = Instance.new('Part')
	Object.Transparency = 0.5
	Object.Shape = Enum.PartType.Cylinder
	Object.Parent = Workspace.Scene
	Object.Anchored = true
	Object.CanCollide = true
	Object.Color = Color3.fromRGB(175, 175, 175)
	Object.Position = LocalPlayer.Character.PrimaryPart.Position + LocalPlayer.Character.PrimaryPart.CFrame.LookVector * 7.0 + Vector3.new(0, 4, 0)
	Object.Size = Vector3.new(1, 8, 8)
	Object.Orientation = Vector3.new(0, 0, 90)
	Debris:AddItem(Object, 5)
end)


-- Player
local Gui_PlayerSettings = Gui.AddFolder('Player Settings', false)

Gui_PlayerSettings.AddSeparator('Read Only')
	.SetNameColor(Color3.fromRGB(237, 255, 172))
	.SetFrameColor(Color3.fromRGB(39, 167, 92))

-- Jump Counter
Gui_PlayerSettings.AddInteger('Jump Counter', 0).SetReadOnly()

-- Teleport
Gui_PlayerSettings.AddSeparator('Teleport')
	.SetNameColor(Color3.fromRGB(237, 255, 172))
	.SetFrameColor(Color3.fromRGB(39, 167, 92))

Gui_PlayerSettings.AddButton('Teleport_White_Spawn')
	.SetName('White Spawn')
	.SetColor(Color3.fromRGB(255, 255, 255))
	.SetNameColor(Color3.fromRGB(0, 0, 0))
	.Listen(function()
		if LocalPlayer.Character and LocalPlayer.Character.PrimaryPart then
			LocalPlayer.Character:SetPrimaryPartCFrame(Workspace.Scene.Spawn_White.CFrame + Vector3.new(0, 4, 0))
		end
	end)

Gui_PlayerSettings.AddButton('Teleport_Red_Spawn')
	.SetName('Red Spawn')
	.SetColor(Color3.fromRGB(240, 100, 100))
	.SetNameColor(Color3.fromRGB(0, 0, 0))
	.Listen(function()
		if LocalPlayer.Character and LocalPlayer.Character.PrimaryPart then
			LocalPlayer.Character:SetPrimaryPartCFrame(Workspace.Scene.Spawn_Red.CFrame + Vector3.new(0, 4, 0))
		end
	end)

Gui_PlayerSettings.AddButton('Teleport_Green_Spawn')
	.SetName('Green Spawn')
	.SetColor(Color3.fromRGB(100, 240, 100))
	.SetNameColor(Color3.fromRGB(0, 0, 0))
	.Listen(function()
		if LocalPlayer.Character and LocalPlayer.Character.PrimaryPart then
			LocalPlayer.Character:SetPrimaryPartCFrame(Workspace.Scene.Spawn_Green.CFrame + Vector3.new(0, 4, 0))
		end
	end)

-- WalkSpeed
Gui_PlayerSettings.AddSeparator('WalkSpeed')
	.SetNameColor(Color3.fromRGB(237, 255, 172))
	.SetFrameColor(Color3.fromRGB(39, 167, 92))

Gui_PlayerSettings.AddNumberSlider('WalkSpeed_Value', StarterPlayer.CharacterWalkSpeed, 0, 50, 1, true)
	.SetName('Value')
	.Listen(function(NewNumber)
		if Humanoid then
			LocalPlayer.Character.Humanoid.WalkSpeed = NewNumber
		end
	end)
Gui_PlayerSettings.AddButton('WalkSpeed_Reset')
	.SetName('Reset')
	.Listen(function()
		Gui_PlayerSettings.Get('WalkSpeed_Value').SetValue(StarterPlayer.CharacterWalkSpeed)
	end)

-- JumpPower
Gui_PlayerSettings.AddSeparator('JumpPower')
	.SetNameColor(Color3.fromRGB(237, 255, 172))
	.SetFrameColor(Color3.fromRGB(39, 167, 92))

Gui_PlayerSettings.AddNumberSlider('JumpPower_Value', StarterPlayer.CharacterJumpPower, 0, 100, 1, true)
	.SetName('Value')
	.Listen(function(NewNumber)
		if Humanoid then
			LocalPlayer.Character.Humanoid.JumpPower = NewNumber
		end
	end)
Gui_PlayerSettings.AddButton('JumpPower_Reset')
	.SetName('Reset')
	.Listen(function()
		Gui_PlayerSettings.Get('JumpPower_Value').SetValue(StarterPlayer.CharacterJumpPower)
	end)

-- Humanoid State
Gui_PlayerSettings.AddSeparator('Humanoid State')
	.SetNameColor(Color3.fromRGB(237, 255, 172))
	.SetFrameColor(Color3.fromRGB(39, 167, 92))

Gui_PlayerSettings.AddButton('ChangeState_Jump')
	.SetName('Jump')
	.Listen(function()
		if Humanoid then
			LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
		end
	end)

Gui_PlayerSettings.AddButton('ChangeState_Ragdoll')
	.SetName('Ragdoll')
	.Listen(function()
		if Humanoid then
			LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Ragdoll)
		end
	end)

Gui_PlayerSettings.AddButton('ChangeState_Dead')
	.SetName('Dead')
	.Listen(function()
		if Humanoid then
			LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Dead)
		end
	end)


-- Objects
local Gui_Objects = Gui.AddFolder('Scene Objects', false)

Gui_Objects.AddSeparator('BLOCK')

Gui_Objects.AddColorSliderHSV('Block Color', Workspace.Scene.SceneObject_Block.Color).Listen(function(NewColor)
	Workspace.Scene.SceneObject_Block.Color = NewColor
end)
Gui_Objects.AddNumberSlider('Block Transparency', Workspace.Scene.SceneObject_Block.Transparency, 0.0, 1.0, 1).Listen(function(NewNumber)
	Workspace.Scene.SceneObject_Block.Transparency = NewNumber
end)
Gui_Objects.AddBool('Block Anchored', Workspace.Scene.SceneObject_Block.Anchored).Listen(function(NewBool)
	Workspace.Scene.SceneObject_Block.Anchored = NewBool
end)
Gui_Objects.AddBool('Block CanCollide', Workspace.Scene.SceneObject_Block.CanCollide).Listen(function(NewBool)
	Workspace.Scene.SceneObject_Block.CanCollide = NewBool
end)
Gui_Objects.AddVector3('Block Orientation', Workspace.Scene.SceneObject_Block.Orientation).Listen(function(NewVec3)
	Workspace.Scene.SceneObject_Block.Orientation = NewVec3
end)
Gui_Objects.AddVector3('Block Size', Workspace.Scene.SceneObject_Block.Size).Listen(function(NewVec3)
	Workspace.Scene.SceneObject_Block.Size = NewVec3
end)
Gui_Objects.AddBool('Block Cast Shadow', Workspace.Scene.SceneObject_Block.CastShadow).Listen(function(NewBool)
	Workspace.Scene.SceneObject_Block.CastShadow = NewBool
end)
Gui_Objects.AddString('Block Text', Workspace.Scene.SceneObject_Block.SurfaceGui.TextLabel.Text, true).Listen(function(NewString)
	Workspace.Scene.SceneObject_Block.SurfaceGui.TextLabel.Text = NewString
end)
Gui_Objects.AddBool('Block Text Visible', Workspace.Scene.SceneObject_Block.SurfaceGui.Enabled, true).Listen(function(NewBool)
	Workspace.Scene.SceneObject_Block.SurfaceGui.Enabled = NewBool
end)

Gui_Objects.AddSeparator('SPHERE')

Gui_Objects.AddColorSliderHSV('Sphere Color', Workspace.Scene.SceneObject_Sphere.Color).Listen(function(NewColor)
	Workspace.Scene.SceneObject_Sphere.Color = NewColor
end)
Gui_Objects.AddBool('Sphere CanCollide', Workspace.Scene.SceneObject_Sphere.CanCollide).Listen(function(NewBool)
	Workspace.Scene.SceneObject_Sphere.CanCollide = NewBool
end)
Gui_Objects.AddIntegerSlider('Sphere Size', Workspace.Scene.SceneObject_Sphere.Size.X, 1, 40).Listen(function(NewNumber)
	Workspace.Scene.SceneObject_Sphere.Size = Vector3.new(NewNumber, NewNumber, NewNumber)
end)

Gui_Objects.AddSeparator('CYLINDER')

Gui_Objects.AddColorSliderHSV('Cylinder Color', Workspace.Scene.SceneObject_Cylinder.Color).Listen(function(NewColor)
	Workspace.Scene.SceneObject_Cylinder.Color = NewColor
end)
Gui_Objects.AddVector3('Cylinder Orientation', Workspace.Scene.SceneObject_Cylinder.Orientation).Listen(function(NewVec3)
	Workspace.Scene.SceneObject_Cylinder.Orientation = NewVec3
end)
Gui_Objects.AddNumberSlider('Cylinder Length', Workspace.Scene.SceneObject_Cylinder.Size.X, 1.0, 10.0, 2).Listen(function(NewNumber)
	Workspace.Scene.SceneObject_Cylinder.Size = Vector3.new(NewNumber, Workspace.Scene.SceneObject_Cylinder.Size.Y, Workspace.Scene.SceneObject_Cylinder.Size.Z)
end)
Gui_Objects.AddNumberSlider('Cylinder Radius', Workspace.Scene.SceneObject_Cylinder.Size.Y, 0.5, 30.0, 2).Listen(function(NewNumber)
	Workspace.Scene.SceneObject_Cylinder.Size = Vector3.new(Workspace.Scene.SceneObject_Cylinder.Size.X, NewNumber, NewNumber)
end)

local MaterialEnumsChoices = {
	['SmoothPlastic'] = Enum.Material.SmoothPlastic;
	['Plastic'] = Enum.Material.Plastic;
	['Grass'] = Enum.Material.Grass;
	['Cobblestone'] = Enum.Material.Cobblestone;
	['Brick'] = Enum.Material.Brick;
	['CorrodedMetal'] = Enum.Material.CorrodedMetal;
}
Gui_Objects.AddListPicker('Cylinder Material', 'Plastic', {
	'SmoothPlastic';
	'Plastic';
	'Grass';
	'Cobblestone';
	'Brick';
	'CorrodedMetal';
}, false).Listen(function(NewChoice)
	Workspace.Scene.SceneObject_Cylinder.Material = MaterialEnumsChoices[NewChoice]
end)

-- Lighting --
local Gui_Lighting = Gui.AddFolder('Scene Lighting', false)

Gui_Lighting.AddColorSliderRGB('Ambient', Lighting.Ambient, 3).Listen(function(NewColor)
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