DeriveGamemode("sandbox")
GLEIP = GLEIP or {}
GLEIP.Debug = GLEIP.Debug or true

local strTbl = getmetatable("")
function strTbl:__index(key)
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
GLEIP.Modules:LoadModules()
