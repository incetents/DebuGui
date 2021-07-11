
-- Module
local GizmoBase = {}

function GizmoBase.new()
    
    local API = {
		_IsDestroyed = false,
        _Listener = nil,
        _LastInput = nil,
		_Connections = {},
    }

	-- Private API
	function API._AddConnection(Connection)
		table.insert(API._Connections, Connection)
	end
	function API._Destroy()
		API._IsDestroyed = true
		for __, Connection in ipairs(API._Connections) do
			Connection:Disconnect()
		end
		API._Connections = {}
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