LinkLuaModifier("modifier_demon_power_strike", "heroes/hero_demon/power_strike", LUA_MODIFIER_MOTION_NONE)


demon_power_strike = class({})

function demon_power_strike:GetIntrinsicModifierName()
    return "modifier_demon_power_strike"
end

modifier_demon_power_strike = class({
    IsHidden                = function(self) return true end,
    IsPurgable              = function(self) return false end,
    IsDebuff                = function(self) return false end,
    IsBuff                  = function(self) return true end,
    RemoveOnDeath           = function(self) return false end,
    DeclareFunctions        = function(self) return 
        {
            MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE,
            MODIFIER_EVENT_ON_TAKEDAMAGE,
        } end,

})

function modifier_demon_power_strike:GetModifierPreAttack_CriticalStrike()
    local ability = self:GetAbility()
    local trigger_chance = ability:GetSpecialValueFor("trigger_chance")
    local caster = self:GetCaster()
    local soul_modifier_count = caster:FindModifierByName("modifier_demon_soul_collector"):GetStackCount()
    local soul_crit_mult = ability:GetSpecialValueFor("crit_mult_per_soul") * soul_modifier_count
    local crit_mult = ability:GetSpecialValueFor("crit_mult") + soul_crit_mult

    if RollPercentage(trigger_chance) then
        self.crit = true
        return crit_mult
    else
        self.crit = false
        return
    end
end

function modifier_demon_power_strike:OnTakeDamage( params )
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