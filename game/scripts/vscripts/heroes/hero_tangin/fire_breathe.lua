LinkLuaModifier("modifier_tangin_fire_breathe_debuff", "heroes/hero_tangin/fire_breathe", LUA_MODIFIER_MOTION_NONE)

tangin_fire_breathe = class({})

function tangin_fire_breathe:GetCastRange()
	return self:GetSpecialValueFor("wave_distance")
end
function tangin_fire_breathe:OnSpellStart()
   local vDirection = (self:GetCursorPosition() - self:GetCaster():GetOrigin()):Normalized()
	local caster = self:GetCaster()
	
    local particle = "particles/units/heroes/hero_dragon_knight/dragon_knight_breathe_fire.vpcf"

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
    EmitSoundOn("Hero_DragonKnight.BreathFire", self:GetCaster())
	
	local base_dmg = self:GetSpecialValueFor("base_dmg")
	local damage_pct = self:GetSpecialValueFor("damage_pct")/100
	self.wave_damage = base_dmg + caster:GetStrength()*damage_pct 
end

function tangin_fire_breathe:OnProjectileHit( hTarget, vLocation )
	if hTarget ~= nil then
		local caster = self:GetCaster()
		local debuff_duration = self:GetSpecialValueFor("debuff_duration")

		PopupCriticalDamage(hTarget, self.wave_damage)
		DealDamage(caster, hTarget, self.wave_damage, self:GetAbilityDamageType(), DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION, self)
		hTarget:AddNewModifier(self:GetCaster(), self, "modifier_tangin_fire_breathe_debuff", {duration = debuff_duration})

	end
end

modifier_tangin_fire_breathe_debuff = class({
    IsHidden                = function(self) return false end,
    IsPurgable              = function(self) return false end,
    IsDebuff                = function(self) return true end,
    IsBuff                  = function(self) return false end,
    RemoveOnDeath           = function(self) return false end,
    DeclareFunctions        = function(self) return 
        {
            MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,
        } end,

})

function modifier_tangin_fire_breathe_debuff:GetModifierBaseDamageOutgoing_Percentage()
    return self:GetAbility():GetSpecialValueFor("decrease_dmg")*(-1)
end