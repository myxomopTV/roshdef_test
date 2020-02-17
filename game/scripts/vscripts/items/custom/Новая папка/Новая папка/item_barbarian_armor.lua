LinkLuaModifier("modifier_item_barbarian_armor", "items/custom/item_barbarian_armor", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_barbarian_armor_buff", "items/custom/item_barbarian_armor", LUA_MODIFIER_MOTION_NONE)

item_barbarian_armor = class({})

function item_barbarian_armor:GetIntrinsicModifierName()
	return "modifier_item_barbarian_armor"
end
--------------------------------------------------------
------------------------------------------------------------
modifier_item_barbarian_armor = class({
	IsHidden 				= function(self) return true end,
	DeclareFunctions		= function(self) return 
		{
			MODIFIER_PROPERTY_HEALTH_BONUS,
			MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
			MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
			MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
			MODIFIER_PROPERTY_EXTRA_HEALTH_PERCENTAGE,
		} end,
})

function modifier_item_barbarian_armor:GetModifierHealthBonus()
	return self:GetAbility():GetSpecialValueFor("bonus_health")
end

function modifier_item_barbarian_armor:GetModifierBonusStats_Strength()
	return self:GetAbility():GetSpecialValueFor("bonus_str")
end
function modifier_item_barbarian_armor:GetModifierHealthRegenPercentage()
	return self:GetAbility():GetSpecialValueFor("bonus_regen_pct")
end

function modifier_item_barbarian_armor:GetModifierPhysicalArmorBonus()
	return self:GetAbility():GetSpecialValueFor("bonus_armor")
end

function modifier_item_barbarian_armor:GetModifierExtraHealthPercentage()
	return self:GetAbility():GetSpecialValueFor("bonus_health_pct")
end

item_barbarian_armor_1 = class(item_barbarian_armor)
item_barbarian_armor_2 = class(item_barbarian_armor)
