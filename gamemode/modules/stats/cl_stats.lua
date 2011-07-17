

function MODULE:Init()

	local function GetUpdatedStat(um)
		local ply = LocalPlayer()
		ply[um:ReadString()] = um:ReadShort()
	end

	usermessage.Hook("StatUpdate", GetUpdatedStat)
end
