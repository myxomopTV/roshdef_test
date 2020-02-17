LinkLuaModifier("modifier_tangin_sleep", "heroes/hero_tangin/sleep", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_tangin_sleep_debuff", "heroes/hero_tangin/sleep", LUA_MODIFIER_MOTION_NONE)


tangin_sleep = class({})

function tangin_sleep:OnSpellStart()
    local caster = self:GetCaster()
    local buff_duration = self:GetSpecialValueFor("buff_duration")

    EmitSoundOn("chaos_knight_chaknight_laugh_16", caster)

    caster:AddNewModifier(caster, self, "modifier_tangin_sleep", {duration = buff_duration})
end

modifier_tangin_sleep = class({
    IsHidden                = function(self) return false end,
    IsPurgable              = function(self) return false end,
    IsDebuff                = function(self) return false end,
    IsBuff                  = function(self) return true end,
    RemoveOnDeath           = function(self) return false end,
})

function modifier_tangin_sleep:OnDestroy()
    if IsServer() then
        local caster = self:GetCaster()
        local debuff_duration = self:GetSpecialValueFor("debuff_duration")
        EmitSoundOn("chaos_knight_chaknight_notyet_09", caster)

        caster:AddNewModifier(caster, self:GetAbility(), "modifier_tangin_sleep_debuff", {duration = 111111})
        Timers:CreateTimer(debuff_duration, function()
            caster:RemoveModifierByName("modifier_tangin_sleep_debuff")
         end)
    end
end

modifier_tangin_sleep_debuff = class({
    IsHidden                = function(self) return false end,
    IsPurgable              = function(self) return false end,
    IsDebuff                = function(self) return true end,
    IsBuff                  = function(self) return false end,
    RemoveOnDeath           = function(self) return false end,
    CheckState              = function(self) return
    {[MODIFIER_STATE_STUNNED] = true} end,

})

function modifier_tangin_sleep_debuff:GetEffectName()
    return "particles/generic_gameplay/generic_sleep.vpcf"
end

function modifier_tangin_sleep_debuff:GetEffectAttachType()
    return PATTACH_OVERHEAD_FOLLOW
end
