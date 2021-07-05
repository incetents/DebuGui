
-- Module
local GizmoBase = {}

function GizmoBase.new()
    
    local API = {
        Listener = nil,
        LastInput = '',
    }

    -- Functions
    function API.Validate(Input)
        warn('! Validate Function not implemented')
        return false
    end
    --
    function API.Listen(func)
        API.Listener = func
        return API
    end
    --
    function API.Set(newValue)
        API.Validate(newValue)
        return API
    end

    -- END
    return API
end


-- End
return GizmoBase