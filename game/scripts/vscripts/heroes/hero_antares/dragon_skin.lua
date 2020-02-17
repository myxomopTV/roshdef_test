LinkLuaModifier("modifier_antares_dragon_skin", "heroes/hero_antares/dragon_skin", LUA_MODIFIER_MOTION_NONE)

antares_dragon_skin = class({})

function antares_dragon_skin:GetIntrinsicModifierName()
	return "modifier_antares_dragon_skin"
end

modifier_antares_dragon_skin = class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	DeclareFunctions		= function(self) return 
		{
			MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
			MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
			MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
		} end,
})

function modifier_antares_dragon_skin:GetModifierPhysicalArmorBonus()
	local caster = self:GetCaster()
	local mult = 1
	if caster:HasModifier("modifier_item_special_antares_upgrade_1") or caster:HasModifier("modifier_item_special_antares_upgrade_2") or caster:HasModifier("modifier_item_special_antares_upgrade_3") or caster:HasModifier("modifier_item_special_antares_upgrade_4")  then
		mult = 2
	end	
	return self:GetAbility():GetSpecialValueFor("bonus_armor")*mult
end

function modifier_antares_dragon_skin:GetModifierConstantHealthRegen()
	local caster = self:GetCaster()
	local mult = 1
	if caster:HasModifier("modifier_item_special_antares_upgrade_1") or caster:HasModifier("modifier_item_special_antares_upgrade_2") or caster:HasModifier("modifier_item_special_antares_upgrade_3") or caster:HasModifier("modifier_item_special_antares_upgrade_4")  then
		mult = 2
	end	
	return self:GetAbility():GetSpecialValueFor("bonus_regen")*mult
end

function modifier_antares_dragon_skin:GetModifierHealthRegenPercentage()
	local caster = self:GetCaster()
	local mult = 1
	if caster:HasModifier("modifier_item_special_antares_upgrade_1") or caster:HasModifier("modifier_item_special_antares_upgrade_2") or caster:HasModifier("modifier_item_special_antares_upgrade_3") or caster:HasModifier("modifier_item_special_antares_upgrade_4")  then
		mult = 2
	end	
	return self:GetAbility():GetSpecialValueFor("bonus_regen_pct")*mult
end
