LinkLuaModifier("modifier_monkey_king_immortal_secret", "heroes/hero_monkey_king/immortal_secret", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_monkey_king_immortal_secret_passive", "heroes/hero_monkey_king/immortal_secret", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_monkey_king_immortal_secret_buff", "heroes/hero_monkey_king/immortal_secret", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_monkey_king_immortal_secret_cooldown", "heroes/hero_monkey_king/immortal_secret", LUA_MODIFIER_MOTION_NONE)

monkey_king_immortal_secret = class({})

function monkey_king_immortal_secret:GetIntrinsicModifierName()
    return "modifier_monkey_king_immortal_secret_passive"
end

function monkey_king_immortal_secret:OnSpellStart()
	local caster = self:GetCaster()
    local hit_count = self:GetSpecialValueFor("hit_count")

	local modifier = caster:AddNewModifier(caster, self, "modifier_monkey_king_immortal_secret_buff", nil)
    modifier:SetStackCount(hit_count)
end

modifier_monkey_king_immortal_secret_buff = class({
	IsHidden 				= function(self) return false end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
    DeclareFunctions        = function(self) return 
        {
           MODIFIER_EVENT_ON_ATTACK_START,
           MODIFIER_EVENT_ON_ATTACK_LANDED,
           MODIFIER_PROPERTY_MODEL_SCALE,
        } end,
})


function modifier_monkey_king_immortal_secret_buff:OnAttackStart( params )
    if IsServer() then
        local caster = self:GetCaster()
        local target = params.target
        if params.attacker == caster and ( not caster:IsIllusion() ) then
 
            if not caster:HasModifier("modifier_monkey_king_boundless_strike_custom") and  target ~= nil and target:GetTeamNumber() ~= self:GetParent():GetTeamNumber() and not target:IsBuilding() and not target:IsMagicImmune() then
                local strike_ability = caster:FindAbilityByName("monkey_king_boundless_strike_custom")
                print("111")
                if strike_ability and strike_ability:GetLevel() > 0 then
                    print("222")
                    caster:SetCursorPosition(target:GetAbsOrigin())
                    strike_ability:OnAbilityPhaseStart()
                end
            end
        end
    end

    return 0
end
function modifier_monkey_king_immortal_secret_buff:OnAttackLanded( params )
    if IsServer() then
        local caster = self:GetCaster()
        local target = params.target
        if params.attacker == caster and ( not caster:IsIllusion() ) then
 
            if not caster:HasModifier("modifier_monkey_king_boundless_strike_custom") and  target ~= nil and target:GetTeamNumber() ~= self:GetParent():GetTeamNumber() and not target:IsBuilding() and not target:IsMagicImmune() then
                local strike_ability = caster:FindAbilityByName("monkey_king_boundless_strike_custom")
                print("111")
                if strike_ability and strike_ability:GetLevel() > 0 then
                    print("222")
                    caster:SetCursorPosition(target:GetAbsOrigin())                        
                    strike_ability:OnSpellStart()
 
                    local stack_count = self:GetStackCount()
                    if stack_count > 1 then
                        self:DecrementStackCount()
                    else
                        self:Destroy()
                    end
                end
            end
        end
    end

    return 0
end

function modifier_monkey_king_immortal_secret_buff:GetModifierModelScale()
    return self:GetAbility():GetSpecialValueFor("bonus_scale")*self:GetStackCount()
end

modifier_monkey_king_immortal_secret_passive = class({
    IsHidden                = function(self) return true end,
    IsPurgable              = function(self) return false end,
    IsDebuff                = function(self) return false end,
    IsBuff                  = function(self) return true end,
    RemoveOnDeath           = function(self) return false end,
    DeclareFunctions        = function(self) return 
        {
            MODIFIER_PROPERTY_MIN_HEALTH,
            MODIFIER_EVENT_ON_TAKEDAMAGE
        } end,

})
function modifier_monkey_king_immortal_secret_passive:GetMinHealth()
    if self:GetCaster():HasModifier("modifier_monkey_king_immortal_secret_cooldown") or not self:GetCaster():IsRealHero() then
        return nil
    else
        return 1
    end

end

function modifier_monkey_king_immortal_secret_passive:OnTakeDamage( keys )
    if not  IsServer() then
        return
    end
    if keys.unit ~= self:GetCaster() then
        return
    end
    if self:GetCaster():FindModifierByName("modifier_monkey_king_immortal_secret_cooldown") then
        return
    end

    if self:GetCaster():GetHealth() <= 1 then
        local caster = self:GetCaster()
        local ability = self:GetAbility()
        local immortal_duration = ability:GetSpecialValueFor("immortal_duration")
        local immortal_cooldown = ability:GetSpecialValueFor("immortal_cooldown")
        
        caster:AddNewModifier(caster, ability, "modifier_monkey_king_immortal_secret", { duration = immortal_duration})
        caster:AddNewModifier(caster, ability, "modifier_monkey_king_immortal_secret_cooldown", { duration = immortal_cooldown})
   
    end
end

modifier_monkey_king_immortal_secret = class({
    IsHidden                = function(self) return false end,
    IsPurgable              = function(self) return false end,
    IsDebuff                = function(self) return false end,
    IsBuff                  = function(self) return true end,
    RemoveOnDeath           = function(self) return false end,
    DeclareFunctions        = function(self) return 
        {
            MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
        } end,
    CheckState      = function(self) return 
        {
            [MODIFIER_STATE_NO_HEALTH_BAR] = true,          
            [MODIFIER_STATE_INVULNERABLE] = true, 
        } end,
})

function modifier_monkey_king_immortal_secret:GetModifierHealthRegenPercentage()
    return self:GetAbility():GetSpecialValueFor("immortal_regen_pct")
end

function modifier_monkey_king_immortal_secret:GetEffectName()
    return "particles/econ/items/wraith_king/wraith_king_ti6_bracer/wraith_king_ti6_hellfireblast_debuff.vpcf"
end

modifier_monkey_king_immortal_secret_cooldown = class({
    IsHidden                = function(self) return false end,
    IsPurgable              = function(self) return false end,
    IsDebuff                = function(self) return true end,
    IsBuff                  = function(self) return false end,
    RemoveOnDeath           = function(self) return false end,
})