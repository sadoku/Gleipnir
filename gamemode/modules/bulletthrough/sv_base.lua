weapons.Register({
	Author = "Macendo",
	Instructions = "Lock and unlock",
	Contact = "",
	Purpose = "",
	PrintName = "BAZENZ",
	Slot = 1,
	SlotPos = 3,
	DrawAmmo = false,
	DrawCrosshair = true,
	Sound = Sound("Weapon_AK47.Single"),
	Base = "weapon_base",
	Initialize = function(self)
		self:SetWeaponHoldType("normal")
	end,
	Fire = function(self)
		self.Weapon:EmitSound(self.Sound)
	end
}, "gleip_base", true)

weapons.Register({
	Author = "Macendo",
	Instructions = "Dick sucker",
	Contact = "",
	Purpose = "",
	PrintName = "Suckah",
	Slot = 1,
	SlotPos = 3,
	DrawAmmo = false,
	DrawCrosshair = true,
	Base = "gleip_base",
	Initialize = function(self)
		self:SetWeaponHoldType("normal")
	end,
	PrimaryAttack = function(self)
		self:Fire()
	end,
	SecondaryAttack = function(self)
		self:Fire()
	end
}, "gleip_ak", true)
