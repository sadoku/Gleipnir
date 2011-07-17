DeriveGamemode("sandbox")
BRP = BRP or {}
BRP.Debug = BRP.Debug or true
local ols = string.sub
string.sub = function(str, start, endp)
	if type(start) == "string" then
		debug.Trace()
		Error("Failz")
	else
		return ols(str,start,endp)
	end
end

local bajs = getmetatable("")
function bajs:__index(key)
	if type(key) == "number" then
		debug.Trace()
	end
	return string[ key ] or self:sub(key,key)
end
function GM:Initialize()

self.BaseClass:Initialize( self )

end

include("butil.lua")
include("sh_entities.lua")
include("sh_module.lua")
BRP.Modules:LoadModules()
