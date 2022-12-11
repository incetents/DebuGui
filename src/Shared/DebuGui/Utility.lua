-- © 2022 Emmanuel Lajeunesse

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

function Utility.IsFolderVisible(API, CheckSelf)

	if CheckSelf and API.IsVisible and not API.IsVisible() then
		return false
	end
	while API ~= nil do
		API = API._ParentAPI
		if API ~= nil and API.IsVisible and not API.IsVisible() then
			return false
		end
	end
	return true
end

function Utility.ModifyCanvasHeight(DrawFrame, Amount)
	DrawFrame.CanvasSize = UDim2.fromOffset(0, DrawFrame.CanvasSize.Y.Offset + Amount)
end

return Utility