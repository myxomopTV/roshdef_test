--[[Author: YOLOSPAGHETTI
	Date: February 4, 2016
	Checks if Riki is behind his target
	Borrows heavily from bristleback.lua]]
	
function CheckBackstab(params)
	
	local caster = params.caster
	local target = params.target
	local ability = params.ability
	if target:GetUnitName() == "npc_dota_damage_tester" or target:IsBuilding() then
		return
	end
	
	local agility_damage_multiplier = ability:GetSpecialValueFor("agility_damage") / 100
	local previous_stack_count = 0
	-- The y value of the angles vector contains the angle we actually want: where units are directionally facing in the world.
	local victim_angle = params.target:GetAnglesAsVector().y
	local origin_difference = params.target:GetAbsOrigin() - params.attacker:GetAbsOrigin()

	-- Get the radian of the origin difference between the attacker and Riki. We use this to figure out at what angle the victim is at relative to Riki.
	local origin_difference_radian = math.atan2(origin_difference.y, origin_difference.x)
	
	-- Convert the radian to degrees.
	origin_difference_radian = origin_difference_radian * 180
	local attacker_angle = origin_difference_radian / math.pi
	-- Makes angle "0 to 360 degrees" as opposed to "-180 to 180 degrees" aka standard dota angles.
	attacker_angle = attacker_angle + 180.0
	
	-- Finally, get the angle at which the victim is facing Riki.
	local result_angle = attacker_angle - victim_angle
	result_angle = math.abs(result_angle)
	
	
	-- Check for the backstab angle.
	if result_angle >= (180 - (ability:GetSpecialValueFor("backstab_angle") / 2)) and result_angle <= (180 + (ability:GetSpecialValueFor("backstab_angle") / 2)) then 
		-- Play the sound on the victim.
		EmitSoundOn(params.sound, target)
		
		previous_stack_count = 0
		local damage = caster:GetAgility() * agility_damage_multiplier

		if caster:HasModifier("modifier_slark_essence_shift_datadriven_buff_counter") then
			previous_stack_count = caster:GetModifierStackCount("modifier_slark_essence_shift_datadriven_buff_counter", caster)
			
			--We have to remove and replace the modifier so the duration will refresh (so it will show the duration of the latest Essence Shift).
			caster:RemoveModifierByNameAndCaster("modifier_slark_essence_shift_datadriven_buff_counter", caster)
		end
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_slark_essence_shift_datadriven_buff_counter", nil)
		caster:SetModifierStackCount("modifier_slark_essence_shift_datadriven_buff_counter", caster, previous_stack_count + 1)
		
		--Apply an Agility buff for Slark.
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_slark_essence_shift_datadriven_buff", nil)
		-- Create the back particle effect.
		local particle = ParticleManager:CreateParticle(params.particle, PATTACH_ABSORIGIN_FOLLOW, target) 
		-- Set Control Point 1 for the backstab particle; this controls where it's positioned in the world. In this case, it should be positioned on the victim.
		ParticleManager:SetParticleControlEnt(particle, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true) 
		-- Apply extra backstab damage based on Riki's agility
		ApplyDamage({victim = target, attacker = caster, damage = damage, damage_type = ability:GetAbilityDamageType(),damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION })
	end
end

function modifier_slark_essence_shift_datadriven_buff_on_destroy(keys)
	if keys.caster:HasModifier("modifier_slark_essence_shift_datadriven_buff_counter") then
		local previous_stack_count = keys.caster:GetModifierStackCount("modifier_slark_essence_shift_datadriven_buff_counter", keys.caster)
		if previous_stack_count > 1 then
			keys.caster:SetModifierStackCount("modifier_slark_essence_shift_datadriven_buff_counter", keys.caster, previous_stack_count - 1)
		else
			keys.caster:RemoveModifierByNameAndCaster("modifier_slark_essence_shift_datadriven_buff_counter", keys.caster)
		end
	end
end