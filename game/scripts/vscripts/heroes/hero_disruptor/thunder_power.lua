LinkLuaModifier("modifier_disruptor_thunder_power", "heroes/hero_disruptor/thunder_power", LUA_MODIFIER_MOTION_NONE)

disruptor_thunder_power = class({})

function disruptor_thunder_power:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	local buff_duration = self:GetSpecialValueFor("buff_duration")

	target:AddNewModifier(caster, self, "modifier_disruptor_thunder_power", {duration = buff_duration})
	EmitSoundOn("Hero_Disruptor.KineticField.Pinfold", target)
	
end
--------------------------------------------------------
------------------------------------------------------------
modifier_disruptor_thunder_power = class({
	IsHidden 				= function(self) return false end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	DeclareFunctions		= function(self) return 
		{
			MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
			MODIFIER_PROPERTY_MODEL_SCALE,
			MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
			MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
			MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		} end,
})

function modifier_disruptor_thunder_power:GetStatusEffectName()
	return "particles/status_fx/status_effect_dark_willow_shadow_realm.vpcf"
end

function modifier_disruptor_thunder_power:StatusEffectPriority()	
	return 120
end

function modifier_disruptor_thunder_power:GetModifierBonusStats_Strength()
	return self:GetAbility():GetSpecialValueFor("bonus_stats")
end

function modifier_disruptor_thunder_power:GetModifierBonusStats_Agility()
	return self:GetAbility():GetSpecialValueFor("bonus_stats")
end

function modifier_disruptor_thunder_power:GetModifierBonusStats_Intellect()
	return self:GetAbility():GetSpecialValueFor("bonus_stats")
end

function modifier_disruptor_thunder_power:GetModifierTotalDamageOutgoing_Percentage()
	return self:GetAbility():GetSpecialValueFor("bonus_out_dmg")
end

function modifier_disruptor_thunder_power:GetModifierModelScale()
	return self:GetAbility():GetSpecialValueFor("model_scale")
end

