
LinkLuaModifier( "modifier_item_angel_wings", "items/custom/item_angel_wings.lua", LUA_MODIFIER_MOTION_NONE )

item_angel_wings = class({})

function item_angel_wings:OnSpellStart()
	local caster = self:GetCaster()

	caster:AddNewModifier(caster, self, "modifier_item_angel_wings", {})
	caster:RemoveItem(self)
end

--------------------------------------------------------------------------------

modifier_item_angel_wings = class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	DeclareFunctions		= function(self) return 
		{
			MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
		} end,
})

function modifier_item_angel_wings:OnCreated()
	local ability = self:GetAbility()
	local caster = self:GetCaster()
	self.bonus_ms = ability:GetSpecialValueFor("bonus_ms")

	local effect = "particles/units/heroes/hero_omniknight/omniknight_guardian_angel_wings.vpcf"
	local particle_fx = ParticleManager:CreateParticle(effect, PATTACH_ABSORIGIN_FOLLOW, caster)
	ParticleManager:SetParticleControlEnt(particle_fx, 0, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(particle_fx, 5, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
	self:AddParticle(particle_fx, true, false, 100, false, false)

end

function modifier_item_angel_wings:GetEffectName()
	return "particles/units/heroes/hero_omniknight/omniknight_guardian_angel_wings.vpcf"
end

function modifier_item_angel_wings:GetModifierMoveSpeedBonus_Constant()
	return self.bonus_ms
end

function modifier_item_angel_wings:CheckState()
	local state = {
		[MODIFIER_STATE_FLYING] = true
	}
	return state
end
