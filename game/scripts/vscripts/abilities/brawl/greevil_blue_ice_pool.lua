greevil_blue_ice_pool = class({})

LinkLuaModifier("modifier_greevil_blue_ice_pool", "abilities/greevil_blue_ice_pool", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_greevil_blue_ice_pool_thinker", "abilities/greevil_blue_ice_pool", LUA_MODIFIER_MOTION_NONE)

function greevil_blue_ice_pool:GetAbilityTextureName()
	return "greevil_blue_ice_pool"
end

function greevil_blue_ice_pool:GetCastAnimation()
	return ACT_DOTA_CAST_ABILITY_2
end

function greevil_blue_ice_pool:OnSpellStart()
	self.radius = self:GetSpecialValueFor("radius")
	self.duration = self:GetSpecialValueFor("duration")

	local dummy = CreateUnitByName("npc_dummy_unit", self:GetCaster():GetOrigin(), false, self:GetCaster(), self:GetCaster(), self:GetCaster():GetTeamNumber())
	dummy:AddNewModifier(self:GetCaster(), self, "modifier_greevil_blue_ice_pool_thinker", {duration = self.duration})

	local poolPFX = ParticleManager:CreateParticle("particles/greevils/greevil_blue/greevil_blue_ice_pool.vpcf", PATTACH_ABSORIGIN_FOLLOW, dummy)
	ParticleManager:SetParticleControl(poolPFX, 0, dummy:GetOrigin())
	ParticleManager:SetParticleControl(poolPFX, 1, Vector(self.radius, 0, 0))
	ParticleManager:SetParticleControl(poolPFX, 2, Vector(self.duration, 0, 0))
	ParticleManager:ReleaseParticleIndex(poolPFX)

	local castPFX = ParticleManager:CreateParticle("particles/greevils/greevil_blue/greevil_blue_ice_pool_cast.vpcf", PATTACH_ABSORIGIN, self:GetCaster())
	ParticleManager:SetParticleControlEnt(castPFX, 0, self:GetCaster(), PATTACH_POINT, "attach_mouth", self:GetCaster():GetOrigin(), true)
	ParticleManager:ReleaseParticleIndex(castPFX)
end

modifier_greevil_blue_ice_pool = class({
	IsPurgable = function() return false end,
	IsHidden = function() return true end,
})

modifier_greevil_blue_ice_pool_thinker = class({
	IsPurgable = function() return false end,
	IsHidden = function() return true end,
	IsAura = function() return true end,
	GetModifierAura = function() return "modifier_greevil_blue_ice_pool" end,
	GetAuraSearchTeam = function() return DOTA_UNIT_TARGET_TEAM_ENEMY end,
	GetAuraSearchType = function() return DOTA_UNIT_TARGET_HERO end,
	GetAuraSearchFlags = function() return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES end,
	GetAuraDuration = function() return 0.2 end,
})

function modifier_greevil_blue_ice_pool_thinker:GetAuraRadius()
	return self:GetAbility().radius
end

if IsServer() then
	function modifier_greevil_blue_ice_pool_thinker:OnDestroy()
		UTIL_Remove(self:GetParent())
	end
end