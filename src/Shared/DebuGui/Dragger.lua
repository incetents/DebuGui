
-- Services
local Players = game:GetService("Players")

-- References
local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()
local Utility = require(script.Parent.Utility)

-- Module
local Dragger = {}

-- Create
function Dragger.new(Button)
    local Class = {
        IsDragging = false,
        Button = Button,
        StartPos = nil,
        MouseClickPos = Vector2.new(0, 0),
        MouseDragDelta = Vector2.new(0, 0),
        -- Listeners
        Listener_OnDrag = nil,
        Listener_OnDragStart = nil,
        Listener_OnDragEnd = nil,
    }
    function Class.OnDrag(func)
        Utility.QuickTypeAssert(func, 'function')
        Class.Listener_OnDrag = func
    end
    function Class.OnDragStart(func)
        Utility.QuickTypeAssert(func, 'function')
        Class.Listener_OnDragStart = func
    end
    function Class.OnDragEnd(func)
        Utility.QuickTypeAssert(func, 'function')
        Class.Listener_OnDragEnd = func
    end
    --
    local Connections = {}
    --
    Connections[1] = Class.Button.MouseButton1Down:Connect(function()
        Class.MouseClickPos = Vector2.new(Mouse.X, Mouse.Y)
        Class.IsDragging = true
        if Class.Listener_OnDragStart then
            Class.Listener_OnDragStart()
        end
    end)
    Connections[2] = Class.Button.MouseButton1Up:Connect(function()
        Class.IsDragging = false
        if Class.Listener_OnDragEnd then
            Class.Listener_OnDragEnd()
        end
    end)
    Connections[3] = Mouse.Button1Up:Connect(function()
        Class.IsDragging = false
        if Class.Listener_OnDragEnd then
            Class.Listener_OnDragEnd()
        end
    end)
    Connections[4] = Mouse.Move:Connect(function()
        if Class.IsDragging then
            if Class.Listener_OnDrag then
                local Delta = Vector2.new(Mouse.X - Class.MouseClickPos.X, Mouse.Y - Class.MouseClickPos.Y)    
                Class.Listener_OnDrag(Delta)
            end
        end
    end)
    -- Destroy
    function Class.Destroy()
        for __, Connection in pairs(Connections) do
            Connection:Disconnect()
        end
        Connections = nil
        Class.Listener_OnDrag = nil
        Class.Listener_OnDragStart = nil
        Class.Listener_OnDragEnd = nil
    end
    --
    return Class
end

-- End
return Dragger