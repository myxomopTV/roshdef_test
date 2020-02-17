modifier_race_buff = class({
	IsHidden 				= function(self) return false end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return true end,
	GetAttributes 			= function(self) return MODIFIER_ATTRIBUTE_MULTIPLE end,
	DeclareFunctions		= function(self) return 
		{	
			MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,
			MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
			MODIFIER_PROPERTY_EVASION_CONSTANT,
			MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
			MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
			MODIFIER_PROPERTY_EXTRA_HEALTH_PERCENTAGE,
			} end,
})
function modifier_race_buff:OnCreated()
	local ability = self:GetAbility()
	self.dmg_bonus = ability:GetSpecialValueFor("dmg_bonus")
	self.armor_bonus = ability:GetSpecialValueFor("armor_bonus")
	self.evasion_bonus = ability:GetSpecialValueFor("evasion_bonus")
	self.hp_bonus = ability:GetSpecialValueFor("hp_bonus")
	self.as_bonus = ability:GetSpecialValueFor("as_bonus")
	self.magical_resist = ability:GetSpecialValueFor("magical_resist")
end

function modifier_race_buff:GetModifierBaseDamageOutgoing_Percentage()
	return self.dmg_bonus
end

function modifier_race_buff:GetModifierPhysicalArmorBonus()
	return self.armor_bonus
end

function modifier_race_buff:GetModifierEvasion_Constant()
	return self.evasion_bonus
end

function modifier_race_buff:GetModifierAttackSpeedBonus_Constant()
	return self.as_bonus
end

function modifier_race_buff:GetModifierMagicalResistanceBonus()
	return self.magical_resist
end

function modifier_race_buff:GetModifierExtraHealthPercentage()
	return self.hp_bonus
end
