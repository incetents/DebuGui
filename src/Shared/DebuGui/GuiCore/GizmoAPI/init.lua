
-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Gizmo UI References
local GizmoUI_Button = ReplicatedStorage.GizmoUI_Button
local GizmoUI_CheckBox = ReplicatedStorage.GizmoUI_CheckBox
local GizmoUI_Folder = ReplicatedStorage.GizmoUI_Folder
local GizmoUI_Separator = ReplicatedStorage.GizmoUI_Separator
local GizmoUI_TextBox = ReplicatedStorage.GizmoUI_TextBox
local GizmoUI_TextBox_Multi2 = ReplicatedStorage.GizmoUI_TextBox_Multi2
local GizmoUI_TextBox_Multi3 = ReplicatedStorage.GizmoUI_TextBox_Multi3

-- Modules
local Utility = require(script.Parent.Parent.Utility)
local GizmoBool = require(script.GizmoBool)
local GizmoButton = require(script.GizmoButton)
local GizmoFolder = require(script.GizmoFolder)
local GizmoInteger = require(script.GizmoInteger)
local GizmoNumber = require(script.GizmoNumber)
local GizmoSeparator = require(script.GizmoSeparator)
local GizmoString = require(script.GizmoString)
local GizmoVector2 = require(script.GizmoVector2)
local GizmoVector3 = require(script.GizmoVector3)

-- Module
local GizmoAPI = {}

-- Global Function
local function UpdateLayout(GizmosArray)
	for i, GizmoData in ipairs(GizmosArray) do
		if i % 2 == 0 then
			GizmoData.Gui.BackgroundColor3 = Color3.new(1, 1, 1)
		else
			GizmoData.Gui.BackgroundColor3 = Color3.new(0, 0, 0)
		end
	end
end

--
function GizmoAPI.new(GuiParent, ParentAPI)

	--
	local API = {}

	-- Data
	API.GizmosTable = {}
	API.GizmosArray = {}

	-- Listener
	local ListenersForNewGizmo = {}

	-- Helper Functions
	local function TriggerListeners()
		for __, Listener in ipairs(ListenersForNewGizmo) do
			Listener()
		end
	end
	local function AddGizmo(GIZMO_UI, GIZMO_CLASS, UniqueName, ...)

		-- Doop Check
		if API.GizmosTable[UniqueName] then
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
		API.GizmosTable[UniqueName] = NewGizmoAPI
		table.insert(API.GizmosArray, NewGizmoAPI)

		-- Update UI
		UpdateLayout(API.GizmosArray)

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
	--
	function API._UpdateAllGizmos()
		
		-- Update self
		for __, Gizmo in ipairs(API.GizmosArray) do
			if Gizmo._Update then
				Gizmo._Update()
			end
		end
		-- Update Parent
		if ParentAPI then
			ParentAPI._UpdateAllGizmos()
		end
	
	end
	--

	----------------
	-- Public API --
	----------------

	function API.AddString(UniqueName, DefaultValue, ClearTextOnFocus)
		local NewAPI = AddGizmo(GizmoUI_TextBox, GizmoString, UniqueName, DefaultValue, ClearTextOnFocus)
		TriggerListeners()
		return NewAPI
	end
	--
	function API.AddInteger(UniqueName, DefaultValue, ClearTextOnFocus)
		local NewAPI = AddGizmo(GizmoUI_TextBox, GizmoInteger, UniqueName, DefaultValue, ClearTextOnFocus)
		TriggerListeners()
		return NewAPI
	end
	--
	function API.AddNumber(UniqueName, DefaultValue, ClearTextOnFocus, DecimalAmount)
		local NewAPI = AddGizmo(GizmoUI_TextBox, GizmoNumber, UniqueName, DefaultValue, ClearTextOnFocus, DecimalAmount)
		TriggerListeners()
		return NewAPI
	end
	--
	function API.AddBool(UniqueName, DefaultValue)
		local NewAPI = AddGizmo(GizmoUI_CheckBox, GizmoBool, UniqueName, DefaultValue)
		TriggerListeners()
		return NewAPI
	end
	--
	function API.AddButton(UniqueName)
		local NewAPI = AddGizmo(GizmoUI_Button, GizmoButton, UniqueName)
		TriggerListeners()
		return NewAPI
	end
	--
	function API.AddSeparator(UniqueName, Color, Text, Height)
		local NewAPI = AddGizmo(GizmoUI_Separator, GizmoSeparator, UniqueName, Color, Text, Height)
		TriggerListeners()
		return NewAPI
	end
	--
	function API.AddFolder(UniqueName, IsOpen)
		local NewAPI = AddGizmo(GizmoUI_Folder, GizmoFolder, UniqueName, API, IsOpen)
		TriggerListeners()
		return NewAPI
	end
	--
	function API.AddVector2(UniqueName, DefaultVec2, ClearTextOnFocus, DecimalAmount)
		local NewAPI = AddGizmo(GizmoUI_TextBox_Multi2, GizmoVector2, UniqueName, DefaultVec2, ClearTextOnFocus, DecimalAmount)
		TriggerListeners()
		return NewAPI
	end
	--
	function API.AddVector3(UniqueName, DefaultVec3, ClearTextOnFocus, DecimalAmount)
		local NewAPI = AddGizmo(GizmoUI_TextBox_Multi3, GizmoVector3, UniqueName, DefaultVec3, ClearTextOnFocus, DecimalAmount)
		TriggerListeners()
		return NewAPI
	end

	-- Returns API of Gizmo
	function API.Get(UniqueName)
		-- Sanity
		if API.GizmosTable[UniqueName] == nil then
			warn("Warning! Trying to get non-existant Gizmo ("..UniqueName..")")
			return nil
		end
		return API.GizmosTable[UniqueName]
	end
	-- Removes API of Gizmo
	function API.Remove(UniqueName)
		-- Sanity
		if API.GizmosTable[UniqueName] == nil then
			warn("Warning! Trying to remove non-existant Gizmo ("..UniqueName..")")
			return
		end

		-- Flag API as bad
		API.GizmosTable[UniqueName]._Destroy()


		-- Destroy Gui
		API.GizmosTable[UniqueName].Gui:Destroy()
		-- Remove References
		API.GizmosTable[UniqueName] = nil
		local Index = Utility.FindArrayIndexByValue(API.GizmosArray, UniqueName)
		if Index then
			table.remove(API.GizmosArray, Index)
		end

		TriggerListeners()
	end

	-- Sanity
	function API.GetValue()
		warn("Warning! Trying to get a Value from an API class")
		return nil
	end

	--
	return API

end

-- End
return GizmoAPI