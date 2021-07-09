
-- Module
local GizmoBase = {}

function GizmoBase.new()
    
    local API = {
		IsDestroyed = false,
        Listener = nil,
        LastInput = '',
		Connections = {},
    }

	-- Private API
	function API._AddConnection(Connection)
		table.insert(API.Connections, Connection)
	end
	function API._Destroy()
		API.IsDestroyed = true
		for __, Connection in ipairs(API.Connections) do
			Connection:Disconnect()
		end
	end
	function API._DeadCheck()
		if API.IsDestroyed then
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
        API.Listener = func
        return API
    end
    --
    function API.Set(newValue)
		if API._DeadCheck() then return nil end
        API.Validate(newValue)
        return API
    end

    -- END
    return API
end


-- End
return GizmoBase