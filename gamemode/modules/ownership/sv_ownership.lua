function MODULE:Init()
	self:callOnLoad("ngwi", function(mod)
		mod:AddHandler("Buy ent", self.BuyEnt, [[if e.Owner then return false else return true end]])
		mod:AddHandler("Sell ent", self.SellEnt, [[if LocalPlayer() == e.Owner then return true else return false end]])
	end)
end

function MODULE.SellEnt(ply, args)
	Entity(args[1]).Owner = NULL
	umsg.Start("entOwner")
		umsg.Entity(Entity(args[1]))
		umsg.Entity(NULL)
	umsg.End()
end

function MODULE.BuyEnt(ply, args)
	Entity(args[1]).Owner = ply
	print("New ownah")
	umsg.Start("entOwner")
		umsg.Entity(Entity(args[1]))
		umsg.Entity(ply)
	umsg.End()
end
