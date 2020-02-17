
LinkLuaModifier( "modifier_ricko_hunger", "heroes/hero_ricko/hunger", LUA_MODIFIER_MOTION_NONE )

ricko_hunger = class({})

function ricko_hunger:OnSpellStart()
	local buff_duration= self:GetSpecialValueFor("buff_duration")
	local caster = self:GetCaster()
	local host = self:GetCaster().host
	if host and IsValidEntity(host) then
		host:AddNewModifier( caster, self, "modifier_ricko_hunger", {duration = buff_duration} )
		host:EmitSound("DOTA_Item.MaskOfMadness.Activate")
	end
end

modifier_ricko_hunger = class({
	IsHidden 				= function(self) return false end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return true end,
	DeclareFunctions		= function(self) return 
		{
			MODIFIER_EVENT_ON_TAKEDAMAGE,
			MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		} end,
})

function modifier_ricko_hunger:GetEffectName()
	return "particles/items2_fx/mask_of_madness.vpcf"
end

function modifier_ricko_hunger:OnTakeDamage( params )
	if IsServer() then
		local Attacker = params.attacker
		local Target = params.unit
		local Ability = params.inflictor
		local flDamage = params.damage
		local ability = self:GetAbility()
		local spell_lifesteal_pct = ability:GetSpecialValueFor("lifesteal_pct")/100

		if Attacker ~= self:GetParent() or not Attacker:IsAlive() or Target == nil or Target:IsBuilding() then
			return 0
		end

		if bit.band( params.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION ) == DOTA_DAMAGE_FLAG_REFLECTION then
			return 0
		end
		if bit.band( params.damage_flags, DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL ) == DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL then
			return 0
		end

		local nFXIndex = ParticleManager:CreateParticle( "particles/generic_gameplay/generic_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, Attacker )
		ParticleManager:ReleaseParticleIndex( nFXIndex )

		local flLifesteal = flDamage * spell_lifesteal_pct
		Attacker:Heal( flLifesteal, nil )
	end
	return 0
end

function modifier_ricko_hunger:GetModifierAttackSpeedBonus_Constant( )
	return self:GetAbility():GetSpecialValueFor("bonus_as")
end
