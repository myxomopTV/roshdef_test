LinkLuaModifier("modifier_item_base_stone_health", "items/baseitems/item_base_stone_health", LUA_MODIFIER_MOTION_NONE)

item_base_stone_health = class({})

function item_base_stone_health:GetIntrinsicModifierName()
	return "modifier_item_base_stone_health"
end

item_base_stone_health_1 = class(item_base_stone_health)
item_base_stone_health_2 = class(item_base_stone_health)
item_base_stone_health_3 = class(item_base_stone_health)

modifier_item_base_stone_health = class({
	IsHidden 		= function(self) return true end,
	DeclareFunctions  = function(self) return {
		MODIFIER_PROPERTY_HEALTH_BONUS,
	}end,
})

function modifier_item_base_stone_health:GetModifierHealthBonus()
	return self:GetAbility():GetSpecialValueFor("bonus_value")
end