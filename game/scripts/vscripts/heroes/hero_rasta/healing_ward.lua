LinkLuaModifier("modifier_rasta_healing_ward", "heroes/hero_rasta/healing_ward", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_rasta_healing_ward_aura", "heroes/hero_rasta/healing_ward", LUA_MODIFIER_MOTION_NONE)

rasta_healing_ward = class({})


function rasta_healing_ward:OnSpellStart( )
	local caster = self:GetCaster()
	local ability = self

	local ward_duration = self:GetSpecialValueFor("ward_duration")
	local ward_health = self:GetSpecialValueFor("ward_health")
	local point = self:GetCursorPosition()
	local fv = caster:GetForwardVector()
	local team = caster:GetTeam()
	local player = caster:GetPlayerID()

	local unit = CreateUnitByName( "npc_dota_rasta_healing_ward", point, true, caster, caster, team )

	unit:SetControllableByPlayer(player, false)
	unit:SetOwner(caster)
	unit:SetForwardVector(fv)	
	
	unit:SetBaseMaxHealth(ward_health)
	unit:SetMaxHealth(ward_health)
	unit:SetHealth(ward_health)				
--	unit:SetBaseAttackTime(bat)
	unit:AddNewModifier(caster, ability, "modifier_rasta_healing_ward", nil)
	unit:AddNewModifier(caster, ability, "modifier_kill", {duration = ward_duration})
	--	unit:SetHealth(unit:GetMaxHealth())
--	unit:SetHealth(unit:GetMaxHealth())
end

modifier_rasta_healing_ward = class({
	IsHidden = function(self) return true end,
	CheckState = function(self) return {
--		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
	}end,
	IsAura = function(self) return true end,
	GetAuraRadius = function(self) return self:GetAbility():GetSpecialValueFor("aura_radius") end,
	GetModifierAura = function(self) return "modifier_rasta_healing_ward_aura" end,
	GetAuraSearchTeam = function(self) return DOTA_UNIT_TARGET_TEAM_FRIENDLY end,
	GetAuraSearchType = function(self) return DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO end,
	GetEffectName = function(self) return "particles/econ/items/juggernaut/jugg_fortunes_tout/jugg_healling_ward_fortunes_tout_hero_heal.vpcf" end,
})

modifier_rasta_healing_ward_aura = class({
	IsHidden = function(self) return false end,
	DeclareFunctions = function(self) return {
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
	}end,
})

function modifier_rasta_healing_ward_aura:GetModifierPhysicalArmorBonus()
    return self:GetAbility():GetSpecialValueFor("aura_armor")
end

function modifier_rasta_healing_ward_aura:GetModifierConstantHealthRegen()
    return self:GetAbility():GetSpecialValueFor("aura_regen")
end

function modifier_rasta_healing_ward_aura:GetModifierHealthRegenPercentage()
    return self:GetAbility():GetSpecialValueFor("aura_regen_pct")
end
