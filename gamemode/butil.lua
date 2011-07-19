GLEIP = {}
GLEIP.Util = {}


function GLEIP.Util:Print(...)
	GLEIP.Util.Striped = false
	local toPrint
	if (SERVER) then
		Msg("[GLEIP:Server] ")
	end
	if (CLIENT) then
		Msg("[GLEIP:Client] ")
	end
	if(GLEIP.Debug) then
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
