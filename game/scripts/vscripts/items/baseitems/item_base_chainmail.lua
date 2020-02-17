LinkLuaModifier("modifier_item_base_chainmail", "items/baseitems/item_base_chainmail", LUA_MODIFIER_MOTION_NONE)

item_base_chainmail = class({})

function item_base_chainmail:GetIntrinsicModifierName()
	return "modifier_item_base_chainmail"
end

modifier_item_base_chainmail = class({
	IsHidden 		= function(self) return true end,
	DeclareFunctions  = function(self) return {
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	}end,
})

function modifier_item_base_chainmail:GetModifierPhysicalArmorBonus()
	return self:GetAbility():GetSpecialValueFor("bonus_value")
end

item_base_chainmail_1 = class(item_base_chainmail)
item_base_chainmail_2 = class(item_base_chainmail)
item_base_chainmail_3 = class(item_base_chainmail)
