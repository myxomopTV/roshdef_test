LinkLuaModifier("modifier_item_warrior_shield", "items/custom/item_warrior_shield", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_warrior_shield_buff", "items/custom/item_warrior_shield", LUA_MODIFIER_MOTION_NONE)

item_warrior_shield = class({})

function item_warrior_shield:GetIntrinsicModifierName()
	return "modifier_item_warrior_shield"
end
--------------------------------------------------------
------------------------------------------------------------
modifier_item_warrior_shield = class({
	IsHidden 				= function(self) return true end,
	DeclareFunctions		= function(self) return 
		{
			MODIFIER_PROPERTY_HEALTH_BONUS,
			MODIFIER_PROPERTY_PHYSICAL_CONSTANT_BLOCK,
			MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
		} end,
})

function modifier_item_warrior_shield:GetModifierHealthBonus()
	return self:GetAbility():GetSpecialValueFor("bonus_health")
end

function modifier_item_warrior_shield:GetModifierPhysical_ConstantBlock()
	return self:GetAbility():GetSpecialValueFor("bonus_block")
end
function modifier_item_warrior_shield:GetModifierIncomingDamage_Percentage()
	local block_chance = self:GetAbility():GetSpecialValueFor("block_chance") 
	if RollPercentage(block_chance) then
		return -1000
	end
end

item_warrior_shield_1 = class(item_warrior_shield)
item_warrior_shield_2 = class(item_warrior_shield)
