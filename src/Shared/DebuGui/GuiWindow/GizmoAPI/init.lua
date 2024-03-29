-- © 2023 Emmanuel Lajeunesse

-- Module
local GizmoAPI = {}

-- Services
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local HttpService = game:GetService("HttpService")
local TextService = game:GetService("TextService")

-- Define
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local Camera = Workspace.CurrentCamera
local DebuGuiRef = script.Parent.Parent

-- Modules
local Utility = require(script.Parent.Parent.Utility)
local Dragger = require(script.Parent.Parent.Dragger)
local GizmoBool = require(script.GizmoBool)
local GizmoButton = require(script.GizmoButton)
local GizmoEmpty = require(script.GizmoEmpty)
local GizmoFolder = require(script.GizmoFolder)
local GizmoInteger = require(script.GizmoInteger)
local GizmoIntegerSlider = require(script.GizmoIntegerSlider)
local GizmoListPicker = require(script.GizmoListPicker)
local GizmoLongString = require(script.GizmoLongString)
local GizmoNumber = require(script.GizmoNumber)
local GizmoNumberSlider = require(script.GizmoNumberSlider)
local GizmoSeparator = require(script.GizmoSeparator)
local GizmoString = require(script.GizmoString)
local GizmoText = require(script.GizmoText)
local GizmoSimpleText = require(script.GizmoSimpleText)
local GizmoVector2 = require(script.GizmoVector2)
local GizmoVector3 = require(script.GizmoVector3)
local GizmoColorSlider = require(script.GizmoColorSlider)

-- Gizmo UI References
local GizmoUI_Button = DebuGuiRef.GizmoUI_Button
local GizmoUI_CheckBox = DebuGuiRef.GizmoUI_CheckBox
local GizmoUI_Empty = DebuGuiRef.GizmoUI_Empty
local GizmoUI_Folder = DebuGuiRef.GizmoUI_Folder
local GizmoUI_Picker = DebuGuiRef.GizmoUI_Picker
local GizmoUI_Separator = DebuGuiRef.GizmoUI_Separator
local GizmoUI_Slider = DebuGuiRef.GizmoUI_Slider
local GizmoUI_Text = DebuGuiRef.GizmoUI_Text
local GizmoUI_SimpleText = DebuGuiRef.GizmoUI_SimpleText
local GizmoUI_TextBox = DebuGuiRef.GizmoUI_TextBox
local GizmoUI_TextBox_Multi2 = DebuGuiRef.GizmoUI_TextBox_Multi2
local GizmoUI_TextBox_Multi3 = DebuGuiRef.GizmoUI_TextBox_Multi3
local GizmoUI_TextMultiline = DebuGuiRef.GizmoUI_TextMultiline
local GizmoUI_TripleSlider = DebuGuiRef.GizmoUI_TripleSlider

----------------------
-- Helper Functions --
----------------------
local function UpdateLayout(API)
	for i, GizmoData in ipairs(API._GizmosArray) do
		if i % 2 == 0 then
			GizmoData.Gui.BackgroundColor3 = Color3.new(1, 1, 1)
		else
			GizmoData.Gui.BackgroundColor3 = Color3.new(0, 0, 0)
		end
	end
end

-----------------
-- Public API --
-----------------
function GizmoAPI.New(GuiParent, MasterAPI, ParentAPI)

	------------
	-- Module --
	------------
	local API = {}
	API._GuiParent = GuiParent
	API._ParentAPI = ParentAPI
	API._MasterAPI = MasterAPI or API
	API._GizmosTable = {} -- [UniqueName] = GizmoAPI Hold all Gizmos in a table
	API._GizmosArray = {} -- {Array of GizmoAPI}
	API._GizmosFolders = {} -- [UniqueName] = Folders GizmoAPI (more specific version of _GizmosTable)
	API._Modal = {
		Lock = false,
		ListenerAPI = nil,
		Frame = nil
	}

	----------------------
	-- Helper Functions --
	----------------------
	local function TriggerNewGizmoListeners()
		if API._ParentAPI then
			for _, FolderGizmoAPI in pairs(API._ParentAPI._GizmosFolders) do
				FolderGizmoAPI._NewGizmoAdded()
			end
		end
	end
	local function AddGizmo(GIZMO_UI, GIZMO_CLASS, UniqueName, ...)
		-- Doop Check
		if API._GizmosTable[UniqueName] then
			warn('Gizmo already exists ('..UniqueName..')')
			return
		end
		UniqueName = UniqueName or HttpService:GenerateGUID(false)

		-- New UI
		local GizmoUI = GIZMO_UI:Clone()
		GizmoUI.Parent = GuiParent
		GizmoUI.Name = UniqueName

		-- System
		local NewGizmoAPI = GIZMO_CLASS.new(GizmoUI, UniqueName, ...)

		-- API Defaults
		NewGizmoAPI.Name = UniqueName
		NewGizmoAPI.Gui = GizmoUI

		-- Store
		API._GizmosTable[UniqueName] = NewGizmoAPI
		table.insert(API._GizmosArray, NewGizmoAPI)
		-- Folder Special Case
		if GIZMO_CLASS == GizmoFolder then
			API._GizmosFolders[UniqueName] = NewGizmoAPI
		end

		-- Update UI
		UpdateLayout(API)

		-- Add Size if not in hidden folder
		if Utility.IsFolderVisible(API, true) then
			Utility.ModifyCanvasHeight(API._MasterAPI._GuiParent, GizmoUI.AbsoluteSize.Y)
		end

		-- Update
		TriggerNewGizmoListeners()

		-- Return API
		return NewGizmoAPI
	end

	-----------------
	-- Private API --
	-----------------
	function API._UpdateAllGizmos()
		-- Update self
		for _, Gizmo in ipairs(API._GizmosArray) do
			if Gizmo._UpdateVisual then
				Gizmo._UpdateVisual()
			end
		end

		-- Update Parent
		if ParentAPI then
			ParentAPI._UpdateAllGizmos()
		end
	end

	-- Modal Ignore
	function API._CloseModal()
		-- Needs to be master API
		if API._MasterAPI ~= API then
			return API._MasterAPI._CloseModal()
		end

		-- Check if Modal is not in-use
		if not API._Modal.Lock then return end

		-- Remove Modal
		GuiParent.Parent.ModalLock.Visible = false
		API._Modal.Frame:Destroy()

		-- Remove Locks
		API._Modal.Lock = false
		API._Modal.ListenerAPI = nil
		API._Modal.Frame = nil
	end

	function API._ModalChoiceSelected(Choice)
		-- Needs to be master API
		if API._MasterAPI ~= API then
			return API._MasterAPI._ModalChoiceSelected(Choice)
		end

		-- Check if Modal is not in-use
		if not API._Modal.Lock then return end

		-- Update Data
		if API._Modal.ListenerAPI.Validate(Choice) then
			API._Modal.ListenerAPI.TriggerListeners()
		end

		API._CloseModal()
	end

	function API._CreateModal(ModalName, ModalListenerAPI, DefaultChoice, Choices)
		-- Needs to be master API
		if API._MasterAPI ~= API then
			return API._MasterAPI._CreateModal(ModalName, ModalListenerAPI, DefaultChoice, Choices)
		end

		-- Modal in-use
		if API._Modal.Lock then return end
		API._Modal.Lock = true
		API._Modal.ListenerAPI = ModalListenerAPI

		-- Hide self
		GuiParent.Parent.ModalLock.Visible = true

		-- Defaults
		local ScreenGui = GuiParent.Parent.Parent
		local ModalFrame = DebuGuiRef.ModalFrame:Clone()
		ModalFrame.Parent = ScreenGui
		ModalFrame.Visible = true
		API._Modal.Frame = ModalFrame

		-- Title
		ModalFrame.TopBar.Title.Text = ModalName

		-- Force Gui to be the front-most one
		API.BringGuiForward(ScreenGui)

		-- Drag Position of ModalFrame
		local ModalTitleDragger = Dragger.new(ModalFrame.TopBar)
		local NodalCoreDragger = Dragger.new(ModalFrame.DragCore)

		local Dragger_ModalPos;
		ModalTitleDragger.OnDragStart(function()
			Dragger_ModalPos = ModalFrame.AbsolutePosition
		end)
		ModalTitleDragger.OnDrag(function(Delta)
			ModalFrame.Position = UDim2.fromOffset(Dragger_ModalPos.X + Delta.X, Dragger_ModalPos.Y + Delta.Y)
		end)
		NodalCoreDragger.OnDragStart(function()
			Dragger_ModalPos = ModalFrame.AbsolutePosition
		end)
		NodalCoreDragger.OnDrag(function(Delta)
			ModalFrame.Position = UDim2.fromOffset(Dragger_ModalPos.X + Delta.X, Dragger_ModalPos.Y + Delta.Y)
		end)

		-- Add Things to the modal
		local TotalWidth = 200 -- Minimum
		local TotalHeight = ModalFrame.TopBar.AbsoluteSize.Y
		for Index = 1, #Choices do
			-- Create Button
			local Button = GizmoUI_Button:Clone()
			Button.Parent = ModalFrame.DrawFrame
			Button.Name = Choices[Index]
			Button.TextButton.Text = Choices[Index]
			if Choices[Index] == DefaultChoice then
				Button.TextButton.BackgroundColor3 = Color3.fromRGB(55, 108, 12)
				Button.TextButton.TextColor3 = Color3.fromRGB(20, 255, 248)
			end

			-- Fix Frame
			Button.TextButton.Position = UDim2.new(0, 5, 0.5, 0)
			Button.TextButton.Size = UDim2.new(1, -10, 1, -4)

			-- Choice
			Button.TextButton.MouseButton1Down:Connect(function()
				API._ModalChoiceSelected(Choices[Index])
			end)

			-- Record change in height
			TotalHeight += Button.AbsoluteSize.Y
			-- Check if change in width
			local Width = TextService:GetTextSize(
				Button.TextButton.Text,
				Button.TextButton.TextSize,
				Button.TextButton.Font,
				Vector2.new(Camera.ViewportSize.X, Button.TextButton.TextSize)
			).X
			TotalWidth = math.max(TotalWidth, Width + 15) -- 15 pixels Padding
		end

		-- Cap Size by Window Size
		TotalWidth = math.min(TotalWidth, Camera.ViewportSize.X)
		TotalHeight = math.min(TotalHeight, Camera.ViewportSize.Y)
		-- Fix Size
		ModalFrame.Size = UDim2.fromOffset(TotalWidth, TotalHeight)

		-- Fix Position (below and to the right of the mouse)
		local TargetX = Mouse.X
		local TargetY = Mouse.Y
		-- Check if can't fit below mouse
		if Mouse.Y + TotalHeight > Camera.ViewportSize.Y then
			TargetY -= TotalHeight
		end
		-- Check if can't fit to the right of the mouse
		if Mouse.X + TotalWidth > Camera.ViewportSize.X then
			TargetX -= TotalWidth
		end
		ModalFrame.Position = UDim2.fromOffset(TargetX, TargetY)

		-- Close Modal
		ModalFrame.CloseBtn.MouseButton1Down:Connect(function()
			API._CloseModal()
		end)
	end

	----------------
	-- Public API --
	----------------
	function API.AddEmpty(UniqueName, Height)
		return AddGizmo(GizmoUI_Empty, GizmoEmpty, UniqueName, API, Height)
	end

	function API.AddString(UniqueName, DefaultValue, ClearTextOnFocus)
		return AddGizmo(GizmoUI_TextBox, GizmoString, UniqueName, API, DefaultValue, ClearTextOnFocus)
	end

	function API.AddText(UniqueName, DefaultValue)
		return AddGizmo(GizmoUI_Text, GizmoText, UniqueName, API, DefaultValue)
	end

	function API.AddSimpleText(UniqueName, DefaultValue)
		return AddGizmo(GizmoUI_SimpleText, GizmoSimpleText, UniqueName, API, DefaultValue)
	end

	function API.AddLongString(UniqueName, DefaultValue, ClearTextOnFocus, Height)
		return AddGizmo(GizmoUI_TextMultiline, GizmoLongString, UniqueName, API, DefaultValue, ClearTextOnFocus, Height)
	end

	function API.AddInteger(UniqueName, DefaultValue, ClearTextOnFocus)
		return AddGizmo(GizmoUI_TextBox, GizmoInteger, UniqueName, API, DefaultValue, ClearTextOnFocus)
	end

	function API.AddIntegerSlider(UniqueName, DefaultValue, MinValue, MaxValue, UpdateOnlyOnDragEnd)
		return AddGizmo(GizmoUI_Slider, GizmoIntegerSlider, UniqueName, API, DefaultValue, MinValue, MaxValue, UpdateOnlyOnDragEnd)
	end

	function API.AddNumber(UniqueName, DefaultValue, DecimalAmount, ClearTextOnFocus)
		return AddGizmo(GizmoUI_TextBox, GizmoNumber, UniqueName, API, DefaultValue, DecimalAmount, ClearTextOnFocus)
	end

	function API.AddNumberSlider(UniqueName, DefaultValue, MinValue, MaxValue, DecimalAmount, UpdateOnlyOnDragEnd)
		return AddGizmo(GizmoUI_Slider, GizmoNumberSlider, UniqueName, API, DefaultValue, MinValue, MaxValue, DecimalAmount, UpdateOnlyOnDragEnd)
	end

	function API.AddBool(UniqueName, DefaultValue)
		return AddGizmo(GizmoUI_CheckBox, GizmoBool, UniqueName, API, DefaultValue)
	end

	function API.AddButton(UniqueName)
		return AddGizmo(GizmoUI_Button, GizmoButton, UniqueName, API)
	end

	function API.AddSeparator(UniqueName, Color, Height)
		return AddGizmo(GizmoUI_Separator, GizmoSeparator, UniqueName, API, Color, Height)
	end

	function API.AddFolder(UniqueName, StartOpen)
		return AddGizmo(GizmoUI_Folder, GizmoFolder, UniqueName, API._MasterAPI, API, StartOpen)
	end

	function API.AddVector2(UniqueName, DefaultVec2, DecimalAmount, ClearTextOnFocus)
		return AddGizmo(GizmoUI_TextBox_Multi2, GizmoVector2, UniqueName, API, DefaultVec2, DecimalAmount, ClearTextOnFocus)
	end

	function API.AddVector3(UniqueName, DefaultVec3, DecimalAmount, ClearTextOnFocus)
		return AddGizmo(GizmoUI_TextBox_Multi3, GizmoVector3, UniqueName, API, DefaultVec3, DecimalAmount, ClearTextOnFocus)
	end

	function API.AddColorSliderRGB(UniqueName, DefaultColor, DecimalAmount, UpdateOnlyOnDragEnd)
		return AddGizmo(GizmoUI_TripleSlider, GizmoColorSlider, UniqueName, API, DefaultColor, UpdateOnlyOnDragEnd, 1, DecimalAmount)
	end

	function API.AddColorSliderRGBInt(UniqueName, DefaultColor, UpdateOnlyOnDragEnd)
		return AddGizmo(GizmoUI_TripleSlider, GizmoColorSlider, UniqueName, API, DefaultColor, UpdateOnlyOnDragEnd, 2, nil)
	end

	function API.AddColorSliderHSV(UniqueName, DefaultColor, DecimalAmount, UpdateOnlyOnDragEnd)
		return AddGizmo(GizmoUI_TripleSlider, GizmoColorSlider, UniqueName, API, DefaultColor, UpdateOnlyOnDragEnd, 3, DecimalAmount)
	end

	function API.AddColorSliderHSVInt(UniqueName, DefaultColor, UpdateOnlyOnDragEnd)
		return AddGizmo(GizmoUI_TripleSlider, GizmoColorSlider, UniqueName, API, DefaultColor, UpdateOnlyOnDragEnd, 4, nil)
	end

	function API.AddListPicker(UniqueName, DefaultChoice, ChoiceArray, AllowNoChoice, ClearTextOnFocus, IgnoreSameResult)
		return AddGizmo(GizmoUI_Picker, GizmoListPicker, UniqueName, API, DefaultChoice, ChoiceArray, AllowNoChoice, ClearTextOnFocus, IgnoreSameResult)
	end

	-- Returns API of Gizmo
	function API.Get(UniqueName)
		assert(typeof(UniqueName) == 'string', 'UniqueName must be of type string')
		-- Sanity
		if API._GizmosTable[UniqueName] == nil then
			return nil
		end
		return API._GizmosTable[UniqueName]
	end

	-- Returns API of Folder
	function API.GetFolder(UniqueName)
		assert(typeof(UniqueName) == 'string', 'UniqueName must be of type string')
		-- Sanity
		if API._GizmosFolders[UniqueName] == nil then
			error("Warning! Folder does not exist ("..UniqueName..")")
			return nil
		end
		return API._GizmosFolders[UniqueName]
	end

	-- Removes API of Gizmo
	function API.RemoveAll()
		for _, Gizmo in ipairs(API._GizmosArray) do
			Gizmo._Destroy()
		end
		API._GizmosTable = {}
		API._GizmosArray = {}
		API._GizmosFolders = {}
	end

	-- Removes API of Gizmo
	function API.Remove(UniqueName)
		-- Sanity
		if API._GizmosTable[UniqueName] == nil then
			warn("Warning! Trying to remove non-existant Gizmo ("..UniqueName..")")
			return
		end

		-- Remove Canvas Height
		if Utility.IsFolderVisible(API, true) then
			Utility.ModifyCanvasHeight(API._MasterAPI._GuiParent, -API._GizmosTable[UniqueName].Gui.AbsoluteSize.Y)
		end

		-- Destroy Gui
		API._GizmosTable[UniqueName]._Destroy()

		-- Possible full destruction (Gizmo has API inside of it)
		if API._GizmosTable[UniqueName].RemoveAll then
			API._GizmosTable[UniqueName].RemoveAll()
		end

		-- Remove References
		local Index = Utility.FindArrayIndexByValue(API._GizmosArray, API._GizmosTable[UniqueName])
		assert(Index ~= nil, 'Nil Index Error')
		table.remove(API._GizmosArray, Index)
		API._GizmosTable[UniqueName] = nil
		API._GizmosFolders[UniqueName] = nil

		-- Update Visuals
		UpdateLayout(API)

		-- Call High level events
		TriggerNewGizmoListeners()
	end

	-- Sanity
	function API.GetValue()
		warn("Warning! Trying to get a Value from an API class")
		return nil
	end

	return API
end

return GizmoAPI