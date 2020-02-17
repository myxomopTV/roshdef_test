LinkLuaModifier("modifier_item_barbarian_shield", "items/custom/item_barbarian_shield", LUA_MODIFIER_MOTION_NONE)

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
			MODIFIER_PROPERTY_PHYSICAL_CONSTANT_BLOCK,
		} end,
})

function modifier_item_barbarian_shield:GetModifierPhysical_ConstantBlock()
	local block_chance = self:GetAbility():GetSpecialValueFor("block_chance") 
	if RollPercentage(block_chance) then
		return 999999
	end
end
