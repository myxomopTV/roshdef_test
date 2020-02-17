LinkLuaModifier("modifier_tangin_crit_strike", "heroes/hero_tangin/crit_strike", LUA_MODIFIER_MOTION_NONE)


tangin_crit_strike = class({})

function tangin_crit_strike:GetIntrinsicModifierName()
    return "modifier_tangin_crit_strike"
end

modifier_tangin_crit_strike = class({
    IsHidden                = function(self) return true end,
    IsPurgable              = function(self) return false end,
    IsDebuff                = function(self) return false end,
    IsBuff                  = function(self) return true end,
    RemoveOnDeath           = function(self) return false end,
    DeclareFunctions        = function(self) return 
        {
            MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE,
--            MODIFIER_EVENT_ON_TAKEDAMAGE,
        } end,

})

function modifier_tangin_crit_strike:OnCreated()
    if IsServer() then
        self:StartIntervalThink(0.1)
    end
end

function modifier_tangin_crit_strike:OnIntervalThink()
    local caster = self:GetCaster()
    local ability = self:GetAbility()
    local base_crit = ability:GetSpecialValueFor("base_crit")
    local str_crit = caster:GetStrength() * ability:GetSpecialValueFor("str_crit")
    self:SetStackCount(base_crit + str_crit)
end

function modifier_tangin_crit_strike:GetModifierPreAttack_CriticalStrike()
    local trigger_chance = self:GetAbility():GetSpecialValueFor("trigger_chance")
    if RollPercentage(trigger_chance) then
        return self:GetStackCount()
    end
    return
end

function modifier_tangin_crit_strike:OnTakeDamage( params )
    if IsServer() then
        local parent = self:GetParent()
        local Target = params.unit
        local Attacker = params.attacker
        local Ability = params.inflictor
        local flDamage = params.damage
        local lifesteal_pct = self:GetAbility():GetSpecialValueFor("lifesteal_pct")
        
        if self.crit and Attacker ~= nil and Attacker == parent and Target ~= nil and not Target:IsBuilding() and Ability == nil then

            local heal =  flDamage * lifesteal_pct / 100 
            parent:Heal( heal, self:GetAbility() )
            local nFXIndex = ParticleManager:CreateParticle( "particles/generic_gameplay/generic_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, parent )
            ParticleManager:ReleaseParticleIndex( nFXIndex )

        end
    end
    return 0
end