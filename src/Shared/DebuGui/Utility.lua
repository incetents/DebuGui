
local Utility = {}

function Utility.QuickTypeAssert(Object, Type)
    assert(typeof(Object) == Type, "Invalid Type, expected "..Type.." type, got ("..typeof(Object)..")")
end

return Utility