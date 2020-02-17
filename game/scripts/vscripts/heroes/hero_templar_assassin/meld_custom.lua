LinkLuaModifier("modifier_templar_assassin_meld_custom", "heroes/hero_templar_assassin/meld_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_templar_assassin_meld_custom_debuff", "heroes/hero_templar_assassin/meld_custom", LUA_MODIFIER_MOTION_NONE)


templar_assassin_meld_custom = class({})

function templar_assassin_meld_custom:GetIntrinsicModifierName()
    return "modifier_templar_assassin_meld_custom"
end

modifier_templar_assassin_meld_custom = class({
    IsHidden                = function(self) return true end,
    IsPurgable              = function(self) return false end,
    IsDebuff                = function(self) return false end,
    IsBuff                  = function(self) return true end,
    RemoveOnDeath           = function(self) return false end,
    DeclareFunctions        = function(self) return 
        {
            MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
            MODIFIER_EVENT_ON_ATTACK_LANDED,
--            MODIFIER_EVENT_ON_ATTACK,

        } end,
})

function modifier_templar_assassin_meld_custom:OnCreated(table)
    if IsServer() then
        self:StartIntervalThink(0.05)
        self:GetParent():SetProjectileModel("particles/units/heroes/hero_templar_assassin/templar_assassin_meld_attack.vpcf")
    end
end

function modifier_templar_assassin_meld_custom:OnIntervalThink()
    if IsServer() then
        if self:GetAbility():IsCooldownReady() then
            if not self.meld_ready then
                self.meld_ready = true
                self:GetParent():SetProjectileModel("particles/units/heroes/hero_templar_assassin/templar_assassin_meld_attack.vpcf")
            end
            local ability = self:GetAbility()
            local base_dmg = ability:GetSpecialValueFor("base_dmg")
            local agility_dmg = self:GetParent():GetAgility()*ability:GetSpecialValueFor("agility_dmg")
            self:SetStackCount(base_dmg + agility_dmg)
        else
            self:SetStackCount(0)
               self:GetParent():SetProjectileModel("particles/units/heroes/hero_templar_assassin/templar_assassin_base_attack.vpcf")
--             self:GetParent():RevertProjectile()
        end
    end
end

function modifier_templar_assassin_meld_custom:GetModifierPreAttack_BonusDamage()
    return self:GetStackCount()
end
function modifier_templar_assassin_meld_custom:OnAttack(params)
    if not IsServer() then return end
    local attacker = params.attacker
    local caster = self:GetCaster()
    local ability = self:GetAbility()
    
    if attacker == caster   then
        
        if self.meld_ready  then
            self.meld_attack = true
            if not caster.split == false then
                 ability:UseResources(true, true, true)
                self.meld_ready = false
           end            
        else
            self.meld_attack = false
        end
    end
end
--[[
function modifier_templar_assassin_meld_custom:OnAttackLanded(params)
    if IsServer() then
        if params.attacker == self:GetParent() and self.meld_attack then
            local ability = self:GetAbility()
            local debuff_duration = ability:GetSpecialValueFor("debuff_duration")
            EmitSoundOn("Hero_TemplarAssassin.Meld.Attack", params.target)
            local modifier = params.target:AddNewModifier(params.attacker, self:GetAbility(), "modifier_templar_assassin_meld_custom_debuff", {Duration = debuff_duration})
            modifier:IncrementStackCount()

       end
    end
end
]]

function modifier_templar_assassin_meld_custom:OnAttackLanded(params)
    if IsServer() then
        if params.attacker == self:GetParent() and self.meld_ready then
           local ability = self:GetAbility()
            local debuff_duration = ability:GetSpecialValueFor("debuff_duration")

            if not self:GetParent():HasModifier("modifier_item_special_ta_upgrade") then
                self.meld_ready = false
                ability:UseResources(true, true, true)
            end
                        
            local target = params.target
            if target:IsBuilding() then
                return
            end
            EmitSoundOn("Hero_TemplarAssassin.Meld.Attack", target)
            local modifier = target:AddNewModifier(params.attacker, self:GetAbility(), "modifier_templar_assassin_meld_custom_debuff", {Duration = debuff_duration})
            modifier:IncrementStackCount()

       end
    end
end

function modifier_templar_assassin_meld_custom:GetEffectName()
    if self.meld_ready then
        return "particles/units/heroes/hero_templar_assassin/templar_assassin_meld.vpcf"
    else
        return
    end
end

modifier_templar_assassin_meld_custom_debuff = class({
    IsHidden                = function(self) return false end,
    IsPurgable              = function(self) return false end,
    IsDebuff                = function(self) return true end,
    IsBuff                  = function(self) return false end,
    RemoveOnDeath           = function(self) return true end,
    DeclareFunctions        = function(self) return 
        {
            MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
        } end,

})

function modifier_templar_assassin_meld_custom_debuff:GetModifierPhysicalArmorBonus()
    return self:GetStackCount()*self:GetAbility():GetSpecialValueFor("armor_decrease")*(-1)
end
function modifier_templar_assassin_meld_custom_debuff:OnCreated(table)
    if IsServer() then
        self.nfx = ParticleManager:CreateParticle("particles/units/heroes/hero_templar_assassin/templar_assassin_meld_armor.vpcf", PATTACH_POINT_FOLLOW, self:GetCaster())
        ParticleManager:SetParticleControlEnt(self.nfx, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
    end
end
function modifier_templar_assassin_meld_custom_debuff:OnRemoved()
    if IsServer() then
        ParticleManager:ClearParticle(self.nfx)
    end
end

function modifier_templar_assassin_meld_custom_debuff:GetEffectName()
    return "particles/units/heroes/hero_templar_assassin/templar_meld_overhead.vpcf"
end

function modifier_templar_assassin_meld_custom_debuff:GetEffectAttachType()
    return PATTACH_OVERHEAD_FOLLOW
end