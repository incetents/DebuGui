
-- Services
local Players = game:GetService("Players")

-- References
local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()
local Utility = require(script.Parent.Utility)

-- Global Data
local Draggers = {}

-- Global Functions
local function DragEndGlobal()
	for __, Class in ipairs(Draggers) do
		if Class.IsDragging and Class.Listener_OnDragEnd then
			Class.Listener_OnDragEnd()
		end
		Class.IsDragging = false
	end
end
local function DragGlobal()
	for __, Class in ipairs(Draggers) do
		if Class.IsDragging and Class.Listener_OnDrag then
			local Delta = Vector2.new(Mouse.X - Class.MouseClickPos.X, Mouse.Y - Class.MouseClickPos.Y)    
			Class.Listener_OnDrag(Delta)
			return -- Only 1 thing can be dragged at once
		end
	end
end

-- Events
Mouse.Button1Up:Connect(DragEndGlobal)
Mouse.Move:Connect(DragGlobal)

-- Module
local Dragger = {}

-- Create
function Dragger.new(DraggerButton)

	-- Class
    local Class = {
        IsDragging = false,
        MouseClickPos = Vector2.new(0, 0),
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

    -- Data
	local Button = DraggerButton
    local Connections = {}

    -- Setup
    table.insert(Connections, Button.MouseButton1Down:Connect(function()
        Class.MouseClickPos = Vector2.new(Mouse.X, Mouse.Y)
        Class.IsDragging = true
        if Class.Listener_OnDragStart then
            Class.Listener_OnDragStart()
        end
    end))
    table.insert(Connections, Button.MouseButton1Up:Connect(function()
		DragEndGlobal()
    end))

    -- Destroy
    function Class.Destroy()
        for __, Connection in ipairs(Connections) do
            Connection:Disconnect()
        end
        Connections = nil
        Class.Listener_OnDrag = nil
        Class.Listener_OnDragStart = nil
        Class.Listener_OnDragEnd = nil
		--
		local Index = Utility.FindArrayIndexByValue(Draggers, Class)
		assert(Index ~= nil, 'Dragger Class is nil')
		table.remove(Draggers, Index)
    end

	--
	table.insert(Draggers, Class)
    --
    return Class
end

-- End
return Dragger