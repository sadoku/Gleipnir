local x = 20
local y = 200
local z = 2
local tp = false

function MODULE:CalcView(ply, pos, angles, fov)
	local view = {}
	if not tp then return end
	local traceData = {}
	traceData.start = pos
	traceData.endpos = pos - ( angles:Forward()*100 ) + ( angles:Right()*30  )
	traceData.filter = ply
	local result = util.TraceLine(traceData)
	view.origin = result.HitPos
	-- So we dun go through the floor...
	view.origin.z = view.origin.z+2
	-- Less breakage according to wiki
	return GAMEMODE:CalcView(ply, view.origin, angles, fov)
end   

-- Draw ammo on gun
function MODULE:PostDrawOpaqueRenderables()
	if self.DrawAmmo and ValidEntity(LocalPlayer()) and ValidEntity(LocalPlayer():GetActiveWeapon()) and LocalPlayer():GetActiveWeapon():Clip1() > 0 then
		pos, ang = LocalPlayer():GetBonePosition(LocalPlayer():LookupBone("ValveBiped.Bip01_R_Hand"))
		ang:RotateAroundAxis( ang:Up(), 90 )
		ang:RotateAroundAxis( ang:Forward(), -90 )
		cam.Start3D2D(pos - (ang:Right() * 10) + (ang:Forward() *5), ang, 0.25)
			draw.SimpleTextOutlined(tostring(LocalPlayer():GetActiveWeapon():Clip1()).."/"..tostring(LocalPlayer():GetAmmoCount(LocalPlayer():GetActiveWeapon():GetPrimaryAmmoType())), "ScoreboardText", 0,0, Color(100, 100, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0,0,0))
		cam.End3D2D()
	end

end

function MODULE:HUDShouldDraw(el)
	if el == "CHudHealth" or el == "CHudAmmo" or el == "CHudSecondaryAmmo" then
		return false
	end
end

function MODULE:KeyPress(ply, key)
	if key == IN_ATTACK then
		self.DrawAmmo = true
		timer.Create("ResetAmmoDraw", 4, 1, function(self)
			self.DrawAmmo = false
		end, self)
	end
end

function MODULE:ShouldDrawLocalPlayer(ply)
	return tp
end

function MODULE:Init()
	function toggle()
	     tp = not tp
	end
	concommand.Add("toggle3rd", toggle)
end

function MODULE:HUDPaint()
	surface.SetDrawColor(255,255,255,255)
	local hitpos = LocalPlayer():GetEyeTrace()
	--hitpos = util.TraceLine(hitpos)
	hitpos = hitpos.HitPos:ToScreen()
	surface.DrawRect(hitpos.x, hitpos.y, 2,2)
end
