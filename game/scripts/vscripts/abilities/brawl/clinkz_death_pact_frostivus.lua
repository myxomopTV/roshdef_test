clinkz_death_pact_frostivus = class({})

LinkLuaModifier("modifier_clinkz_death_pact_frostivus", "abilities/clinkz_death_pact_frostivus", LUA_MODIFIER_MOTION_NONE)

function clinkz_death_pact_frostivus:OnSpellStart()
	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_clinkz_death_pact_frostivus", {duration = self:GetSpecialValueFor("duration")})
	self:GetCaster():SetHealth(self:GetCaster():GetHealth() + self:GetSpecialValueFor("health_gain"))
	self:GetCaster():CalculateStatBonus()

	local nFXIndex = ParticleManager:CreateParticle("particles/units/heroes/hero_clinkz/clinkz_death_pact.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
	ParticleManager:SetParticleControlEnt(nFXIndex, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetCaster():GetOrigin(), true)
	ParticleManager:SetParticleControlEnt(nFXIndex, 1, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_head", self:GetCaster():GetOrigin(), true)
	ParticleManager:ReleaseParticleIndex(nFXIndex)

	EmitSoundOn("Hero_Clinkz.DeathPact.Cast", self:GetCaster())
end

modifier_clinkz_death_pact_frostivus = class({
	IsPurgable = function() return false end,
})

function modifier_clinkz_death_pact_frostivus:DeclareFunctions()
	return {MODIFIER_PROPERTY_HEALTH_BONUS, MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE}
end

function modifier_clinkz_death_pact_frostivus:GetModifierHealthBonus()
	return self:GetAbility():GetSpecialValueFor("health_gain")
end

function modifier_clinkz_death_pact_frostivus:GetModifierBaseAttack_BonusDamage()
	return self:GetAbility():GetSpecialValueFor("damage_gain")
end