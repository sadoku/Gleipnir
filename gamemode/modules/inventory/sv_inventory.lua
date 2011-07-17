function MODULE:SaveInInv(ply, cmd, args)
end



function MODULE:AddToInv(ply, item)
	pennis:insert("inventory", {
		ctype = item['ctype'],
		steamid = ply:SteamID(),
		model = item['model']
	})
	local lastid = sql.Query("SELECT last_insert_rowid();")[1]['last_insert_rowid()']
	MsgN("LastID: "..tostring(lastid))
	item.id = lastid
	table.insert(ply.Inventory, item)
	umsg.Start("NewItem", ply)
		umsg.String(item.ctype)
		umsg.String(item.model)
		umsg.Short(item.id)
	umsg.End()
end

function MODULE:Drop(ply, item)
	local itemt = ply.Inventory[tonumber(item)]
	pennis:delete("inventory", itemt)
	table.remove(ply.Inventory, item)
	if weapons.Get(itemt.ctype) then
		ply:Give(itemt.ctype)
	else
		local ent = ents.Create(itemt.ctype)
		ent:SetModel(itemt.model)
		ent:SetPos(ply:GetShootPos()+(ply:GetForward()*80))
		ent:Spawn()
	end

end

function MODULE:PlayerSay(ply, txt)
	if string.find(txt, "/holster") then
		local wep = ply:GetActiveWeapon()
		if wep:GetClass() ~= "weapon_physgun" then
			self:AddToInv(ply, {
				ctype = wep:GetClass(),
				model = wep:GetModel()
			})
			ply:StripWeapon(wep:GetClass())
		end
		return false
	end
end

function MODULE:PlayerInitialSpawn(ply)
	ply.Inventory = {}
	local pennisRes = pennis:select("inventory"):filter("steamid == "..sql.SQLStr(ply:SteamID())):fetch()
	if pennisRes then
		ply.Inventory = pennisRes
		for k,v in pairs(ply.Inventory) do
			timer.Simple(1, function()
				umsg.Start("NewItem", ply)
					umsg.String(v.ctype)
					umsg.String(v.model)
					umsg.Short(v.id)
				umsg.End()
			end)
		end
	end
end

function MODULE:Init()
	concommand.Add("_IDrop", function(ply,cmd,args) self:Drop(ply, args[1]) end)
	pennis:createTable("inventory", {
		steamid = "varchar(18)",
		ctype = "varchar(30)",
		model = "varchar(100)" -- For prop_physics
	})
	self:callOnLoad("ngwi", function(mod)
		mod:AddHandler("Pickup",function(ply, args)
			local ent = Entity(tonumber(args[1]))
			self:AddToInv(ply, {
				ctype = ent:GetClass(),
				model = ent:GetModel()
			})
			ent:Remove()
		end)
	end)
end

-- People manually pick them up by pressing E
function MODULE:PlayerCanPickupWeapon(ply, wep)
	MsgN("Printing wep table")
	print(wep:IsPlayerHolding())
	--PrintTable(wep:GetTable())

end

function MODULE:PlayerUse(ply, ent)
	if ent:IsWeapon() then
		ply:Chatprint("The weapon "..ent:GetClass().." has been placed in your inventory!")
		ent:Remove()
		return false
	end
end
