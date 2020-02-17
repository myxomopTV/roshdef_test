LinkLuaModifier("modifier_item_special_mark", "heroes/mystic_dragon/item_special_mark", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_special_mark_upgrade", "heroes/mystic_dragon/item_special_mark", LUA_MODIFIER_MOTION_NONE)

item_special_mark = class({})

function item_special_mark:GetIntrinsicModifierName()
	return "modifier_item_special_mark"
end

modifier_item_special_mark = class({
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

function modifier_item_special_mark:OnCreated()
	if not IsServer() then
		return
	end
	local caster = self:GetCaster()

end

function modifier_item_special_mark:GetModifierPreAttack_BonusDamage()
	return self:GetAbility():GetSpecialValueFor("bonus_dmg")
end

function modifier_item_special_mark:GetModifierBonusStats_Strength()
	return self:GetAbility():GetSpecialValueFor("bonus_str")
end

function modifier_item_special_mark:GetModifierBonusStats_Agility()
	return self:GetAbility():GetSpecialValueFor("bonus_agi")
end

function modifier_item_special_mark:GetModifierBonusStats_Intellect()
	return self:GetAbility():GetSpecialValueFor("bonus_int")
end

function modifier_item_special_mark:GetEffectName()
	if self:GetCaster():GetUnitName()=="npc_dota_hero_templar_assassin" then
		return "particles/econ/courier/courier_babyroshan_ti9/courier_babyroshan_ti9_ambient.vpcf"
	else
		return
	end	
end

item_special_mark_upgrade = class({})

function item_special_mark_upgrade:GetIntrinsicModifierName()
	return "modifier_item_special_mark_upgrade"
end

modifier_item_special_mark_upgrade = class({
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

function modifier_item_special_mark_upgrade:OnCreated()
	if not IsServer() then
		return
	end
	self:StartIntervalThink(0.1)
end

function modifier_item_special_mark_upgrade:GetModifierPreAttack_BonusDamage()
	return self:GetAbility():GetSpecialValueFor("bonus_dmg")
end

function modifier_item_special_mark_upgrade:GetModifierBonusStats_Strength()
	return self:GetAbility():GetSpecialValueFor("bonus_str")
end

function modifier_item_special_mark_upgrade:GetModifierBonusStats_Agility()
	return self:GetAbility():GetSpecialValueFor("bonus_agi")
end

function modifier_item_special_mark_upgrade:GetModifierBonusStats_Intellect()
	return self:GetAbility():GetSpecialValueFor("bonus_int")
end

function modifier_item_special_mark_upgrade:GetEffectName()
	if self:GetCaster():GetUnitName()=="npc_dota_hero_templar_assassin" then
		return "particles/econ/courier/courier_babyroshan_ti9/courier_babyroshan_ti9_ambient.vpcf"
	else
		return
	end	
end
