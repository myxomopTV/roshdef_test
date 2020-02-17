LinkLuaModifier("modifier_zombie_aura", "abilities/zombie_lord/zombie_aura", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_zombie_aura_debuff", "abilities/zombie_lord/zombie_aura", LUA_MODIFIER_MOTION_NONE)

if not zombie_aura then zombie_aura = class({}) end

function zombie_aura:GetIntrinsicModifierName()
	return "modifier_zombie_aura"
end

function zombie_aura:GetCastRange()
	return self:GetSpecialValueFor("aura_radius")
end

modifier_zombie_aura = class({
	IsHidden 	= function(self) return true end,
	IsAura 		= function(self) return true end,
	GetAuraRadius 	= function(self) return self:GetAbility():GetSpecialValueFor("aura_radius") end,
	GetAuraSearchTeam = function(self) return DOTA_UNIT_TARGET_TEAM_ENEMY end,
	GetAuraSearchFlags = function(self) return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES end,
	GetAuraSearchType = function(self) return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end,
	GetModifierAura   = function(self) return "modifier_zombie_aura_debuff" end,
})

modifier_zombie_aura_debuff = class({
	IsHidded 	= function(self) return false end,
	DeclareFunctions = function(self) return {
		MODIFIER_EVENT_ON_DEATH
	}end,
})

function modifier_zombie_aura_debuff:OnDeath(data)
	local parent = self:GetParent()
	local killer = data.killer
	local unit = data.unit

	if unit == parent and not unit.zombie then
		local ability = self:GetAbility()
		local caster = self:GetCaster()
		local point = unit:GetAbsOrigin()
		local team = caster:GetTeam()
		local level = ability:GetLevel()
		local unit_name = "npc_dota_zombie_"..level

		local unit = CreateUnitByName(unit_name, point, true, caster, caster, team)
		unit.zombie = true
	end
end
