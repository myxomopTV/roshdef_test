
LinkLuaModifier( "modifier_storm_arcane_power", "heroes/hero_storm/arcane_power", LUA_MODIFIER_MOTION_NONE )

storm_arcane_power = class({})

function storm_arcane_power:GetIntrinsicModifierName()
	return "modifier_storm_arcane_power"
end


--------------------------------------------------------------------------------

modifier_storm_arcane_power = class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return true end,
	IsBuff                  = function(self) return false end,
	RemoveOnDeath 			= function(self) return false end,
	DeclareFunctions		= function(self) return 
		{
			MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE,
			MODIFIER_PROPERTY_MANACOST_PERCENTAGE,
		} end,
})

function modifier_storm_arcane_power:GetModifierPercentageCooldown()
	return self:GetAbility():GetSpecialValueFor("reduce_cd")
end

function modifier_storm_arcane_power:GetModifierPercentageManacost()
	return self:GetAbility():GetSpecialValueFor("reduce_mp")
end

function modifier_storm_arcane_power:GetEffectName()
	return "particles/generic_gameplay/rune_arcane_owner.vpcf"
end

function modifier_storm_arcane_power:OnCreated()
	local caster = self:GetCaster()
	caster:EmitSound("stormspirit_ss_rare_0"..RandomInt(1, 5))
end
