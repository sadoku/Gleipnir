function MODULE:Init()
	self.handlers = {}
end

function MODULE:DispatchConCmd(ply, cmd, args)
	self.handlers[string.Replace(string.Replace(cmd, "ngwi", ""), "_", " ")][1](ply,args)
end

function MODULE:PlayerInitialSpawn(ply)
	for k,v in pairs(self.handlers) do
		umsg.Start("ngwiNewHandler", ply)
			if(v[2]) then
				umsg.Bool(true)
				umsg.String(v[2])
			else
				umsg.Bool(false)
			end
			umsg.String(k)
		umsg.End()
	end
end

function MODULE:AddHandler(name, callback, filterOptFunc)
	umsg.Start("ngwiNewHandler")
		if(filterOptFunc) then
			umsg.Bool(true)
			umsg.String(filterOptFunc)
		else
			umsg.Bool(false)
		end
		umsg.String(name) -- Clientside knows to call ngwi+name
	umsg.End()
	concommand.Add("ngwi"..string.Replace(name, " ", "_"), function(ply,cmd,args) self:DispatchConCmd(ply,cmd,args) end)
	self.handlers[name] = {callback,filterOptFunc}
end
