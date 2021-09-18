-- Module
local GizmoAPI = {}

-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Gizmo UI References
local GizmoUI_Button = ReplicatedStorage.GizmoUI_Button
local GizmoUI_CheckBox = ReplicatedStorage.GizmoUI_CheckBox
local GizmoUI_Folder = ReplicatedStorage.GizmoUI_Folder
local GizmoUI_Separator = ReplicatedStorage.GizmoUI_Separator
local GizmoUI_Slider = ReplicatedStorage.GizmoUI_Slider
local GizmoUI_TextBox = ReplicatedStorage.GizmoUI_TextBox
local GizmoUI_TextBox_Multi2 = ReplicatedStorage.GizmoUI_TextBox_Multi2
local GizmoUI_TextBox_Multi3 = ReplicatedStorage.GizmoUI_TextBox_Multi3
local GizmoUI_TextMultiline = ReplicatedStorage.GizmoUI_TextMultiline

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
local GizmoVector2 = require(script.GizmoVector2)
local GizmoVector3 = require(script.GizmoVector3)

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

	-------------
	-- Defines --
	-------------
	local API = {}
	API._GizmosTable = {}
	API._GizmosArray = {}
	API._ParentAPI = ParentAPI

	-- Special Case (if Master API is self)
	if MasterAPI == nil then
		MasterAPI = API
	end

	-- Listener
	local ListenersForNewGizmo = {}

	-- Helper Functions
	local function TriggerNewGizmoListeners()
		for __, Listener in ipairs(ListenersForNewGizmo) do
			Listener()
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

		-- Update UI
		UpdateLayout(API)
		-- Add Size if not in hidden folder
		if Utility.IsAPIVisible(API, true) then
			MasterAPI._AddToCanvasSize(GizmoUI.AbsoluteSize.Y)
		end

		-- Return API
		return NewGizmoAPI
	end

	-----------------
	-- Private API --
	-----------------
	function API._ListenForNewGizmos(func)
		Utility.QuickTypeAssert(func, 'function')
		table.insert(ListenersForNewGizmo, func)
	end

	function API._UpdateAllGizmos()
		
		-- Update self
		for __, Gizmo in ipairs(API._GizmosArray) do
			if Gizmo._Update then
				Gizmo._Update()
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
		local NewAPI = AddGizmo(GizmoUI_TextBox, GizmoString, UniqueName, DefaultValue, ClearTextOnFocus)
		TriggerNewGizmoListeners()
		return NewAPI
	end

	function API.AddLongString(UniqueName, DefaultValue, Height)
		local NewAPI = AddGizmo(GizmoUI_TextMultiline, GizmoLongString, UniqueName, MasterAPI, DefaultValue, Height)
		TriggerNewGizmoListeners()
		return NewAPI
	end

	function API.AddInteger(UniqueName, DefaultValue, ClearTextOnFocus)
		local NewAPI = AddGizmo(GizmoUI_TextBox, GizmoInteger, UniqueName, DefaultValue, ClearTextOnFocus)
		TriggerNewGizmoListeners()
		return NewAPI
	end

	function API.AddIntegerSlider(UniqueName, DefaultValue, MinValue, MaxValue)
		local NewAPI = AddGizmo(GizmoUI_Slider, GizmoIntegerSlider, UniqueName, DefaultValue, MinValue, MaxValue)
		TriggerNewGizmoListeners()
		return NewAPI
	end

	function API.AddNumber(UniqueName, DefaultValue, ClearTextOnFocus, DecimalAmount)
		local NewAPI = AddGizmo(GizmoUI_TextBox, GizmoNumber, UniqueName, DefaultValue, ClearTextOnFocus, DecimalAmount)
		TriggerNewGizmoListeners()
		return NewAPI
	end

	function API.AddNumberSlider(UniqueName, DefaultValue, MinValue, MaxValue, DecimalAmount)
		local NewAPI = AddGizmo(GizmoUI_Slider, GizmoNumberSlider, UniqueName, DefaultValue, MinValue, MaxValue, DecimalAmount)
		TriggerNewGizmoListeners()
		return NewAPI
	end

	function API.AddBool(UniqueName, DefaultValue)
		local NewAPI = AddGizmo(GizmoUI_CheckBox, GizmoBool, UniqueName, DefaultValue)
		TriggerNewGizmoListeners()
		return NewAPI
	end

	function API.AddButton(UniqueName)
		local NewAPI = AddGizmo(GizmoUI_Button, GizmoButton, UniqueName)
		TriggerNewGizmoListeners()
		return NewAPI
	end

	function API.AddSeparator(UniqueName, Color, Text, Height)
		local NewAPI = AddGizmo(GizmoUI_Separator, GizmoSeparator, UniqueName, MasterAPI, Color, Text, Height)
		TriggerNewGizmoListeners()
		return NewAPI
	end

	function API.AddFolder(UniqueName, StartOpen)
		local NewAPI = AddGizmo(GizmoUI_Folder, GizmoFolder, UniqueName, MasterAPI, API, StartOpen)
		TriggerNewGizmoListeners()
		return NewAPI
	end

	function API.AddVector2(UniqueName, DefaultVec2, ClearTextOnFocus, DecimalAmount)
		local NewAPI = AddGizmo(GizmoUI_TextBox_Multi2, GizmoVector2, UniqueName, DefaultVec2, ClearTextOnFocus, DecimalAmount)
		TriggerNewGizmoListeners()
		return NewAPI
	end

	function API.AddVector3(UniqueName, DefaultVec3, ClearTextOnFocus, DecimalAmount)
		local NewAPI = AddGizmo(GizmoUI_TextBox_Multi3, GizmoVector3, UniqueName, DefaultVec3, ClearTextOnFocus, DecimalAmount)
		TriggerNewGizmoListeners()
		return NewAPI
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
	function API.Remove(UniqueName)

		-- Sanity
		if API._GizmosTable[UniqueName] == nil then
			warn("Warning! Trying to remove non-existant Gizmo ("..UniqueName..")")
			return
		end

		-- Remove Canvas Height
		if Utility.IsAPIVisible(API, true) then
			MasterAPI._AddToCanvasSize(-API._GizmosTable[UniqueName].Gui.AbsoluteSize.Y)
		end

		-- Base level destruction
		API._GizmosTable[UniqueName]._Destroy()
		-- High level destruction if requested
		if API._GizmosTable[UniqueName]._OnDestroy then
			API._GizmosTable[UniqueName]._OnDestroy()
		end

		-- Remove References
		local Index = Utility.FindArrayIndexByValue(API._GizmosArray, API._GizmosTable[UniqueName])
		assert(Index ~= nil, 'Nil Index Error')
		table.remove(API._GizmosArray, Index)
		
		-- Remove Gui
		API._GizmosTable[UniqueName] = nil

		-- Update Visuals
		UpdateLayout(API)

		-- Call High level events
		TriggerNewGizmoListeners()
	end

	-- Removes API of Gizmo
	function API.RemoveAll()
		for __, Gizmo in ipairs(API._GizmosArray) do
			Gizmo._Destroy()
		end
		API._GizmosTable = {}
		API._GizmosArray = {}
	end

	-- Sanity
	function API.GetValue()
		warn("Warning! Trying to get a Value from an API class")
		return nil
	end

	return API
end

return GizmoAPI