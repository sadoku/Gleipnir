GLEIP = {}
GLEIP.Util = {}


function GLEIP.Util.print(...)
	GLEIP.Util.Striped = false
	local toPrint
	if (SERVER) then
		Msg("[GLEIP:Server] ")
	end
	if (CLIENT) then
		Msg("[GLEIP:Client] ")
	end
	for v,k in pairs(arg) do
			if(v != "n") then
				Msg(tostring(k))
			end
	end
	Msg("\n")
end
