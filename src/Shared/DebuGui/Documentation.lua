--[[

	-- © 2021 Emmanuel Lajeunesse
	-- DebuGui Documentation

	-- DebuGui : First point of Access

		-- NewWindow (GuiName, InitData)
			-- @Description: Creates a GuiWindow object and returns it
			-- @Parameters:
				GuiName (string) = Name of GuiWindow object internally
				InitData (table) = A bunch of data you can specify
					{
						X = Default X Position of Window
						Y = Default Y Position of Window
						Width = Width of Window
						Height = Height of Window
						Title = Displayed Title on top of Window
					}

		-- GetWindow (GuiName)
			-- @Description: Returns an existing GuiWindow object with a matching name
			-- @Parameters:
					GuiName (string) = Name of GuiWindow object internally

		-- WaitForWindow (TimeOutTime)
			-- @Description: Similar to GetWindow call except it yields until a value is returned
			-- @Parameters:
					TimeOutTime (number) = Time to wait, nil = wait forever

		-- GetConstants ()
			-- @Description: Returns the Constants Module as a table (ScriptModule that is directly below DebuGui called Constants)
			-- @Returns: (table)


	-- GuiWindow (Core) : A singular window spawned from DebuGui's NewWindow

		-- BringGuiForward (ChosenGui)
			-- @Description: Makes the Gui have the highest Display Order of all other GuiWindows
			-- @Parameters:
				ChosenGui (ScreenGui) = ScreenGui of the GuiWindow

		-- GetScreenGui ()
			-- @Description: Returns the associated ScreenGui
			-- @Returns: (Boolean)

		-- Destroy ()
			-- @Description: Destroys ScreenGui and all internal data relating to the GuiWindow

		-- Enable ()
			-- @Description: Sets the Enabled of the ScreenGui to true
			-- @Returns: (GuiWindow)

		-- Disable ()
			-- @Description: Sets the Enabled of the ScreenGui to false
			-- @Returns: (GuiWindow)

		-- Show ()
			-- @Description: Make the DrawFrame of the GuiWindow visible
			-- @Returns: (GuiWindow)

		-- Hide ()
			-- @Description: Make the DrawFrame of the GuiWindow invisible
			-- @Returns: (GuiWindow)

		-- IsVisible ()
			-- @Description: check whether or not the GuiWindow is visible
			-- @Returns: (GuiWindow)

		-- ToggleVisibility ()
			-- @Description: Toggles the GuiWindows Visibility state (on -> off) or vice versa
			-- @Returns: (GuiWindow)

		-- Minimize ()
			-- @Description: Shrink the GuiWindow to the bottom left corner of the screen
			-- @Returns: (GuiWindow)

		-- Minimize ()
			-- @Description: Returns a shrunken GuiWindow back to normal
			-- @Returns: (GuiWindow)

		-- IsMinimized ()
			-- @Description: Returns whether or not the Window is minimized
			-- @Returns: (boolean)

		-- ToggleMinimized ()
			-- @Description: Toggles the GuiWindows Minimized state (on -> off) or vice versa
			-- @Returns: (GuiWindow)

		-- SetTopBarColor (NewColor)
			-- @Description: Sets the color of the top bar of the Frame
			-- @Parameters:
					NewColor (Color3) = New background color
			-- @Returns: (GuiWindow)

		-- SetScrollbarWidth (Width)
			-- @Description: Sets the width of the scrollbar for the DrawFrame
			-- @Parameters:
					Width (number) = New background color
			-- @Returns: (GuiWindow)

		-- SetScrollbarColor (NewColor)
			-- @Description: Sets the color of the scrollbar for the DrawFrame
			-- @Parameters:
					NewColor (Color3) = New background color
			-- @Returns: (GuiWindow)


	-- GuiWindow (Gizmos)

		-- Get (UniqueName)
			-- @Description: Return the API of a specific Gizmo
			-- @Parameters:
					UniqueName (String) = UniqueName of the Gizmo
			-- @Returns: (Gizmo)

		-- GetFolder (UniqueName)
			-- @Description: Return the API of a specific Folder
			-- @Parameters:
					UniqueName (String) = UniqueName of the Folder
			-- @Returns: (Folder Gizmo)

		-- Remove (UniqueName)
			-- @Description: Destroy a Gizmo
			-- @Parameters:
					UniqueName (String) = UniqueName of the Gizmo
			-- @Returns: (Gizmo)

		-- RemoveAll ()
			-- @Description: Destroy all the gizmos
			-- @Returns: (Gizmo)

		-- AddString (UniqueName, DefaultValue, ClearTextOnFocus = false)
			-- @Description: String Gizmo, stores 1 editable string
			-- @Parameters:
					UniqueName (String) = UniqueName of the Gizmo
					DefaultValue (String) = Initial Text
					ClearTextOnFocus (Boolean) = Clicking the Textbox will clear the current text
			-- @Returns: (Gizmo)

		-- AddText (UniqueName, DefaultValue)
			-- @Description: Text Gizmo, stores 1 non-editable string
			-- @Parameters:
					UniqueName (String) = UniqueName of the Gizmo
					DefaultValue (String) = Displayed Text
			-- @Returns: (Gizmo)

		-- AddLongString (UniqueName, DefaultValue, Height)
			-- @Description: LongString Gizmo, similar to StringGizmo except with larger display box
			-- @Parameters:
					UniqueName (String) = UniqueName of the Gizmo
					DefaultValue (String) = Initial Text
					Height (number) = Pixel Height of gizmo
			-- @Returns: (Gizmo)

		-- AddInteger (UniqueName, DefaultValue, ClearTextOnFocus = false)
			-- @Description: Integer Gizmo, displays 1 number that holds one rounded number
			-- @Parameters:
					UniqueName (String) = UniqueName of the Gizmo
					DefaultValue (number) = Initial Integer Value
					ClearTextOnFocus (Boolean) = Clicking the Textbox will clear the current text
			-- @Returns: (Gizmo)

		-- AddIntegerSlider (UniqueName, DefaultValue, MinValue, MaxValue, UpdateOnlyOnDragEnd)
			-- @Description: IntegerSlider Gizmo, displays 1 slider that can only result in an integer within a given range
			-- @Parameters:
					UniqueName (String) = UniqueName of the Gizmo
					DefaultValue (number) = Initial Integer Value
					MinValue (number) = Smallest Possible Integer
					MaxValue (number) = Largest Possible Integer
					UpdateOnlyOnDragEnd = (boolean) = only trigger Listen updates on MouseReleased
			-- @Returns: (Gizmo)

		-- AddNumber (UniqueName, DefaultValue, DecimalAmount, ClearTextOnFocus = false)
			-- @Description: Number Gizmo, displays 1 number
			-- @Parameters:
					UniqueName (String) = UniqueName of the Gizmo
					DefaultValue (number) = Initial Number Value
					DecimalAmount (number) = How many digits after the decimal point are displayed
					ClearTextOnFocus (Boolean) = Clicking the Textbox will clear the current text
			-- @Returns: (Gizmo)

		-- AddNumberSlider (UniqueName, DefaultValue, MinValue, MaxValue, DecimalAmount, UpdateOnlyOnDragEnd)
			-- @Description: NumberSlider Gizmo, displays 1 slider that can only result in a number within a given range
			-- @Parameters:
					UniqueName (String) = UniqueName of the Gizmo
					DefaultValue (number) = Initial Number Value
					MinValue (number) = Smallest Possible Number
					MaxValue (number) = Largest Possible Number
					UpdateOnlyOnDragEnd = (boolean) = only trigger Listen updates on MouseReleased
			-- @Returns: (Gizmo)

		-- AddBool (UniqueName, DefaultValue)
			-- @Description: Boolean Gizmo, displays a checkbox that can be on or off
			-- @Parameters:
					UniqueName (String) = UniqueName of the Gizmo
					DefaultValue (number) = Initial Boolean Value
			-- @Returns: (Gizmo)

		-- AddButton (UniqueName)
			-- @Description: Button Gizmo, displays a button that can be pressed for the Listen event
			-- @Parameters:
					UniqueName (String) = UniqueName of the Gizmo
			-- @Returns: (Gizmo)

		-- AddSeparator (UniqueName, Color, Text, Height)
			-- @Description: Separator Gizmo, simple frame with text on it
			-- @Parameters:
					UniqueName (String) = UniqueName of the Gizmo
					Color (Color3) = BackgroundColor of the separator
					Text (String) = Displayed text
					Height (number) = Pixel Height of the Gizmo
			-- @Returns: (Gizmo)

		-- AddFolder (UniqueName, StartOpen)
			-- @Description: Folder Gizmo, can store any existing gizmo within itself as its own category (even other folders)
			-- @Parameters:
					UniqueName (String) = UniqueName of the Gizmo
					StartOpen (Boolean) = Is Initially Opened
			-- @Returns: (Gizmo)

		-- AddVector2 (UniqueName, DefaultVec2, DecimalAmount, ClearTextOnFocus = false)
			-- @Description: Vector2 Gizmo, can store a Vector2 Value
			-- @Parameters:
					UniqueName (String) = UniqueName of the Gizmo
					DefaultVec2 (Vector2) = Initial Vector2 Value
					DecimalAmount (number) = How many digits after the decimal point are displayed
					ClearTextOnFocus (Boolean) = Clicking the Textbox will clear the current text
			-- @Returns: (Gizmo)

		-- AddVector3 (UniqueName, DefaultVec3, DecimalAmount, ClearTextOnFocus = false)
			-- @Description: Vector3 Gizmo, can store a Vector2 Value
			-- @Parameters:
					UniqueName (String) = UniqueName of the Gizmo
					DefaultVec3 (Vector3) = Initial Vector3 Value
					DecimalAmount (number) = How many digits after the decimal point are displayed
					ClearTextOnFocus (Boolean) = Clicking the Textbox will clear the current text
			-- @Returns: (Gizmo)

		-- AddColorSliderRGB (UniqueName, DefaultColor, UpdateOnlyOnDragEnd)
			-- @Description: ColorSliderRGB Gizmo, 3 sliders that control the RGB Values of a Color(0 to 1 range)
			-- @Parameters:
					UniqueName (String) = UniqueName of the Gizmo
					DefaultColor (Color3) = Initial Color3 Value
					UpdateOnlyOnDragEnd = (boolean) = only trigger Listen updates on MouseReleased
			-- @Returns: (Gizmo)

		-- AddColorSliderRGBInt (UniqueName, DefaultColor, DecimalAmount, UpdateOnlyOnDragEnd)
			-- @Description: ColorSliderRGBInt Gizmo, 3 sliders that control the RGB Values of a Color (0 to 255 range)
			-- @Parameters:
					UniqueName (String) = UniqueName of the Gizmo
					DefaultColor (Color3) = Initial Color3 Value
					DecimalAmount (number) = How many digits after the decimal point are displayed
					UpdateOnlyOnDragEnd = (boolean) = only trigger Listen updates on MouseReleased
			-- @Returns: (Gizmo)

		-- AddColorSliderHSV (UniqueName, DefaultColor, UpdateOnlyOnDragEnd)
			-- @Description: ColorSliderHSV Gizmo, 3 sliders that control the HSV Values of a Color (0 to 1 range)
			-- @Parameters:
					UniqueName (String) = UniqueName of the Gizmo
					DefaultColor (Color3) = Initial Color3 Value
					UpdateOnlyOnDragEnd (boolean) = only trigger Listen updates on MouseReleased
			-- @Returns: (Gizmo)

		-- AddListPicker (UniqueName, DefaultChoice, ChoiceArray, AllowNoChoice, ClearTextOnFocus = false)
			-- @Description: ListPicker Gizmo, have 1 string selected from a list of strings. Opens a Modal to select which one you want
			-- @Parameters:
					UniqueName (String) = UniqueName of the Gizmo
					DefaultChoice (string) = Default Choice to be displayed
					ChoiceArray (table) = Array table of all possible choices
					AllowNoChoice = Allows nil to be a possible Choice
					ClearTextOnFocus (Boolean) = Clicking the Textbox will clear the current text
			-- @Returns: (Gizmo)


	-- Gizmo (Base) : All Gizmos will have this api

		-- Listen (func)
			-- @Description: Listen for changes in the gizmos value
			-- @Parameters:
					func (Function) = Reference to the function that is called when the value is changed
			-- @Returns: (Gizmo)

		-- TriggerListeners ()
			-- @Description: calls every function listening to this gizmo with the currently stored value
			-- @Returns: (Gizmo)

		-- Set (newValue)
			-- @Description: change the internal stored value
			-- @Parameters:
					newValue (Gizmo's Stored Value type)
			-- @Returns: (Gizmo)

		-- GetValue ()
			-- @Description: returns the internal stored value
			-- @Returns: (Gizmo's Stored Value)


	-- Gizmo (Bool) : Can toggle on/off

		-- SetName (name)
			-- @Description: Changes displayed name
			-- @Parameters:
					name (String) = New displayed name
			-- @Returns: (Gizmo)

		-- SetNameColor (color)
			-- @Description: Changes color of the displayed name
			-- @Parameters:
					color (Color3) = New color for the displayed name
			-- @Returns: (Gizmo)

		-- SetCheckboxColor (color)
			-- @Description: Changes color of the checkbox
			-- @Parameters:
					color (Color3) = New color for the checkbox
			-- @Returns: (Gizmo)

		-- SetReadOnly (state)
			-- @Description: Will lock UI from being modified by the User
			-- @Parameters:
					state (Boolean) = LockState
			-- @Returns: (Gizmo)

		-- IsReadOnly ()
			-- @Description: Check the ReadOnly state
			-- @Returns: (Boolean)


	-- Gizmo (Button) : a Button then when pushed will call its Listen function

		-- SetName (name)
			-- @Description: Changes displayed name
			-- @Parameters:
					name (String) = New displayed name
			-- @Returns: (Gizmo)

		-- SetNameColor (color)
			-- @Description: Changes color of the displayed name
			-- @Parameters:
					color (Color3) = New color for the displayed name
			-- @Returns: (Gizmo)

		-- SetColor (color)
			-- @Description: Changes color of the button
			-- @Parameters:
					color (Color3) = New color for the button
			-- @Returns: (Gizmo)

		-- SetReadOnly (state)
			-- @Description: Will lock UI from being modified by the User
			-- @Parameters:
					state (Boolean) = LockState
			-- @Returns: (Gizmo)

		-- IsReadOnly ()
			-- @Description: Check the ReadOnly state
			-- @Returns: (Boolean)


	-- Gizmo (ColorSlider) : 3 sliders for RGB/HSV values

		-- SetName (name)
			-- @Description: Changes displayed name
			-- @Parameters:
					name (String) = New displayed name
			-- @Returns: (Gizmo)

		-- SetNameColor (color)
			-- @Description: Changes color of the displayed name
			-- @Parameters:
					color (Color3) = New color for the displayed name
			-- @Returns: (Gizmo)

		-- SetValueBGColor (color)
			-- @Description: Changes color of the background element of the displayed value
			-- @Parameters:
					color (Color3) = New color for the background element
			-- @Returns: (Gizmo)

		-- SetValueTextColor (color)
			-- @Description: Changes color of the displayed value
			-- @Parameters:
					color (Color3) = New color for the displayed value
			-- @Returns: (Gizmo)

		-- SetReadOnly (state)
			-- @Description: Will lock UI from being modified by the User
			-- @Parameters:
					state (Boolean) = LockState
			-- @Returns: (Gizmo)

		-- IsReadOnly ()
			-- @Description: Check the ReadOnly state
			-- @Returns: (Boolean)


	-- Gizmo (Folder) : Folder that can also contain Gizmos in a recursive fashion

		-- SetName (name)
			-- @Description: Changes displayed name
			-- @Parameters:
					name (String) = New displayed name
			-- @Returns: (Gizmo)

		-- SetNameColor (color)
			-- @Description: Changes color of the displayed name
			-- @Parameters:
					color (Color3) = New color for the displayed name
			-- @Returns: (Gizmo)

		-- SetColor (color)
			-- @Description: Changes color of the frame container
			-- @Parameters:
					color (Color3) = New color for the frame container
			-- @Returns: (Gizmo)

		-- GetColor ()
			-- @Description: Returns the color of the frame container
			-- @Returns: (Color3)


		-- IsVisible ()
			-- @Description: Whether the folder is currently visible
			-- @Returns: (Boolean)

		-- [ Also uses same API as (GuiWindow Gizmos) ]

		-- Get (UniqueName)
		-- GetFolder (UniqueName)
		-- Remove (UniqueName)
		-- RemoveAll ()
		-- AddString (UniqueName, DefaultValue, ClearTextOnFocus)
		-- AddText (UniqueName, DefaultValue)
		-- AddLongString (UniqueName, DefaultValue, Height)
		-- AddInteger (UniqueName, DefaultValue, ClearTextOnFocus)
		-- AddIntegerSlider (UniqueName, DefaultValue, MinValue, MaxValue, UpdateOnlyOnDragEnd)
		-- AddNumber (UniqueName, DefaultValue, DecimalAmount, ClearTextOnFocus)
		-- AddNumberSlider (UniqueName, DefaultValue, MinValue, MaxValue, DecimalAmount, UpdateOnlyOnDragEnd)
		-- AddBool (UniqueName, DefaultValue)
		-- AddButton (UniqueName)
		-- AddSeparator (UniqueName, Color, Text, Height)
		-- AddFolder (UniqueName, StartOpen)
		-- AddVector2 (UniqueName, DefaultVec2, DecimalAmount, ClearTextOnFocus)
		-- AddVector3 (UniqueName, DefaultVec3, DecimalAmount, ClearTextOnFocus)
		-- AddColorSliderRGB (UniqueName, DefaultColor, UpdateOnlyOnDragEnd)
		-- AddColorSliderRGBInt (UniqueName, DefaultColor, DecimalAmount, UpdateOnlyOnDragEnd)
		-- AddColorSliderHSV (UniqueName, DefaultColor, UpdateOnlyOnDragEnd)
		-- AddListPicker (UniqueName, DefaultChoice, ChoiceArray, AllowNoChoice, ClearTextOnFocus)

	-- Gizmo (Integer) : stores 1 rounded number

		-- SetName (name)
			-- @Description: Changes displayed name
			-- @Parameters:
					name (String) = New displayed name
			-- @Returns: (Gizmo)

		-- SetNameColor (color)
			-- @Description: Changes color of the displayed name
			-- @Parameters:
					color (Color3) = New color for the displayed name
			-- @Returns: (Gizmo)

		-- SetValueBGColor (color)
			-- @Description: Changes color of the background element of the displayed value
			-- @Parameters:
					color (Color3) = New color for the background element
			-- @Returns: (Gizmo)

		-- SetValueTextColor (color)
			-- @Description: Changes color of the displayed value
			-- @Parameters:
					color (Color3) = New color for the displayed value
			-- @Returns: (Gizmo)

		-- SetReadOnly (state)
			-- @Description: Will lock UI from being modified by the User
			-- @Parameters:
					state (Boolean) = LockState
			-- @Returns: (Gizmo)

		-- IsReadOnly ()
			-- @Description: Check the ReadOnly state
			-- @Returns: (Boolean)


	-- Gizmo (IntegerSlider) : stores 1 rounded number with min/max values 

		-- SetName (name)
			-- @Description: Changes displayed name
			-- @Parameters:
					name (String) = New displayed name
			-- @Returns: (Gizmo)

		-- SetNameColor (color)
			-- @Description: Changes color of the displayed name
			-- @Parameters:
					color (Color3) = New color for the displayed name
			-- @Returns: (Gizmo)

		-- SetValueBGColor (color)
			-- @Description: Changes color of the background element of the displayed value
			-- @Parameters:
					color (Color3) = New color for the background element
			-- @Returns: (Gizmo)

		-- SetValueTextColor (color)
			-- @Description: Changes color of the displayed value
			-- @Parameters:
					color (Color3) = New color for the displayed value
			-- @Returns: (Gizmo)

		-- SetMinValue (NewMinValue)
			-- @Description: Changes the min value and updates the current value to clamp it properly
			-- @Parameters:
					NewMinValue (number) = New lowest value for the slider
			-- @Returns: (Gizmo)

		-- SetMaxValue (NewMaxValue)
			-- @Description: Changes the max value and updates the current value to clamp it properly
			-- @Parameters:
					NewMaxValue (number) = New highest value for the slider
			-- @Returns: (Gizmo)

		-- SetReadOnly (state)
			-- @Description: Will lock UI from being modified by the User
			-- @Parameters:
					state (Boolean) = LockState
			-- @Returns: (Gizmo)

		-- IsReadOnly ()
			-- @Description: Check the ReadOnly state
			-- @Returns: (Boolean)


	-- Gizmo (ListPicker) : stores a list of strings with only 1 that can be selected

		-- SetName (name)
			-- @Description: Changes displayed name
			-- @Parameters:
					name (String) = New displayed name
			-- @Returns: (Gizmo)

		-- SetNameColor (color)
			-- @Description: Changes color of the displayed name
			-- @Parameters:
					color (Color3) = New color for the displayed name
			-- @Returns: (Gizmo)

		-- SetValueTextColor (color)
			-- @Description: Changes color of the displayed value
			-- @Parameters:
					color (Color3) = New color for the displayed value
			-- @Returns: (Gizmo)

		-- AddChoice (choice)
			-- @Description: Adds a choice from the list of choices
			-- @Parameters:
					choice (string) = New string choice
			-- @Returns: (Gizmo)

		-- RemoveChoice (choice)
			-- @Description: Removes a choice from the list of choices
			-- @Parameters:
					choice (string) = choice to be removed
			-- @Returns: (Gizmo)

		-- ChangeChoices (NewChoices)
			-- @Description: Sets all choices with a list of new ones
			-- @Parameters:
					NewChoices (table) = table array of strings
			-- @Returns: (Gizmo)

		-- SetReadOnly (state)
			-- @Description: Will lock UI from being modified by the User
			-- @Parameters:
					state (Boolean) = LockState
			-- @Returns: (Gizmo)

		-- IsReadOnly ()
			-- @Description: Check the ReadOnly state
			-- @Returns: (Boolean)


	-- Gizmo (LongString) : stores a multiline string

		-- SetName (name)
			-- @Description: Changes displayed name
			-- @Parameters:
					name (String) = New displayed name
			-- @Returns: (Gizmo)

		-- SetNameColor (color)
			-- @Description: Changes color of the displayed name
			-- @Parameters:
					color (Color3) = New color for the displayed name
			-- @Returns: (Gizmo)

		-- SetValueBGColor (color)
			-- @Description: Changes color of the background element of the displayed value
			-- @Parameters:
					color (Color3) = New color for the background element
			-- @Returns: (Gizmo)

		-- SetValueTextColor (color)
			-- @Description: Changes color of the displayed value
			-- @Parameters:
					color (Color3) = New color for the displayed value
			-- @Returns: (Gizmo)

		-- SetReadOnly (state)
			-- @Description: Will lock UI from being modified by the User
			-- @Parameters:
					state (Boolean) = LockState
			-- @Returns: (Gizmo)

		-- IsReadOnly ()
			-- @Description: Check the ReadOnly state
			-- @Returns: (Boolean)

		-- SetHeight (NewHeight)
			-- @Description: Modifies pixel height of the gizmo
			-- @Parameters:
					NewHeight (number) = height in pixels
			-- @Returns: (Gizmo)

		-- SetHeightBasedOnLineCount (LineCount)
			-- @Description: Modifies height of the gizmo based on amount of rows
			-- @Parameters:
					NewHeight (number) = row count
			-- @Returns: (Gizmo)


	-- Gizmo (Number) : stores 1 number

		-- SetName (name)
			-- @Description: Changes displayed name
			-- @Parameters:
					name (String) = New displayed name
			-- @Returns: (Gizmo)

		-- SetNameColor (color)
			-- @Description: Changes color of the displayed name
			-- @Parameters:
					color (Color3) = New color for the displayed name
			-- @Returns: (Gizmo)

		-- SetValueBGColor (color)
			-- @Description: Changes color of the background element of the displayed value
			-- @Parameters:
					color (Color3) = New color for the background element
			-- @Returns: (Gizmo)

		-- SetValueTextColor (color)
			-- @Description: Changes color of the displayed value
			-- @Parameters:
					color (Color3) = New color for the displayed value
			-- @Returns: (Gizmo)

		-- SetReadOnly (state)
			-- @Description: Will lock UI from being modified by the User
			-- @Parameters:
					state (Boolean) = LockState
			-- @Returns: (Gizmo)

		-- IsReadOnly ()
			-- @Description: Check the ReadOnly state
			-- @Returns: (Boolean)


	-- Gizmo (NumberSlider) : stores 1 number with min/max values

		-- SetName (name)
			-- @Description: Changes displayed name
			-- @Parameters:
					name (String) = New displayed name
			-- @Returns: (Gizmo)

		-- SetNameColor (color)
			-- @Description: Changes color of the displayed name
			-- @Parameters:
					color (Color3) = New color for the displayed name
			-- @Returns: (Gizmo)

		-- SetValueBGColor (color)
			-- @Description: Changes color of the background element of the displayed value
			-- @Parameters:
					color (Color3) = New color for the background element
			-- @Returns: (Gizmo)

		-- SetValueTextColor (color)
			-- @Description: Changes color of the displayed value
			-- @Parameters:
					color (Color3) = New color for the displayed value
			-- @Returns: (Gizmo)

		-- SetMinValue (NewMinValue)
			-- @Description: Changes the min value and updates the current value to clamp it properly
			-- @Parameters:
					NewMinValue (number) = New lowest value for the slider
			-- @Returns: (Gizmo)

		-- SetMaxValue (NewMaxValue)
			-- @Description: Changes the max value and updates the current value to clamp it properly
			-- @Parameters:
					NewMaxValue (number) = New highest value for the slider
			-- @Returns: (Gizmo)

		-- SetReadOnly (state)
			-- @Description: Will lock UI from being modified by the User
			-- @Parameters:
					state (Boolean) = LockState
			-- @Returns: (Gizmo)

		-- IsReadOnly ()
			-- @Description: Check the ReadOnly state
			-- @Returns: (Boolean)


	-- Gizmo (Separator) : small textbox to visually seperate a section

		-- SetName (name)
			-- @Description: Changes displayed name
			-- @Parameters:
					name (String) = New displayed name
			-- @Returns: (Gizmo)

		-- SetColor (color)
			-- @Description: Changes color of the separator
			-- @Parameters:
					color (Color3) = New color for the separator
			-- @Returns: (Gizmo)

		-- SetHeight (NewHeight)
			-- @Description: Modifies pixel height of the gizmo
			-- @Parameters:
					NewHeight (number) = height in pixels
			-- @Returns: (Gizmo)


	-- Gizmo (String) : editable textbox

		-- SetName (name)
			-- @Description: Changes displayed name
			-- @Parameters:
					name (String) = New displayed name
			-- @Returns: (Gizmo)

		-- SetNameColor (color)
			-- @Description: Changes color of the displayed name
			-- @Parameters:
					color (Color3) = New color for the displayed name
			-- @Returns: (Gizmo)

		-- SetValueBGColor (color)
			-- @Description: Changes color of the background element of the displayed value
			-- @Parameters:
					color (Color3) = New color for the background element
			-- @Returns: (Gizmo)

		-- SetValueTextColor (color)
			-- @Description: Changes color of the displayed value
			-- @Parameters:
					color (Color3) = New color for the displayed value
			-- @Returns: (Gizmo)

		-- SetReadOnly (state)
			-- @Description: Will lock UI from being modified by the User
			-- @Parameters:
					state (Boolean) = LockState
			-- @Returns: (Gizmo)

		-- IsReadOnly ()
			-- @Description: Check the ReadOnly state
			-- @Returns: (Boolean)


	-- Gizmo (Text) : non-editable textbox

		-- SetName (name)
			-- @Description: Changes displayed name
			-- @Parameters:
					name (String) = New displayed name
			-- @Returns: (Gizmo)

		-- SetNameColor (color)
			-- @Description: Changes color of the displayed name
			-- @Parameters:
					color (Color3) = New color for the displayed name
			-- @Returns: (Gizmo)

		-- SetValueTextColor (color)
			-- @Description: Changes color of the displayed value
			-- @Parameters:
					color (Color3) = New color for the displayed value
			-- @Returns: (Gizmo)


	-- Gizmo (Vector2) : stores 2 numbers

		-- SetName (name)
			-- @Description: Changes displayed name
			-- @Parameters:
					name (String) = New displayed name
			-- @Returns: (Gizmo)

		-- SetNameColor (color)
			-- @Description: Changes color of the displayed name
			-- @Parameters:
					color (Color3) = New color for the displayed name
			-- @Returns: (Gizmo)

		-- SetValueBGColor (color)
			-- @Description: Changes color of the background element of the displayed value
			-- @Parameters:
					color (Color3) = New color for the background element
			-- @Returns: (Gizmo)

		-- SetValueTextColor (color)
			-- @Description: Changes color of the displayed value
			-- @Parameters:
					color (Color3) = New color for the displayed value
			-- @Returns: (Gizmo)

		-- SetReadOnly (state)
			-- @Description: Will lock UI from being modified by the User
			-- @Parameters:
					state (Boolean) = LockState
			-- @Returns: (Gizmo)

		-- IsReadOnly ()
			-- @Description: Check the ReadOnly state
			-- @Returns: (Boolean)


	-- Gizmo (Vector3) : stores 3 numbers

		-- SetName (name)
			-- @Description: Changes displayed name
			-- @Parameters:
					name (String) = New displayed name
			-- @Returns: (Gizmo)

		-- SetNameColor (color)
			-- @Description: Changes color of the displayed name
			-- @Parameters:
					color (Color3) = New color for the displayed name
			-- @Returns: (Gizmo)

		-- SetValueBGColor (color)
			-- @Description: Changes color of the background element of the displayed value
			-- @Parameters:
					color (Color3) = New color for the background element
			-- @Returns: (Gizmo)

		-- SetValueTextColor (color)
			-- @Description: Changes color of the displayed value
			-- @Parameters:
					color (Color3) = New color for the displayed value
			-- @Returns: (Gizmo)

		-- SetReadOnly (state)
			-- @Description: Will lock UI from being modified by the User
			-- @Parameters:
					state (Boolean) = LockState
			-- @Returns: (Gizmo)

		-- IsReadOnly ()
			-- @Description: Check the ReadOnly state
			-- @Returns: (Boolean)


]]