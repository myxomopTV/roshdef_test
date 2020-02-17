function ChickenRush( keys )

	local ability = keys.ability
	local caster = keys.caster
	local chicken_count = ability:GetSpecialValueFor( "chicken_count" )
	local interval = ability:GetSpecialValueFor( "spawn_interval" )
	local chicken_duration = ability:GetSpecialValueFor( "chicken_duration" )

	local unit_name = "npc_dota_mad_chicken"--..RandomOrder[i]
	EmitSoundOn("ChickenRush", caster)
	
	for i=1,chicken_count do
		Timers:CreateTimer(interval*i, function ()
			local chicken = CreateUnitByName(unit_name, caster:GetAbsOrigin(), true, caster, caster, caster:GetTeam())
			chicken:AddNewModifier(caster, ability, "modifier_phased", nil)
			chicken:AddNewModifier(caster, ability, "modifier_kill", {duration = chicken_duration})
--			chicken:SetControllableByPlayer(caster:GetPlayerID(), true)
		end)
	end
	
end

--sounds/weapons/hero/vengeful_spirit/chicken_dance.vsnd
--sounds/weapons/hero/skywrath/taunt_chicken.vsnd
--sounds/ambient/chicken.vsnd