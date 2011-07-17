BRP = {}
BRP.Util = {}


function BRP.Util:Print(...)
	BRP.Util.Striped = false
	local toPrint
	if (SERVER) then
		Msg("[BRP:Server] ")
	end
	if (CLIENT) then
		Msg("[BRP:Client] ")
	end
	if(BRP.Debug) then
		local debuginfo =debug.getinfo(2)
		Msg("function "..debuginfo.name.." at line "..tostring(debuginfo.currentline).." in file "..debuginfo.short_src.." printed: ")
	end
	for v,k in pairs(arg) do
			if(v != "n") then
				Msg(tostring(k))
			end
	end
	Msg("\n")
end