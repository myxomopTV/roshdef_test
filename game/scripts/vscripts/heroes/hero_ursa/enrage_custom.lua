LinkLuaModifier("modifier_ursa_enrage_custom", "heroes/hero_ursa/enrage_custom", LUA_MODIFIER_MOTION_NONE)

ursa_enrage_custom = class({})

function ursa_enrage_custom:OnSpellStart()
	local caster = self:GetCaster()
	local buff_duration = self:GetSpecialValueFor("buff_duration")

	EmitSoundOn("Hero_Ursa.Enrage",caster)
	caster:Purge(false, true, false, true, false)
	local buff_modifier = caster:AddNewModifier( caster, self, "modifier_ursa_enrage_custom", {duration = buff_duration})

	local effect = "particles/units/heroes/hero_ursa/ursa_enrage_buff.vpcf"
	local pfx = ParticleManager:CreateParticle(effect, PATTACH_ABSORIGIN_FOLLOW, caster)
	ParticleManager:SetParticleControl(pfx, 0, caster:GetAbsOrigin()) -- Origin
--	ParticleManager:ReleaseParticleIndex(pfx)
	buff_modifier:AddParticle(pfx, false, false, 100, true, false)
end
--------------------------------------------------------
------------------------------------------------------------
modifier_ursa_enrage_custom = class({
	IsHidden 				= function(self) return false end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	DeclareFunctions		= function(self) return 
		{MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
		} end,
})

--function modifier_ursa_enrage_custom:GetEffectName()
--	return "particles/units/heroes/hero_ursa/ursa_enrage_hero_effect.vpcf"
--end

function modifier_ursa_enrage_custom:GetStatusEffectName()
	return "particles/status_fx/status_effect_overpower.vpcf"
end

function modifier_ursa_enrage_custom:GetModifierIncomingDamage_Percentage()
	return self:GetAbility():GetSpecialValueFor("damage_reduction")*(-1)
end
