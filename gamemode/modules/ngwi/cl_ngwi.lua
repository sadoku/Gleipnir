function MODULE:Init()
	self.handlers = {}
	usermessage.Hook("ngwiNewHandler", function(um)
		local filter = um:ReadBool() and (false or um:ReadString())
		local name = um:ReadString()
		if(filter) then filter = CompileString(filter, name.."filter") end
		self.handlers[name] = filter	
	end)
end

function MODULE:CallScreenClickHook(click, mc, aimvc)
	if not click then -- When released
		local trc = util.TraceLine({
			start = LocalPlayer():GetShootPos(),
			endpos = LocalPlayer():GetShootPos()+(aimvc*200),
			filter = LocalPlayer()
		})
		if trc.HitNonWorld then
			local menu = DermaMenu()
			--menu:AddOption("Pickup", function() RunConsoleCommand("_saveInInv", tostring(trc.Entity:EntIndex())) end)
			for k,v in pairs(self.handlers) do
				if not v then
					menu:AddOption(k, function() RunConsoleCommand("ngwi"..string.Replace(k, " ", "_"), tostring(trc.Entity:EntIndex())) end)
				else
					setfenv(v, {e = trc.Entity, LocalPlayer = LocalPlayer})
					local result = v()
					print("NGWI handler result for "..k..": "..tostring(result))
					if result then
						menu:AddOption(k, function() RunConsoleCommand("ngwi"..string.Replace(k, " ", "_"), tostring(trc.Entity:EntIndex())) end)
					end
				end
			end
			menu:Open()
		end
		--PrintTable(trc)
	end
end
