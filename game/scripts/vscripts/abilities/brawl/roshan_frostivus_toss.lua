roshan_frostivus_toss = class({})

LinkLuaModifier("modifier_roshan_frostivus_toss", "abilities/roshan_frostivus_toss", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_roshan_frostivus_toss_knockback", "abilities/roshan_frostivus_toss", LUA_MODIFIER_MOTION_NONE)

function roshan_frostivus_toss:GetAbilityTextureName()
	return "roshan_frostivus_toss"
end

function roshan_frostivus_toss:GetCastAnimation()
	return ACT_DOTA_CAST_ABILITY_3
end

function roshan_frostivus_toss:OnSpellStart()
	self.radius = self:GetSpecialValueFor("radius")
	self.land_radius = self:GetSpecialValueFor("land_radius")
	self.slow_duration = self:GetSpecialValueFor("slow_duration")
	self.damage = self:GetAbilityDamage()

	local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetCaster():GetOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
	for _,enemy in pairs(enemies) do
		local knocbackOrigin = self:GetCaster():GetOrigin() + self:GetCaster():GetForwardVector():Normalized() * -1200
		local knocbackCenter = RotatePosition(Vector(0,0,0), QAngle(0,RandomFloat(-15, 15),0), knocbackOrigin)
		enemy:AddNewModifier(self:GetCaster(), self, "modifier_knockback", {
			should_stun = 1,
			knockback_duration = 1.0,
			duration = 1.0,
			knockback_distance = 1200,
			knockback_height = 600,
			center_x = knocbackCenter.x,
			center_y = knocbackCenter.y,
			center_z = knocbackCenter.z
		})
		enemy:AddNewModifier(self:GetCaster(), self, "modifier_roshan_frostivus_toss_knockback", {duration = 1.0})
		ApplyDamage({
			victim = enemy,
			attacker = self:GetCaster(),
			damage = self.damage,
			damage_type = self:GetAbilityDamageType(),
			ability = self
		})
	end
end

modifier_roshan_frostivus_toss = class({
	IsPurgable = function() return false end,
})

function modifier_roshan_frostivus_toss:DeclareFunctions()
	return {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE}
end

function modifier_roshan_frostivus_toss:GetModifierMoveSpeedBonus_Percentage()
	return -self:GetAbility():GetSpecialValueFor("slow")
end

modifier_roshan_frostivus_toss_knockback = class({
	IsPurgable = function() return false end,
	IsHidden = function() return true end,
})

if IsServer() then
	function modifier_roshan_frostivus_toss_knockback:OnDestroy()
		local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetParent():GetOrigin(), nil, self:GetAbility().land_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		for _,enemy in pairs(enemies) do
			ApplyDamage({
				victim = enemy,
				attacker = self:GetCaster(),
				damage = self:GetAbility().damage,
				damage_type = self:GetAbility():GetAbilityDamageType(),
				ability = self:GetAbility()
			})
			enemy:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_roshan_frostivus_toss", {duration = self:GetAbility().slow_duration})
		end
	end
end