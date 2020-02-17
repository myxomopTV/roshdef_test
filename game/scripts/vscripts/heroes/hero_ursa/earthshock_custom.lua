LinkLuaModifier("modifier_ursa_earthshock_custom", "heroes/hero_ursa/earthshock_custom", LUA_MODIFIER_MOTION_NONE)

if not ursa_earthshock_custom then ursa_earthshock_custom = class({}) end

function ursa_earthshock_custom:OnSpellStart()
	local caster = self:GetCaster()
	local ability = self
	local radius = ability:GetSpecialValueFor("shock_radius")
	local debuff_duration = ability:GetSpecialValueFor("debuff_duration")
	local damage = ability:GetSpecialValueFor("damage")
	EmitSoundOn("Hero_Ursa.Earthshock",caster)

	local effect = "particles/units/heroes/hero_ursa/ursa_earthshock.vpcf"
	local pfx = ParticleManager:CreateParticle(effect, PATTACH_ABSORIGIN_FOLLOW, caster)
	ParticleManager:SetParticleControl(pfx, 0, caster:GetAbsOrigin()) -- Origin
	ParticleManager:SetParticleControl(pfx, 1, Vector(radius, radius/2, radius)) -- Origin
	ParticleManager:ReleaseParticleIndex(pfx)
	
	local units = FindUnitsInRadius(caster:GetTeamNumber(), 
								caster:GetAbsOrigin(),
								nil,
								radius,
								DOTA_UNIT_TARGET_TEAM_ENEMY,
								DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 
								DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
								FIND_ANY_ORDER, 
								false) 
	
	for i=1,#units do
		local unit = units[i]
		unit:AddNewModifier( caster, self, "modifier_ursa_earthshock_custom", {duration = debuff_duration})		
		DealDamage(caster, unit, damage, DAMAGE_TYPE_MAGICAL, nil, ability)
	end
end

modifier_ursa_earthshock_custom = class({
	IsHidden 				= function(self) return false end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return true end,
	IsBuff                  = function(self) return false end,
	RemoveOnDeath 			= function(self) return false end,
	DeclareFunctions		= function(self) return 
		{MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		} end,
})

function modifier_ursa_earthshock_custom:GetEffectName()
	return "particles/units/heroes/hero_ursa/ursa_earthshock_modifier.vpcf"
end

function modifier_ursa_earthshock_custom:GetModifierAttackSpeedBonus_Constant()
	return self:GetAbility():GetSpecialValueFor("as_ms_slow")*(-1)
end

function modifier_ursa_earthshock_custom:GetModifierMoveSpeedBonus_Percentage()
	return self:GetAbility():GetSpecialValueFor("as_ms_slow")*(-1)
end
