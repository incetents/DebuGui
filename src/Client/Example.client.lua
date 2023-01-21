-- © 2023 Emmanuel Lajeunesse

-- Roblox Services --
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Module --
local DebuGui = require(ReplicatedStorage.DebuGui)

local _ToDestroy = nil

-- Set Minimum Layout Order
DebuGui.SetDisplayOrderMinimum(600) -- All DebuGui windows will start from this number and increment

-- Create New Window
local Gui1 = DebuGui.NewWindow('Core', {
	Title = 'API Examples',
	X = 150,
	Y = 20,
	Width = 600,
	Height = 520,
})
--Gui1.Minimize()
Gui1.SetTopBarColor(Color3.fromRGB(103, 65, 161))
Gui1.SetScrollbarWidth(10)
Gui1.SetScrollbarColor(Color3.fromRGB(134, 29, 103))

-- Additional Master Functions for testing
--	Gui1.Disable()
--	Gui1.Enable()
--	Gui1.ToggleEnabled()
--	Gui1.Hide()
--	Gui1.Show()
--	Gui1.Minimize()
--	Gui1.Maximize()
--	Gui1.ToggleVisibility()
--	Gui1.ToggleMinimized()
--  Gui1.SetPosition(100, 100)
--  Gui1.SetSize(500, 5)

-- Getting Reference to Gui
local Gui1_AlternateRef = DebuGui.GetWindow('Core')
Gui1_AlternateRef.AddIntegerSlider('TEST123', 2, 0, 10)
Gui1_AlternateRef.Remove('TEST123')


-- Empty --
Gui1.AddSeparator('EMPTY_SEPARATOR').SetName('EMPTY')

Gui1.AddEmpty()
Gui1.AddEmpty(nil, 120)

-- Test Destroy
_ToDestroy = Gui1.AddEmpty()
_ToDestroy.Destroy()


-- Text Simple --
Gui1.AddSeparator('TEXT_SIMPLE_SEPARATOR').SetName('SIMPLE TEXT')
--
Gui1.AddSimpleText('SimpleString1', '12345678901234567890123456789012345678901234567890')
Gui1.AddSimpleText('SimpleString2', '???').SetValue('qwertyuiop')

-- Test Destroy
_ToDestroy = Gui1.AddSimpleText('SimpleStringDelete', "DON'T LOOK")
_ToDestroy.Destroy()


-- Text --
Gui1.AddSeparator('TEXT_SEPARATOR').SetName('TEXT')
--
Gui1.AddText('text1', 'abc')
Gui1.AddText('text2', 'abc').SetName('custom name')
Gui1.AddText('text3', 'zxc').SetValue('Funky')
Gui1.AddText('text4', 'text')
	.SetNameColor(Color3.fromRGB(223, 78, 78))
	.SetValueTextColor(Color3.fromRGB(78, 93, 223))

Gui1.AddText('text5', 'abc')
	.Listen(function(V)
		print('text5 changed to: ', V)
	end)
	.SetValue('Krankey Kong')

Gui1.AddText('text6', 'abc')
	.SetValue('Frankey Kong')
	.Listen(function(V)
		print('text6 changed to: ', V)
	end)

-- Test Destroy
_ToDestroy = Gui1.AddText('textDelete', "DON'T LOOK")
_ToDestroy.Destroy()


-- Booleans --
Gui1.AddSeparator('BOOL_SEPARATOR').SetName('BOOLS')
--
Gui1.AddBool('bool1', true).SetName('fancy bool').Listen(function(NewValue)
	print('bool1 result: ', NewValue)
end).SetValue(true).SetValue(false).SetValue(false).SetValue(true).SetValue(true)
Gui1.AddBool('bool2', false).SetNameColor(Color3.new(1,0,0))
Gui1.AddBool('bool3').SetCheckboxColor(Color3.fromRGB(46, 106, 124))
Gui1.AddBool('bool4', true).Listen(function(NewValue)
	print("New Bool4 Value: ", NewValue)
end)
Gui1.AddBool('bool5', false).SetValue(true).SetCheckboxColor(Color3.fromRGB(122, 40, 122))
Gui1.AddBool('bool6', true).SetReadOnly()
Gui1.AddBool('bool7', false).SetReadOnly().SetValue(true).SetValue(false)

Gui1.AddBool('bool_multi_listen', true)
	.Listen(function()
		print('multi listen A')
	end)
	.Listen(function()
		print('multi listen B')
	end)

-- Test Destroy
_ToDestroy = Gui1.AddBool('boolDelete', true)
_ToDestroy.Destroy()


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

-- Test Destroy
_ToDestroy = Gui1.AddButton('buttonDelete')
_ToDestroy.Destroy()


-- Integers --
Gui1.AddSeparator('INTEGERS_SEPARATOR').SetName('INTEGERS')
--
Gui1.AddInteger('int_test', 1).Listen(function(NewValue)
	print('int_test', NewValue)
end)
Gui1.AddInteger('int1', 1).SetName('fancy integer')
Gui1.AddInteger('int2', -1).SetNameColor(Color3.fromRGB(255, 148, 148))
Gui1.AddInteger('int3', '_9_#$%#$&*')
Gui1.AddInteger('int4')
Gui1.AddInteger('int5', 6.6).Listen(function(NewValue)
	print("NEW int5 Value: "..NewValue)
end).SetValueBGColor(Color3.fromRGB(39, 87, 59))
Gui1.AddInteger('int6', 1).SetValue(2).SetValueTextColor(Color3.fromRGB(62, 197, 118))
Gui1.AddInteger('int7', 1).SetValue('a')
Gui1.AddInteger('int8', 'a').SetValue(1).SetValueTextColor(Color3.fromRGB(0, 0, 0))
Gui1.AddInteger('int9', 99).SetReadOnly()

-- Test Destroy
_ToDestroy = Gui1.AddInteger('intDelete', 123)
_ToDestroy.Destroy()


-- Integer Sliders --
Gui1.AddSeparator('INTEGER_SLIDER_SEPARATOR').SetName('INTEGER SLIDERS')
--
Gui1.AddIntegerSlider('intslider1 (constant update)', 2, 0, 10, false).Listen(function(NewValue)
	print('New intslider1 Value: '..NewValue)
end)
Gui1.AddIntegerSlider('intslider2 (drag end update)', 0, -5, 5, true).Listen(function(NewValue)
	print('New intslider2 Value: '..NewValue)
end)
Gui1.AddIntegerSlider('intslider3', 50.1, 0.1, 50.1)
Gui1.AddIntegerSlider('intslider4', 25, 0, 50).SetValue(99)
Gui1.AddIntegerSlider('intslider5', 25, 0, 50).SetValue(-1)
Gui1.AddIntegerSlider('intslider6', 1, -2, 2).SetReadOnly()

Gui1.AddIntegerSlider('intslider_min', 0, -20, 20)
	.SetMinValue(1)

Gui1.AddIntegerSlider('intslider_max', 0, -20, 20)
	.SetMaxValue(-1)

-- Test Destroy
_ToDestroy = Gui1.AddIntegerSlider('intsliderDelete', 5, 0, 10)
_ToDestroy.Destroy()


-- Long String
Gui1.AddSeparator('LONG_STRING_SEPARATOR').SetName('LONG STRING')
--
Gui1.AddLongString('longstring1', "line1\nline2\nline3")
Gui1.AddLongString('longstring2', "a\nb\nc\nd\ne")
	.SetHeightBasedOnLineCount(5)

Gui1.AddLongString('longstring2 (biased)', "a\nb\nc\nd\ne\nf")
	.SetHeightBasedOnLineCount(6)

Gui1.AddLongString('longstring2 (biased again)', "a\nb\nc\nd\ne\nf\ng")
	.SetHeightBasedOnLineCount(7)

Gui1.AddLongString('longstring3', "line1\nline2\nline3", false, 30)
Gui1.AddLongString('longstring4', "line1\nline2\nline3", false, 30).SetHeight(100)

Gui1.AddLongString('longstring_locked', "line1\nline2\nline3")
	.SetReadOnly()

-- Test Destroy
_ToDestroy = Gui1.AddLongString('longstringDelete',  "line1\nline2\nline3")
_ToDestroy.Destroy()


-- Numbers --
Gui1.AddSeparator('NUMBER_SEPARATOR').SetName('NUMBERS')
--
Gui1.AddNumber('num1', 1).SetName('fancy number')
Gui1.AddNumber('num2', -1).SetNameColor(Color3.fromRGB(148, 255, 175))
Gui1.AddNumber('num3', '9_#$%#$&*')
Gui1.AddNumber('num4')
Gui1.AddNumber('num5', 6.6).Listen(function(NewValue)
	print("New num5 Value: "..NewValue)
end).SetValueBGColor(Color3.fromRGB(87, 86, 39))
Gui1.AddNumber('num6', 1).SetValue(2).SetValueTextColor(Color3.fromRGB(197, 62, 175))
Gui1.AddNumber('num7', 1).SetValue('a').SetReadOnly()
Gui1.AddNumber('num8', 'a').SetValue(1).SetValueTextColor(Color3.fromRGB(0, 0, 0))
Gui1.AddNumber('num9', '123.456789', 3).Listen(function(NewValue)
	print("New num9 Value: "..NewValue)
end)

Gui1.AddNumber('num_colorOnNumber', 100)
	.SetValueTextColor(Color3.new(0,0,0))
	.SetValueBGColor(Color3.fromRGB(100, 255, 255))
	.Listen(function(NewValue)
		Gui1.Get('num_colorOnNumber').SetValueBGColor(Color3.fromRGB(NewValue, NewValue * 0.5, 255 - NewValue))
end)

-- Test Destroy
_ToDestroy = Gui1.AddNumber('numberDelete', 420)
_ToDestroy.Destroy()


-- Number Sliders --
Gui1.AddSeparator('NUMBER_SLIDER_SEPARATOR').SetName('NUMBER SLIDERS')
--
Gui1.AddNumberSlider('numslider1 (constant update)', 100, 50, 100, nil, false).SetValueBGColor(Color3.fromRGB(197, 62, 175)).Listen(function(NewValue)
	print('New numslider1 Value: '..NewValue)
end)
Gui1.AddNumberSlider('numslider2 (drag end update)', 100, 100, 200, 4, true).SetValueTextColor(Color3.fromRGB(62, 197, 118)).Listen(function(NewValue)
	print('New numslider2 Value: '..NewValue)
end)
Gui1.AddNumberSlider('numslider3', 20, 0, 100, 3).SetValue(45)
Gui1.AddNumberSlider('numslider4', 40, 33, 44)
Gui1.AddNumberSlider('numslider5', 1, 2, 3, 2)
Gui1.AddNumberSlider('numslider6', 20, 0, 100, 1).SetValue(-1)
Gui1.AddNumberSlider('numslider7', 20, 0, 100, 0)
	.SetName('No Decimals')
	.SetNameColor(Color3.fromRGB(223, 157, 35))

Gui1.Remove('numslider4')

Gui1.AddNumberSlider('numslider8', 1, 2, 3, 2).SetReadOnly()

Gui1.AddNumberSlider('numslider_min', 0, -20, 20, 4)
	.SetMinValue(1)

Gui1.AddNumberSlider('numslider_max', 0, -20, 20, 4)
	.SetMaxValue(-1)

-- Test Destroy
_ToDestroy = Gui1.AddNumberSlider('numberSliderDelete', 0, -20, 20, 1)
_ToDestroy.Destroy()


-- Separators --
Gui1.AddSeparator('SEPARATOR_SEPARATOR').SetName('SEPARATORS')
--
Gui1.AddSeparator('separator1')
Gui1.AddSeparator('separator2', Color3.fromRGB(223, 157, 35))
Gui1.AddSeparator('separator3', Color3.fromRGB(129, 175, 36)).SetName('TEST TEST')
Gui1.AddSeparator('separator4', nil, 42)
Gui1.AddSeparator('separator5').SetFrameColor(Color3.fromRGB(173, 72, 72))
Gui1.AddSeparator('separator6').SetName('junkster')
Gui1.AddSeparator('separator7').SetHeight(8)

-- Test Destroy
_ToDestroy = Gui1.AddSeparator('separatorDelete')
_ToDestroy.Destroy()


-- Strings --
Gui1.AddSeparator('STRING_SEPARATOR').SetName('STRINGS')
--
Gui1.AddString('string1', 'aa').SetName('fancy string').Listen(function(NewValue)
	print(NewValue)
end)
Gui1.AddString('string2', '1').SetNameColor(Color3.fromRGB(255, 200, 148))
Gui1.AddString('string3', '_#$%#$&*').SetValueBGColor(Color3.fromRGB(87, 86, 39))
Gui1.AddString('string4').SetValueTextColor(Color3.fromRGB(248, 150, 232))
Gui1.AddString('string5', 'default').Listen(function(NewValue)
	print("New String5 Value: "..NewValue)
end)
Gui1.AddString('string6', 'a').SetValue('b')
Gui1.AddString('string7', 'readonly string').SetReadOnly()

-- Test Destroy
_ToDestroy = Gui1.AddString('stringDelete', 'GONE')
_ToDestroy.Destroy()


-- Vectors --
Gui1.AddSeparator('VECTOR_SEPARATOR').SetName('VECTORS')
--
Gui1.AddVector2('vec2_1', Vector2.new(7.9, -2)).Listen(function(NewVector)
	print("New vec2_1 Value: ", NewVector)
end)
Gui1.AddVector2('vec2_2', Vector2.new(666, 999)).SetReadOnly()
Gui1.AddVector2('vec2_3')
Gui1.AddVector2('vec2_4', Vector2.new(123.456789, 987.654321), 3)
Gui1.AddVector2('vec2_5', Vector2.new(-1, -1))
	.SetNameColor(Color3.fromRGB(223, 157, 35))
	.SetValueBGColor(Color3.fromRGB(248, 150, 232))
	.SetValueTextColor(Color3.fromRGB(0, 0, 0))

Gui1.AddVector2('vec2_6', Vector2.new(6, 6)).SetReadOnly()


Gui1.AddVector3('vec3_1', Vector3.new(7.9, -2, 54)).Listen(function(NewVector)
	print("New vec3_1 Value: ", NewVector)
end)
Gui1.AddVector3('vec3_2', Vector3.new(666, 999, -1)).SetReadOnly()
Gui1.AddVector3('vec3_3')
Gui1.AddVector3('vec3_4', Vector3.new(123.456789, 987.654321, 555.55555), 3)
Gui1.AddVector3('vec3_5', Vector3.new(-1, -1, -1))
	.SetNameColor(Color3.fromRGB(223, 157, 35))
	.SetValueBGColor(Color3.fromRGB(248, 150, 232))
	.SetValueTextColor(Color3.fromRGB(0, 0, 0))

Gui1.AddVector3('vec3_6', Vector3.new(6, 6, 6)).SetReadOnly()

-- Test Destroy
_ToDestroy = Gui1.AddVector2('vec2Delete', Vector2.new(1, 2))
_ToDestroy.Destroy()
-- Test Destroy
_ToDestroy = Gui1.AddVector3('vec2Delete', Vector3.new(1, 2, 3))
_ToDestroy.Destroy()


-- Color Slider
Gui1.AddSeparator('COLOR_SLIDER_SEPARATOR').SetName('COLOR SLIDERS')
--
Gui1.AddColorSliderRGB('ColorSliderRGB_1', Color3.fromRGB(123, 69, 255), 2, true)
	.Listen(function(NewValue)
		print('New ColorSliderRGB_1 Value: ', NewValue)
end)

Gui1.AddColorSliderRGB('ColorSliderRGB_2', Color3.fromRGB(0, 255, 77), nil, true)
	.Listen(function(NewValue)
		print('New ColorSliderRGB_2 Value: ', NewValue)
end)

Gui1.AddColorSliderRGBInt('ColorSliderRGBInt_1', Color3.fromRGB(10, 44, 78))
	.SetValue(Color3.fromRGB(126, 0, 0))

Gui1.AddColorSliderRGBInt('ColorSliderRGBInt_2', Color3.fromRGB(66, 67, 68), true)
	.Listen(function(NewValue)
		print('New ColorSliderRGBInt_2 Value: ', NewValue)
end)

Gui1.AddColorSliderHSV('ColorSliderHSV_1', Color3.fromRGB(255, 255, 0), 2, true)
	.SetValue(Color3.fromRGB(126, 0, 0))
	.Listen(function(NewValue)
		print('New ColorSliderHSV_1 Value: ', NewValue)
end)

Gui1.AddColorSliderHSVInt('ColorSliderHSV_2', Color3.fromRGB(111, 0, 255), true)
	.SetValue(Color3.fromRGB(0, 107, 126))
	.Listen(function(NewValue)
		print('New ColorSliderHSV_2 Value: ', NewValue)
end)

Gui1.AddColorSliderRGBInt('ColorSliderRGB_Locked', Color3.fromRGB(123, 69, 255))
	.SetReadOnly()

-- Test Destroy
_ToDestroy = Gui1.AddColorSliderRGB('rgbDelete', Color3.fromRGB(123, 69, 255), 2, true)
_ToDestroy.Destroy()
_ToDestroy = Gui1.AddColorSliderRGBInt('rgbDelete', Color3.fromRGB(123, 69, 255), true)
_ToDestroy.Destroy()
_ToDestroy = Gui1.AddColorSliderHSV('hsvDelete', Color3.fromRGB(123, 69, 255), 2, true)
_ToDestroy.Destroy()
_ToDestroy = Gui1.AddColorSliderHSVInt('hsvDelete', Color3.fromRGB(123, 69, 255), true)
_ToDestroy.Destroy()


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
}).SetValue('false')

Gui1.AddListPicker('listpicker3', nil, {'a', 'b', 'c'})
	.Listen(function(NewChoice)
		print('listpicker3 choice: ', NewChoice)
	end)

Gui1.AddListPicker('listpicker4', nil, {'a', 'b', 'c'}, true, true, true)
	.Listen(function(NewChoice)
		print('listpicker4 choice: ', NewChoice)
	end)
	.SetName('funny custom name')

Gui1.AddListPicker('listpicker5', '1', {'1'})
	.AddChoice('2')
	.AddChoice('3')
	.AddChoice('4')
	.SetValue('3')

Gui1.AddListPicker('listpicker6', '4', {'1', '2', '3', '4'})
	.RemoveChoice('2')
	.RemoveChoice('4')
	.RemoveChoice('1')
	.SetValue('1')
	.SetNameColor(Color3.fromRGB(223, 78, 78))

Gui1.AddListPicker('listpicker7', '3', {'1', '2', '3', '4'})
	.ChangeChoices({'a', 'b', 'c', 'd', '3'})
	.SetValueTextColor(Color3.fromRGB(223, 78, 78))

Gui1.AddListPicker('listpicker8', '3', {'1', '2', '3', '4'})
	.ChangeChoices({'a', 'b', 'c', 'd', 'e'})

Gui1.AddListPicker('listpicker_locked', '1', {'1', '2', '3'}).SetReadOnly()

-- Test Destroy
_ToDestroy = Gui1.AddListPicker('listDelete', '1', {'1', '2', '3'})
_ToDestroy.Destroy()

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

Folder1.AddSeparator('empty space (90 px)')
Folder1.AddEmpty(nil, 90)

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
Folder1.AddColorSliderHSV('colorsliderhsv', Color3.fromRGB(67, 44, 129), 2, true)
Folder1.AddListPicker('listpicker1', 'bbb', {
	'aaa', 'bbb', 'ccc', 'ddd', 'eee_1234567890123456789012345678901234567890_eee'
}).Listen(function(NewChoice)
	print('listpicker1 choice: ', NewChoice)
end)

Folder1.AddLongString('longstring1', "line1\nline2\nline3")
Folder1.AddLongString('longstring2', "a\nb\nc\nd\ne")
	.SetHeightBasedOnLineCount(5)

Folder1.AddLongString('longstring3', "line1\nline2\nline3", false, 30)
Folder1.AddLongString('longstring4', "line1\nline2\nline3", false, 30).SetHeight(100)

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

-- Test Destroy
_ToDestroy = Gui1.AddFolder('folderDelete', true)
_ToDestroy.AddString('stringdelete', 'fake')
_ToDestroy.Destroy()

print('------ SEPARATION LINE ------')

----------------
-- Getter API --
----------------

-- Getters for Values

-- print("~~~ Quick Value Getters")
-- print('bool1 = ', Gui1.Get('bool1').GetValue())
-- print('button1 = ', Gui1.Get('button1').GetValue())
-- print('ColorSliderRGB_1 = ', Gui1.Get('ColorSliderRGB_1').GetValue())
-- print('folder1 = ', Gui1.Get('folder1').GetValue())
-- print('int1 = ', Gui1.Get('int1').GetValue())
-- print('intslider1 = ', Gui1.Get('intslider1').GetValue())
-- print('num1 = ', Gui1.Get('num1').GetValue())
-- print('numslider1 = ', Gui1.Get('numslider1').GetValue())
-- print('separator6 = ', Gui1.Get('separator6').GetValue())
-- print('string1 = ', Gui1.Get('string1').GetValue())
-- print('text1 = ', Gui1.Get('text1').GetValue())
-- print('vec2_1 = ', Gui1.Get('vec2_1').GetValue())
-- print('vec3_1 = ', Gui1.Get('vec3_1').GetValue())

-- API Acessing
-- !!! EXPENSIVE/SLOW TO PRINT, only use for testing/sparingly !!! --

-- print("BoolGui API: ", Gui1.Get('bool1'))
-- print("ButtonGui API: ", Gui1.Get('button1'))
-- print("ColorSliderGui API: ", Gui1.Get('ColorSliderRGB_1'))
-- print("FolderGui API: ", Gui1.Get('folder1'))
-- print("IntegerGui API: ", Gui1.Get('int1'))
-- print("IntegerSliderGui API: ", Gui1.Get('intslider1'))
-- print("ListPickerGui API: ", Gui1.Get('listpicker1'))
-- print("LongStringGui API: ", Gui1.Get('longstring1'))
-- print("NumberGui API: ", Gui1.Get('num1'))
-- print("NumberSliderGui API: ", Gui1.Get('numslider1'))
-- print("SeparatorGui API: ", Gui1.Get('separator1'))
-- print("StringGui API: ", Gui1.Get('string1'))
-- print("TextGui API: ", Gui1.Get('text1'))
-- print("Vector2Gui API: ", Gui1.Get('vec2_1'))
-- print("Vector3Gui API: ", Gui1.Get('vec3_1'))

---------------
-- Removal API --
---------------

-- removing invalid Gui --
Gui1.Remove('Fake Non-ExistantGui')

-- removing valid Gui --
Gui1.AddInteger('remove1', 1)
Gui1.Remove('remove1')

-- Examples of attempting to access removed Guis --
print("~~~")
local rBool = Gui1.AddBool('removeBool', true)
print(Gui1.Get('removeBool').GetValue())
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

local rVec2 = Gui1.AddVector2('removeVector2')
Gui1.Remove('removeVector2')
rVec2.SetName('Invalid')

------------------------
-- Destroy Entire Gui --
------------------------
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