roshan_frostivus_mini_slam = class({})

LinkLuaModifier("modifier_roshan_frostivus_mini_slam", "abilities/roshan_frostivus_mini_slam", LUA_MODIFIER_MOTION_NONE)

function roshan_frostivus_mini_slam:GetAbilityTextureName()
	return "roshan_frostivus_mini_slam"
end

function roshan_frostivus_mini_slam:GetCastAnimation()
	return ACT_DOTA_CAST_ABILITY_5
end

function roshan_frostivus_mini_slam:OnSpellStart()
	local radius = self:GetSpecialValueFor("radius")
	local damage = self:GetAbilityDamage()

	self:GetCaster():EmitSound("RoshanFrost.MiniSlam")

	local slamCastPFX = ParticleManager:CreateParticle("particles/neutral_fx/roshan_slam.vpcf", PATTACH_ABSORIGIN, self:GetCaster())
	ParticleManager:SetParticleControl(slamCastPFX, 0, self:GetCaster():GetOrigin() + Vector(0, 0, 50))
	ParticleManager:SetParticleControl(slamCastPFX, 1, Vector(radius, radius, radius))
	ParticleManager:ReleaseParticleIndex(slamCastPFX)

	local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetCaster():GetOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	for _,enemy in pairs(enemies) do
		ApplyDamage({
			victim = enemy,
			attacker = self:GetCaster(),
			damage = damage,
			damage_type = self:GetAbilityDamageType(),
			ability = self
		})
		enemy:AddNewModifier(self:GetCaster(), self, "modifier_roshan_frostivus_mini_slam", {duration = self:GetSpecialValueFor("slow_duration")})
	end
end

modifier_roshan_frostivus_mini_slam = class({
	IsPurgable = function() return false end,
})

function modifier_roshan_frostivus_mini_slam:DeclareFunctions()
	return {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE}
end

function modifier_roshan_frostivus_mini_slam:GetModifierMoveSpeedBonus_Percentage()
	return -self:GetAbility():GetSpecialValueFor("slow_amount")
end