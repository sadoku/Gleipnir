function MODULE:PlayerCanSeePlayersChat(str, team, listener, speaker)
	if IsValid(listener) and IsValid(speaker) and listener:IsPlayer() and speaker:IsPlayer() then
		if not string.find(str, "//") then
			if listener:GetPos():Distance(speaker:GetPos()) > 100 then
				return false
			end
		end
	end
end

function MODULE:PlayerSay(ply, str, team)
	if(string.sub(str, 1,2) == "//") then
		return "[OOC]"..string.sub(str,3)
	end
end
