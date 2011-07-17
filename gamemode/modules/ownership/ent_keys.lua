weapons.Register({
	Author = "Macendo",
	Instructions = "Lock and unlock",
	Contact = "",
	Purpose = "",
	PrintName = "Keys",
	Slot = 1,
	SlotPos = 3,
	DrawAmmo = false,
	DrawCrosshair = true,
	Base = "weapon_base",
	Initialize = function(self)
		self:SetWeaponHoldType("normal")
	end,
	PrimaryAttack = function(self)
		local toOpen = self.Owner:GetEyeTrace()
		if toOpen.HitNonWorld and toOpen.Entity.Owner == self.Owner then
			toOpen.Entity:Fire("lock", "",0)
			self.Owner:EmitSound("npc/metropolice/gear".. math.floor(math.Rand(1,7)) ..".wav")
		end
	end,
	SecondaryAttack = function(self)
		local toOpen = self.Owner:GetEyeTrace()
		if toOpen.HitNonWorld and toOpen.Entity.Owner == self.Owner then
			self.Owner:EmitSound("npc/metropolice/gear".. math.floor(math.Rand(1,7)) ..".wav")
			toOpen.Entity:Fire("unlock", "", 0)
		end
	end
}, "keys", true)
