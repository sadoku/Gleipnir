function MODULE:Init()
	usermessage.Hook("entHealth", function(um)
		local ent = um:ReadEntity()
		local health = um:ReadLong()
		ent.hp = health
	end)
end

function MODULE:HUDPaint()
	local ent = LocalPlayer():GetEyeTrace().Entity
	if IsValid(ent) and ent.hp then
		draw.DrawText("HP: "..tostring(ent.hp), "ScoreboardText", ScrW()/2, ScrH()/2, Color(255,0,0,255),TEXT_ALIGN_CENTER)
	end
end
