LinkLuaModifier("modifier_item_taras_heart", "items/custom/item_taras_heart", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_taras_heart_buff", "items/custom/item_taras_heart", LUA_MODIFIER_MOTION_NONE)

item_taras_heart = class({})

function item_taras_heart:GetIntrinsicModifierName()
	return "modifier_item_taras_heart"
end
--------------------------------------------------------
------------------------------------------------------------
modifier_item_taras_heart = class({
	IsHidden 				= function(self) return true end,
	DeclareFunctions		= function(self) return 
		{
			MODIFIER_PROPERTY_HEALTH_BONUS,
			MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
			MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
		} end,
})

function modifier_item_taras_heart:GetModifierHealthBonus()
	return self:GetAbility():GetSpecialValueFor("bonus_health")
end

function modifier_item_taras_heart:GetModifierBonusStats_Strength()
	return self:GetAbility():GetSpecialValueFor("bonus_str")
end
function modifier_item_taras_heart:GetModifierHealthRegenPercentage()
	return self:GetAbility():GetSpecialValueFor("bonus_regen_pct")
end

item_taras_heart_1 = class(item_taras_heart)
item_taras_heart_2 = class(item_taras_heart)
