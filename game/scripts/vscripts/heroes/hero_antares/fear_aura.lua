LinkLuaModifier("modifier_antares_fear_aura", "heroes/hero_antares/fear_aura", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_antares_fear_aura_debuff", "heroes/hero_antares/fear_aura", LUA_MODIFIER_MOTION_NONE)

antares_fear_aura = class({})

function antares_fear_aura:GetCastRange()
	return self:GetSpecialValueFor("aura_radius")
end

function antares_fear_aura:GetIntrinsicModifierName()
	return "modifier_antares_fear_aura"
end

modifier_antares_fear_aura = class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	IsAura 					= function(self) return true end,
	GetAuraSearchTeam 		= function(self) return DOTA_UNIT_TARGET_TEAM_ENEMY end,
	GetAuraSearchType 		= function(self) return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end,
	GetAuraSearchFlags 		= function(self) return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES end,
	GetAuraRadius 			= function(self) return self:GetAbility():GetSpecialValueFor("aura_radius") end,
	GetModifierAura 		= function(self) return "modifier_antares_fear_aura_debuff" end,
})


modifier_antares_fear_aura_debuff = class({
    IsHidden                = function(self) return false end,
    IsPurgable              = function(self) return false end,
    IsDebuff                = function(self) return true end,
    IsBuff                  = function(self) return false end,
    RemoveOnDeath           = function(self) return false end,
    DeclareFunctions        = function(self) return 
        {
            MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
        } end,

})

function modifier_antares_fear_aura_debuff:GetModifierTotalDamageOutgoing_Percentage()

	return self:GetAbility():GetSpecialValueFor("decrease_dmg")*(-1)  
end



