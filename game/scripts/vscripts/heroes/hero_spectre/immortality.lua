LinkLuaModifier("modifier_spectre_immortality", "heroes/hero_spectre/immortality", LUA_MODIFIER_MOTION_NONE)

spectre_immortality = class({})

function spectre_immortality:OnSpellStart()
	local caster = self:GetCaster()
	local duration = self:GetSpecialValueFor("duration")

	EmitSoundOn("Hero_Spectre.Reality", caster)
	caster:AddNewModifier(caster, self, "modifier_spectre_immortality", {duration = duration})
end

modifier_spectre_immortality = class({
	IsHidden 				= function(self) return false end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	DeclareFunctions		= function(self) return 
		{MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE,
		} end,
	CheckState		= function(self) return 
		{
			[MODIFIER_STATE_NO_HEALTH_BAR] = true,          
			[MODIFIER_STATE_INVULNERABLE] = true, 
			[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		} end,
})

function modifier_spectre_immortality:GetModifierPreAttack_CriticalStrike()
	return self:GetAbility():GetSpecialValueFor("bonus_crit")
end

function modifier_spectre_immortality:GetEffectName()
	return "particles/econ/items/spectre/spectre_transversant_soul/spectre_ti7_crimson_spectral_dagger_path_owner.vpcf"
end
