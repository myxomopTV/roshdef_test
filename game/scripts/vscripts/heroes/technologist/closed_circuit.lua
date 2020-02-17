if customability_technologist_closed_circuit == nil then
    customability_technologist_closed_circuit = class({})
end


LinkLuaModifier( "modifier_technologist_energized", "heroes/technologist/modifiers/energy_system.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_technologist_energized_stack", "heroes/technologist/modifiers/energy_system.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_technologist_energized_failsafe", "heroes/technologist/modifiers/energy_system.lua", LUA_MODIFIER_MOTION_NONE )

function customability_technologist_closed_circuit:OnUpgrade() 
	self.damagePerc = (40 + (self:GetLevel() * .83)) / 100
end

function customability_technologist_closed_circuit:GetManaCost()
	return 40
end

function customability_technologist_closed_circuit:GetAOERadius()
	return 40
end

function customability_technologist_closed_circuit:OnSpellStart()

	local Caster = self:GetCaster()
	local Target = false
	if not self:GetCursorTargetingNothing() then
        Target = self:GetCursorTarget()
    end
    local point = self:GetCursorPosition()

    local mod = Caster:FindModifierByName("modifier_technologist_energy")
    mod:ModifyStacks(-self:GetManaCost(-1))

    local diode = Dummies:ActivateDummy(Caster)
    diode:SetAbsOrigin(Caster:GetAbsOrigin())
   	diode:SetOriginalModel("models/heroes/techies/fx_techiesfx_stasis.vmdl")
	diode:SetModel("models/heroes/techies/fx_techiesfx_stasis.vmdl")

	Leap(diode, point, 300, 1000, time, true, function(unit)
		StartAnimation(unit, {duration = 1, activity=ACT_DOTA_DIE, rate=1}) --animations.lua function
		Timers:CreateTimer(1, function()
			FreezeAnimation(unit)
		end)
		StartBeam(unit)
    end)
end



function StartBeam(diode)

	local Caster = diode.master
	local ability = Caster:FindAbilityByName("customability_technologist_closed_circuit")
	local speed = 1000
	local collisionRadius = 30
--	local dmg = Caster:GetIntellect() * ability.damagePerc		--Get Intelligence scaled
	local dmg_interval = ability:GetSpecialValueFor("dmg_interval")
	local base_dmg = ability:GetSpecialValueFor("base_dmg")
	local int_dmg = Caster:GetIntellect() * ability:GetSpecialValueFor("int_dmg_level")/100 * ability:GetLevel()
	local dmg_per_sec = (base_dmg + int_dmg )
	local dmg = math.ceil((base_dmg + int_dmg ) * dmg_interval )
	local firedcount = 1
	local hitcount = 0
--	print("dmg_interval = "..dmg_interval)
	print("damage per second = "..dmg_per_sec)
	print("damage per tick = "..dmg)

	diode.beamParticle = CreateBeamParticle(diode, Caster)

	-- A timer running every second that starts 5 seconds in the future, respects pauses
	Timers:CreateTimer(.1, function()
		if firedcount > 40 then
			return false 
		end

	    local dummy = Dummies:ActivateDummy(Caster)
	    dummy:SetAbsOrigin(diode:GetAbsOrigin())
	    --local debug = ParticleManager:CreateParticle("particles/units/heroes/hero_wisp/wisp_guardian.vpcf", PATTACH_ABSORIGIN_FOLLOW, dummy)
		Physics:Unit(dummy)
		dummy:SetGroundBehavior(PHYSICS_GROUND_LOCK)
        dummy:SetNavCollisionType(PHYSICS_NAV_NOTHING)
        dummy:SetStaticVelocity("closed_circuit_projectile", (Caster:GetAbsOrigin() - dummy:GetAbsOrigin()):Normalized() * speed)

        Timers:CreateTimer( dmg_interval , function()
        	Caster:AddNewModifier(Caster, ability, "modifier_technologist_energized_failsafe", {duration = 10})
        	local units = FindUnitsInRadius( Caster:GetTeamNumber(), dummy:GetAbsOrigin(), nil, collisionRadius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
			if units[1] then
				--Create beam particle attached to Target
				diode.beamParticle = CreateBeamParticle(diode, units[1])

				--Apply 1 stack of Energized
				units[1]:AddNewModifier(Caster, ability, "modifier_technologist_energized", {})

				DealDamage(Caster, units[1], dmg, DAMAGE_TYPE_MAGICAL, nil)
--				PopupNumbersFilter("shock",units[1], dmg, Caster)

				Dummies:DeactivateDummy(dummy)

				hitcount = hitcount + 1

				if hitcount > 39 then
					ParticleManager:DestroyParticle(diode.beamParticle, false)
					Timers:CreateTimer(1, function()
						diode:RemoveSelf()
					end)
				end
				return false
			end

        	--Check if in range of Caster
        	if (dummy:GetAbsOrigin() - Caster:GetAbsOrigin()):Length2D() > 75 then
	        	dummy:SetStaticVelocity("closed_circuit_projectile", (Caster:GetAbsOrigin() - dummy:GetAbsOrigin()):Normalized() * speed)
	        else
	        	--Create beam particle attached to Caster
	        	diode.beamParticle = CreateBeamParticle(diode, Caster)

	        	--Add 1 mana/energy
	        	local mod = Caster:FindModifierByName("modifier_technologist_energy")
			    mod:ModifyStacks(1)
--			    PopupNumbersFilter("energy",  Caster, 1, Caster )

	        	Dummies:DeactivateDummy(dummy)

	        	hitcount = hitcount + 1

				if hitcount > 39 then
					ParticleManager:DestroyParticle(diode.beamParticle, false)
					Timers:CreateTimer(1, function()
						diode:RemoveSelf()
					end)
				end
	        	return false
	        end
		    return dmg_interval
		end)

		firedcount = firedcount + 1
	    return .1
	end)
end

function CreateBeamParticle(diode, Target)
	if not diode.beamParticle then
		diode.beamParticle = ParticleManager:CreateParticle("particles/technologist/closed_circuit.vpcf", PATTACH_ABSORIGIN_FOLLOW, diode)
	end
	ParticleManager:SetParticleControlEnt(diode.beamParticle,1,Target,PATTACH_POINT_FOLLOW,"attach_hitloc",Target:GetAbsOrigin(),true)
	return diode.beamParticle
end