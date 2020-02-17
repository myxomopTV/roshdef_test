
-- Set the units looking at the same point of the caster
function SquadSummon( event )

	local caster = event.caster
	local ability = event.ability
	local point = caster:GetAbsOrigin()
	local team = caster:GetTeam()
	local ability_level = ability:GetLevel() - 1
	
	if ability_level+1 <= 4 
		then
			local unit_name = "npc_dota_spartacus_soldier1"
			local name = "soldier"
				for i=1,2 do
					local unit = CreateUnitByName( unit_name, point, true, caster, caster, team )
						SetUnitStats(name,unit,event)
					local ability1= unit:FindAbilityByName("spartacus_sword_of_vengance")
					ability1:SetLevel(ability_level+1)					
						  
				end
			local unit_name = "npc_dota_spartacus_mage1"
			local name = "mage"
				for i=1,2 do
					local unit = CreateUnitByName( unit_name, point, true, caster, caster, team )
					SetUnitStats(name,unit,event)
					local ability1= unit:FindAbilityByName("creature_magic_attack")
					ability1:SetLevel(1)					
						  
				end				
		else
			local unit_name = "npc_dota_spartacus_soldier2"
			local name = "soldier"
				for i=1,2 do
					local unit = CreateUnitByName( unit_name, point, true, caster, caster, team )
					SetUnitStats(name,unit,event)
					local ability1= unit:FindAbilityByName("spartacus_sword_of_vengance")
					ability1:SetLevel(ability_level+1)
				end		
			local unit_name = "npc_dota_spartacus_mage2"
			local name = "mage"
				for i=1,2 do
					local unit = CreateUnitByName( unit_name, point, true, caster, caster, team )
					SetUnitStats(name,unit,event)
					local ability1= unit:FindAbilityByName("creature_magic_attack")
					ability1:SetLevel((ability_level+1)/2.5+1)
					if ability_level>3 then 
						local ability2= unit:FindAbilityByName("true_strike_datadriven")
						ability2:SetLevel(1)
					end
				end	

	end

	if ability_level+1 >= 2 
		then
			local unit_name = "npc_dota_spartacus_siege"
			local name = "siege"
				
					local unit = CreateUnitByName( unit_name, point, true, caster, caster, team )
						SetUnitStats(name,unit,event)
					local ability1= unit:FindAbilityByName("lone_druid_spirit_bear_demolish")
					ability1:SetLevel(ability_level+1)					
					local ability2= unit:FindAbilityByName("black_dragon_splash_attack")
					ability2:SetLevel((ability_level+1)/4)					
					local ability3= unit:FindAbilityByName("true_strike_datadriven")
					ability3:SetLevel((ability_level+1)/5)					
						  
				

	end
	
	if ability_level+1 >= 3
		then
			local unit_name = "npc_dota_spartacus_commander"
			local name = "commander"
				
					local unit = CreateUnitByName( unit_name, point, true, caster, caster, team )
						SetUnitStats(name,unit,event)
					local ability1= unit:FindAbilityByName("spartacus_sword_of_vengance")
					ability1:SetLevel(ability_level+3)					
					local ability2= unit:FindAbilityByName("commander_aura")
					ability2:SetLevel(ability_level-1)					
						  						  
				
	end
end
	
function SetUnitStats(name,target,event)
	
	local caster = event.caster
	local ability = event.ability
	local ability_level = ability:GetLevel() - 1
	local dmg_per_strenght = ability:GetLevelSpecialValueFor("dmg_per_str_"..name, ability:GetLevel() - 1)
	local hp_per_strenght = ability:GetLevelSpecialValueFor("hp_per_str_"..name, ability:GetLevel() - 1) 
	local player = caster:GetPlayerID()
	local fv = caster:GetForwardVector()
	local summon_duration = ability:GetLevelSpecialValueFor("summon_duration", ability:GetLevel() - 1)

	target:AddNewModifier( caster, ability, "modifier_kill", { duration = summon_duration } )
	target:SetControllableByPlayer(player, false)
	target:SetOwner(caster)
	target:SetForwardVector(fv)

	local strenght = caster:GetStrength()
--	local agility = caster:GetAgility()
--	local intellegence = caster:GetIntellect()

	local base_hp = ability:GetLevelSpecialValueFor("base_hp_"..name, ability_level)
	local base_dmg = ability:GetLevelSpecialValueFor("base_dmg_"..name, ability_level)
	local base_armor = ability:GetLevelSpecialValueFor("base_armor_"..name, ability_level)
--	local bat = ability:GetLevelSpecialValueFor("summon_bat", ability_level)
	
	target:SetBaseDamageMin(base_dmg + strenght*dmg_per_strenght )
	target:SetBaseDamageMax(base_dmg + strenght*dmg_per_strenght )				
	target:SetPhysicalArmorBaseValue( base_armor )
	target:SetBaseMaxHealth(base_hp+ strenght*hp_per_strenght )
	target:SetMaxHealth(base_hp+ strenght*hp_per_strenght )
	target:SetHealth(base_hp+ strenght*hp_per_strenght )
--	target:SetBaseAttackTime(bat)

end

