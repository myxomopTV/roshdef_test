LinkLuaModifier("modifier_templar_assassin_refraction_custom", "heroes/hero_templar_assassin/refraction_custom", LUA_MODIFIER_MOTION_NONE)


templar_assassin_refraction_custom = class({})

function templar_assassin_refraction_custom:OnSpellStart()
    local caster = self:GetCaster()
    local buff_duration = self:GetSpecialValueFor("buff_duration")
    caster:AddNewModifier(caster, self, "modifier_templar_assassin_refraction_custom", {duration = buff_duration})

end

modifier_templar_assassin_refraction_custom = class({
    IsHidden                = function(self) return false end,
    IsPurgable              = function(self) return false end,
    IsDebuff                = function(self) return false end,
    IsBuff                  = function(self) return true end,
    RemoveOnDeath           = function(self) return false end,
    DeclareFunctions        = function(self) return 
        {
            MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,
            MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
            MODIFIER_EVENT_ON_ATTACK_LANDED
        } end,

})
function modifier_templar_assassin_refraction_custom:OnCreated(table)
     if IsServer() then
        local nfx = ParticleManager:CreateParticle("particles/units/heroes/hero_templar_assassin/templar_assassin_refraction.vpcf", PATTACH_POINT_FOLLOW, self:GetCaster())
        ParticleManager:SetParticleControlEnt(nfx, 1, self:GetCaster(), PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self:GetCaster():GetAbsOrigin(), false)
        self:AddEffect(nfx)
    end
end
function modifier_templar_assassin_refraction_custom:OnAttackLanded(params)
    if IsServer() then
        if params.attacker == self:GetParent() then
            EmitSoundOn("Hero_TemplarAssassin.Refraction.Damage", params.target)
        elseif params.target == self:GetParent() then
            EmitSoundOn("Hero_TemplarAssassin.Refraction.Absorb", self:GetParent())
        end
    end
end

function modifier_templar_assassin_refraction_custom:GetModifierBaseDamageOutgoing_Percentage()
    return self:GetAbility():GetSpecialValueFor("bonus_dmg")
end

function modifier_templar_assassin_refraction_custom:GetModifierIncomingDamage_Percentage()
    return self:GetAbility():GetSpecialValueFor("bonus_resist")*(-1)
end