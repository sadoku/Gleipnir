GLEIP = GLEIP or {}
GLEIP.Util = GLEIP.Util or {}
GLEIP.Util.Entities = GLEIP.Util.Entities or {}




-- LET'S GO BIATCH

--You should provide the full path :S
function GLEIP.Util.Entities:LoadEntityFolder(directory)
	include(directory.."/shared.lua")
	scripted_ents.Register(ENT, ENT.Name, false)
end
