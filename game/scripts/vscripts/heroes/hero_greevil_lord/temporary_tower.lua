high_towers = {
	"npc_dota_greevil_lord_tower_4",
	"npc_dota_greevil_lord_tower_fire",
	"npc_dota_greevil_lord_tower_ice",
	"npc_dota_greevil_lord_tower_earth",
	"npc_dota_greevil_lord_tower_storm",
}

function BuildTower( event )
	local point = event.target_points[1]
	local caster = event.caster
	local player = caster:GetPlayerID()
	local ability = event.ability
	local level = ability:GetLevel()
	local unit_name = "npc_dota_greevil_lord_tower_temp"
	
	if level >= 5 then
		local index = RandomInt(1,#high_towers)
		unit_name = high_towers[index]
	end
		
	local base_hp = ability:GetSpecialValueFor("base_hp")
	local base_dmg = ability:GetSpecialValueFor("base_dmg")
	local base_armor = ability:GetSpecialValueFor("base_armor")
	local duration = ability:GetSpecialValueFor("duration") 
	
	
	local tower = CreateUnitByName(unit_name, point, true, caster, caster, caster:GetTeamNumber())
	tower:SetControllableByPlayer(player, true)
	tower:AddNewModifier(caster,ability,"modifier_kill",{duration = duration})
	tower:AddNewModifier(caster,ability,"modifier_phased",{duration = 0.01})

	local new_hp = base_hp

	tower:SetBaseDamageMin(base_dmg )
	tower:SetBaseDamageMax(base_dmg  )				
	tower:SetPhysicalArmorBaseValue(base_armor )
	tower:SetMaxHealth( new_hp )
	tower:SetBaseMaxHealth( new_hp )
	tower:SetHealth( new_hp )

	ability:ApplyDataDrivenModifier(caster, tower, "modifier_tower_bonus", nil)
	
end

