LinkLuaModifier("modifier_item_base_stone_mana", "items/baseitems/item_base_stone_mana", LUA_MODIFIER_MOTION_NONE)

item_base_stone_mana = class({})

function item_base_stone_mana:GetIntrinsicModifierName()
	return "modifier_item_base_stone_mana"
end

item_base_stone_mana_1 = class(item_base_stone_mana)
item_base_stone_mana_2 = class(item_base_stone_mana)
item_base_stone_mana_3 = class(item_base_stone_mana)

modifier_item_base_stone_mana = class({
	IsHidden 		= function(self) return true end,
	DeclareFunctions  = function(self) return {
		MODIFIER_PROPERTY_MANA_BONUS,
	}end,
})

function modifier_item_base_stone_mana:GetModifierManaBonus()
	return self:GetAbility():GetSpecialValueFor("bonus_value")
end

