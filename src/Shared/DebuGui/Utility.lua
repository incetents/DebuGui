
local Utility = {}

function Utility.QuickTypeAssert(Object, Type)
    assert(typeof(Object) == Type, "Invalid Type, expected "..Type.." type, got ("..typeof(Object)..")")
end

function Utility.FindArrayIndexByValue(array, value)
	Utility.QuickTypeAssert(array, 'table')
	for index, otherValue in ipairs(array) do
		if otherValue == value then
			return index
		end 
	end
	return nil
end

function Utility.IsAPIVisible(API, CheckSelf)
	if CheckSelf and API._IsVisible == false then
		return false
	end
	while API ~= nil do
		API = API._ParentAPI
		if API ~= nil and API._IsVisible == false then
			return false
		end
	end
	return true
end

return Utility