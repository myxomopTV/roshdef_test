LinkLuaModifier("modifier_drow_ranger_marksmanship_custom", "heroes/hero_drow_ranger/marksmanship_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_drow_ranger_marksmanship_custom_debuff", "heroes/hero_drow_ranger/marksmanship_custom", LUA_MODIFIER_MOTION_NONE)


drow_ranger_marksmanship_custom = class({})

function drow_ranger_marksmanship_custom:GetIntrinsicModifierName()
    return "modifier_drow_ranger_marksmanship_custom"
end

modifier_drow_ranger_marksmanship_custom = class({
    IsHidden                = function(self) return true end,
    IsPurgable              = function(self) return false end,
    IsDebuff                = function(self) return false end,
    IsBuff                  = function(self) return true end,
    RemoveOnDeath           = function(self) return false end,
    DeclareFunctions        = function(self) return 
        {
            MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_PHYSICAL,
            MODIFIER_EVENT_ON_ATTACK_START,
            MODIFIER_EVENT_ON_ATTACK_LANDED,

        } end,
})

function modifier_drow_ranger_marksmanship_custom:CheckState()
    local state = {}
    if self.strike > 0 then
        state[MODIFIER_STATE_CANNOT_MISS] = true
    end 
    return state   
end

function modifier_drow_ranger_marksmanship_custom:OnCreated(table)
    if IsServer() then
        local caster = self:GetCaster()
        self.strike = 0
        self.original_projectile = caster:GetRangedProjectileName()
        self.marksmanship_projectile = "particles/units/heroes/hero_drow/drow_marksmanship_attack.vpcf"
    end
end

function modifier_drow_ranger_marksmanship_custom:GetModifierProcAttack_BonusDamage_Physical()
    if self.strike > 0 then
        return self:GetAbility():GetSpecialValueFor("bonus_damage")
    else
        return 0
    end   
end

function modifier_drow_ranger_marksmanship_custom:OnAttackStart(params)
    if not IsServer() then return end
    local attacker = params.attacker
    local caster = self:GetCaster()
    local ability = self:GetAbility()
    local trigger_chance = ability:GetSpecialValueFor("trigger_chance")
    
    if attacker == caster  then
        if RollPercentage(trigger_chance) then
            self.strike = self.strike + 1
            caster:SetRangedProjectileName(self.marksmanship_projectile)
        else
--            self.strike = false
            caster:SetRangedProjectileName(self.original_projectile)
        end
    end
end

function modifier_drow_ranger_marksmanship_custom:OnAttackLanded(params)
    if not IsServer() then return end
    local attacker = params.attacker
    local target = params.target
    local caster = self:GetCaster()
    local ability = self:GetAbility()
    
    if attacker == caster and target then
        if self.strike > 0 then
            target:AddNewModifier(caster, ability, "modifier_drow_ranger_marksmanship_custom_debuff", {Duration = 0.01})
            self.strike = self.strike - 1
        end
    end
end


modifier_drow_ranger_marksmanship_custom_debuff = class({
    IsHidden                = function(self) return true end,
    IsPurgable              = function(self) return false end,
    IsDebuff                = function(self) return false end,
    IsBuff                  = function(self) return true end,
    RemoveOnDeath           = function(self) return false end,
    DeclareFunctions        = function(self) return 
        {
            MODIFIER_PROPERTY_IGNORE_PHYSICAL_ARMOR,
        } end,
})

function modifier_drow_ranger_marksmanship_custom_debuff:GetModifierIgnorePhysicalArmor()
    return 1  
end
