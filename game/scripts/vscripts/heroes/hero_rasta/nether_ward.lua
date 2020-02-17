LinkLuaModifier("modifier_rasta_nether_ward", "heroes/hero_rasta/nether_ward", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_rasta_nether_ward_aura", "heroes/hero_rasta/nether_ward", LUA_MODIFIER_MOTION_NONE)

rasta_nether_ward = class({})


function rasta_nether_ward:OnSpellStart( )
	local caster = self:GetCaster()
	local ability = self

	local ward_duration = self:GetSpecialValueFor("ward_duration")
	local ward_health = self:GetSpecialValueFor("ward_health")
	local point = self:GetCursorPosition()
	local fv = caster:GetForwardVector()
	local team = caster:GetTeam()
	local player = caster:GetPlayerID()

	local unit = CreateUnitByName( "npc_dota_rasta_nether_ward", point, true, caster, caster, team )

	unit:SetControllableByPlayer(player, false)
	unit:SetOwner(caster)
	unit:SetForwardVector(fv)	
	
	unit:SetBaseMaxHealth(ward_health)
	unit:SetMaxHealth(ward_health)
	unit:SetHealth(ward_health)				
--	unit:SetBaseAttackTime(bat)
	unit:AddNewModifier(unit, ability, "modifier_rasta_nether_ward", nil)
	unit:AddNewModifier(caster, ability, "modifier_kill", {duration = ward_duration})
	--	unit:SetHealth(unit:GetMaxHealth())
--	unit:SetHealth(unit:GetMaxHealth())
end

modifier_rasta_nether_ward = class({
	IsHidden = function(self) return true end,
	CheckState = function(self) return {
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
	}end,
	IsAura = function(self) return true end,
	GetAuraRadius = function(self) return self:GetAbility():GetSpecialValueFor("aura_radius") end,
	GetModifierAura = function(self) return "modifier_rasta_nether_ward_aura" end,
	GetAuraSearchTeam = function(self) return DOTA_UNIT_TARGET_TEAM_ENEMY end,
	GetAuraSearchType = function(self) return DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO end,
	GetEffectName = function(self) return "particles/units/heroes/hero_pugna/pugna_ward_ambient.vpcf" end,
})

modifier_rasta_nether_ward_aura = class({
	IsHidden = function(self) return false end,
})

function modifier_rasta_nether_ward_aura:OnCreated()
	self:StartIntervalThink(1)
end

function modifier_rasta_nether_ward_aura:OnIntervalThink()
	local parent = self:GetParent()
	local caster = self:GetCaster()
	local ability = self:GetAbility()
	local hero = caster:GetOwner()
	print(hero:GetUnitName())
	local aura_int_dmg = ability:GetSpecialValueFor("aura_int_dmg")*hero:GetIntellect()/100
	local damage =  ability:GetSpecialValueFor("aura_damage") + aura_int_dmg

    DealDamage(caster, parent, damage, DAMAGE_TYPE_MAGICAL, DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION + DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL, ability)

end

