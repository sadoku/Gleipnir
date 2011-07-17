-- GMod doesn't load empty files, lul
function MODULE:UpdateXP(ply)
	BRP.Util:Print("In UpdateXP")
	umsg.Start("UpdateXP", ply)
		umsg.Long(ply.xp)
		umsg.Long(ply.mxp)
		umsg.Long(ply.level)
	umsg.End()
	BRP.Util:Print("XP Update sent")
end

function MODULE:Init()
	concommand.Add("_UpdateXP", function(ply) BRP.Modules.Modules.experience:UpdateXP(ply) end)
end

function MODULE:PlayerInitialSpawn(ply)
	BRP.Util:Print("Spawned a player :O")
	ply.xp = 0
	ply.mxp = 400
	ply.level = 1
	self:UpdateXP(ply)
end

function MODULE:OnNPCKilled(npc, killer, weapon)
	BRP.Util:Print(killer:Name().." just killed an npc")
	if(killer.IsPlayer != nil and killer:IsPlayer()) then
		BRP.Util:Print("Add XP")
		killer.xp = killer.xp + (45+(4*killer.level))
		if(killer.xp >= killer.mxp) then
			killer.mxp = ((8 * killer.level)* (45+(5*killer.level)))
			killer.xp = 0
			killer.level = killer.level + 1
			self:UpdateXP(killer)
			if(BRP.Modules.Modules.stats) then
				killer.stamina = killer.stamina*1.10
				BRP.Modules.Modules.stats:UpdateStat(killer, "stamina")
			end
			umsg.Start("LevelUP", killer)
			umsg.End()
		end
		BRP.Util:Print("Just tried to add xp")
		self:UpdateXP(killer)
		--killer:ConCommand("_UpdateXP")
		BRP.Util:Print("Tried to send it")
	end
end


