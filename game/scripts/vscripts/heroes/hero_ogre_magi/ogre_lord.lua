--[[
	Author: Noya
	Date: 15.01.2015.
	Spawns a unit with different levels of the unit_name passed
	Each level needs a _level unit inside npc_units or npc_units_custom.txt
]]
function SpiritBearSpawn1( event )
	local caster = event.caster
	local player = caster:GetPlayerID()
	local ability = event.ability
	local level = ability:GetLevel()
	local origin = caster:GetAbsOrigin() + RandomVector(100)

	local armor_per_agility = ability:GetLevelSpecialValueFor("armor_per_agi", ability:GetLevel() - 1)
	local dmg_per_intellect = ability:GetLevelSpecialValueFor("dmg_per_int", ability:GetLevel() - 1)
	local hp_per_strenght = ability:GetLevelSpecialValueFor("hp_per_str", ability:GetLevel() - 1) 
	
	-- Set the unit name, concatenated with the level number
	local unit_name = event.unit_name
	unit_name = unit_name..level

		-- Check if the bear is alive, heals and spawns them near the caster if it is
		-- Create the unit and make it controllable
		caster.bear = CreateUnitByName(unit_name, origin, true, caster, caster, caster:GetTeamNumber())
		caster.bear:SetControllableByPlayer(player, true)
		
		local strenght = caster:GetStrength()
		local agility = caster:GetAgility()
		local intellegence = caster:GetIntellect()
		
		caster.bear:SetBaseDamageMin(caster.bear:GetBaseDamageMin() + intellegence*dmg_per_intellect )
		caster.bear:SetBaseDamageMax(caster.bear:GetBaseDamageMax() + intellegence*dmg_per_intellect )				
		caster.bear:SetPhysicalArmorBaseValue(caster.bear:GetPhysicalArmorBaseValue() + agility*armor_per_agility )
		caster.bear:SetMaxHealth(caster.bear:GetMaxHealth()+ strenght*hp_per_strenght )
		caster.bear:SetBaseMaxHealth(caster.bear:GetMaxHealth()+ strenght*hp_per_strenght )
		caster.bear:SetHealth(caster.bear:GetMaxHealth())

end

function SpiritBearSpawn( event )
	local caster = event.caster
	local player = caster:GetPlayerID()
	local ability = event.ability
	local level = ability:GetLevel()
	local origin = caster:GetAbsOrigin() + RandomVector(100)

	local armor_per_agility = ability:GetLevelSpecialValueFor("armor_per_agi", ability:GetLevel() - 1)
	local dmg_per_intellect = ability:GetLevelSpecialValueFor("dmg_per_int", ability:GetLevel() - 1)
	local hp_per_strenght = ability:GetLevelSpecialValueFor("hp_per_str", ability:GetLevel() - 1) 
	
	-- Set the unit name, concatenated with the level number
	local unit_name = event.unit_name
	unit_name = unit_name..level
	local targets = caster.wolves or {}

		for _,unit in pairs(targets) do	
		if unit and IsValidEntity(unit) then
			unit:ForceKill(true)
			end
		end
		-- Check if the bear is alive, heals and spawns them near the caster if it is
		-- Create the unit and make it controllable
		unit = CreateUnitByName(unit_name, origin, true, caster, caster, caster:GetTeamNumber())
		unit:SetControllableByPlayer(player, true)
		caster.wolves = {}
		table.insert(caster.wolves, unit)		

		local strenght = caster:GetStrength()
		local agility = caster:GetAgility()
		local intellegence = caster:GetIntellect()
		local new_hp = unit:GetMaxHealth()+ strenght*hp_per_strenght

		unit:SetBaseDamageMin(unit:GetBaseDamageMin() + intellegence*dmg_per_intellect )
		unit:SetBaseDamageMax(unit:GetBaseDamageMax() + intellegence*dmg_per_intellect )				
		unit:SetPhysicalArmorBaseValue(unit:GetPhysicalArmorBaseValue() + agility*armor_per_agility )
		unit:SetMaxHealth( new_hp )
		unit:SetBaseMaxHealth( new_hp )
		unit:SetHealth( new_hp )


		-- Apply the synergy buff if the ability existt
		-- Learn its abilities: return lvl 2, entangle lvl 3, demolish lvl 4. By Index
end

function KillWolves( event )
	local caster = event.caster
	local targets = caster.wolves or {}
for _,unit in pairs(targets) do	
	if unit and IsValidEntity(unit) then
		unit:ForceKill(true)
		end
	end
-- Reset table
caster.wolves = {}
end

