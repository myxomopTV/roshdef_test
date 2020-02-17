LinkLuaModifier("modifier_tangin_iron_curtain", "heroes/hero_tangin/iron_curtain", LUA_MODIFIER_MOTION_NONE)


tangin_iron_curtain = class({})

function tangin_iron_curtain:OnSpellStart()
    local caster = self:GetCaster()
    local duration = self:GetSpecialValueFor("duration")

    EmitSoundOn("tangin_iron_curtain", caster)
    caster:AddNewModifier(caster, self, "modifier_tangin_iron_curtain", {duration = duration})
    caster:StartGestureWithPlaybackRate(ACT_DOTA_TAUNT, 1)
end

modifier_tangin_iron_curtain = class({
    IsHidden                = function(self) return false end,
    IsPurgable              = function(self) return false end,
    IsDebuff                = function(self) return false end,
    IsBuff                  = function(self) return true end,
    RemoveOnDeath           = function(self) return false end,
    DeclareFunctions        = function(self) return 
        {
            MODIFIER_PROPERTY_STATUS_RESISTANCE,
            MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
            MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
            MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
        } end,

})

function modifier_tangin_iron_curtain:GetStatusEffectName()
    return "particles/econ/items/effigies/status_fx_effigies/status_effect_statue_compendium_2014_radiant.vpcf"
end

function modifier_tangin_iron_curtain:StatusEffectPriority()
    return 100
end

function modifier_tangin_iron_curtain:GetActivityTranslationModifiers()
    return "ck_gesture"
end

function modifier_tangin_iron_curtain:GetModifierHealthRegenPercentage()
    return self:GetAbility():GetSpecialValueFor("bonus_regen")
end

function modifier_tangin_iron_curtain:GetModifierPhysicalArmorBonus()
    return self:GetAbility():GetSpecialValueFor("bonus_armor")
end

function modifier_tangin_iron_curtain:GetModifierStatusResistance()
    return self:GetAbility():GetSpecialValueFor("bonus_resist")
end
