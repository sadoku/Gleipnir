weapons.Register({
	Author = "Sadoku",
	Instructions = "Left click fire, right click zoom",
	Contact = "",
	Purpose = "",
	PrintName = "Ak",
	Slot = 3,
	SlotPos = 1,
	IconLetter = "b",
	DrawCrosshair = true,
	Base = "wep_base",
	Category = "Gleipnir",
	Spawnable = true,
	AdminSpawnable = true,
	ViewModel = "models/weapons/v_rif_ak47.mdl",
	WorldModel = "models/weapons/w_rif_ak47.mdl",
	Weight = 5,
	AutoSwitchTo = false,
	AutoSwitchFrom = false,
	Primary = {
		Sound = Sound( "Weapon_AK47.Single" ),
		Recoil = 1.5,
		Damage = 40,
		NumShots = 1,
		Cone = 0.02,
		ClipSize = 25,
		Delay = 0.07,
		DefaultClip = 50,
		Automatic = true,
		Ammo = "smg1"
	},
	Secondary = {
		Automatic = false,
		Ammo = "none"
	},
	IronSightsPos = Vector( 6.1, -7, 2.5 ),
	IronSightsAng = Vector( 2.8, 0, 0 ),
	Initialize = function(self)
		self:SetWeaponHoldType("ar2")
	end,
}, "ak47", true)