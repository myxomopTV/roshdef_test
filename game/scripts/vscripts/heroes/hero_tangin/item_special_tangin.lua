LinkLuaModifier("modifier_item_special_tangin", "heroes/hero_tangin/item_special_tangin", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_special_tangin_upgrade", "heroes/hero_tangin/item_special_tangin", LUA_MODIFIER_MOTION_NONE)

item_special_tangin = class({})

function item_special_tangin:GetIntrinsicModifierName()
	return "modifier_item_special_tangin"
end

modifier_item_special_tangin = class({
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

function modifier_item_special_tangin:GetModifierPreAttack_BonusDamage()
	return self:GetAbility():GetSpecialValueFor("bonus_dmg")
end

function modifier_item_special_tangin:GetModifierBonusStats_Strength()
	return self:GetAbility():GetSpecialValueFor("bonus_str")
end

function modifier_item_special_tangin:GetModifierBonusStats_Agility()
	return self:GetAbility():GetSpecialValueFor("bonus_agi")
end

function modifier_item_special_tangin:GetModifierBonusStats_Intellect()
	return self:GetAbility():GetSpecialValueFor("bonus_int")
end

function modifier_item_special_tangin:GetEffectName()
	if self:GetCaster():GetUnitName()=="npc_dota_hero_chaos_knight" then
		return "particles/econ/courier/courier_babyroshan_ti9/courier_babyroshan_ti9_ambient.vpcf"
	else
		return
	end	
end

item_special_tangin_upgrade = class({})

function item_special_tangin_upgrade:GetIntrinsicModifierName()
	return "modifier_item_special_tangin_upgrade"
end

modifier_item_special_tangin_upgrade = class({
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

function modifier_item_special_tangin_upgrade:GetModifierPreAttack_BonusDamage()
	return self:GetAbility():GetSpecialValueFor("bonus_dmg")
end

function modifier_item_special_tangin_upgrade:GetModifierBonusStats_Strength()
	return self:GetAbility():GetSpecialValueFor("bonus_str")
end

function modifier_item_special_tangin_upgrade:GetModifierBonusStats_Agility()
	return self:GetAbility():GetSpecialValueFor("bonus_agi")
end

function modifier_item_special_tangin_upgrade:GetModifierBonusStats_Intellect()
	return self:GetAbility():GetSpecialValueFor("bonus_int")
end

function modifier_item_special_tangin_upgrade:GetEffectName()
	if self:GetCaster():GetUnitName()=="npc_dota_hero_chaos_knight" then
		return "particles/econ/courier/courier_babyroshan_ti9/courier_babyroshan_ti9_ambient.vpcf"
	else
		return
	end	
end
