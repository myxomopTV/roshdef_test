LinkLuaModifier("modifier_ursa_overpower_custom", "heroes/hero_ursa/overpower_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ursa_overpower_ultimate", "heroes/hero_ursa/overpower_custom", LUA_MODIFIER_MOTION_NONE)

ursa_overpower_custom = class({})

function ursa_overpower_custom:OnSpellStart()
	local caster = self:GetCaster()
	local buff_duration = self:GetSpecialValueFor("buff_duration")

	EmitSoundOn("Hero_Ursa.Overpower",caster)
	local buff_modifier = caster:AddNewModifier( caster, self, "modifier_ursa_overpower_custom", {duration = buff_duration})
end
--------------------------------------------------------
------------------------------------------------------------
modifier_ursa_overpower_custom = class({
	IsHidden 				= function(self) return false end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	DeclareFunctions		= function(self) return 
		{MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		} end,
})

function modifier_ursa_overpower_custom:GetEffectName()
	return "particles/units/heroes/hero_ursa/ursa_overpower_buff.vpcf"
end

function modifier_ursa_overpower_custom:GetModifierAttackSpeedBonus_Constant()
	return self:GetAbility():GetSpecialValueFor("as_bonus")
end

ursa_overpower_ultimate = class({})

function ursa_overpower_ultimate:GetIntrinsicModifierName()
	return "modifier_ursa_overpower_ultimate"
end

modifier_ursa_overpower_ultimate = class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
})

function modifier_ursa_overpower_ultimate:OnCreated()
	local ability = self:GetAbility()
	local buff_interval = ability:GetSpecialValueFor("buff_interval")
	self:StartIntervalThink(buff_interval)
end

function modifier_ursa_overpower_ultimate:OnIntervalThink()
	local caster = self:GetCaster()
	local ability = self:GetAbility()
	local buff_duration = ability:GetSpecialValueFor("buff_duration")
	if caster:IsAlive() == false then
		return
	end
	
	EmitSoundOn("Hero_Ursa.Overpower",caster)
	caster:AddNewModifier( caster, ability, "modifier_ursa_overpower_custom", {duration = buff_duration})
	caster:Purge(false, true, false, true, false)
end

