
LinkLuaModifier( "modifier_bristleback_hard_skin", "heroes/hero_bristleback/hard_skin", LUA_MODIFIER_MOTION_NONE )

bristleback_hard_skin = class({})

function bristleback_hard_skin:GetIntrinsicModifierName()
	return "modifier_bristleback_hard_skin"
end

modifier_bristleback_hard_skin = class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return true end,
	DeclareFunctions		= function(self) return 
		{
			MODIFIER_PROPERTY_EXTRA_HEALTH_PERCENTAGE,
		} end,
})

function modifier_bristleback_hard_skin:GetModifierExtraHealthPercentage()
	return self:GetAbility():GetSpecialValueFor("bonus_health_pct")
end
