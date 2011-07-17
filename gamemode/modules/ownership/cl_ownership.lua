function MODULE:Init()
	usermessage.Hook("entOwner", function(um)
		um:ReadEntity().Owner = um:ReadEntity()
	end)
end

function MODULE:HUDPaint()
	local eTrac = LocalPlayer():GetEyeTrace()
	if eTrac.HitNonWorld and eTrac.Entity:GetClass() == "prop_door_rotating" then
		if IsValid(eTrac.Entity.Owner) then
			draw.DrawText("Owner: "..eTrac.Entity.Owner:Nick(), "Trebuchet24", ScrW()/2, ScrH()/2, Color(255,0,0,255),TEXT_ALIGN_CENTER)
		else
			draw.DrawText("Unowned", "Trebuchet24", ScrW()/2, ScrH()/2, Color(255,0,0,255), TEXT_ALIGN_CENTER)
		end
	end
end
