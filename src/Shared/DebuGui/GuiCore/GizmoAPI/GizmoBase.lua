
-- Module
local GizmoBase = {}

function GizmoBase.new()
    
    local API = {
		_IsDestroyed = false,
        _Listener = nil,
        _LastInput = nil,
		_Connections = nil,
		_Draggers = nil,
    }

	-- Private API
	function API._AddConnection(Connection)
		if API._Connections == nil then
			API._Connections = {}
		end
		table.insert(API._Connections, Connection)
	end

	function API._AddDragger(Dragger)
		if API._Draggers == nil then
			API._Draggers = {}
		end
		table.insert(API._Draggers, Dragger)
	end

	function API._Destroy()
		API._IsDestroyed = true
		-- Remove Connections
		if API._Connections then
			for _, Connection in ipairs(API._Connections) do
				Connection:Disconnect()
			end
		end
		API._Connections = nil
		-- Remove Draggers
		if API._Draggers then
			for _, Dragger in ipairs(API._Draggers) do
				Dragger.Destroy()
			end
		end
		-- Remove GUI
		if API.Gui then
			API.Gui:Destroy()
		end
		API.Gui = nil
	end

	function API._DeadCheck()
		if API._IsDestroyed then
			warn("Warning! Accessing Removed Gizmo ("..API.Name..")")
			return true
		end
		return false
	end

    -- Public API
    function API.Validate(__) -- Input
        warn('! Validate Function not implemented')
        return false
    end
    --
    function API.Listen(func)
		if API._DeadCheck() then return nil end
        API._Listener = func
        return API
    end
    --
    function API.Set(newValue)
		if API._DeadCheck() then return nil end
        API.Validate(newValue)
        return API
    end
	--
	function API.GetValue()
		return API._LastInput
	end

    -- END
    return API
end


-- End
return GizmoBase