function MODULE:PlayerSpawnedProp(ply, mdl, ent)
	ent.hp = 500
	umsg.Start("entHealth")
		umsg.Entity(ent)
		umsg.Long(500)
	umsg.End()
end

function MODULE:EntityTakeDamage(target, inflictor, attacker, dmg, dmgInfo)
	if target.hp then
		if target.hp-15 <= 0 then
			target:Remove()
		else
			target.hp = target.hp-15
			umsg.Start("entHealth")
				umsg.Entity(target)
				umsg.Long(target.hp)
			umsg.End()
		end
	end
end
