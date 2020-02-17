
LinkLuaModifier( "modifier_item_midas_crown", "items/custom/midas_crown", LUA_MODIFIER_MOTION_NONE )

item_midas_crown = class({})

function item_midas_crown:GetIntrinsicModifierName()
	return "modifier_item_midas_crown"
end

modifier_item_midas_crown = class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return true end,
	DeclareFunctions		= function(self) return 
		{
			MODIFIER_EVENT_ON_DEATH,
			MODIFIER_PROPERTY_EXP_RATE_BOOST,
			MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
			MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
			MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		} end,
})

function modifier_item_midas_crown:GetEffectName()
	return "particles/leader/leader_overhead.vpcf"
end

function modifier_item_midas_crown:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end

function modifier_item_midas_crown:OnCreated()
	if IsServer() then
		local interval = self:GetAbility():GetSpecialValueFor("interval")
		self:StartIntervalThink(interval)
	end
end

function modifier_item_midas_crown:OnIntervalThink()
	local caster = self:GetCaster()
	local ability = self:GetAbility()
	local tick_gold = ability:GetSpecialValueFor("tick_gold")
	caster:ModifyGold(tick_gold, false, 0)
end

function modifier_item_midas_crown:GetModifierPercentageExpRateBoost()
	return self:GetAbility():GetSpecialValueFor("bonus_exp")
end

function modifier_item_midas_crown:GetModifierBonusStats_Strength()
	return self:GetAbility():GetSpecialValueFor("bonus_stats")
end

function modifier_item_midas_crown:GetModifierBonusStats_Agility()
	return self:GetAbility():GetSpecialValueFor("bonus_stats")
end

function modifier_item_midas_crown:GetModifierBonusStats_Intellect()
	return self:GetAbility():GetSpecialValueFor("bonus_stats")
end

item_midas_crown_1 = class(item_midas_crown)
item_midas_crown_2 = class(item_midas_crown)
item_midas_crown_3 = class(item_midas_crown)
