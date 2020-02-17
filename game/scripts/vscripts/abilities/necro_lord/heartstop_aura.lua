LinkLuaModifier("modifier_heartstop_aura", "abilities/necro_lord/heartstop_aura", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_heartstop_aura_debuff", "abilities/necro_lord/heartstop_aura", LUA_MODIFIER_MOTION_NONE)

if not heartstop_aura then heartstop_aura = class({}) end

function heartstop_aura:GetIntrinsicModifierName()
	return "modifier_heartstop_aura"
end

function heartstop_aura:GetCastRange()
	return self:GetSpecialValueFor("aura_radius")
end

modifier_heartstop_aura = class({
	IsHidden 	= function(self) return false end,
	IsAura 		= function(self) return true end,
	GetAuraRadius 	= function(self) return self:GetAbility():GetSpecialValueFor("aura_radius") end,
	GetAuraSearchTeam = function(self) return DOTA_UNIT_TARGET_TEAM_ENEMY end,
	GetAuraSearchFlags = function(self) return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES end,
	GetAuraSearchType = function(self) return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end,
	GetModifierAura   = function(self) return "modifier_heartstop_aura_debuff" end,
})

modifier_heartstop_aura_debuff = class({
	IsHidded 	= function(self) return false end,
})

function modifier_heartstop_aura_debuff:OnCreated()
	local ability = self:GetAbility()
	local interval = ability:GetSpecialValueFor("interval")
	local aura_dmg = ability:GetSpecialValueFor("aura_dmg")/100
	self.dmg_interval = aura_dmg*interval
	print(interval)
	print(aura_dmg)
	print(self.dmg_interval)
	self:StartIntervalThink(interval)
end

function modifier_heartstop_aura_debuff:OnIntervalThink()
	local ability = self:GetAbility()
	local parent = self:GetParent()
	local caster = self:GetCaster()
	local damage = parent:GetMaxHealth()*self.dmg_interval

	DealDamage( caster, parent, damage, DAMAGE_TYPE_PURE, DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION + DOTA_DAMAGE_FLAG_HPLOSS, ability)
end

creature_heartstop_aura = class(heartstop_aura)
boss_heartstop_aura = class(heartstop_aura)