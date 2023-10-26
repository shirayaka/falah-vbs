-- Copyright © 2017 Bohemia Interactive Simulations - support@BISimulations.com

-- @name draw
-- @author Martin Sochor
-- @description Functions for drawing primitives using DebugLine

return {
	["debug"] = {
		-- @description Draw a colored line
		-- @argument ... [anything] list of values we would like to write in log
		["Log"] = function(...)
            local finalString = tostring(({...})[1])
			-- for _, source in pairs({...}) do
            for i=2, (#({...})) do
				finalString = finalString .. "," .. tostring(({...})[i])
			end
			DebugLog(finalString)
		end,
    }
}