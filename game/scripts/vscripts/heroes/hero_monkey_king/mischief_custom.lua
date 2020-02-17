LinkLuaModifier("modifier_monkey_king_mischief_custom", "heroes/hero_monkey_king/mischief_custom", LUA_MODIFIER_MOTION_NONE)

monkey_king_mischief_custom = class({})

function monkey_king_mischief_custom:GetIntrinsicModifierName()
    return "modifier_monkey_king_mischief_custom"
end

modifier_monkey_king_mischief_custom = class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
    DeclareFunctions        = function(self) return 
        {
            MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE,
            MODIFIER_EVENT_ON_ATTACK_LANDED,
         } end,
})
function modifier_monkey_king_mischief_custom:GetModifierPreAttack_CriticalStrike( )
    if IsServer() then
        local ability = self:GetAbility()
        local crit_chance = ability:GetSpecialValueFor("crit_chance")
        local crit_multiplier = ability:GetSpecialValueFor("crit_multiplier")

        if RollPercentage(crit_chance) then
            return crit_multiplier
        end
    end
end

function modifier_monkey_king_mischief_custom:OnAttackLanded( params )
    if IsServer() then
        local ability = self:GetAbility()
        local caster = self:GetCaster()
        local dodge_chance = ability:GetSpecialValueFor("dodge_chance")

        if RollPercentage(dodge_chance) and params.target == caster and ( not caster:IsIllusion() ) and ability:IsCooldownReady() then
            if self:GetParent():PassivesDisabled() then
                return 0
            end

            caster:AddNewModifier(caster, ability, "modifier_monkey_king_transform", {duration = 0.1})
            caster:AddNewModifier(caster, ability, "modifier_invulnerable", {duration = 0.1})
            ability:UseResources(true, false, true)
        end
    end

    return 0
end