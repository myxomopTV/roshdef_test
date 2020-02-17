require ("abilities/basic")

function SpiritBearSpawn( event )
	local caster = event.caster
	local player = caster:GetPlayerID()
	local ability = event.ability
	local level = ability:GetLevel()
	local origin = caster:GetAbsOrigin() + RandomVector(100)

	-- Set the unit name, concatenated with the level number
	local unit_name = event.unit_name


	-- Check if the bear is alive, heals and spawns them near the caster if it is
	if  caster.bear and IsValidEntity(caster.bear) and caster.bear:IsAlive() then
		FindClearSpaceForUnit(caster.bear, origin, true)
		caster.bear:SetHealth(caster.bear:GetMaxHealth())
	
		-- Spawn particle
		local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_lone_druid/lone_druid_bear_spawn.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster.bear)	


		
	else
		
----[[		
		if caster.bear then 	
			local unit = caster.bear
			item_table = {}
			for i = 0, 8 do
				local item = unit:GetItemInSlot( i )

				if item ~= nil then  		
					table.insert(item_table , item)
				end				
			end	
		end
--]]
		-- Create the unit and make it controllable
		caster.bear = CreateUnitByName(unit_name, origin, true, caster, caster, caster:GetTeamNumber())
		caster.bear:SetControllableByPlayer(player, true)
		caster.bear:SetUnitCanRespawn(true)
		local ability_level = ability:GetLevel()

		local strenght = caster:GetStrength()
		local agility = caster:GetAgility()
		local intellegence = caster:GetIntellect()

		local base_hp = ability:GetSpecialValueFor("summon_hp")
		local base_hpreg = ability:GetSpecialValueFor("summon_hpreg")
		local base_dmg = ability:GetSpecialValueFor("summon_dmg")
		local base_armor = ability:GetSpecialValueFor("summon_armor")
		local dmg_per_agility = ability:GetSpecialValueFor("dmg_per_agi")
		local hp_per_strenght = ability:GetSpecialValueFor("hp_per_str")
		local model_scale = ability:GetSpecialValueFor("summon_scale")
		local fv = caster:GetForwardVector()
		caster.bear:SetForwardVector(fv)
		
		caster.bear:SetBaseMaxHealth(base_hp + strenght*hp_per_strenght )
		caster.bear:SetMaxHealth(base_hp + strenght*hp_per_strenght )
		caster.bear:SetHealth(base_hp + strenght*hp_per_strenght )
		caster.bear:SetBaseHealthRegen(base_hpreg)
		caster.bear:SetBaseDamageMin(base_dmg + agility*dmg_per_agility )
		caster.bear:SetBaseDamageMax(base_dmg + agility*dmg_per_agility )				
		caster.bear:SetPhysicalArmorBaseValue(base_armor)
		caster.bear:SetModelScale(model_scale)
		
		SetLevelForSubAbility(ability, "lone_druid_spirit_bear_return", caster.bear, 1, 1)
		SetLevelForSubAbility(ability, "lone_druid_spirit_bear_resist", caster.bear, 1, nil)
		SetLevelForSubAbility(ability, "lone_druid_spirit_bear_vitality", caster.bear, 6, 1)

		local items = item_table or {}
		for _,item in pairs(items) do	
			 caster.bear:AddItem(item)
		 end
		-- Apply the backslash on death modifier
		if ability ~= nil then
			ability:ApplyDataDrivenModifier(caster, caster.bear, "modifier_spirit_bear", nil)
			caster.bear:AddNewModifier(caster, ability, "modifier_lone_druid_spirit_bear_attack_check", nil)
		end
	end

end

--[[
	Author: Noya
	Date: 15.01.2015.
	When the skill is leveled up, try to find the casters bear and replace it by a new one on the same place
]]
function SpiritBearLevel( event )
	local caster = event.caster
	local player = caster:GetPlayerID()
	local ability = event.ability
	local level = ability:GetLevel()
	local unit_name = event.unit_name

	print("Level Up Bear")


	if caster.bear and caster.bear:IsAlive() then 
		-- Remove the old bear in its position
		local origin = caster.bear:GetAbsOrigin()
		local health_pct = caster.bear:GetHealth()/caster.bear:GetMaxHealth()
		-- Create the unit and make it controllable
		
		local strenght = caster:GetStrength()
		local agility = caster:GetAgility()
		local intellegence = caster:GetIntellect()

		local base_hp = ability:GetSpecialValueFor("summon_hp")
		local base_hpreg = ability:GetSpecialValueFor("summon_hpreg")
		local base_dmg = ability:GetSpecialValueFor("summon_dmg")
		local base_armor = ability:GetSpecialValueFor("summon_armor")
		local dmg_per_agility = ability:GetSpecialValueFor("dmg_per_agi")
		local hp_per_strenght = ability:GetSpecialValueFor("hp_per_str")
		local model_scale = ability:GetSpecialValueFor("summon_scale")
		local fv = caster:GetForwardVector()
		caster.bear:SetForwardVector(fv)
		
		caster.bear:SetBaseMaxHealth(base_hp + strenght*hp_per_strenght )
		caster.bear:SetMaxHealth(base_hp + strenght*hp_per_strenght )
		caster.bear:SetHealth(health_pct*caster.bear:GetMaxHealth())
		caster.bear:SetBaseHealthRegen(base_hpreg)
		caster.bear:SetBaseDamageMin(base_dmg + agility*dmg_per_agility )
		caster.bear:SetBaseDamageMax(base_dmg + agility*dmg_per_agility )				
		caster.bear:SetPhysicalArmorBaseValue(base_armor)
		caster.bear:SetModelScale(model_scale)
		
		SetLevelForSubAbility(ability, "lone_druid_spirit_bear_return", caster.bear, 1, 1)
		SetLevelForSubAbility(ability, "lone_druid_spirit_bear_resist", caster.bear, 1, nil)
		SetLevelForSubAbility(ability, "lone_druid_spirit_bear_vitality", caster.bear, 6, 1)

		-- Apply the backslash on death modifier
		ability:ApplyDataDrivenModifier(caster, caster.bear, "modifier_spirit_bear", nil)
		caster.bear:AddNewModifier(caster, ability, "modifier_lone_druid_spirit_bear_attack_check", nil)
--		caster.bear:AddNewModifier(caster, ability, "modifier_spirit_bear_attack_damage", nil)

		-- Learn its abilities: return lvl 2, entangle lvl 3, demolish lvl 4. By Index
	end
end

-- Do a percentage of the caster health then the spawned unit takes fatal damage
function SpiritBearDeath( event )
	local caster = event.caster
	local killer = event.attacker
	local ability = event.ability
	local casterHP = caster:GetMaxHealth()
	local backlash_damage = ability:GetLevelSpecialValueFor( "backlash_damage", ability:GetLevel() - 1 ) * 0.01

	-- Calculate and do the damage
	local damage = casterHP * backlash_damage

	ApplyDamage({ victim = caster, attacker = killer, damage = damage, damage_type = DAMAGE_TYPE_PURE })
end


