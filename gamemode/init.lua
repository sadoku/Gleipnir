DeriveGamemode("sandbox")
GM.Name = "Gleipnir"
GLEIP = GLEIP or {}
GLEIP.Debug = GLEIP.Debug or true
DeriveGamemode("sandbox")
AddCSLuaFile("butil.lua")
AddCSLuaFile("sh_entities.lua")
AddCSLuaFile("sh_module.lua")
AddCSLuaFile("cl_init.lua")
include("butil.lua")
include("sv_pstorage.lua")
include("sh_module.lua")

function GM:PlayerSpawn(ply)
	ply:UnSpectate()
	hook.Call("PlayerLoadout", {}, ply)
end

GLEIP.Modules:LoadModules()
