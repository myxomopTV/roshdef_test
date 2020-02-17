LinkLuaModifier("modifier_spectre_dagger_custom_debuff", "heroes/hero_spectre/dagger_custom", LUA_MODIFIER_MOTION_NONE)

spectre_dagger_custom = class({})

function spectre_dagger_custom:GetAbilityTextureName()
	local caster = self:GetCaster()
	local texture = "spectre_spectral_dagger"
	if caster:HasModifier("modifier_item_mystic_dagger") then
		texture = "spectre/immortal/spectre_spectral_dagger"
	elseif caster:HasModifier("modifier_item_mystic_dagger_upgrade") then
		texture = "spectre/immortal/spectre_crimson_spectral_dagger"
	end	
	return texture
end
function spectre_dagger_custom:OnSpellStart()
   local vDirection = (self:GetCursorPosition() - self:GetCaster():GetOrigin()):Normalized()
	local caster = self:GetCaster()
	
    local particle = "particles/units/heroes/hero_spectre/spectre_spectral_dagger.vpcf"
	if caster:HasModifier("modifier_item_mystic_dagger") then
		particle = "particles/econ/items/spectre/spectre_transversant_soul/spectre_transversant_spectral_dagger.vpcf"
	elseif caster:HasModifier("modifier_item_mystic_dagger_upgrade") then
		particle = "particles/econ/items/spectre/spectre_transversant_soul/spectre_ti7_crimson_spectral_dagger.vpcf"
	end
	
    ProjectileManager:CreateLinearProjectile({
	  EffectName = particle,
	  Ability = self,
	  vSpawnOrigin = self:GetCaster():GetOrigin(),
	  fStartRadius = self:GetSpecialValueFor("wave_width_initial"),
	  fEndRadius = self:GetSpecialValueFor("wave_width_end"),
	  vVelocity = vDirection * self:GetSpecialValueFor("wave_speed"),
	  fDistance = self:GetSpecialValueFor("wave_speed"),
	  Source = self:GetCaster(),
	  iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
	  iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
--      iUnitTargetFlags = self:GetAbilityTargetFlags(),
	  bProvidesVision = true,
	  iVisionTeamNumber = self:GetCaster():GetTeamNumber(),
	  iVisionRadius = self:GetSpecialValueFor("wave_width_end"),
    })
    EmitSoundOn("Hero_Spectre.DaggerCast.ti7", self:GetCaster())
	
	local damage_pct = self:GetSpecialValueFor("damage_pct")/100
	self.wave_damage = math.floor((caster:GetStrength()+caster:GetAgility()+caster:GetIntellect())*damage_pct)
end

function spectre_dagger_custom:OnProjectileHit( hTarget, vLocation )
	if hTarget ~= nil then
		local caster = self:GetCaster()
		local stun_duration = self:GetSpecialValueFor("stun_duration")
		local debuff_duration = self:GetSpecialValueFor("debuff_duration")

		EmitSoundOn("Hero_Spectre.DaggerImpact", hTarget)		
		PopupCriticalDamage(hTarget, self.wave_damage)
		DealDamage(caster, hTarget, self.wave_damage, self:GetAbilityDamageType(), DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION, self)
		hTarget:AddNewModifier(self:GetCaster(), self, "modifier_stunned", {duration = stun_duration})
		hTarget:AddNewModifier(self:GetCaster(), self, "modifier_spectre_dagger_custom_debuff", {duration = debuff_duration})
	end
end

modifier_spectre_dagger_custom_debuff = class({
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

function modifier_spectre_dagger_custom_debuff:GetModifierPhysicalArmorBonus()
	return self:GetAbility():GetSpecialValueFor("armor_debuff")*(-1)
end

