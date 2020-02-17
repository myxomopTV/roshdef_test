LinkLuaModifier("modifier_monkey_king_jingu_mastery_custom", "heroes/hero_monkey_king/jingu_mastery_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_monkey_king_jingu_mastery_custom_buff", "heroes/hero_monkey_king/jingu_mastery_custom", LUA_MODIFIER_MOTION_NONE)

monkey_king_jingu_mastery_custom = class({})

function monkey_king_jingu_mastery_custom:GetIntrinsicModifierName()
    return "modifier_monkey_king_jingu_mastery_custom"
end

modifier_monkey_king_jingu_mastery_custom = class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
    DeclareFunctions        = function(self) return 
        {
        MODIFIER_EVENT_ON_ATTACK,
        MODIFIER_EVENT_ON_ATTACK_LANDED,
        } end,
})

function modifier_monkey_king_jingu_mastery_custom:OnAttackLanded( params )
    if IsServer() then
        local caster = self:GetCaster()
        if not caster:HasModifier("modifier_monkey_king_boundless_strike_custom") and params.attacker == caster and ( not caster:IsIllusion() ) then
            if self:GetParent():PassivesDisabled() then
                return 0
            end
--            caster:RemoveModifierByName("modifier_monkey_king_jingu_mastery_custom_buff")
 
            local target = params.target
            local ability = self:GetAbility()
            local trigger_chance = ability:GetSpecialValueFor("trigger_chance")
            caster:RemoveModifierByName("modifier_monkey_king_jingu_mastery_custom_buff")

            if RollPercentage(trigger_chance) and target ~= nil and target:GetTeamNumber() ~= self:GetParent():GetTeamNumber() and not target:IsBuilding() then
                EmitSoundOn("Hero_MonkeyKing.IronCudgel", caster)
                caster:AddNewModifier(caster, ability, "modifier_monkey_king_jingu_mastery_custom_buff", nil)
            end
        end
    end

    return 0
end

modifier_monkey_king_jingu_mastery_custom_buff = class({
    IsHidden                = function(self) return false end,
    IsPurgable              = function(self) return false end,
    IsDebuff                = function(self) return false end,
    IsBuff                  = function(self) return true end,
    RemoveOnDeath           = function(self) return false end,
    DeclareFunctions        = function(self) return 
        {
            MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
            MODIFIER_EVENT_ON_TAKEDAMAGE,
        } end,

})

function modifier_monkey_king_jingu_mastery_custom_buff:GetEffectName()
    return "particles/units/heroes/hero_monkey_king/monkey_king_quad_tap_overhead.vpcf"
end

function modifier_monkey_king_jingu_mastery_custom_buff:GetEffectAttachType()
    return PATTACH_OVERHEAD_FOLLOW
end

function modifier_monkey_king_jingu_mastery_custom_buff:GetModifierPreAttack_BonusDamage()
    return self:GetAbility():GetSpecialValueFor("bonus_dmg")
end

function modifier_monkey_king_jingu_mastery_custom_buff:OnTakeDamage( params )
    if IsServer() then
        local parent = self:GetParent()
        local Target = params.unit
        local Attacker = params.attacker
        local Ability = params.inflictor
        local flDamage = params.damage
        local lifesteal_pct = self:GetAbility():GetSpecialValueFor("lifesteal_pct")
        
        if Attacker ~= nil and Attacker == parent and Target ~= nil and not Target:IsBuilding() and Ability == nil then

            local heal =  flDamage * lifesteal_pct / 100 
            parent:Heal( heal, self:GetAbility() )
            local nFXIndex = ParticleManager:CreateParticle( "particles/generic_gameplay/generic_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, parent )
            ParticleManager:ReleaseParticleIndex( nFXIndex )

        end
    end
    return 0
end