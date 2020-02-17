LinkLuaModifier("modifier_antares_dragon_blood", "heroes/hero_antares/dragon_blood", LUA_MODIFIER_MOTION_NONE)

antares_dragon_blood = class({})

function antares_dragon_blood:GetIntrinsicModifierName()
	return "modifier_antares_dragon_blood"
end

modifier_antares_dragon_blood = class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	DeclareFunctions		= function(self) return 
		{
			MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		} end,
})

function modifier_antares_dragon_blood:OnCreated()	
	self:StartIntervalThink(0.1)
end

function modifier_antares_dragon_blood:OnIntervalThink()	
	local caster = self:GetCaster()
	self:SetStackCount(caster:GetStrength())
end

function modifier_antares_dragon_blood:GetModifierAttackSpeedBonus_Constant()
	return self:GetAbility():GetSpecialValueFor("bonus_str_as")*self:GetStackCount()
end
