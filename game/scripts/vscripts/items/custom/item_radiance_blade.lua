LinkLuaModifier("modifier_item_radiance_blade", "items/custom/item_radiance_blade", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_radiance_blade_aura", "items/custom/item_radiance_blade", LUA_MODIFIER_MOTION_NONE)

item_radiance_blade = class({})

function item_radiance_blade:GetIntrinsicModifierName()
	return "modifier_item_radiance_blade"
end

function item_radiance_blade:GetCastRange()
	return self:GetSpecialValueFor("aura_radius")
end
--------------------------------------------------------
------------------------------------------------------------
modifier_item_radiance_blade = class({
	IsHidden 				= function(self) return true end,
	IsAura 					= function(self) return true end,
	GetAuraRadius 			= function(self) return self:GetAbility():GetSpecialValueFor("aura_radius") end,
	GetAuraSearchTeam 		= function(self) return DOTA_UNIT_TARGET_TEAM_ENEMY end,
	GetAuraSearchType 		= function(self) return DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO end,
	GetModifierAura 		= function(self) return "modifier_item_radiance_blade_aura" end,
	DeclareFunctions		= function(self) return 
		{
			MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
			MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
			MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
			MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		} end,
})
function modifier_item_radiance_blade:GetModifierPreAttack_BonusDamage()
	return self:GetAbility():GetSpecialValueFor("bonus_attack")
end

function modifier_item_radiance_blade:GetModifierBonusStats_Strength()
	return self:GetAbility():GetSpecialValueFor("bonus_stats")
end

function modifier_item_radiance_blade:GetModifierBonusStats_Agility()
	return self:GetAbility():GetSpecialValueFor("bonus_stats")
end

function modifier_item_radiance_blade:GetModifierBonusStats_Intellect()
	return self:GetAbility():GetSpecialValueFor("bonus_stats")
end

function modifier_item_radiance_blade:GetEffectName()
	return "particles/item/radiance/radiance_owner.vpcf"
end

modifier_item_radiance_blade_aura = class({
	IsHidden 		= function(self) return false end,
})

function modifier_item_radiance_blade_aura:OnCreated()
	local caster = self:GetCaster()
	self:StartIntervalThink(1)
	local pfx = ParticleManager:CreateParticle("particles/items2_fx/radiance.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	ParticleManager:SetParticleControl(pfx, 1, caster:GetAbsOrigin())
	self:AddParticle(pfx, false, false, MODIFIER_PRIORITY_HIGH, false, false)

end

function modifier_item_radiance_blade_aura:GetEffectName()
	return "particles/econ/events/ti6/radiance_ti6.vpcf"
end

function modifier_item_radiance_blade_aura:OnIntervalThink()
	local caster = self:GetCaster()
	local parent = self:GetParent()
	local ability = self:GetAbility()
	local aura_dmg = ability:GetSpecialValueFor("aura_dmg")
	local aura_dmg_pct = ability:GetSpecialValueFor("aura_dmg_pct")/100
	local damage = aura_dmg + aura_dmg_pct*caster:GetMaxHealth()
	print(damage)

	DealDamage(caster, parent, damage, DAMAGE_TYPE_MAGICAL, nil, ability)


end

item_radiance_blade_1 = class(item_radiance_blade)
item_radiance_blade_2 = class(item_radiance_blade)

