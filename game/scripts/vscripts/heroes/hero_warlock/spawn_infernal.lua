LinkLuaModifier("modifier_warlock_spawn_infernal", "heroes/hero_warlock/spawn_infernal", LUA_MODIFIER_MOTION_NONE)

warlock_spawn_infernal = class({})

function warlock_spawn_infernal:GetIntrinsicModifierName()
	return "modifier_warlock_spawn_infernal"
end
--------------------------------------------------------
------------------------------------------------------------
modifier_warlock_spawn_infernal = class({
	IsHidden 				= function(self) return false end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	DeclareFunctions		= function(self) return 
		{
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		} end,
})

function modifier_warlock_spawn_infernal:OnAttackLanded( params )
	if IsServer() then
		local target = params.target
		local attacker = params.attacker
		local caster = self:GetCaster()
		local ability = self:GetAbility()
		
		if attacker == caster and target then
			local fw = caster:GetForwardVector()
			local point = target:GetAbsOrigin() + fw*100		
			local team = caster:GetTeam()
			local duration = ability:GetSpecialValueFor("duration")
			local unit_name = "npc_dota_dire_forest_boss_minion_"..ability:GetLevel()

			EmitSoundOn("warlock_golem_wargol_move_06",target)
--[[
			local effect = "particles/econ/items/pugna/pugna_ward_ti5/pugna_ward_attack_medium_ti_5.vpcf"
			local pfx = ParticleManager:CreateParticle(effect, PATTACH_CUSTOMORIGIN, nil)
			ParticleManager:SetParticleControl(pfx, 0, point) -- Origin
			ParticleManager:SetParticleControl(pfx, 1, point) -- Origin
			ParticleManager:ReleaseParticleIndex(pfx)			
]]
			local unit = CreateUnitByName( unit_name, point, false, nil, nil, team )
			unit:SetForwardVector(fw)
			unit:AddNewModifier( caster, nil, "modifier_phased", {duration = 0.1} )
			unit:AddNewModifier( caster, nil, "modifier_kill", {duration = duration} )
		end
	end

	return 0
end
