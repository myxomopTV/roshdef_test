LinkLuaModifier("modifier_item_barbarian_shield", "items/custom/item_barbarian_shield", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_barbarian_shield_buff", "items/custom/item_barbarian_shield", LUA_MODIFIER_MOTION_NONE)

item_barbarian_shield = class({})

function item_barbarian_shield:GetIntrinsicModifierName()
	return "modifier_item_barbarian_shield"
end
--------------------------------------------------------
------------------------------------------------------------
modifier_item_barbarian_shield = class({
	IsHidden 				= function(self) return true end,
	DeclareFunctions		= function(self) return 
		{
			MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
			MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
			MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
			MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
			MODIFIER_PROPERTY_STATUS_RESISTANCE,
			MODIFIER_PROPERTY_HEALTH_BONUS,
			MODIFIER_PROPERTY_PHYSICAL_CONSTANT_BLOCK,
			MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
		} end,
})

function modifier_item_barbarian_shield:GetModifierBonusStats_Strength()
	return self:GetAbility():GetSpecialValueFor("bonus_stats")
end

function modifier_item_barbarian_shield:GetModifierBonusStats_Agility()
	return self:GetAbility():GetSpecialValueFor("bonus_stats")
end

function modifier_item_barbarian_shield:GetModifierBonusStats_Intellect()
	return self:GetAbility():GetSpecialValueFor("bonus_stats")
end

function modifier_item_barbarian_shield:GetModifierPhysicalArmorBonus()
	return self:GetAbility():GetSpecialValueFor("bonus_armor")
end

function modifier_item_barbarian_shield:GetModifierStatusResistance()
	return self:GetAbility():GetSpecialValueFor("bonus_status_resist")
end

function modifier_item_barbarian_shield:GetModifierHealthBonus()
	return self:GetAbility():GetSpecialValueFor("bonus_health")
end

function modifier_item_barbarian_shield:GetModifierPhysical_ConstantBlock()
	return self:GetAbility():GetSpecialValueFor("bonus_block")
end

function modifier_item_barbarian_shield:GetModifierIncomingDamage_Percentage()
	local block_chance = self:GetAbility():GetSpecialValueFor("block_chance") 
	if RollPercentage(block_chance) then
		return -1000
	end
end

item_barbarian_shield_1 = class(item_barbarian_shield)
item_barbarian_shield_2 = class(item_barbarian_shield)
