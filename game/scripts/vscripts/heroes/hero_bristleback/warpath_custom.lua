
LinkLuaModifier( "modifier_bristleback_warpath_custom", "heroes/hero_bristleback/warpath_custom", LUA_MODIFIER_MOTION_NONE )

bristleback_warpath_custom = class({})

function bristleback_warpath_custom:GetIntrinsicModifierName()
	return "modifier_bristleback_warpath_custom"
end

modifier_bristleback_warpath_custom = class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return true end,
	DeclareFunctions		= function(self) return 
		{
			MODIFIER_EVENT_ON_TAKEDAMAGE,
			MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		} end,
})

function modifier_bristleback_warpath_custom:OnTakeDamage( params )
	if IsServer() then
		local Attacker = params.attacker
		local Target = params.unit
		local Ability = params.inflictor
		local flDamage = params.damage
		local ability = self:GetAbility()
		local spell_lifesteal_pct = ability:GetSpecialValueFor("spell_lifesteal_pct")/100

		if Attacker ~= self:GetParent() or Ability == nil or Target == nil then
			return 0
		end

		if bit.band( params.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION ) == DOTA_DAMAGE_FLAG_REFLECTION then
			return 0
		end
		if bit.band( params.damage_flags, DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL ) == DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL then
			return 0
		end

		local nFXIndex = ParticleManager:CreateParticle( "particles/items3_fx/octarine_core_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, Attacker )
		ParticleManager:ReleaseParticleIndex( nFXIndex )

		local flLifesteal = flDamage * spell_lifesteal_pct
		Attacker:Heal( flLifesteal, ability )
	end
	return 0
end

function modifier_bristleback_warpath_custom:GetModifierBonusStats_Strength()
	return self:GetAbility():GetSpecialValueFor("bonus_str")
end
