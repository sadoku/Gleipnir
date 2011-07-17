local function SpawnCar(ply,cmd,args)
	BRP.Modules.Modules.vehicles:SpawnVehicle(ply, args[1])
end
function MODULE:Init()
	self.Numz = {}
	numpad.Register("EnterCar", function(ply, key, vehicle)
		if(key == 1) then ply:EnterVehicle(vehicle) end
		if(vehicle.Seats[key-1]) then ply:EnterVehicle(vehicle.Seats[key-1]) end
	end)
	concommand.Add("SpawnCar", SpawnCar)
	self.CarsActive = nil
end

local function AddSeats(self, vehicle)
	if(self.Vehicles[vehicle.vtype].Seats ~= nil) then
		vehicle.Seats = vehicle.Seats or {}
		for v,k in pairs(self.Vehicles[vehicle.vtype].Seats) do
			local seat = ents.Create("prop_vehicle_prisoner_pod")
			seat:SetKeyValue("vehiclescript", "scripts/vehicles/prisoner_pod.txt")
			seat:SetModel(k.model or "models/props_phx/carseat2.mdl")
			seat:SetPos(vehicle:LocalToWorld(k.pos))
			seat:SetParent(vehicle)
			seat:DeleteOnRemove(vehicle)
			seat:Spawn()
			seat.parent = vehicle
			table.insert(vehicle.Seats, seat)
		end
	end
end

function MODULE:SpawnVehicle(owner, vtype, pos)
	local pos = pos or owner:GetPos() + (owner:GetAngles():Forward()*150)
	if(self.Vehicles[vtype] ~= nil) then
		BRP.Util:Print("Found ya, stuff")
		local  vehicle = ents.Create("prop_vehicle_jeep")
		vehicle.vtype = vtype
		vehicle.fuel = self.Vehicles[vtype].fuel
		vehicle:SetPos(pos)
		vehicle:SetModel(self.Vehicles[vtype].model or "models/buggy.mdl")
		vehicle:SetKeyValue("vehiclescript", "scripts/vehicles/"..(self.Vehicles[vtype].script or "jeep_test")..".txt")
		AddSeats(self, vehicle)
		if(self.Vehicles[vtype].Headlights) then
			for v,k in pairs(self.Vehicles[vtype].Headlights) do
				print(k.pos)
				vehicle.headlights = vehicle.headlights or {}
				local ent = ents.Create("env_projectedtexture")
				ent:SetParent(vehicle)
				ent:SetKeyValue("enableshadows", 1)
				ent:SetKeyValue("farz", 2048)
				ent:SetKeyValue("nearz", 8)
				ent:SetKeyValue("lightfov", 50)
				ent:SetKeyValue("lightcolor", "255 255 255")
				ent:SetLocalPos(k.pos)
				ent:SetLocalAngles(Angle(0,90,90))
				ent:Spawn()
				ent:Input("SpotlightTexture", NULL, NULL, "effects/flashlight001")
			end
		end
		vehicle:Spawn()
	else BRP.Util:Print("Failed") return false end
end

function MODULE:Think()
end

function MODULE:PlayerEnteredVehicle(ply, vehicle, role)
	if(vehicle.parent != nil or vehicle.Seats != nil) then
		local rp = RecipientFilter()
		rp:RemoveAllPlayers()
		for v,k in pairs((vehicle.Seats or vehicle.parent.Seats)) do
			if(k:GetDriver() != NULL) then
				rp:AddPlayer(k:GetDriver())
			end
		end
		if(vehicle.Seats and vehicle:GetDriver() != NULL) then rp:AddPlayer(vehicle:GetDriver()) end
		rp:RemovePlayer(ply)
		umsg.Start("_NewGuyInCar", rp)
			umsg.Entity(vehicle)
			umsg.Entity(ply)
		umsg.End()
		for v,k in pairs(vehicle.Seats or vehicle.parent.Seats) do
			print(k)
		end
		umsg.Start("_SeatsTaken", ply)
			
		umsg.End()
	end
end

function MODULE:PlayerLeaveVehicle(ply, vehicle)
	umsg.Start("_LeftCar", ply)
	umsg.End()
end

function MODULE:PlayerUse(ply, ent)
	if(ent.Seats or ent.parent) then
		local ent = ent
		if(ent.parent) then ent = ent.parent end
		umsg.Start("_DoEnter", ply)
			BRP.Util:Print(#ent.Seats)
			umsg.Entity(ent)
			umsg.Short(#ent.Seats)
			for v,k in pairs(ent.Seats) do
				umsg.Entity(k)
			end
		umsg.End()
		local numz = {}
		for i=0,9 do
			numz[i] = numpad.OnDown(ply, i, "EnterCar", i, ent)
		end
		timer.Simple(5,function(numz)
			for v,k in pairs(numz) do
				numpad.Remove(k)
			end
		end, numz)
		return false
	end
end
