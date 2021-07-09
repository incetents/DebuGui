
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild('PlayerGui')

-- DEBUG SETUP
local C = PlayerGui:WaitForChild('DebuGui_UI')
if C then
    C:Destroy()
end

local DebuGui = require(ReplicatedStorage.DebuGui)

-- Create New Window
local Gui1 = DebuGui.new('Core', {
    Title = 'TEST NAME HERE 12312312',
    X = 300,
    Y = 100,
    Width = 600,
    Height = 500,
})
Gui1.SetTopBarColor(Color3.fromRGB(103, 65, 161))
Gui1.SetScrollbarWidth(10)
Gui1.SetScrollbarColor(Color3.fromRGB(134, 29, 103))

UserInputService.InputBegan:Connect(function(input)
	--
	if input.KeyCode == Enum.KeyCode.One then
		Gui1.Disable()
	elseif input.KeyCode == Enum.KeyCode.Two then
		Gui1.Enable()
	elseif input.KeyCode == Enum.KeyCode.Three then
		Gui1.Hide()
	elseif input.KeyCode == Enum.KeyCode.Four then
		Gui1.Show()
	elseif input.KeyCode == Enum.KeyCode.Five then
		Gui1.Minimize()
	elseif input.KeyCode == Enum.KeyCode.Six then
		Gui1.Maximize()
	elseif input.KeyCode == Enum.KeyCode.Seven then
		Gui1.ToggleVisibility()
	elseif input.KeyCode == Enum.KeyCode.Eight then
		Gui1.ToggleMinimized()
	end
	--
end)
	

-- Booleans --
Gui1.AddBool('bool1', true).SetName('fancy bool')
Gui1.AddBool('bool2', false).SetNameColor(Color3.new(1,0,0))
Gui1.AddBool('bool3').SetCheckboxColor(Color3.fromRGB(46, 106, 124))
Gui1.AddBool('bool4', true).Listen(function(NewValue)
    print("New Bool4: ", NewValue)
end)
Gui1.AddBool('bool5', false).Set(true).SetCheckboxColor(Color3.fromRGB(122, 40, 122))
Gui1.AddBool('bool6', true).ReadOnly()
Gui1.AddBool('bool7', false).ReadOnly().Set(true).Set(false)

-- Buttons --
Gui1.AddButton('button1').SetName('fancy button')
Gui1.AddButton('button2').Listen(function()
    print("PRESSED BUTTON 2")
end).SetColor(Color3.fromRGB(54, 45, 134))
Gui1.AddButton('(X)').SetNameColor(Color3.fromRGB(255, 148, 148))
Gui1.AddButton('1234567890123456789012345678901234567890').SetColor(Color3.fromRGB(52, 134, 45))
local B3 = Gui1.AddButton('button3').SetName('Locked Button').ReadOnly().Listen(function()
	print("PRESS")
end)
Gui1.AddButton('button4').SetName('Toggle Locked Button').Listen(function()
	if B3.IsReadOnly() then
		B3.ReadOnly(false)
		B3.SetName('Unlocked Button')
	else
		B3.ReadOnly(true)
		B3.SetName('Locked Button')
	end
end)

-- Folders --
local Folder1 = Gui1.AddFolder('Folder1', false)
	.SetName('My Cool Folder')
	.SetNameColor(Color3.fromRGB(0, 0, 0))
	.SetColor(Color3.fromRGB(82, 79, 235))

Folder1.AddBool('bool1', true)
Folder1.AddButton('button1')

local SubFolder1 = Folder1.AddFolder('SubFolder1', true)
	.SetColor(Color3.fromRGB(139, 108, 41))
SubFolder1.AddBool('bool1', false)
SubFolder1.AddInteger('int', 12)
SubFolder1.AddNumber('num1', 24)

local SubSubFolder1 = SubFolder1.AddFolder('SubSubFolder1', true)
	.SetNameColor(Color3.fromRGB(0, 0, 0))
	.SetColor(Color3.fromRGB(82, 79, 235))
SubSubFolder1.AddBool('bool1', false)
SubSubFolder1.AddInteger('int', 12)
SubSubFolder1.AddNumber('num1', 24)

Folder1.AddInteger('int1', 99)
Folder1.AddNumber('num1', 99.99)
Folder1.AddSeparator('separator1')
Folder1.AddString('string1', 'Cool Beans')
SubSubFolder1.AddString('test1', 'xxx')
SubFolder1.AddString('test1', 'xxx')

local DeepFolder1 = SubSubFolder1.AddFolder('DeepFolder1', false)
local DeepFolder2 = DeepFolder1.AddFolder('DeepFolder2', false)
local DeepFolder3 = DeepFolder2.AddFolder('DeepFolder3', false)
DeepFolder3.AddFolder('DeepFolder4', false)

local SmallFrameFolder1 = Gui1.AddFolder('Small Frame Folder', false)
SmallFrameFolder1
	.SetColor(Color3.fromRGB(184, 163, 44))
	.SetNameColor(Color3.new(0,0,0))
	.SetFrameHeightLimit(72)
	.SetScrollbarColor(Color3.fromRGB(184, 163, 44))
	.SetScrollbarWidth(24)

SmallFrameFolder1.AddString('string1', 'text')
SmallFrameFolder1.AddString('string2', 'text')
SmallFrameFolder1.AddString('string3', 'text')
SmallFrameFolder1.AddString('string4', 'text')
SmallFrameFolder1.AddString('string5', 'text')
SmallFrameFolder1.AddString('string6', 'text')
SmallFrameFolder1.AddString('string7', 'text')

-- Integers --
Gui1.AddInteger('int1', 1).SetName('fancy integer')
Gui1.AddInteger('int2', -1).SetNameColor(Color3.fromRGB(255, 148, 148))
Gui1.AddInteger('int3', '_9_#$%#$&*')
Gui1.AddInteger('int4')
Gui1.AddInteger('int5', 6.6).Listen(function(NewValue)
    print("NEW int5: "..NewValue)
end).SetValueColor(Color3.fromRGB(39, 87, 59))
Gui1.AddInteger('int6', 1).Set(2).SetValueTextColor(Color3.fromRGB(62, 197, 118))
Gui1.AddInteger('int7', 1).Set('a')
Gui1.AddInteger('int8', 'a').Set(1).SetValueTextColor(Color3.fromRGB(0, 0, 0))

-- Numbers --
Gui1.AddNumber('num1', 1).SetName('fancy number')
Gui1.AddNumber('num2', -1).SetNameColor(Color3.fromRGB(148, 255, 175))
Gui1.AddNumber('num3', '9__#$%#$&*')
Gui1.AddNumber('num4')
Gui1.AddNumber('num5', 6.6).Listen(function(NewValue)
    print("NEW num: "..NewValue)
end).SetValueColor(Color3.fromRGB(87, 86, 39))
Gui1.AddNumber('num6', 1).Set(2).SetValueTextColor(Color3.fromRGB(197, 62, 175))
Gui1.AddNumber('num7', 1).Set('a').ReadOnly()
Gui1.AddNumber('num8', 'a').Set(1).SetValueTextColor(Color3.fromRGB(0, 0, 0))

-- Separators --
Gui1.AddSeparator('seperator1')
Gui1.AddSeparator('seperator2', Color3.fromRGB(223, 157, 35))
Gui1.AddSeparator('seperator3', Color3.fromRGB(129, 175, 36), 'TEST TEST')
Gui1.AddSeparator('seperator4', nil, '* SECTION TEST *', 42)
Gui1.AddSeparator('seperator5').SetColor(Color3.fromRGB(173, 72, 72))
Gui1.AddSeparator('seperator6').SetName('junkster')
Gui1.AddSeparator('seperator7').SetHeight(8)

-- Strings --
Gui1.AddString('string1', '1').SetName('fancy string')
Gui1.AddString('string2', 'aa').SetNameColor(Color3.fromRGB(255, 200, 148))
Gui1.AddString('string3', '__#$%#$&*').SetValueColor(Color3.fromRGB(87, 86, 39))
Gui1.AddString('string4').SetValueTextColor(Color3.fromRGB(248, 150, 232))
Gui1.AddString('string5', 'default').Listen(function(NewValue)
    print("NEW STRING5: "..NewValue)
end)
Gui1.AddString('string6', 'a').Set('b')

---------------
-- Other API --
---------------

Gui1.AddSeparator('OtherSeparator').SetName('* Misc *')

-- removing invalid Gui --
Gui1.Remove('Non-ExistantGuiName')

-- removing valid Gui --
Gui1.AddInteger('remove1', 1)
Gui1.Remove('remove1')

-- Attempting to access removed Guis --
local rBool = Gui1.AddBool('removeBool', true)
Gui1.Remove('removeBool')
rBool.SetName('Invalid')

local rButton = Gui1.AddButton('removeButton')
Gui1.Remove('removeButton')
rButton.SetName('Invalid')

local rInteger = Gui1.AddInteger('removeInteger')
Gui1.Remove('removeInteger')
rInteger.SetName('Invalid')

local rNumber = Gui1.AddNumber('removeNumber')
Gui1.Remove('removeNumber')
rNumber.SetName('Invalid')

local rSeparator = Gui1.AddSeparator('removeSeparator')
Gui1.Remove('removeSeparator')
rSeparator.SetName('Invalid')

local rString = Gui1.AddString('removeString')
Gui1.Remove('removeString')
rString.SetName('Invalid')

----------------------
-- Multiple Windows --
----------------------
local Extra1 = DebuGui.new('Extra1', {
    Title = 'Extra1',
    X = 100,
    Y = 70,
    Width = 400,
    Height = 300,
})
Extra1.SetTopBarColor(Color3.fromRGB(65, 103, 161))

local Extra2 = DebuGui.new('Extra2', {
    Title = 'Extra2',
    X = 50,
    Y = 130,
    Width = 400,
    Height = 300,
})
Extra2.SetTopBarColor(Color3.fromRGB(65, 103, 161))