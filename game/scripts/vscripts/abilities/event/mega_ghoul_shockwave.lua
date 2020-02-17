LinkLuaModifier("modifier_mega_ghoul_shockwave", "abilities/event/mega_ghoul_shockwave", LUA_MODIFIER_MOTION_NONE)

mega_ghoul_shockwave = class({})

function mega_ghoul_shockwave:GetIntrinsicModifierName()
	return "modifier_mega_ghoul_shockwave"
end

function mega_ghoul_shockwave:OnProjectileHit( hTarget, vLocation )
  if hTarget ~= nil then
    local caster = self:GetCaster()
    local damage = self:GetSpecialValueFor("damage")

    DealDamage(caster, hTarget, damage, self:GetAbilityDamageType(), DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION, self)
  end
end

modifier_mega_ghoul_shockwave = class({
  IsHidden = function(self) return true end,
})

function modifier_mega_ghoul_shockwave:OnCreated()
    if IsServer() then
      self:GetCaster():SetRenderColor(0, 0, 128)
      local ability = self:GetAbility()
      local wave_interval = ability:GetSpecialValueFor("wave_interval")

      self:StartIntervalThink(wave_interval)
    end
end

function modifier_mega_ghoul_shockwave:OnIntervalThink()
    local caster = self:GetCaster()
    local ability = self:GetAbility()
    local point = caster:GetAbsOrigin()
    local radius = ability:GetSpecialValueFor("radius")
    local enemies = caster:FindEnemyUnitsInRadius(point, radius, nil)

    for _,enemy in pairs(enemies) do
      local vDirection = (enemy:GetAbsOrigin() - self:GetCaster():GetOrigin()):Normalized()
      EmitSoundOn("Hero_Magnataur.ShockWave.Particle", caster)

      local particle = "particles/units/heroes/hero_magnataur/magnataur_shockwave.vpcf"

      ProjectileManager:CreateLinearProjectile({
        EffectName = particle,
        Ability = ability,
        vSpawnOrigin = point,
        fStartRadius = ability:GetSpecialValueFor("wave_width_initial"),
        fEndRadius = ability:GetSpecialValueFor("wave_width_end"),
        vVelocity = vDirection * ability:GetSpecialValueFor("wave_speed"),
        fDistance = ability:GetSpecialValueFor("wave_distance"),
        Source = ability:GetCaster(),
        iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
        iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
      --      iUnitTargetFlags = ability:GetAbilityTargetFlags(),
        bProvidesVision = true,
        iVisionTeamNumber = ability:GetCaster():GetTeamNumber(),
        iVisionRadius = ability:GetSpecialValueFor("wave_width_end"),
      })
    end
end

