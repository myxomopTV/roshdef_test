LinkLuaModifier("modifier_greevil_unit_upgrade", "heroes/hero_greevil_lord/upgrade_unit", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_greevil_healer_aura", "heroes/hero_greevil_lord/spawn_healer", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_greevil_healer_aura_buff", "heroes/hero_greevil_lord/spawn_healer", LUA_MODIFIER_MOTION_NONE)

greevil_lord_spawn_healer = class({})

function greevil_lord_spawn_healer:OnSpellStart()
	if IsServer() then
		local ability = self
		local caster = self:GetCaster()		
		local point = caster:GetAbsOrigin()
		local player = caster:GetPlayerID()
		local level = ability:GetLevel()
		local unit_name = "npc_dota_greevil_lord_unit_healer"
			
		local duration = ability:GetSpecialValueFor("duration") 	
		
		local unit = CreateUnitByName(unit_name, point, false, caster, caster, caster:GetTeamNumber())
		unit:SetControllableByPlayer(player, true)
		unit:AddNewModifier(caster,ability,"modifier_kill",{duration = duration})
		unit:AddNewModifier(caster,ability,"modifier_phased",{duration = 0.01})
		unit:AddNewModifier(caster,ability,"modifier_greevil_unit_upgrade",nil)
		unit:AddNewModifier(caster,ability,"modifier_greevil_healer_aura",nil)

	end	
end

modifier_greevil_healer_aura = class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	DeclareFunctions		= function(self) return 
		{
			MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
			MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
		} end,
})
function modifier_greevil_healer_aura:OnCreated()
	if IsServer() then
		self.aura_radius = self:GetAbility():GetSpecialValueFor("aura_radius")
	end
end
function modifier_greevil_healer_aura:GetEffectName()
	return "particles/econ/items/juggernaut/jugg_fortunes_tout/jugg_healling_ward_fortunes_tout_ward.vpcf"
end
function modifier_greevil_healer_aura:IsAura()
	return true
end
function modifier_greevil_healer_aura:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end
function modifier_greevil_healer_aura:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end
function modifier_greevil_healer_aura:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
end
function modifier_greevil_healer_aura:GetAuraRadius()
	return self.aura_radius 
end
function modifier_greevil_healer_aura:GetModifierAura()
	return "modifier_greevil_healer_aura_buff"
end

modifier_greevil_healer_aura_buff = class({
	IsHidden 				= function(self) return false end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	DeclareFunctions		= function(self) return 
		{
			MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
			MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
		} end,
})

function modifier_greevil_healer_aura_buff:GetModifierConstantHealthRegen()
	return self:GetAbility():GetSpecialValueFor("hp_reg")
end

function modifier_greevil_healer_aura_buff:GetModifierHealthRegenPercentage()
	return self:GetAbility():GetSpecialValueFor("hp_reg_pct")
end
