function MODULE:Init()
	usermessage.Hook("_DoEnter", function(um)
		self.Car = um:ReadEntity()
		local amount = um:ReadShort()
		self.seats = {}
		self.TryingToEnter = 255
		self.ToneGoal = SysTime()+5
		for i=1,amount do
			self.seats[i] = um:ReadEntity()
		end
		self.DrawSeats = true
	end)
	self.DX = CreateClientConVar("CDX", 0)
	self.DY = CreateClientConVar("CDY", 0)
	self.DZ = CreateClientConVar("CDZ", 0)
	-- CONTINUE ABOVE
end

function MODULE:HUDPaint()
	local opacity = 255
	if(self.TryingToEnter) then	
		opacity = Lerp((self.ToneGoal-SysTime())/5, 0, 255)
		draw.SimpleText("HAI", "ScoreboardText", 255,255,Color(255,255,255,opacity))
	end
	if(self.Car) then
		local pos = self.Car:LocalToWorld(Vector(self.DX:GetInt(), self.DY:GetInt(), self.DZ:GetInt())):ToScreen()
		draw.SimpleText(".", "ScoreboardText", pos.x, pos.y)
		local att = self.Car:LookupAttachment("vehicle_driver_eyes")
		att = self.Car:GetAttachment(att)
		local pos = Vector(att.Pos.x, att.Pos.y, att.Pos.z):ToScreen()
		draw.SimpleText("ATTACHMENT", "ScoreboardText", pos.x, pos.y, Color(255,255,255, opacity), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end
	if(self.DrawSeats) then
		local att = self.Car:LookupAttachment("vehicle_driver_eyes")
		att = self.Car:GetAttachment(att)
		local pos = self.Car:WorldToLocal(Vector(att.Pos.x, att.Pos.y, att.Pos.z))
		surface.SetDrawColor(255,255,255,opacity)
		surface.DrawRect(50+pos.x, 200+pos.y,10,10)
		surface.SetTextColor(0,0,0,opacity)
		surface.SetTextPos(50+pos.x, 195+pos.y)
		surface.DrawText("1")
		for v,k in pairs(self.seats) do
			--if(k:GetDriver()) then surface.SetDrawColor(255,0,0,255) else surface.SetDrawColor(0,255,0,255) end
			local pos = self.Car:WorldToLocal(k:GetPos())
			surface.DrawRect(50+pos.x,200+pos.y,10,10)
			surface.SetTextPos(50+pos.x, 195+pos.y)
			surface.DrawText(tostring(v+1))
		end
	end
end
