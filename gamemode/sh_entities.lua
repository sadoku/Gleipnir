BRP = BRP or {}
BRP.Util = BRP.Util or {}
BRP.Util.Entities = BRP.Util.Entities or {}




-- LET'S GO BIATCH

--You should provide the full path :S
function BRP.Util.Entities:LoadEntityFolder(directory)
	include(directory.."/shared.lua")
	scripted_ents.Register(ENT, ENT.Name, false)
end