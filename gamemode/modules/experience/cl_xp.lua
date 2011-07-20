local function UpdateXP(um)
	LocalPlayer().xp = um:ReadLong()
	LocalPlayer().mxp = um:ReadLong()
	LocalPlayer().level = um:ReadLong()
end

local function LevelUp(um)
	chat.AddText("You have leveled 1 level, you are now level "..tostring(LocalPlayer().level))
end

function MODULE:InitPostEntity()
	usermessage.Hook("UpdateXP", UpdateXP)
	usermessage.Hook("LevelUP", LevelUp)
	RunConsoleCommand("_UpdateXP")
end
