function MODULE:HUDPaint()
	local health = LocalPlayer():Health()
	local height = 20
	local width = health*5
	local x = ScrW()/2-(width/2)
	local y = ScrH()-height
	surface.CreateFont("coolvetica", 22, 0, true,false,"ShitPants")
	surface.SetFont("ShitPants")
	local healthtext = tostring(LocalPlayer():Health()/100).."%"
	local hwidth, hheight = surface.GetTextSize(healthtext)
	surface.SetDrawColor(180,0,0,255)
	surface.DrawRect(x,y,width,height)
	surface.SetDrawColor(255,255,255,255*0.10)
	surface.DrawRect(x,y,width,height)
	surface.SetDrawColor(255,255,255,255*0.05)
	surface.DrawRect(x,y,width,height/2)
	surface.SetTextColor(255,255,255,255)
	surface.SetTextPos(x+(width/2)-hwidth/2,y-(hheight/2*0.05))
	surface.DrawText(healthtext)
	
	surface.CreateFont("HALFLIFE2", 40, 200, true, false, "theamazingfonttoshowmeammo")
	-- That was that damn healtbar, puh
	-- Ammo here ...
	if(LocalPlayer().GetActiveWeapon and LocalPlayer():GetActiveWeapon() and LocalPlayer():GetActiveWeapon():IsValid() and LocalPlayer():GetActiveWeapon():Clip1() != -1) then
		surface.SetFont("theamazingfonttoshowmeammo")
		surface.SetTextColor(255,255,255,255)
		local ammo =  LocalPlayer():GetActiveWeapon():Clip1()
		local loops = ammo/20
		local secondloop = 20
		if(loops < 1 or loops == 1) then 
			secondloop = ammo
			--print(secondloop)
			loops = 2 
		else 
			loops = loops
		end
		for i=1, loops do
			local x = (x - 30)-(50*i)
			local y = y - 2
			for j=1,secondloop do
				ammo = ammo - 1
				surface.SetTextPos(x,y-(j*10))
				surface.DrawText("r")
			end
		end
	end
	-- Ammo done, lalalai
	-- Salary now ...
	local SalaryText = "Wallet: "..tostring(LocalPlayer():GetNWInt("money",0)).."$"
	surface.SetFont("ShitPants")
	local SW,SH = surface.GetTextSize(SalaryText)
	surface.SetTextPos(x+5+width,y)
	surface.SetTextColor(255,255,255,255)
	surface.DrawText(SalaryText)
	
	surface.SetFont("ShitPants")
	surface.SetTextPos(x+150+width,y)
	surface.SetTextColor(255,255,255,255)
	surface.DrawText("XP: "..tostring(LocalPlayer().xp).." MXP: "..tostring(LocalPlayer().mxp).." Level: "..tostring(LocalPlayer().level))
end
