
event_shockwave = class({})

function event_shockwave:GetCastRange()
	return self:GetSpecialValueFor("wave_distance")
end

function event_shockwave:OnSpellStart()
   local vDirection = (self:GetCursorPosition() - self:GetCaster():GetOrigin()):Normalized()
	 local caster = self:GetCaster()
	
    local particle = "particles/units/heroes/hero_magnataur/magnataur_shockwave.vpcf"

    ProjectileManager:CreateLinearProjectile({
      EffectName = particle,
      Ability = self,
      vSpawnOrigin = self:GetCaster():GetOrigin(),
      fStartRadius = self:GetSpecialValueFor("wave_width_initial"),
      fEndRadius = self:GetSpecialValueFor("wave_width_end"),
      vVelocity = vDirection * self:GetSpecialValueFor("wave_speed"),
      fDistance = self:GetSpecialValueFor("wave_distance"),
      Source = self:GetCaster(),
      iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
      iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
--      iUnitTargetFlags = self:GetAbilityTargetFlags(),
      bProvidesVision = true,
      iVisionTeamNumber = self:GetCaster():GetTeamNumber(),
      iVisionRadius = self:GetSpecialValueFor("wave_width_end"),
    })
--    EmitSoundOn("Hero_DragonKnight.BreathFire", self:GetCaster())
end

function event_shockwave:OnProjectileHit( hTarget, vLocation )
	if hTarget ~= nil then
		local caster = self:GetCaster()
		local damage = self:GetSpecialValueFor("damage")

		PopupCriticalDamage(hTarget, self.wave_damage)
		DealDamage(caster, hTarget, damage, self:GetAbilityDamageType(), DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION, self)

	end
end
