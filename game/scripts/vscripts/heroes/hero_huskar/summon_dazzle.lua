LinkLuaModifier("modifier_huskar_summon_dazzle", "heroes/hero_huskar/summon_dazzle", LUA_MODIFIER_MOTION_NONE)

huskar_summon_dazzle = class({})

function huskar_summon_dazzle:OnSpellStart()
    local caster = self:GetCaster()
    local ability = self
	local unit_name = "npc_dota_huskar_dazzle"
	local point = caster:GetAbsOrigin()
	local summon_duration = ability:GetSpecialValueFor("summon_duration")
	local grave_duration = ability:GetSpecialValueFor("grave_duration")
	
	local unit  = CreateUnitByName(unit_name, point + RandomVector(100), true, caster, caster, caster:GetTeamNumber())
	EmitSoundOn("dazzle_dazz_ability_shalgrave_06", caster)
	unit:AddNewModifier( caster, self, "modifier_kill", {duration = summon_duration})
	unit:AddNewModifier( caster, self, "modifier_huskar_summon_dazzle", {duration = summon_duration})
	caster:AddNewModifier( caster, self, "modifier_dazzle_shallow_grave", {duration = grave_duration})
end
--------------------------------------------------------
------------------------------------------------------------
modifier_huskar_summon_dazzle = class({
	IsHidden 				= function(self) return false end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
})

function modifier_huskar_summon_dazzle:OnCreated()
	local interval = self:GetAbility():GetSpecialValueFor("interval")
	self:StartIntervalThink(interval)
end

function modifier_huskar_summon_dazzle:OnIntervalThink()
	local caster = self:GetCaster()
	local parent = self:GetParent()
	local ability = self:GetAbility()
	local heal_radius = ability:GetSpecialValueFor("heal_radius")
	local heal_pct = ability:GetSpecialValueFor("heal_pct")
--[[	
	local units = FindUnitsInRadius(caster:GetTeamNumber(), 
									parent:GetAbsOrigin(),
									nil,
									heal_radius,
									DOTA_UNIT_TARGET_TEAM_FRIENDLY,
									DOTA_UNIT_TARGET_HERO, 
									DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
									FIND_ANY_ORDER, 
									false)
]]									
	parent:StartGestureWithPlaybackRate( ACT_DOTA_CAST_ABILITY_3, 2 )								
--	for i=1,#units do
		local unit = caster
		local heal_amount = unit:GetMaxHealth()*heal_pct/100
		unit:Heal(heal_amount, ability)
		
		local effect = "particles/econ/items/dazzle/dazzle_ti9/dazzle_shadow_wave_ti9.vpcf"
		local pfx = ParticleManager:CreateParticle(effect, PATTACH_ABSORIGIN_FOLLOW, parent)
		ParticleManager:SetParticleControl(pfx, 0, parent:GetAbsOrigin()) -- Origin
		ParticleManager:SetParticleControl(pfx, 1, unit:GetAbsOrigin()) -- Origin
		ParticleManager:ReleaseParticleIndex(pfx)
		EmitSoundOn("Greevil.Shadow_Wave", parent)
--	end
--	DealDamage(caster, parent, total_dmg, DAMAGE_TYPE_MAGICAL, nil, ability)
end

function modifier_huskar_summon_dazzle:GetEffectName()
	return "particles/econ/items/dazzle/dazzle_ti6/dazzle_ti6_shallow_grave.vpcf"
end


