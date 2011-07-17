function MODULE:Init()
	-- The callback just calls MODULE:ChangeJob
	concommand.Add("_ChangeJob", function(ply,cmd,args)
		self:ChangeJob(ply, tonumber(args[1]))
	end)
	timer.Create("GleipPayTimer", 30, 0, MODULE.Payday, self)
end


-- Called when F2 is pressed
function MODULE:ShowTeam(ply)
	umsg.Start("ShowJobs",ply)
	umsg.End()
end

function MODULE:Payday()
	for number,ply in pairs(player.GetAll()) do
		if(ply.Job and ply.Job.salary) then
			ply:ChatPrint("Payday! You have been given $"..tostring(ply.Job.salary))
			ply:AddToBank(ply.Job.salary)
		else
			ply:ChatPrint("You have been given $30")
			ply:AddToBank(30)
		end
	end
end

function MODULE:ChangeJob(ply, job)
	local job = self.Jobs[job]
	print(ply:Name().." wants the job "..job.name)
	print("Checking if he can")
	-- If there is no restrict then there is no restrict
	if job.restrict then
		restrict, message = job.restrict(ply)
		if restrict == false then
			print(message)
			return false
		end
	end
	print("Congrats on the job!")
	ply.Job = job
	ply:Kill()
	return true
end

function MODULE:PlayerSpawn(ply)
	if ply.Job then
		ply:SetModel(ply.Job.model)
	else
		ply:SetModel("models/player/barney.mdl")
	end
end

function MODULE:PlayerLoadout(ply)
	ply.Loadout = true
	if ply.Job and ply.Job.weapons then
		for v,k in pairs(ply.Job.weapons) do
			ply:Give(k)
		end
	end
	ply:Give("weapon_physgun")
	ply:Give("gmod_tool")
	ply.Loadout = false
end
