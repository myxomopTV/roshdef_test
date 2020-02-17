LinkLuaModifier("modifier_mars_this_is_sparta_stack", "heroes/hero_mars/this_is_sparta", LUA_MODIFIER_MOTION_NONE)



function StackCountIncrease( keys )

    local caster = keys.caster
    local ability = keys.ability
    local modifier = "modifier_mars_this_is_sparta_stack"
	local kill_need = ability:GetSpecialValueFor("kill_need")
    local currentStacks = caster:GetModifierStackCount(modifier, ability)
	print("vse ok ?!")
	if ability.kill_count == nil then
		ability.kill_count = 1
	else
		ability.kill_count = ability.kill_count + 1
	end
	local stack = math.floor(ability.kill_count/kill_need)
	print(ability.kill_count)
	if stack == 1 then
		ability.kill_count = 0
		caster:AddNewModifier(caster, ability, modifier, nil)
		caster:SetModifierStackCount(modifier, ability, (currentStacks + 1))

		local effect = "particles/units/heroes/hero_pudge/pudge_fleshheap_count.vpcf"
		local pfx = ParticleManager:CreateParticle(effect, PATTACH_OVERHEAD_FOLLOW, caster)
--		ParticleManager:SetParticleControl(pfx, 0, target:GetAbsOrigin()) -- Origin	
	end
	
end

function ThisIsSpartaStart( keys )
    local caster = keys.caster
    local ability = keys.ability
    local modifier = "modifier_mars_this_is_sparta_stack"
    local currentStacks = caster:GetModifierStackCount(modifier, ability)
	local unit_name = "npc_dota_mars_warrior"
	
	local spawn_duration = ability:GetSpecialValueFor("spawn_duration")
	local unit_count = ability:GetSpecialValueFor("unit_count") + currentStacks
	
	EmitSoundOn("this_is_sparta", caster)
	for i=1,unit_count do
--		Timers:CreateTimer(0.25*i, function ()
			local point = caster:GetAbsOrigin() + RandomVector(ability:GetSpecialValueFor("spawn_radius"))
			local unit = CreateUnitByName(unit_name, point, true, caster, caster, caster:GetTeamNumber())
			unit:AddNewModifier(caster,ability,"modifier_phased",{duration = 0.1})
			unit:AddNewModifier(caster,ability,"modifier_kill",{duration = spawn_duration})
--		end)
	end
end

function ThisIsSpartaEnd( keys )
	local caster = keys.caster
	
	StopSoundOn("this_is_sparta",caster)	
end
------------------------------------------------------------
------------------------------------------------------------
modifier_mars_this_is_sparta_stack = class({
	IsHidden 				= function(self) return false end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
 
})
--sounds/vo/mars/mars_no_03_02.vsnd
--sounds/weapons/hero/mars/spear_knockback.vsnd
--sounds/weapons/hero/mars/phalanx_attack01.vsnd
--particles/econ/items/doom/doom_f2p_death_effect/doom_bringer_f2p_death.vpcf
--particles/units/heroes/hero_lone_druid/lone_druid_battle_cry_overhead.vpcf
--particles/units/heroes/hero_monkey_king/monkey_king_quad_tap_overhead.vpcf
--particles/econ/events/ti6/teleport_start_ti6_lvl3_shield.vpcf
--particles/econ/events/ti6/teleport_start_ti6_lvl3_rays.vpcf
