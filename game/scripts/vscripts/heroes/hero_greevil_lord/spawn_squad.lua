LinkLuaModifier("modifier_greevil_unit_upgrade", "heroes/hero_greevil_lord/upgrade_unit", LUA_MODIFIER_MOTION_NONE)

function SpawnSquad(event)
	local ability = event.ability
	local caster = event.caster
	local point = caster:GetAbsOrigin()
	local player = caster:GetPlayerOwnerID() 
	local hero = PlayerResource:GetSelectedHeroEntity(player) or caster:GetOwner()

	local unit_name = "npc_dota_greevil_lord_unit_weak"
	local spawn_duration = ability:GetSpecialValueFor("duration")
	local base_hp = ability:GetSpecialValueFor("base_hp")
	local base_dmg = ability:GetSpecialValueFor("base_dmg")
	local base_armor = ability:GetSpecialValueFor("base_armor")
	local unit_count = ability:GetSpecialValueFor("unit_count")
	print(unit_name)
	print(spawn_duration)
	print(base_hp)
	print(base_dmg)
	print(base_armor)
	print(unit_count)
	
	for i=1, unit_count do
		local unit = CreateUnitByName(unit_name, point, true, caster, caster, caster:GetTeamNumber())
		unit:SetControllableByPlayer(player, true)
		unit:SetOwner(hero)

		local new_hp = base_hp 

		unit:SetBaseDamageMin(base_dmg )
		unit:SetBaseDamageMax(base_dmg )				
		unit:SetPhysicalArmorBaseValue(base_armor )
		unit:SetMaxHealth( new_hp )
		unit:SetBaseMaxHealth( new_hp )
		unit:SetHealth( new_hp )
		
		unit:AddNewModifier(unit, nil, "modifier_greevil_unit_upgrade", nil)
		unit:AddNewModifier(caster,ability,"modifier_kill",{duration = spawn_duration})
		unit:AddNewModifier(caster,ability,"modifier_phased",{duration = 0.1})
	end
end


