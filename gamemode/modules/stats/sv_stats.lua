function MODULE:PlayerInitialSpawn(ply)
	print("Initial spawn")
	ply.stamina = 5
	ply.agility = 10
	self:UpdateStat(ply, "agility")
	self:UpdateStat(ply, "stamina")
end

function MODULE:PlayerSpawn(ply)
	ply:SetHealth(ply.stamina*10)
	ply:SetJumpPower(ply.agility*10)
	GAMEMODE:SetPlayerSpeed(ply, 100, ply.agility*25)
	

end


function MODULE:UpdateStat(ply, stat)
	umsg.Start("StatUpdate", ply)
		umsg.String(stat)
		umsg.Short(ply[stat])
	umsg.End()
end

function MODULE:AddToStat(ply, stat, amount, update)
	if(ply != nil and stat != nil and amount != nil) then
		print(ply[stat])
		ply[stat] = ply[stat] + amount
		if(update == true) then
			self:UpdateStat(ply, stat)
		end
		return true
	else
		return false
	end
end

function MODULE:Init()
	--self:GetSub("agility")
end
