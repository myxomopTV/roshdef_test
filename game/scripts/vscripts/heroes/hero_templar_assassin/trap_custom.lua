LinkLuaModifier("modifier_templar_assassin_trap_custom", "heroes/hero_templar_assassin/trap_custom", LUA_MODIFIER_MOTION_NONE)


templar_assassin_trap_custom = class({})

function templar_assassin_trap_custom:OnSpellStart()
    local caster = self:GetCaster()
    local player = caster:GetPlayerID()
    local point = caster:GetAbsOrigin()
    local team = caster:GetTeamNumber()
--    local trap_duration = self:GetSpecialValueFor("trap_duration")

    if caster.trap and IsValidEntity(caster.trap) and caster.trap:IsAlive() then
        caster.trap:ForceKill(false)
    end

    caster.trap = CreateUnitByName("npc_dota_templar_assassin_trap", point, false, caster, caster, team)
    caster.trap:SetControllableByPlayer(player, true)
    caster.trap:SetUnitCanRespawn(true)
--    caster.trap:AddNewModifier(caster, self, "modifier_kill", {duration = trap_duration})
    caster.trap:AddNewModifier(caster, self, "modifier_templar_assassin_trap_custom", nil)
end

modifier_templar_assassin_trap_custom = class({
    IsHidden                = function(self) return true end,
    IsPurgable              = function(self) return false end,
    IsDebuff                = function(self) return false end,
    IsBuff                  = function(self) return true end,
    RemoveOnDeath           = function(self) return true end,
    CheckState      = function(self) return 
        {
--            [MODIFIER_STATE_UNSELECTABLE] = true,
            [MODIFIER_STATE_INVULNERABLE] = true,
            [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
            [MODIFIER_STATE_NO_HEALTH_BAR] = true,
--            [MODIFIER_STATE_BLIND] = true,
            [MODIFIER_STATE_ROOTED] = true,
        } end,
})
function modifier_templar_assassin_trap_custom:GetEffectName()
    return "particles/units/heroes/hero_templar_assassin/templar_assassin_trap_portrait.vpcf"
end

templar_assassin_trap_custom_active = class({})

function templar_assassin_trap_custom_active:OnSpellStart()
    local caster = self:GetCaster()
    local point = caster:GetAbsOrigin()
    local player_hero = caster:GetOwner()
    local trap = player_hero.trap

    local effect = "particles/econ/items/lanaya/lanaya_epit_trap/templar_assassin_epit_trap_explode.vpcf"
    local pfx = ParticleManager:CreateParticle(effect, PATTACH_WORLDORIGIN, nil)
    ParticleManager:SetParticleControl(pfx, 0, point) -- Origin
    ParticleManager:SetParticleControl(pfx, 1, point) -- Origin
    ParticleManager:ReleaseParticleIndex(pfx)
    
    EmitSoundOn("Hero_TemplarAssassin.Trap.Explode", trap)

    trap:ForceKill(false)
    trap:AddEffects(EF_NODRAW)

    if player_hero:IsAlive() then
        player_hero:SetAbsOrigin(point)
        player_hero.trap = nil
    end

end
