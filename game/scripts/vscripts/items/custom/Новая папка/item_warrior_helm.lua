LinkLuaModifier("modifier_item_warrior_helm", "items/custom/item_warrior_helm", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_warrior_helm_buff", "items/custom/item_warrior_helm", LUA_MODIFIER_MOTION_NONE)

item_warrior_helm = class({})

function item_warrior_helm:GetIntrinsicModifierName()
	return "modifier_item_warrior_helm"
end
--------------------------------------------------------
------------------------------------------------------------
modifier_item_warrior_helm = class({
	IsHidden 				= function(self) return true end,
	DeclareFunctions		= function(self) return 
		{
			MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
			MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
			MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
			MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
			MODIFIER_PROPERTY_STATUS_RESISTANCE,
		} end,
})

function modifier_item_warrior_helm:GetModifierBonusStats_Strength()
	return self:GetAbility():GetSpecialValueFor("bonus_stats")
end

function modifier_item_warrior_helm:GetModifierBonusStats_Agility()
	return self:GetAbility():GetSpecialValueFor("bonus_stats")
end

function modifier_item_warrior_helm:GetModifierBonusStats_Intellect()
	return self:GetAbility():GetSpecialValueFor("bonus_stats")
end

function modifier_item_warrior_helm:GetModifierPhysicalArmorBonus()
	return self:GetAbility():GetSpecialValueFor("bonus_armor")
end

function modifier_item_warrior_helm:GetModifierStatusResistance()
	return self:GetAbility():GetSpecialValueFor("bonus_status_resist")
end

item_warrior_helm_1 = class(item_warrior_helm)
item_warrior_helm_2 = class(item_warrior_helm)
