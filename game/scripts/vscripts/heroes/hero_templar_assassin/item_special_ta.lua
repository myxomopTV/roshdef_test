LinkLuaModifier("modifier_item_special_ta", "heroes/hero_templar_assassin/item_special_ta", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_special_ta_upgrade", "heroes/hero_templar_assassin/item_special_ta", LUA_MODIFIER_MOTION_NONE)

item_special_ta = class({})

function item_special_ta:GetIntrinsicModifierName()
	return "modifier_item_special_ta"
end

modifier_item_special_ta = class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	DeclareFunctions		= function(self) return 
		{MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		} end,
})

function modifier_item_special_ta:GetModifierPreAttack_BonusDamage()
	return self:GetAbility():GetSpecialValueFor("bonus_dmg")
end

function modifier_item_special_ta:GetModifierBonusStats_Strength()
	return self:GetAbility():GetSpecialValueFor("bonus_str")
end

function modifier_item_special_ta:GetModifierBonusStats_Agility()
	return self:GetAbility():GetSpecialValueFor("bonus_agi")
end

function modifier_item_special_ta:GetModifierBonusStats_Intellect()
	return self:GetAbility():GetSpecialValueFor("bonus_int")
end

function modifier_item_special_ta:GetEffectName()
	if self:GetCaster():GetUnitName()=="npc_dota_hero_templar_assassin" then
		return "particles/econ/courier/courier_babyroshan_ti9/courier_babyroshan_ti9_ambient.vpcf"
	else
		return
	end	
end

item_special_ta_upgrade = class({})

function item_special_ta_upgrade:GetIntrinsicModifierName()
	return "modifier_item_special_ta_upgrade"
end

modifier_item_special_ta_upgrade = class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	DeclareFunctions		= function(self) return 
		{MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		} end,
})

function modifier_item_special_ta_upgrade:GetModifierPreAttack_BonusDamage()
	return self:GetAbility():GetSpecialValueFor("bonus_dmg")
end

function modifier_item_special_ta_upgrade:GetModifierBonusStats_Strength()
	return self:GetAbility():GetSpecialValueFor("bonus_str")
end

function modifier_item_special_ta_upgrade:GetModifierBonusStats_Agility()
	return self:GetAbility():GetSpecialValueFor("bonus_agi")
end

function modifier_item_special_ta_upgrade:GetModifierBonusStats_Intellect()
	return self:GetAbility():GetSpecialValueFor("bonus_int")
end

function modifier_item_special_ta_upgrade:GetEffectName()
	if self:GetCaster():GetUnitName()=="npc_dota_hero_templar_assassin" then
		return "particles/econ/courier/courier_babyroshan_ti9/courier_babyroshan_ti9_ambient.vpcf"
	else
		return
	end	
end
