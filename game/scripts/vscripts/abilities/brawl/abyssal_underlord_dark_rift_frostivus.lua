abyssal_underlord_dark_rift_frostivus = class({})
abyssal_underlord_cancel_dark_rift_frostivus = class({})

LinkLuaModifier("modifier_abyssal_underlord_dark_rift_frostivus", "abilities/abyssal_underlord_dark_rift_frostivus", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_abyssal_underlord_dark_rift_frostivus_target", "abilities/abyssal_underlord_dark_rift_frostivus", LUA_MODIFIER_MOTION_NONE)

function abyssal_underlord_dark_rift_frostivus:IsHiddenWhenStolen()
	return false
end

function abyssal_underlord_dark_rift_frostivus:OnUpgrade()
	self:GetCaster():FindAbilityByName("abyssal_underlord_cancel_dark_rift_frostivus"):SetLevel(self:GetCaster():FindAbilityByName("abyssal_underlord_cancel_dark_rift_frostivus"):GetMaxLevel())
end

function abyssal_underlord_dark_rift_frostivus:OnSpellStart()
	self:GetCaster().dark_rift_cancelled = false

	self:GetCaster().dark_rift_thinker = CreateModifierThinker(self:GetCaster(), self, "modifier_abyssal_underlord_dark_rift_frostivus_target", {duration = self:GetSpecialValueFor("teleport_delay")}, self:GetCursorPosition(), self:GetCaster():GetTeamNumber(), false)
	self:GetCaster():SwapAbilities(self:GetAbilityName(), "abyssal_underlord_cancel_dark_rift_frostivus", false, true)
	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_abyssal_underlord_dark_rift_frostivus", {duration = self:GetSpecialValueFor("teleport_delay")})
end

function abyssal_underlord_cancel_dark_rift_frostivus:IsHiddenWhenStolen()
	return false
end

function abyssal_underlord_cancel_dark_rift_frostivus:GetCastAnimation()
	return ACT_DOTA_OVERRIDE_ABILITY_4
end

function abyssal_underlord_cancel_dark_rift_frostivus:OnSpellStart()
	self:GetCaster().dark_rift_cancelled = true
	self:GetCaster().dark_rift_thinker:RemoveModifierByName("modifier_abyssal_underlord_dark_rift_frostivus_target")
	self:GetCaster():RemoveModifierByNameAndCaster("modifier_abyssal_underlord_dark_rift_frostivus", self:GetCaster())
end

modifier_abyssal_underlord_dark_rift_frostivus = class({
	IsHidden = function() return true end,
	IsPurgable = function() return false end,
})

if IsServer() then
	function modifier_abyssal_underlord_dark_rift_frostivus:OnCreated(kv)
		self.nFXIndex = ParticleManager:CreateParticle("particles/units/heroes/heroes_underlord/abbysal_underlord_darkrift_ambient.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		ParticleManager:SetParticleControlEnt(self.nFXIndex, 0, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, "follow_origin", self:GetParent():GetOrigin(), true)
		ParticleManager:SetParticleControl(self.nFXIndex, 1, Vector(self:GetAbility():GetSpecialValueFor("radius")))
		ParticleManager:SetParticleControlEnt(self.nFXIndex, 2, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, "follow_origin", self:GetParent():GetOrigin(), true)
		ParticleManager:SetParticleControlEnt(self.nFXIndex, 5, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, "follow_origin", self:GetParent():GetOrigin(), true)
		ParticleManager:SetParticleControlEnt(self.nFXIndex, 20, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, "follow_origin", self:GetParent():GetOrigin(), true)
		self:AddParticle(self.nFXIndex, false, false, -1, false, false)

		self:GetParent():EmitSound("Hero_AbyssalUnderlord.DarkRift.Cast")
	end

	function modifier_abyssal_underlord_dark_rift_frostivus:OnDestroy()
		self:GetParent():StopSound("Hero_AbyssalUnderlord.DarkRift.Cast")
		if not self:GetParent():IsAlive() or self:GetParent().dark_rift_cancelled or self:GetParent():IsInvulnerable() then
			self:GetParent():EmitSound("Hero_AbyssalUnderlord.DarkRift.Aftershock")
			ParticleManager:DestroyParticle(self.nFXIndex, true)
			if self:GetCaster().dark_rift_thinker and not self:GetCaster().dark_rift_thinker:IsNull() then
				self:GetCaster().dark_rift_thinker:RemoveModifierByName("modifier_abyssal_underlord_dark_rift_frostivus_target")
			end
		else
			if self:GetCaster().dark_rift_thinker and not self:GetCaster().dark_rift_thinker:IsNull() then
				self:GetParent():EmitSound("Hero_AbyssalUnderlord.DarkRift.Complete")

				local allies = FindUnitsInRadius(self:GetParent():GetTeamNumber(), self:GetParent():GetOrigin(), nil, self:GetAbility():GetSpecialValueFor("radius"), DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_ANY_ORDER, false)
				for _,ally in pairs(allies) do
					FindClearSpaceForUnit(ally, self:GetCaster().dark_rift_thinker:GetOrigin(), true)
				end
			end
		end
		self:GetParent():SwapAbilities(self:GetAbility():GetAbilityName(), "abyssal_underlord_cancel_dark_rift_frostivus", true, false )
	end
end

modifier_abyssal_underlord_dark_rift_frostivus_target = class({
	IsPurgable = function() return false end,
})

if IsServer() then
	function modifier_abyssal_underlord_dark_rift_frostivus_target:OnCreated(kv)
		local nFXIndex = ParticleManager:CreateParticle("particles/units/heroes/heroes_underlord/abyssal_underlord_darkrift_target.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, self:GetParent())
		ParticleManager:SetParticleControlEnt(nFXIndex, 0, self:GetParent(), PATTACH_OVERHEAD_FOLLOW, "follow_overhead", self:GetParent():GetOrigin(), true)
		ParticleManager:SetParticleControl(nFXIndex, 1, Vector(self:GetParent():GetHullRadius(), 0, 0))
		ParticleManager:SetParticleControlEnt(nFXIndex, 2, self:GetParent(), PATTACH_OVERHEAD_FOLLOW, "follow_overhead", self:GetParent():GetOrigin(), true)
		ParticleManager:SetParticleControlEnt(nFXIndex, 3, self:GetParent(), PATTACH_OVERHEAD_FOLLOW, "follow_overhead", self:GetParent():GetOrigin(), true)
		ParticleManager:SetParticleControlEnt(nFXIndex, 5, self:GetParent(), PATTACH_OVERHEAD_FOLLOW, "follow_overhead", self:GetParent():GetOrigin(), true)
		ParticleManager:SetParticleControlEnt(nFXIndex, 6, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, "follow_origin", self:GetParent():GetOrigin(), true)
		ParticleManager:SetParticleControlEnt(nFXIndex, 20, self:GetParent(), PATTACH_OVERHEAD_FOLLOW, "follow_overhead", self:GetParent():GetOrigin(), true)
		self:AddParticle(nFXIndex, false, false, -1, false, false)

		self:GetParent():EmitSound("Hero_AbyssalUnderlord.DarkRift.Target")

		MinimapEvent(self:GetCaster():GetTeamNumber(), self:GetCaster(), self:GetParent():GetOrigin().x, self:GetParent():GetOrigin().y, DOTA_MINIMAP_EVENT_TEAMMATE_TELEPORTING, self:GetAbility():GetSpecialValueFor("teleport_delay"))

		self:StartIntervalThink(0.1)
		self:OnIntervalThink()
	end

	function modifier_abyssal_underlord_dark_rift_frostivus_target:OnDestroy()
		self:GetParent():StopSound("Hero_AbyssalUnderlord.DarkRift.Target")
		self:GetParent():Destroy()
		self:GetCaster().dark_rift_thinker = nil
		MinimapEvent(self:GetCaster():GetTeamNumber(), self:GetCaster(), 0, 0, DOTA_MINIMAP_EVENT_CANCEL_TELEPORTING, 0)
	end

	function modifier_abyssal_underlord_dark_rift_frostivus_target:OnIntervalThink()
		AddFOWViewer(self:GetCaster():GetTeamNumber(), self:GetParent():GetOrigin(), 150, 0.15, false)
	end
end