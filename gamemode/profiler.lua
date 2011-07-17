profiler = profiler or {}
local called = {}
local SysTime = SysTime
function profiler:activate()

	debug.sethook(function(event)
		local info = debug.getinfo(2, "n")
		if(event == "call") then
			if(called[info.name] != nil) then
				called[info.name].count = called[info.name].count + 1
			else
				called[info.name] = {}
				called[info.name]['count'] = 1
				called[info.name]['time'] = {}
			end
			called[info.name].calledl = SysTime()
		end
		if(event == "return") then
			if(called[info.name] ~= nil and called[info.name].calledl ~= nil) then
				table.insert(called[info.name]['time'], SysTime() - called[info.name].calledl)
				called[info.name].calledl = nil
			end
		end
	end, "cr")

end

function profiler:deactivate()
	debug.sethook()
end

function profiler:print_result()
	for v,k in pairs(called) do
		if(#k.time >= 1) then
			local average = 0
			for j,i in pairs(k.time) do
				average = average + i
			end
			average = average / #k.time
			print(tostring(v).."\t"..tostring(k.count).."\t"..tostring(average))
		end
	end
end
