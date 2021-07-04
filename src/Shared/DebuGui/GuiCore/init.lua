
-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Constants
local MIN_GUI_WIDTH = 60
local MIN_GUI_HEIGHT = 80

-- Gizmo UI References
local GizmoUI_String = ReplicatedStorage.GizmoUI_String

-- Modules
local Dragger = require(script.Parent.Dragger)
local GizmoString = require(script.GizmoString)

-- Global Functions
local function UpdateLayout(GizmosArray)
    for i, GizmoData in ipairs(GizmosArray) do
        if i % 2 == 0 then
            GizmoData.Gui.BackgroundColor3 = Color3.new(1, 1, 1)
        else
            GizmoData.Gui.BackgroundColor3 = Color3.new(0, 0, 0)
        end
    end
end

-- Module
local GuiCore = {}

function GuiCore.new(ScreenGuiRef, PosX, PosY, Width, Height)

    -- Defaults
    PosX = PosX or 100
    PosY = PosY or 100
    Width = Width or 300
    Height = Height or 300

    -- Ref
    local ScreenGui = ScreenGuiRef
    ScreenGui.Enabled = true
    local Master = ScreenGui.Master

    -- Data
    local GizmosTable = {}
    local GizmosArray = {}

    -- Setup
    Master.Position = UDim2.fromOffset(PosX, PosY)
    Master.Size = UDim2.fromOffset(Width, Height)

    -- Drag Position of Master
    local MasterPos;
    local MasterDragger = Dragger.new(Master.TopBar.Title)
    MasterDragger.OnDragStart(function()
        MasterPos = Master.AbsolutePosition
    end)
    MasterDragger.OnDrag(function(Delta)
        Master.Position = UDim2.fromOffset(MasterPos.X + Delta.X, MasterPos.Y + Delta.Y)
    end)

    -- Drag ResizeBtn to Resize
    local MasterSize;
    local ResizeDragger = Dragger.new(Master.ResizeBtn)
    ResizeDragger.OnDragStart(function()
        MasterSize = Master.AbsoluteSize
    end)
    ResizeDragger.OnDrag(function(Delta)
        local NewWidth = math.max(MasterSize.X + Delta.X, MIN_GUI_WIDTH)
        local NewHeight = math.max(MasterSize.Y + Delta.Y, MIN_GUI_HEIGHT)
        Master.Size = UDim2.fromOffset(NewWidth, NewHeight)
    end)

    -- Toggle Visibility
    Master.TopBar.DropDownButton.MouseButton1Down:Connect(function()
        Master.Core.Visible = not Master.Core.Visible
        Master.ResizeBtn.Visible = Master.Core.Visible
        Master.ResizeBtn.Active = Master.Core.Visible
        if Master.Core.Visible then
            Master.TopBar.DropDownButton.Text = 'V'
        else
            Master.TopBar.DropDownButton.Text = '>'
        end
    end)

    --
    local function AddGizmo(GIZMO_CLASS, UniqueName, ...)

        -- New UI
        local GizmoUI = GizmoUI_String:Clone()
        GizmoUI.Parent = Master.Core

        -- System
        local GizmoSystem = GIZMO_CLASS.new(GizmoUI, UniqueName, ...)

        -- API Defaults
        GizmoSystem.Name = UniqueName
        GizmoSystem.Gui = GizmoUI

        -- Store
        GizmosTable[UniqueName] = GizmoSystem
        table.insert(GizmosArray, GizmoSystem)

        -- Update UI
        UpdateLayout(GizmosArray)

        -- Return API
        return GizmoSystem
    end

    -- Exposing API
    local API = {}

    --
    function API.AddString(UniqueName, DefaultValue, ClearTextOnFocus)

        -- Doop Check
        if GizmosTable[UniqueName] then
            warn('Gizmo already exists ('..UniqueName..')')
            return
        end

        local GizmoSystem = AddGizmo(GizmoString, UniqueName, DefaultValue, ClearTextOnFocus)

        -- Return API to User
        return GizmoSystem

    end

    --
    return API
end

--
return GuiCore 