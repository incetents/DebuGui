-- Module
local GizmoAPI = {}

-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Modules
local Utility = require(script.Parent.Parent.Utility)
local GizmoBool = require(script.GizmoBool)
local GizmoButton = require(script.GizmoButton)
local GizmoFolder = require(script.GizmoFolder)
local GizmoInteger = require(script.GizmoInteger)
local GizmoIntegerSlider = require(script.GizmoIntegerSlider)
local GizmoLongString = require(script.GizmoLongString)
local GizmoNumber = require(script.GizmoNumber)
local GizmoNumberSlider = require(script.GizmoNumberSlider)
local GizmoSeparator = require(script.GizmoSeparator)
local GizmoString = require(script.GizmoString)
local GizmoText = require(script.GizmoText)
local GizmoVector2 = require(script.GizmoVector2)
local GizmoVector3 = require(script.GizmoVector3)
local GizmoColorSlider = require(script.GizmoColorSlider)

-- Gizmo UI References
local GizmoUI_Button = ReplicatedStorage.GizmoUI_Button
local GizmoUI_CheckBox = ReplicatedStorage.GizmoUI_CheckBox
local GizmoUI_Folder = ReplicatedStorage.GizmoUI_Folder
local GizmoUI_Separator = ReplicatedStorage.GizmoUI_Separator
local GizmoUI_Slider = ReplicatedStorage.GizmoUI_Slider
local GizmoUI_Text = ReplicatedStorage.GizmoUI_Text
local GizmoUI_TextBox = ReplicatedStorage.GizmoUI_TextBox
local GizmoUI_TextBox_Multi2 = ReplicatedStorage.GizmoUI_TextBox_Multi2
local GizmoUI_TextBox_Multi3 = ReplicatedStorage.GizmoUI_TextBox_Multi3
local GizmoUI_TextMultiline = ReplicatedStorage.GizmoUI_TextMultiline
local GizmoUI_TripleSlider = ReplicatedStorage.GizmoUI_TripleSlider

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
	API._GizmosTable = {} -- [UniqueName] = GizmoAPI Hold all Gizmos in a table
	API._GizmosArray = {} -- {Array of GizmoAPI}
	API._GizmosFolders = {} -- [UniqueName] = Folders GizmoAPI (more specific version of _GizmosTable)

	-- Special Case (if Master API is self)
	if MasterAPI == nil then
		MasterAPI = API
	end

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
			Utility.ModifyCanvasHeight(MasterAPI._GuiParent, GizmoUI.AbsoluteSize.Y)
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
		for __, Gizmo in ipairs(API._GizmosArray) do
			if Gizmo._UpdateVisual then
				Gizmo._UpdateVisual()
			end
		end

		-- Update Parent
		if ParentAPI then
			ParentAPI._UpdateAllGizmos()
		end
	end

	----------------
	-- Public API --
	----------------
	function API.AddString(UniqueName, DefaultValue, ClearTextOnFocus)
		return AddGizmo(GizmoUI_TextBox, GizmoString, UniqueName, DefaultValue, ClearTextOnFocus)
	end

	function API.AddText(UniqueName, DefaultValue)
		return AddGizmo(GizmoUI_Text, GizmoText, UniqueName, DefaultValue)
	end

	function API.AddLongString(UniqueName, DefaultValue, Height)
		return AddGizmo(GizmoUI_TextMultiline, GizmoLongString, UniqueName, MasterAPI, DefaultValue, Height)
	end

	function API.AddInteger(UniqueName, DefaultValue, ClearTextOnFocus)
		return AddGizmo(GizmoUI_TextBox, GizmoInteger, UniqueName, DefaultValue, ClearTextOnFocus)
	end

	function API.AddIntegerSlider(UniqueName, DefaultValue, MinValue, MaxValue, UpdateOnlyOnDragEnd)
		return AddGizmo(GizmoUI_Slider, GizmoIntegerSlider, UniqueName, DefaultValue, MinValue, MaxValue, UpdateOnlyOnDragEnd)
	end

	function API.AddNumber(UniqueName, DefaultValue, ClearTextOnFocus, DecimalAmount)
		return AddGizmo(GizmoUI_TextBox, GizmoNumber, UniqueName, DefaultValue, ClearTextOnFocus, DecimalAmount)
	end

	function API.AddNumberSlider(UniqueName, DefaultValue, MinValue, MaxValue, DecimalAmount, UpdateOnlyOnDragEnd)
		return AddGizmo(GizmoUI_Slider, GizmoNumberSlider, UniqueName, DefaultValue, MinValue, MaxValue, DecimalAmount, UpdateOnlyOnDragEnd)
	end

	function API.AddBool(UniqueName, DefaultValue)
		return AddGizmo(GizmoUI_CheckBox, GizmoBool, UniqueName, DefaultValue)
	end

	function API.AddButton(UniqueName)
		return AddGizmo(GizmoUI_Button, GizmoButton, UniqueName)
	end

	function API.AddSeparator(UniqueName, Color, Text, Height)
		return AddGizmo(GizmoUI_Separator, GizmoSeparator, UniqueName, MasterAPI, Color, Text, Height)
	end

	function API.AddFolder(UniqueName, StartOpen)
		return AddGizmo(GizmoUI_Folder, GizmoFolder, UniqueName, MasterAPI, API, StartOpen)
	end

	function API.AddVector2(UniqueName, DefaultVec2, ClearTextOnFocus, DecimalAmount)
		return AddGizmo(GizmoUI_TextBox_Multi2, GizmoVector2, UniqueName, DefaultVec2, ClearTextOnFocus, DecimalAmount)
	end

	function API.AddVector3(UniqueName, DefaultVec3, ClearTextOnFocus, DecimalAmount)
		return AddGizmo(GizmoUI_TextBox_Multi3, GizmoVector3, UniqueName, DefaultVec3, ClearTextOnFocus, DecimalAmount)
	end

	function API.AddColorSliderRGB(UniqueName, DefaultColor, UpdateOnlyOnDragEnd)
		return AddGizmo(GizmoUI_TripleSlider, GizmoColorSlider, UniqueName, DefaultColor, UpdateOnlyOnDragEnd, 1, nil)
	end

	function API.AddColorSliderRGBInt(UniqueName, DefaultColor, DecimalAmount, UpdateOnlyOnDragEnd)
		return AddGizmo(GizmoUI_TripleSlider, GizmoColorSlider, UniqueName, DefaultColor, UpdateOnlyOnDragEnd, 2, DecimalAmount)
	end

	function API.AddColorSliderHSV(UniqueName, DefaultColor, UpdateOnlyOnDragEnd)
		return AddGizmo(GizmoUI_TripleSlider, GizmoColorSlider, UniqueName, DefaultColor, UpdateOnlyOnDragEnd, 3, nil)
	end

	-- Returns API of Gizmo
	function API.Get(UniqueName)
		-- Sanity
		if API._GizmosTable[UniqueName] == nil then
			warn("Warning! Trying to get non-existant Gizmo ("..UniqueName..")")
			return nil
		end
		return API._GizmosTable[UniqueName]
	end

	-- Removes API of Gizmo
	function API.RemoveAll()
		for __, Gizmo in ipairs(API._GizmosArray) do
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
			Utility.ModifyCanvasHeight(MasterAPI._GuiParent, -API._GizmosTable[UniqueName].Gui.AbsoluteSize.Y)
		end

		-- Destroy Gui
		API._GizmosTable[UniqueName].Gui:Destroy()

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