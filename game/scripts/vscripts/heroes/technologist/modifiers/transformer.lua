

if modifier_technologist_transformer == nil then
    modifier_technologist_transformer = class({})
end


LinkLuaModifier( "modifier_technologist_energized_failsafe", "heroes/technologist/modifiers/energy_system.lua", LUA_MODIFIER_MOTION_NONE )

function modifier_technologist_transformer:IsHidden()
    return false
end

function modifier_technologist_transformer:GetEffectName()
    return "particles/technologist/energized.vpcf"
end

function modifier_technologist_transformer:GetAttributes() 
    return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_technologist_transformer:DestroyOnExpire()
    return true
end

function modifier_technologist_transformer:OnCreated( event )
    if not IsServer() then return end

    local Target = self:GetParent()
    local Caster = self:GetCaster()
    local ability = self:GetAbility()
    local abilitylevel = ability:GetLevel()

    self.manaRegen = event.manaRegen
    --self:SetDuration(event.duration, true)

    --self:SetDuration(event.duration - (1/self.manaRegen), true)
    Caster:AddNewModifier(Caster, self:GetAbility(), "modifier_technologist_energized_failsafe", {duration = 10})
    self:StartIntervalThink(event.tickInterval)
end

function modifier_technologist_transformer:OnIntervalThink()
    if not IsServer() then return end
    local Caster = self:GetCaster()

    Caster:AddNewModifier(Caster, self:GetAbility(), "modifier_technologist_energized_failsafe", {duration = 10})

    local mod = Caster:FindModifierByName("modifier_technologist_energy")
    mod:ModifyStacks(1)
--    PopupNumbersFilter("energy",  Caster, 1, Caster )
end