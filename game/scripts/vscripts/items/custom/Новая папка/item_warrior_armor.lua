LinkLuaModifier("modifier_item_warrior_armor", "items/custom/item_warrior_armor", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_warrior_armor_buff", "items/custom/item_warrior_armor", LUA_MODIFIER_MOTION_NONE)

item_warrior_armor = class({})

function item_warrior_armor:GetIntrinsicModifierName()
	return "modifier_item_warrior_armor"
end
--------------------------------------------------------
------------------------------------------------------------
modifier_item_warrior_armor = class({
	IsHidden 				= function(self) return true end,
	DeclareFunctions		= function(self) return 
		{
			MODIFIER_PROPERTY_HEALTH_BONUS,
			MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
			MODIFIER_PROPERTY_EXTRA_HEALTH_PERCENTAGE,
		} end,
})

function modifier_item_warrior_armor:GetModifierHealthBonus()
	return self:GetAbility():GetSpecialValueFor("bonus_health")
end

function modifier_item_warrior_armor:GetModifierPhysicalArmorBonus()
	return self:GetAbility():GetSpecialValueFor("bonus_armor")
end

function modifier_item_warrior_armor:GetModifierExtraHealthPercentage()
	return self:GetAbility():GetSpecialValueFor("bonus_health_pct")
end

item_warrior_armor_1 = class(item_warrior_armor)
item_warrior_armor_2 = class(item_warrior_armor)
