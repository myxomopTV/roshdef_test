LinkLuaModifier("modifier_item_guardian_armor", "items/custom/item_guardian_armor", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_guardian_armor_buff", "items/custom/item_guardian_armor", LUA_MODIFIER_MOTION_NONE)

item_guardian_armor = class({})

function item_guardian_armor:GetIntrinsicModifierName()
	return "modifier_item_guardian_armor"
end
--------------------------------------------------------
------------------------------------------------------------
modifier_item_guardian_armor = class({
	IsHidden 				= function(self) return true end,
	DeclareFunctions		= function(self) return 
		{
			MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
			MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
			MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		} end,
})

function modifier_item_guardian_armor:GetModifierBonusStats_Strength()
	return self:GetAbility():GetSpecialValueFor("bonus_str")
end

function modifier_item_guardian_armor:GetModifierPhysicalArmorBonus()
	return self:GetAbility():GetSpecialValueFor("bonus_armor")
end

function modifier_item_guardian_armor:GetModifierIncomingDamage_Percentage()
	return self:GetAbility():GetSpecialValueFor("bonus_resist")*(-1)
end

item_guardian_armor_1 = class(item_guardian_armor)
item_guardian_armor_2 = class(item_guardian_armor)
