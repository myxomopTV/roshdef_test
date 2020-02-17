
LinkLuaModifier('modifier_event_ice_shard', 'abilities/event/ice_shard', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier('modifier_event_ice_shard_aura', 'abilities/event/ice_shard', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier('modifier_event_ice_shard_movespeed_slow', 'abilities/event/ice_shard', LUA_MODIFIER_MOTION_NONE)
event_ice_shard = class({})

function event_ice_shard:GetAOERadius()
  return self:GetSpecialValueFor("radius")
end

function event_ice_shard:GetCastRange()
  return self:GetSpecialValueFor("cast_range")
end

function event_ice_shard:OnSpellStart()
    local caster = self:GetCaster()
    local ability = self
    local point = ability:GetCursorPosition()
    local length = #(point - caster:GetOrigin())
    local duration = self:GetSpecialValueFor("duration")
    local radius = self:GetSpecialValueFor("radius")
    local hullRadius = 70

    AddFOWViewer(caster:GetTeamNumber(), point, radius, duration, false)
    local normal = (RotatePosition(Vector(0,0,0), QAngle(0,40,0), caster:GetForwardVector()) * length):Normalized()
    local p = point + normal*(radius/2)
    local modelDummy = CreateUnitByName("npc_dummy_unit", p, false, nil, nil, caster:GetTeamNumber())
    modelDummy.event = true
    modelDummy:SetAbsOrigin(GetGroundPosition(modelDummy:GetAbsOrigin(), modelDummy))
    modelDummy:SetOriginalModel("models/particle/ice_shards.vmdl")
    modelDummy:SetModel("models/particle/ice_shards.vmdl")
    modelDummy:SetModelScale(11)
    modelDummy:AddNewModifier(caster, ability, 'modifier_event_ice_shard',{duration = duration})
    
    modelDummy:SetAbsOrigin(GetGroundPosition(p, modelDummy))
    modelDummy.particle = ParticleManager:CreateParticle("particles/units/heroes/hero_tusk/tusk_ice_shards_projectile_crystal.vpcf",  PATTACH_POINT, self:GetCaster())
    ParticleManager:SetParticleControl(modelDummy.particle, 3,modelDummy:GetAbsOrigin())
    -- modelDummy:SetForwardVector(point - p)
    -- Если захочешь, что бы при создании все существа в радиусе hullRadius отошли от глыб
    -- modelDummy:SetHullRadius(hullRadius)
    -- for _,v in ipairs(FindUnitsInRadius(caster:GetTeamNumber(), modelDummy:GetAbsOrigin(), nil, hullRadius, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)) do
    --  FindClearSpaceForUnit(v, v:GetAbsOrigin(), true)
    -- end
    Timers:CreateTimer(duration, function()
      ParticleManager:DestroyParticle(modelDummy.particle, true)
      UTIL_Remove(modelDummy)
    end)
    local thinker = CreateModifierThinker(caster, self, 'modifier_event_ice_shard_aura', {
      duration = duration
    }, point, caster:GetTeam(), false)
    thinker.event = true

end

modifier_event_ice_shard = class({
    IsHidden                = function(self) return true end,
    IsPurgable              = function(self) return false end,
    IsDebuff                = function(self) return false end,
    IsBuff                  = function(self) return true end,
    RemoveOnDeath           = function(self) return true end,
    IsPermanent       = function(self) return true end,
    CheckState        = function(self) return {
      [MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
      [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
        [MODIFIER_STATE_MAGIC_IMMUNE] = true,
        [MODIFIER_STATE_ATTACK_IMMUNE] = true,
        [MODIFIER_STATE_INVULNERABLE] = true,
        [MODIFIER_STATE_UNSELECTABLE] = true,
        [MODIFIER_STATE_ROOTED] = true,
        [MODIFIER_STATE_NO_HEALTH_BAR] = true,
    }  end,
})

modifier_event_ice_shard_aura = class({
  IsHidden        = function(self) return true end,
  IsPurgable        = function(self) return false end,
  IsDebuff        = function(self) return true end,
  IsBuff                  = function(self) return false end,
  RemoveOnDeath       = function(self) return false end,
  AllowIllusionDuplicate  = function(self) return true end,
  IsPermanent             = function(self) return true end,
  IsAura          = function(self) return true end,
  GetAuraRadius       = function(self) return self:GetAbility():GetSpecialValueFor("radius") end,
  GetAuraSearchTeam     = function(self) return DOTA_UNIT_TARGET_TEAM_ENEMY end,
  GetAuraSearchFlags      = function(self) return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES end,
  GetAuraSearchType   = function(self) return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP end,
  GetModifierAura     = function(self) return 'modifier_event_ice_shard_movespeed_slow' end,
})

modifier_event_ice_shard_movespeed_slow = class({
    IsHidden                = function(self) return false end,
    IsPurgable              = function(self) return true end,
    IsDebuff                = function(self) return true end,
    IsBuff                  = function(self) return false end,
    RemoveOnDeath           = function(self) return true end,
    IsPermanent       = function(self) return false end,
    DeclareFunctions    = function(self) return {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE} end,
    GetModifierMoveSpeedBonus_Percentage  = function(self) return self:GetAbility():GetSpecialValueFor("speed_reduction")*(-1) end,
})

function modifier_event_ice_shard_movespeed_slow:OnCreated()
  local ability = self:GetAbility()
  local interval = ability:GetSpecialValueFor("interval")
  self:StartIntervalThink(interval)
end

function modifier_event_ice_shard_movespeed_slow:OnIntervalThink()
  local caster = self:GetCaster()
  local parent = self:GetParent()
  local ability = self:GetAbility()
  local damage = ability:GetSpecialValueFor("damage")

  DealDamage(caster, parent, damage, ability:GetAbilityDamageType(), DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION, ability)
end