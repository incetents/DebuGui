
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local DebuGui = require(ReplicatedStorage.DebuGui)

-- name, x, y, width, height
local Gui1 = DebuGui.new('Core', 300, 100, 600, 500)

Gui1.AddString('string1', '1')
Gui1.AddString('string2', 'aa')
Gui1.AddString('string3', '__#$%#$&*')
Gui1.AddString('string4').Listen(function(NewValue)
    print("NEW STRING4: "..NewValue)
end)