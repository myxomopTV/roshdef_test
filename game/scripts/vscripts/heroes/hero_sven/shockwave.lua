LinkLuaModifier("modifier_sven_shockwave_debuff", "heroes/hero_sven/shockwave", LUA_MODIFIER_MOTION_NONE)

sven_shockwave = class({})

function sven_shockwave:GetCastRange()
	return self:GetSpecialValueFor("wave_distance")
end

function sven_shockwave:GetAbilityTextureName()
	local caster = self:GetCaster()
	if caster:HasModifier("modifier_sven_god_strength") or caster:HasModifier("modifier_sven_powerup") then
		return "sven/shockwave_red"
	else
		return "sven/shockwave_blue"
	end
end
function sven_shockwave:OnSpellStart()
   local vDirection = (self:GetCursorPosition() - self:GetCaster():GetOrigin()):Normalized()
	local caster = self:GetCaster()
	
    local particle = "particles/units/heroes/hero_magnataur/magnataur_shockwave.vpcf"
	if caster:HasModifier("modifier_sven_god_strength") or caster:HasModifier("modifier_sven_powerup") then
		particle = "particles/econ/items/magnataur/shock_of_the_anvil/magnataur_shockanvil.vpcf"
	end
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
    EmitSoundOn("Hero_Sven.StormBolt", self:GetCaster())
	
	local damage_pct = self:GetSpecialValueFor("damage_pct")/100
	self.wave_damage = caster:GetAverageTrueAttackDamage(caster)*damage_pct 
	caster:RemoveModifierByName("modifier_sven_powerup")

end

function sven_shockwave:OnProjectileHit( hTarget, vLocation )
	if hTarget ~= nil then
		local caster = self:GetCaster()
		local stun_duration = self:GetSpecialValueFor("stun_duration")
		local debuff_duration = self:GetSpecialValueFor("debuff_duration")

		EmitSoundOn("Hero_Sven.StormBoltImpact", hTarget)		
		PopupCriticalDamage(hTarget, self.wave_damage)
		DealDamage(caster, hTarget, self.wave_damage, self:GetAbilityDamageType(), DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION, self)
		hTarget:AddNewModifier(self:GetCaster(), self, "modifier_stunned", {duration = stun_duration})
		hTarget:AddNewModifier(self:GetCaster(), self, "modifier_sven_shockwave_debuff", {duration = debuff_duration})
	end
end

modifier_sven_shockwave_debuff = class({
	IsHidden 				= function(self) return false end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return true end,
	IsBuff                  = function(self) return false end,
	RemoveOnDeath 			= function(self) return true end,
	DeclareFunctions		= function(self) return 
		{
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		} end,
})

function modifier_sven_shockwave_debuff:GetModifierPhysicalArmorBonus()
	return self:GetAbility():GetSpecialValueFor("armor_debuff")*(-1)
end

