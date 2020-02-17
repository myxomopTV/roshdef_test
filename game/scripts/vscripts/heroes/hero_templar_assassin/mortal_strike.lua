LinkLuaModifier("modifier_templar_assassin_mortal_strike", "heroes/hero_templar_assassin/mortal_strike", LUA_MODIFIER_MOTION_NONE)


templar_assassin_mortal_strike = class({})

function templar_assassin_mortal_strike:GetIntrinsicModifierName()
    return "modifier_templar_assassin_mortal_strike"
end

modifier_templar_assassin_mortal_strike = class({
    IsHidden                = function(self) return false end,
    IsPurgable              = function(self) return false end,
    IsDebuff                = function(self) return false end,
    IsBuff                  = function(self) return true end,
    RemoveOnDeath           = function(self) return false end,
    DeclareFunctions        = function(self) return 
        {   MODIFIER_EVENT_ON_DEATH,
            MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE,
--            MODIFIER_EVENT_ON_TAKEDAMAGE,
        } end,

})

function modifier_templar_assassin_mortal_strike:OnDeath(data)
    if IsServer() then
        local parent = self:GetParent()
        local killer = data.attacker
        local killed_unit = data.unit
        
        if killer == parent and killed_unit:GetTeam() ~= killer:GetTeam() then
            if killer:IsRealHero() == false then
                killer = killer:GetPlayerOwner():GetAssignedHero()
            end
            self:IncrementStackCount()
           
            local effect = "particles/units/heroes/hero_pudge/pudge_fleshheap_count.vpcf"
            local pfx = ParticleManager:CreateParticle(effect, PATTACH_ABSORIGIN_FOLLOW, killer)
            ParticleManager:ReleaseParticleIndex(pfx)
        end
    end
end
function modifier_templar_assassin_mortal_strike:GetModifierPreAttack_CriticalStrike()
    local ability = self:GetAbility()
    local trigger_chance = ability:GetSpecialValueFor("trigger_chance")
    local caster = self:GetCaster()
    local stack_crit_mult = ability:GetSpecialValueFor("stack_crit_mult") * self:GetStackCount()
    local crit_mult = ability:GetSpecialValueFor("crit_mult") + stack_crit_mult

    if RollPercentage(trigger_chance) then
        self.crit = true
        return crit_mult
    else
        self.crit = false
        return
    end
end

function modifier_templar_assassin_mortal_strike:OnTakeDamage( params )
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