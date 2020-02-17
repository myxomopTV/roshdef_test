modifier_item_treads_of_ermacor = class({})

------------------------------------------------------------------------------

function modifier_item_treads_of_ermacor:IsHidden() 
	return true
end

--------------------------------------------------------------------------------

function modifier_item_treads_of_ermacor:IsPurgable()
	return false
end

----------------------------------------

function modifier_item_treads_of_ermacor:OnCreated( kv )
	self.bonus_movement_speed = self:GetAbility():GetSpecialValueFor( "bonus_movement_speed" )
	self.bonus_armor = self:GetAbility():GetSpecialValueFor( "bonus_armor" )

end

----------------------------------------

function modifier_item_treads_of_ermacor:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	}
	return funcs
end

----------------------------------------

function modifier_item_treads_of_ermacor:GetModifierMoveSpeedBonus_Constant( params )
	return self.bonus_movement_speed
end

----------------------------------------

function modifier_item_treads_of_ermacor:GetModifierPhysicalArmorBonus( params )
	return self.bonus_armor
end






