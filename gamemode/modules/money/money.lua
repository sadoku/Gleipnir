local meta = _R['Player']


function meta:AddToBank(amount)
	if(CLIENT) then return end
	self:SetNWInt("bank", self:GetNWInt("bank", 0) + amount)
end

function meta:GetBank()
	return self:GetNWInt("bank", 0)
end


function MODULE:Init()
	timer.Create("Interest", 60*5, 0, function(self)
		Msg("New maney")
		for k,v in pairs(player.GetAll()) do
			v:ChatPrint("Due to an interest rate of 0.5%, your wealth has increased by "..tostring(v:GetBank()*0.005))
			v:AddToBank(v:GetBank()*1.005)
		end
	end, self)
end

function meta:AddMoney(amount)
	if(CLIENT) then return end
	self:SetNWInt("money", self:GetNWInt("money", 0) + amount)
end

function meta:GetMoney()
	return self:GetNWInt("money", 0)
end

function MODULE:PlayerInitalSpawn(ply)
	if(CLIENT) then return end
	ply:AddMoney(500)
end
