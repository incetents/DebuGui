-- © 2021 Emmanuel Lajeunesse

-- Roblox Services --
local ReplicatedStorage = game:GetService("ReplicatedStorage")

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
local Gui1 = DebuGui.NewWindow('Core', {
	Title = 'TEST NAME HERE 12312312',
	X = 150,
	Y = 20,
	Width = 600,
	Height = 520,
})
Gui1.SetTopBarColor(Color3.fromRGB(103, 65, 161))
Gui1.SetScrollbarWidth(10)
Gui1.SetScrollbarColor(Color3.fromRGB(134, 29, 103))

-- Additional Master Functions for testing
--	Gui1.Disable()
--	Gui1.Enable()
--	Gui1.Hide()
--	Gui1.Show()
--	Gui1.Minimize()
--	Gui1.Maximize()
--	Gui1.ToggleVisibility()
--	Gui1.ToggleMinimized()

-- Getting Reference to Gui
local Gui1_AlternateRef = DebuGui.GetWindow('Core')
Gui1_AlternateRef.AddIntegerSlider('TEST123', 2, 0, 10)
Gui1_AlternateRef.Remove('TEST123')


-- Text --
Gui1.AddSeparator('TEXT_SEPARATOR').SetName('TEXT')
--
Gui1.AddText('text1', 'abc')
Gui1.AddText('text2', 'abc').SetName('custom name')
Gui1.AddText('text3', 'zxc').Set('Funky')
Gui1.AddText('text4', 'text')
	.SetNameColor(Color3.fromRGB(223, 78, 78))
	.SetValueTextColor(Color3.fromRGB(78, 93, 223))

Gui1.AddText('text5', 'abc')
	.Listen(function(V)
		print('text5 changed to: ', V)
	end)
	.Set('Krankey Kong')

Gui1.AddText('text6', 'abc')
	.Set('Frankey Kong')
	.Listen(function(V)
		print('text6 changed to: ', V)
	end)


-- Booleans --
Gui1.AddSeparator('BOOL_SEPARATOR').SetName('BOOLS')
--
Gui1.AddBool('bool1', true).SetName('fancy bool')
Gui1.AddBool('bool2', false).SetNameColor(Color3.new(1,0,0))
Gui1.AddBool('bool3').SetCheckboxColor(Color3.fromRGB(46, 106, 124))
Gui1.AddBool('bool4', true).Listen(function(NewValue)
	print("New Bool4 Value: ", NewValue)
end)
Gui1.AddBool('bool5', false).Set(true).SetCheckboxColor(Color3.fromRGB(122, 40, 122))
Gui1.AddBool('bool6', true).SetReadOnly()
Gui1.AddBool('bool7', false).SetReadOnly().Set(true).Set(false)


-- Buttons --
Gui1.AddSeparator('BUTTON_SEPARATOR').SetName('BUTTONS')
--
Gui1.AddButton('button1').SetName('fancy button')
Gui1.AddButton('button2').Listen(function()
	print("PRESSED BUTTON 2")
end).SetColor(Color3.fromRGB(54, 45, 134))
Gui1.AddButton('(X)').SetNameColor(Color3.fromRGB(255, 148, 148))
Gui1.AddButton('1234567890123456789012345678901234567890').SetColor(Color3.fromRGB(52, 134, 45))
local B3 = Gui1.AddButton('button3').SetName('Locked Button').SetReadOnly().Listen(function()
	print("PRESS")
end)
Gui1.AddButton('button4').SetName('Toggle Locked Button').Listen(function()
	if B3.IsReadOnly() then
		B3.SetReadOnly(false)
		B3.SetName('Unlocked Button')
	else
		B3.SetReadOnly(true)
		B3.SetName('Locked Button')
	end
end)


-- Integers --
Gui1.AddSeparator('INTEGERS_SEPARATOR').SetName('INTEGERS')
--
Gui1.AddInteger('int1', 1).SetName('fancy integer')
Gui1.AddInteger('int2', -1).SetNameColor(Color3.fromRGB(255, 148, 148))
Gui1.AddInteger('int3', '_9_#$%#$&*')
Gui1.AddInteger('int4')
Gui1.AddInteger('int5', 6.6).Listen(function(NewValue)
	print("NEW int5 Value: "..NewValue)
end).SetValueBGColor(Color3.fromRGB(39, 87, 59))
Gui1.AddInteger('int6', 1).Set(2).SetValueTextColor(Color3.fromRGB(62, 197, 118))
Gui1.AddInteger('int7', 1).Set('a')
Gui1.AddInteger('int8', 'a').Set(1).SetValueTextColor(Color3.fromRGB(0, 0, 0))


-- Integer Sliders --
Gui1.AddSeparator('INTEGER_SLIDER_SEPARATOR').SetName('INTEGER SLIDERS')
--
Gui1.AddIntegerSlider('intslider1', 2, 0, 10, DebuGui.SLIDERPARAM_UPDATE_ON_MOVEMENT).Listen(function(NewValue)
	print('New intslider1 Value: '..NewValue)
end)
Gui1.AddIntegerSlider('intslider2', 0, -5, 5, DebuGui.SLIDERPARAM_UPDATE_ON_RELEASE).Listen(function(NewValue)
	print('New intslider2 Value: '..NewValue)
end)
Gui1.AddIntegerSlider('intslider3', 50.1, 0.1, 50.1)
Gui1.AddIntegerSlider('intslider4', 25, 0, 50).Set(99)
Gui1.AddIntegerSlider('intslider5', 25, 0, 50).Set(-1)


-- Long String
Gui1.AddSeparator('LONG_STRING_SEPARATOR').SetName('LONG STRING')
--
Gui1.AddLongString('longstring1', "line1\nline2\nline3")
Gui1.AddLongString('longstring2', "a\nb\nc\nd\ne")
	.SetHeightBasedOnLineCount(5)


-- Numbers --
Gui1.AddSeparator('NUMBER_SEPARATOR').SetName('NUMBERS')
--
Gui1.AddNumber('num1', 1).SetName('fancy number')
Gui1.AddNumber('num2', -1).SetNameColor(Color3.fromRGB(148, 255, 175))
Gui1.AddNumber('num3', '9__#$%#$&*')
Gui1.AddNumber('num4')
Gui1.AddNumber('num5', 6.6).Listen(function(NewValue)
	print("New num5 Value: "..NewValue)
end).SetValueBGColor(Color3.fromRGB(87, 86, 39))
Gui1.AddNumber('num6', 1).Set(2).SetValueTextColor(Color3.fromRGB(197, 62, 175))
Gui1.AddNumber('num7', 1).Set('a').SetReadOnly()
Gui1.AddNumber('num8', 'a').Set(1).SetValueTextColor(Color3.fromRGB(0, 0, 0))
Gui1.AddNumber('num9', '123.456789', false, 3).Listen(function(NewValue)
	print("New num9 Value: "..NewValue)
end)

Gui1.AddNumber('num_colorOnNumber', 100, false)
	.SetValueTextColor(Color3.new(0,0,0))
	.SetValueBGColor(Color3.fromRGB(100, 255, 255))
	.Listen(function(NewValue)
		Gui1.Get('num_colorOnNumber').SetValueBGColor(Color3.fromRGB(NewValue, NewValue * 0.5, 255 - NewValue))
end)


-- Number Sliders --
Gui1.AddSeparator('NUMBER_SLIDER_SEPARATOR').SetName('NUMBER SLIDERS')
--
Gui1.AddNumberSlider('numslider1', 100, 50, 100, nil, DebuGui.SLIDERPARAM_UPDATE_ON_MOVEMENT).SetValueBGColor(Color3.fromRGB(197, 62, 175)).Listen(function(NewValue)
	print('New numslider1 Value: '..NewValue)
end)
Gui1.AddNumberSlider('numslider2', 100, 100, 200, 4, DebuGui.SLIDERPARAM_UPDATE_ON_RELEASE).SetValueTextColor(Color3.fromRGB(62, 197, 118)).Listen(function(NewValue)
	print('New numslider2 Value: '..NewValue)
end)
Gui1.AddNumberSlider('numslider3', 20, 0, 100, 3).Set(45)
Gui1.AddNumberSlider('numslider4', 40, 33, 44)
Gui1.AddNumberSlider('numslider5', 1, 2, 3, 2)--.SetReadOnly()
Gui1.AddNumberSlider('numslider6', 20, 0, 100, 1).Set(-1)
Gui1.AddNumberSlider('numslider7', 20, 0, 100, 0)
	.SetName('No Decimals')
	.SetNameColor(Color3.fromRGB(223, 157, 35))

Gui1.Remove('numslider4')


-- Separators --
Gui1.AddSeparator('SEPARATOR_SEPARATOR').SetName('SEPARATORS')
--
Gui1.AddSeparator('seperator1')
Gui1.AddSeparator('seperator2', Color3.fromRGB(223, 157, 35))
Gui1.AddSeparator('seperator3', Color3.fromRGB(129, 175, 36), 'TEST TEST')
Gui1.AddSeparator('seperator4', nil, '* SECTION TEST *', 42)
Gui1.AddSeparator('seperator5').SetColor(Color3.fromRGB(173, 72, 72))
Gui1.AddSeparator('seperator6').SetName('junkster')
Gui1.AddSeparator('seperator7').SetHeight(8)


-- Strings --
Gui1.AddSeparator('STRING_SEPARATOR').SetName('STRINGS')
--
Gui1.AddString('string1', 'aa').SetName('fancy string')
Gui1.AddString('string2', '1').SetNameColor(Color3.fromRGB(255, 200, 148))
Gui1.AddString('string3', '__#$%#$&*').SetValueBGColor(Color3.fromRGB(87, 86, 39))
Gui1.AddString('string4').SetValueTextColor(Color3.fromRGB(248, 150, 232))
Gui1.AddString('string5', 'default').Listen(function(NewValue)
	print("New String5 Value: "..NewValue)
end)
Gui1.AddString('string6', 'a').Set('b')


-- Vectors --
Gui1.AddSeparator('VECTOR_SEPARATOR').SetName('VECTORS')
--
Gui1.AddVector2('vec2_1', Vector2.new(7.9, -2)).Listen(function(NewVector)
	print("New vec2_1 Value: ", NewVector)
end)
Gui1.AddVector2('vec2_2', Vector2.new(666, 999)).SetReadOnly()
Gui1.AddVector2('vec2_3')
Gui1.AddVector2('vec2_4', Vector2.new(123.456789, 987.654321), false, 3)
Gui1.AddVector2('vec2_5', Vector2.new(-1, -1))
	.SetNameColor(Color3.fromRGB(223, 157, 35))
	.SetValueBGColor(Color3.fromRGB(248, 150, 232))
	.SetValueTextColor(Color3.fromRGB(0, 0, 0))


Gui1.AddVector3('vec3_1', Vector3.new(7.9, -2, 54)).Listen(function(NewVector)
	print("New vec3_1 Value: ", NewVector)
end)
Gui1.AddVector3('vec3_2', Vector3.new(666, 999, -1)).SetReadOnly()
Gui1.AddVector3('vec3_3')
Gui1.AddVector3('vec3_4', Vector3.new(123.456789, 987.654321, 555.55555), false, 3)
Gui1.AddVector3('vec3_5', Vector3.new(-1, -1, -1))
	.SetNameColor(Color3.fromRGB(223, 157, 35))
	.SetValueBGColor(Color3.fromRGB(248, 150, 232))
	.SetValueTextColor(Color3.fromRGB(0, 0, 0))


-- Color Slider
Gui1.AddSeparator('COLOR_SLIDER_SEPARATOR').SetName('COLOR SLIDERS')
--
Gui1.AddColorSliderRGB('ColorSliderRGB_1', Color3.fromRGB(123, 69, 255), DebuGui.SLIDERPARAM_UPDATE_ON_MOVEMENT)
	.Listen(function(NewValue)
		print('New ColorSliderRGB_1 Value: ', NewValue)
end)

Gui1.AddColorSliderRGB('ColorSliderRGB_2', Color3.fromRGB(0, 255, 77), DebuGui.SLIDERPARAM_UPDATE_ON_RELEASE)
	.Listen(function(NewValue)
		print('New ColorSliderRGB_2 Value: ', NewValue)
end)

Gui1.AddColorSliderRGBInt('ColorSliderRGBInt_1', Color3.fromRGB(10, 44, 78), nil)
	.Set(Color3.fromRGB(126, 0, 0))

Gui1.AddColorSliderRGBInt('ColorSliderRGBInt_2', Color3.fromRGB(66, 67, 68), 2, DebuGui.SLIDERPARAM_UPDATE_ON_RELEASE)
	.Listen(function(NewValue)
		print('New ColorSliderRGBInt_2 Value: ', NewValue)
end)

Gui1.AddColorSliderHSV('ColorSliderHSV_1', Color3.fromRGB(255, 255, 0), DebuGui.SLIDERPARAM_UPDATE_ON_RELEASE)
	.Set(Color3.fromRGB(126, 0, 0))
	.Listen(function(NewValue)
		print('New ColorSliderHSV_1 Value: ', NewValue)
end)


-- List Picker --
Gui1.AddSeparator('LIST_PICKER_SEPARATOR').SetName('LIST PICKERS')
--
Gui1.AddListPicker('listpicker1', 'bbb', {
	'aaa', 'bbb', 'ccc', 'ddd', 'eee_1234567890123456789012345678901234567890_eee'
}).Listen(function(NewChoice)
	print('listpicker1 choice: ', NewChoice)
end)

Gui1.AddListPicker('listpicker2', 'true', {
	'false', 'true', 'false', 'true', 'false', 'true', 'none'
}).Set('false')

Gui1.AddListPicker('listpicker3', nil, {'a', 'b', 'c'})
	.Listen(function(NewChoice)
		print('listpicker3 choice: ', NewChoice)
	end)

Gui1.AddListPicker('listpicker4', nil, {'a', 'b', 'c'}, true)
	.Listen(function(NewChoice)
		print('listpicker4 choice: ', NewChoice)
	end)
	.SetName('funny custom name')

Gui1.AddListPicker('listpicker5', '1', {'1'})
	.AddChoice('2')
	.AddChoice('3')
	.AddChoice('4')
	.Set('3')

Gui1.AddListPicker('listpicker6', '4', {'1', '2', '3', '4'})
	.RemoveChoice('2')
	.RemoveChoice('4')
	.RemoveChoice('1')
	.Set('1')
	.SetNameColor(Color3.fromRGB(223, 78, 78))

Gui1.AddListPicker('listpicker7', '3', {'1', '2', '3', '4'})
	.ChangeChoices({'a', 'b', 'c', 'd', '3'})
	.SetValueTextColor(Color3.fromRGB(223, 78, 78))

Gui1.AddListPicker('listpicker8', '3', {'1', '2', '3', '4'})
	.ChangeChoices({'a', 'b', 'c', 'd', 'e'})


-------------
-- Folders --
-------------

Gui1.AddSeparator('FOLDER_SEPARATOR').SetName('FOLDERS')

local Folder1 = Gui1.AddFolder('folder1', true)
	.SetName('My Cool Folder')
	.SetNameColor(Color3.fromRGB(0, 0, 0))
	.SetColor(Color3.fromRGB(82, 79, 235))

Folder1.AddBool('bool1', true)
Folder1.AddButton('button1')

local SubFolder1 = Folder1.AddFolder('SubFolder1', false)
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
Folder1.AddVector2('vec2', Vector2.new(33, 565))
Folder1.AddVector2('vec3', Vector2.new(33, 565))
Folder1.AddNumberSlider('numslider', 100, 0, 200)
Folder1.AddColorSliderHSV('colorsliderhsv', Color3.fromRGB(67, 44, 129), DebuGui.SLIDERPARAM_UPDATE_ON_RELEASE)
Folder1.AddListPicker('listpicker1', 'bbb', {
	'aaa', 'bbb', 'ccc', 'ddd', 'eee_1234567890123456789012345678901234567890_eee'
}).Listen(function(NewChoice)
	print('listpicker1 choice: ', NewChoice)
end)

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

SmallFrameFolder1.AddString('string1', 'text')
SmallFrameFolder1.AddString('string2', 'text')
SmallFrameFolder1.AddString('string3', 'text')
SmallFrameFolder1.AddString('string4', 'text')
SmallFrameFolder1.AddString('string5', 'text')
SmallFrameFolder1.AddString('string6', 'text')
SmallFrameFolder1.AddString('string7', 'text')

local SmallFrameFolder2 = Gui1.AddFolder('Small Frame Folder 2', true)
SmallFrameFolder2
	.SetColor(Color3.fromRGB(184, 163, 44))
	.SetNameColor(Color3.new(0,0,0))

SmallFrameFolder2.AddString('string1', 'text')
SmallFrameFolder2.AddString('string2', 'text')
SmallFrameFolder2.AddString('string3', 'text')
SmallFrameFolder2.AddString('string4', 'text')
SmallFrameFolder2.AddString('string5', 'text')
SmallFrameFolder2.AddString('string6', 'text')
SmallFrameFolder2.AddString('string7', 'text')

Gui1.Remove('Small Frame Folder 2')

----------------
-- Getter API --
----------------

-- print("~~~")
-- print("BoolGui API: ", Gui1.Get('bool1'))
-- print("ButtonGui API: ", Gui1.Get('button1'))
-- print("FolderGui API: ", Gui1.Get('folder1'))
-- print("IntegerGui API: ", Gui1.Get('int1'))
-- print("NumberGui API: ", Gui1.Get('num1'))
-- print("SeparatorGui API: ", Gui1.Get('seperator1'))
-- print("StringGui API: ", Gui1.Get('string1'))
-- print("Vector2Gui API: ", Gui1.Get('vec2_1'))
-- print("Vector3Gui API: ", Gui1.Get('vec3_1'))

-- print("~~~")
-- print('bool1 = ', Gui1.Get('bool1').GetValue())
-- print('button1 = ', Gui1.Get('button1').GetValue())
-- --print('folder1 = ', Gui1.Get('folder1').GetValue())
-- print('int1 = ', Gui1.Get('int1').GetValue())
-- print('Num1 = ', Gui1.Get('num1').GetValue())
-- print('seperator6 = ', Gui1.Get('seperator6').GetValue())
-- print('string1 = ', Gui1.Get('string1').GetValue())
-- print('vec2_1 = ', Gui1.Get('vec2_1').GetValue())

---------------
-- Removal API --
---------------

-- -- removing invalid Gui --
-- Gui1.Remove('Fake Non-ExistantGui')

-- -- removing valid Gui --
-- Gui1.AddInteger('remove1', 1)
-- Gui1.Remove('remove1')

-- -- Attempting to access removed Guis --
-- local rBool = Gui1.AddBool('removeBool', true)
-- Gui1.Remove('removeBool')
-- rBool.SetName('Invalid')

-- local rButton = Gui1.AddButton('removeButton')
-- Gui1.Remove('removeButton')
-- rButton.SetName('Invalid')

-- local rInteger = Gui1.AddInteger('removeInteger')
-- Gui1.Remove('removeInteger')
-- rInteger.SetName('Invalid')

-- local rNumber = Gui1.AddNumber('removeNumber')
-- Gui1.Remove('removeNumber')
-- rNumber.SetName('Invalid')

-- local rSeparator = Gui1.AddSeparator('removeSeparator')
-- Gui1.Remove('removeSeparator')
-- rSeparator.SetName('Invalid')

-- local rString = Gui1.AddString('removeString')
-- Gui1.Remove('removeString')
-- rString.SetName('Invalid')

-- local rVec2 = Gui1.AddVector2('removeVector2')
-- Gui1.Remove('removeVector2')
-- rVec2.SetName('Invalid')

--Gui1.Destroy()

----------------------
-- Multiple Windows --
----------------------
-- local Extra1 = DebuGui.NewWindow('Extra1', {
--     Title = 'Extra1',
--     X = 100,
--     Y = 70,
--     Width = 400,
--     Height = 300,
-- })
-- Extra1.SetTopBarColor(Color3.fromRGB(65, 103, 161))

-- local Extra2 = DebuGui.NewWindow('Extra2', {
--     Title = 'Extra2',
--     X = 50,
--     Y = 130,
--     Width = 400,
--     Height = 300,
-- })
-- Extra2.SetTopBarColor(Color3.fromRGB(65, 103, 161))