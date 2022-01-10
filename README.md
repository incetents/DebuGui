<!-- iNTRO -->

# DebuGui

DebuGui is an open-source Roblox module that allows users to easily visualize and debug data for their projects with a simple yet flexibly UI system

DebuGui in action:
> ![RobloxStudioBeta_y169wx00Cr](https://user-images.githubusercontent.com/22376381/138623157-e18f079e-43bf-482f-a869-ff9cee4ae07d.png)

https://user-images.githubusercontent.com/22376381/148710941-a6f45eee-98f6-4bac-980d-54c37397bedb.mp4

---

## Examples

In the github project you'll notice some files under src/Client/ that all begin with the word Example. If you want to quickly figure out how to use this module from examples alone, or just want some inspiration on how to use the modules, I suggest taking a look at these files in the Demo.rbxlx scene.
> Example.client.lua

* (for showing a multitude of Gizmo Api calls)

> Example_RacingCondition.client.lua

* (showcasing how to easily grab an existing Window from a different script)

> Example_Scene.client.lua

* (for some more real world examples in the example scene)

---

## Documentation

Under the DebuGui module, there is a module called "Documentation" that contains an example of all the API calls that can be used as an easy reference

> [**Quick Link**](https://github.com/incetents/DebuGui/blob/main/src/Shared/DebuGui/Documentation.lua)

---

## Setup

DebuGui aims to make the process of setup and usage as simple and straightforward as possible.

Firstly, place the core DebuGui module with all of its children in ReplicatedStorage (or whichever client-side location you prefer) and then you're all set.

> ![RobloxStudioBeta_bsXm8c3c5q](https://user-images.githubusercontent.com/22376381/148711026-08488bdb-7c8f-44e9-bec9-817468e43f5d.png)

Now let's create a window

Code:

```lua
-- Setup
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local DebuGui = require(ReplicatedStorage.DebuGui)

-- Create New Window,
local Gui = DebuGui.NewWindow('WINDOW_1', -- First Parameter is WindowID
{ 
	Title = 'Example1',
	X = 250,
	Y = 30,
	Width = 600,
	Height = 520,
})
```

Result:

> ![image1](https://user-images.githubusercontent.com/22376381/148704369-4b8aa626-9e7b-4823-96a5-3509eec23a15.png)

## Notice:
> If ever you need to grab the same window from another script, you can use these Getter functions
```lua
-- Get Window if it exists
local Gui = DebuGui.GetWindow('WINDOW_1') -- Parameter is the WindowID

-- Yield until Window is created
local Gui = DebuGui.WaitForWindow('WINDOW_1') -- Parameter is the WindowID
```

---

## Modifying the Window

There are some API calls to modify the window manually

Example Code:
```lua
Gui.Enable() -- Enables the ScreenGui
Gui.Disable() -- Disables the ScreenGui

Gui.Hide() -- Collapses the Window into a titlebar
Gui.Show() -- Uncollapses the Window
Gui.ToggleVisibility() -- Toggle Collapsable state
Gui.IsVisible() -- Returns Visibility State

Gui.SetPosition(X, Y) -- Sets the Window Position
Gui.SetSize(W, H) -- Sets the Window Size
```

## Minimize

You'll notice that there is a small minus button, this is to minimize the window in the bottom left of the screen. You can then click the docked windows plus button to maximize it.

> ![RobloxStudioBeta_QwWByhiPdU](https://user-images.githubusercontent.com/22376381/148709897-71ce989c-50af-408f-b0d5-616240442aba.png)

> ![RobloxStudioBeta_MuSs0dtaYT](https://user-images.githubusercontent.com/22376381/148709896-39c66207-d6f8-4752-9867-cc5a3d229437.png)

Here are the api calls to do this manually

```lua
Gui.Minimize()
Gui.Maximize()
Gui.ToggleMinimized()
```

---

## Adding Gizmos

Now for the fun part, let's add a few simple data altering gizmos.

Code: 
```lua
-- 1st Parameter is UniqueID (doubles as name)
-- 2nd Parameter is DefaultData (leave blank to start with 0, false, or an empty string)

-- Boolean
Gui.AddBool('bool1', true)

-- Integer
Gui.AddInteger('int1', 1)

-- Number
Gui.AddNumber('num1', 45.78)

-- String
Gui.AddString('string1', 'aa')
```

Result:

> ![RobloxStudioBeta_bR3NYBG1q8](https://user-images.githubusercontent.com/22376381/148705265-5948a904-6526-4500-a555-dd3fb89c4517.png)

---

## Listening / Changing Data

We want to be able to know when we edit the gizmo data, we can achieve this by appending a "Listen" function at the end of our gizmos

Code:
```lua
-- Boolean Gizmo
Gui.AddBool('bool1', true).Listen(function(NewValue)
	print('bool1 new value: ', NewValue)
end)

-- Integer Gizmo
Gui.AddInteger('int1', 1).Listen(function(NewValue)
	print('int1 new value: ', NewValue)
end)

-- Number Gizmo
Gui.AddNumber('num1', 45.78).Listen(function(NewValue)
	print('num1 new value: ', NewValue)
end)

-- String Gizmo
Gui.AddString('string1', 'aa').Listen(function(NewValue)
	print('string1 new value: ', NewValue)
end)
```

Result:

> ![RobloxStudioBeta_NVoX9srerU](https://user-images.githubusercontent.com/22376381/148705540-2bf99c61-4833-45f7-aa21-fe8e5991e3a0.png)
![RobloxStudioBeta_z3a3I6zQkT](https://user-images.githubusercontent.com/22376381/148705542-2e3b9d64-90cb-4a8b-8b6b-c9a735068f27.png)

---

If we want to get the value at any given notice, we can just use the GetValue() function.

```lua
-- Integer Gizmo
print(Gui.AddInteger('int1', 444).GetValue())
```
> output: 444

And if we want to manually change a gizmos data ourself, we can just use the SetValue() function on any current gizmo (Assuming the given parameter is of a valid type)

```lua
-- Integer Gizmo
Gui.AddInteger('int1', 1).SetValue(99)
```
---

## Stacked Calls

All the setter functions in a Gizmos API will return the API itself, meaning that you can call Setter functions one after another in sequence.

Code:
```lua
-- Integer Gizmo
Gui.AddInteger('int1', 1)
	.SetValue(99)
	.SetName('My Cool Integer')
	.SetNameColor(Color3.fromRGB(255, 255, 0))
	.SetValueBGColor(Color3.fromRGB(73, 14, 14))
	.SetValueTextColor (Color3.fromRGB(241, 95, 95))
	.SetReadOnly(true)
```

Result:

> ![RobloxStudioBeta_Ck5d3yeerg](https://user-images.githubusercontent.com/22376381/148705790-c72efbbb-2d49-4297-82f6-104c17439689.png)

For more information on the api of each gizmo, I suggest looking at the Documentation module

---

## Flexibility

You might have noticed that having all the API calls cramped in one location makes it far more difficult to use and the GetValue() function having no real benefit if only called after the creation of the gizmo.

We can resolve this issue by calling the Get() function on the window/folder itself to get the Gizmo API to use it elsewhere. Just make sure you use the correct UniqueID

Code:
```lua
-- Integer Gizmo
Gui.AddInteger('int1', 1)
	.SetValue(99)
	.SetName('My Cool Integer')

local IntGizmo = Gui.Get('int1')
print(IntGizmo.GetValue())

IntGizmo.SetValue(44)
print(IntGizmo.GetValue())
```

Result:

> ![RobloxStudioBeta_mlf2xft62D](https://user-images.githubusercontent.com/22376381/148706052-28f3ff29-220e-4c23-bb67-0b814a2f9b81.png)
![RobloxStudioBeta_hFKfeNexVa](https://user-images.githubusercontent.com/22376381/148706054-8bb44f5a-9c0d-44e0-8937-5043fa361e83.png)

## Notice:
> SetName does not change the UniqueID of the gizmo, in the above example, you'll still be using Get() on the UniqueID that was used on creation

---

## Folders

We can improve the organization of the Window by utilizing folder gizmos. Folders can collapse all gizmos inside of them to quickly hide them from view.

To achieve this, we create a folder gizmo and then add gizmos to the folder similarily to how we would do it on the Window.

Code:
```lua
-- Folder Gizmo
Gui.AddFolder('Folder1', true) -- 2nd parameter is whether it starts open or closed
Gui.Get('Folder1').AddNumber('MyNumber', 33.44)
Gui.Get('Folder1').AddNumber('num1', 129.0)
```

Result:

> ![RobloxStudioBeta_PVKTaSIFqL](https://user-images.githubusercontent.com/22376381/148706497-a37cc2e8-215a-44f0-8521-c50db7e1f746.png)


## Notice:
> You'll notice I re-used an existing Gizmo UniqueID in this example "num1". This is because the UniqueIDs only need to be unique under their parent. If two gizmos have the same ID under different parents, then there's no conflict

---

## Folders Within Folders:

Since the Folder Api can add folder gizmos, we can recursively add more folders inside of folders. The parent folders will simply hide all child folders when collapsed.

Code:
```lua
-- Folder Gizmo
Gui.AddFolder('Folder1', true)
local Folder1 = Gui.Get('Folder1')
Folder1.AddNumber('MyNumber', 33.44)
Folder1.AddNumber('num1', 129.0)

-- Folder inside of a Folder :O
local FolderSquared = Folder1.AddFolder('FolderSquared')
FolderSquared.SetColor(Color3.fromRGB(146, 106, 19))
FolderSquared.AddString('str1', 'Cool Pants')
```

Result:

> ![RobloxStudioBeta_ToqhwAecZW](https://user-images.githubusercontent.com/22376381/148706874-c284e282-7134-411a-97d8-e05837381a25.png)

---

## Removing Gizmos

If for any reason you want to remove an existing Gizmo, you can call the Remove() function on a Window/Folder to delete all data associated with the Gizmo, just make sure to clear your references to dead gizmos if you have any

Example Code:
```lua
-- Number Gizmo
Gui.AddNumber('num1', 45.78).Listen(function(NewValue)
	print('num1 new value: ', NewValue)
end)

-- API
local Num1 = Gui.Get('num1') -- Valid Gizmo API

-- Remove Number Gizmo
Gui.Remove('num1')

-- Attempting to access dead Gizmo
Num1.SetValue(100) --> Will do nothing and output a Warning
```

---

## ReadOnly Flag

ReadOnly is a special flag that is used on all Gizmos (except for folders, text, and separators). This will cause the gizmo to be in a custom state where it cannot be modified in the UI anymore, except by calling SetValue() in the code or disabling the ReadOnly state.


The name and value of the gizmo in the UI will also appear faded to help distinguish this change

Example Code:
```lua
-- Integer Gizmo
local IntegerGizmo = Gui.AddInteger('int1', 44)
IntegerGizmo.SetName('My Cool Integer')

-- Locked
IntegerGizmo.SetReadOnly(true)

-- Unlocked
--IntegerGizmo.SetReadOnly(false)
```

Result:

> ![RobloxStudioBeta_frluUDSkJc](https://user-images.githubusercontent.com/22376381/148708474-70e5c675-7505-49bc-8561-9bfa3a9b35a7.png)


---

## List of all existing Gizmos

> Bool

* A togglable checkbox for true/false states

> Button

* A button that when pressed will trigger its Listeners

> ColorSlider

* 3 sliders for selecting a color with RGB floating point, RGB integers, HSV floating point, and HSV integers

> Folder

* A container to hold gizmos that can be easily collapsed. Also indents all the gizmos a bit with the folder color

> Integer

* A text field that only accepts integers as input

> IntegerSlider

* A slider that can be dragged to change an integers value, requires a min/max value for edge values

> ListPicker

* A modal that opens up to allow the user to select a string from a list of strings

> LongString

* A large textbox for a multiline string

> Number

* A text field that only accepts numbers as input

> NumberSlider

* A slider that can be dragged to change a numbers value, requires a min/max value for edge values

> Separator

* Adds a colored box with text to aesthetically space the gizmos apart

> String

* A textbox that can accept any string as input

> Text

* A textlabel that simply displays a string without any way of editing or highlighting it

> Vector2

* 2 text fields that only accepts numbers as inputs, stores the result as a Vector2

> Vector3

* 3 text fields that only accepts numbers as inputs, stores the result as a Vector3 

---

## Example Place

This published place showcases the Demo place, see for yourself the Gui Window in action

> [**Demo Place**](https://www.roblox.com/games/8502552655/DebuGui-Demo-Place)

---

## Credits

Developed by Emmanuel Lajeunesse

Inspiration from Omar's DearImGui C++ library

---

## License

DebuGui is licensed under the MIT License, see LICENSE.txt for more information.
