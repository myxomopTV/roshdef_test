
function IcefrogRitualStart( keys )
	local caster = keys.caster
	local player = caster:GetPlayerOwner()
	local ability = keys.ability
	local unit_name = caster:GetUnitName()

	local time = 0
	local maxTime = 25

	-- Mango count
	local mango_3_count = 6
	local mango_2_count = 2
	local mango_1_count = 5
	local mango_count = 1

	-- Mango circle
	local mango_3_circumference = 6 -- x6 rows
	local mango_2_circumference = 9 -- x3 rows
	local mango_1_circumference = 3 -- x1 rows
	local mango_circumference = 3

	-- Mango rows
	local mango_3_rows = 6
	local mango_2_rows = 4
	local mango_1_rows = 2

	-- Mango circle radius
	local mango_3_radius = 900
	local mango_2_radius = 500
	local mango_1_radius = 425
	local mango_radius = 128

	-- Mango spread distance
	local mango_3_spread = 50
	local mango_2_spread = 25
	local mango_1_spread = 32.2

	local point = keys.target_points[1]
	local forwardVec = keys.caster:GetForwardVector()
	ability:CreateVisibilityNode(point, mango_3_radius + 322, maxTime + 10)

	-- Mango delay
	local delay3 = 5
	local delay2 = 3.5
	local delay1 = 2.5
	local delay = 1

	-- Camera effects
	local camera_distance = 1200
	local cameraDelay = 5


	-- PART 1 - Spawning the Mangos
	local item = CreateItem("item_enchanted_mango_ritual",nil,nil)
	local drop = CreateItemOnPositionForLaunch(point, item)
	item:LaunchLoot(false, 322, 0.75, point)
	Timers:CreateTimer(maxTime, function()
		if not item:IsNull() then
			item:Kill()
			if not drop:IsNull() then drop:Kill() end
		end
	end)

	Timers:CreateTimer(delay2, function()
		GridNav:DestroyTreesAroundPoint(point, 600, true)
	end)

	local rotateVar3 = 0
	local spreadVar3 = 0
	local rotateOffsetVar3 = 0
	local spreadAngle3 = 0

	for i = 1, mango_3_count do
		for j = 0, mango_3_circumference do
			for k = 0, mango_3_rows do
				local rotate_distance = point + forwardVec * (mango_3_radius + spreadVar3)

				local rotate_angle = QAngle(0,rotateVar3 + rotateOffsetVar3 + spreadAngle3,0)
				rotateVar3 = rotateVar3 + 360/mango_3_circumference
				local rotate_position = RotatePosition(point, rotate_angle, rotate_distance)

				Timers:CreateTimer(delay3, function()
					local item = CreateItem("item_enchanted_mango_ritual",nil,nil)
					local drop = CreateItemOnPositionForLaunch(point, item)
					item:LaunchLoot(false, 750, delay3 / 5, rotate_position)
					Timers:CreateTimer(maxTime, function()
						if not item:IsNull() then
							item:Kill()
							if not drop:IsNull() then drop:Kill() end
						end
					end)
				end)	
			end
			spreadAngle3 = spreadAngle3 + 2
			delay3 = delay3 + 0.1
			spreadVar3 = spreadVar3 + mango_3_spread

		end
		rotateOffsetVar3 = rotateOffsetVar3 + 5
		spreadVar3 = 0
	end

	local rotateVar2 = 0
	local spreadVar2 = 0
	local spreadAngle2 = 0
	for i=1, mango_2_count do
		rotateVar2 = rotateVar2 + 30
	    spreadVar2 = 0
		for j = 0, mango_2_circumference do
			for k = 0, mango_2_rows do
				local rotate_distance = point + forwardVec * (mango_2_radius + spreadVar2)

				local rotate_angle = QAngle(0,rotateVar2 + spreadAngle2,0)
				rotateVar2 = rotateVar2 + 360/mango_2_circumference
				local rotate_position = RotatePosition(point, rotate_angle, rotate_distance)

				Timers:CreateTimer(delay2, function()
					local item = CreateItem("item_enchanted_mango_ritual",nil,nil)
					local drop = CreateItemOnPositionForLaunch(point, item)
					item:LaunchLoot(false, 322, 0.75, rotate_position)
					Timers:CreateTimer(maxTime, function()
						if not item:IsNull() then
							item:Kill()
							if not drop:IsNull() then drop:Kill() end
						end
					end)
				end)
			end
			spreadAngle2 = spreadAngle2 - 1
			delay2 = delay2 + 0.1
			spreadVar2 = spreadVar2 + mango_2_spread
		end
	end

	local rotateVar1 = 0
	local rotateOffsetVar1 = 0
	local spreadVar1 = 0
	local spreadAngle1 = 0
	for i=1, mango_1_count do
		rotateVar1 = rotateVar1 + 30
		spreadVar1 = 0
		for j = 0, mango_1_circumference do
			for k = 0, mango_1_rows do
				local rotate_distance = point + forwardVec * (mango_1_radius + spreadVar1)

				local rotate_angle = QAngle(0,rotateVar1 + spreadAngle1 + rotateOffsetVar1,0)
				rotateVar1 = rotateVar1 + 360/mango_1_circumference
				local rotate_position = RotatePosition(point, rotate_angle, rotate_distance)

				Timers:CreateTimer(delay1, function()
					local item = CreateItem("item_enchanted_mango_ritual",nil,nil)
					local drop = CreateItemOnPositionForLaunch(point, item)
					item:LaunchLoot(false, 322, 0.75, rotate_position)
					Timers:CreateTimer(maxTime, function()
						if not item:IsNull() then
							item:Kill()
							if not drop:IsNull() then drop:Kill() end
						end
					end)
				end)
			end
			spreadAngle1 = spreadAngle1 + 10
			delay1 = delay1 + 0.05
			spreadVar1 = spreadVar1
		end
		rotateOffsetVar1 = rotateOffsetVar1 + 15
	end

	for i=1, mango_count do
		local rotateVar = 0
		for j = 0, mango_circumference do
			local rotate_distance = point + forwardVec * mango_radius

			local rotate_angle = QAngle(0,rotateVar,0)
			rotateVar = rotateVar + 360/mango_circumference
			local rotate_position = RotatePosition(point, rotate_angle, rotate_distance)

			Timers:CreateTimer(delay, function()
				local item = CreateItem("item_enchanted_mango_ritual",nil,nil)
				local drop = CreateItemOnPositionForLaunch(point, item)
				item:LaunchLoot(false, 322, 0.75, rotate_position)
				Timers:CreateTimer(maxTime, function()
					if not item:IsNull() then
						item:Kill()
						if not drop:IsNull() then drop:Kill() end
					end
				end)
			end)
		end
	end


	-- PART 2 - Dynamic Camera Changes

	Timers:CreateTimer(0, function()
		time = time + 1/30

		if time < maxTime then
			return 1/30
		else
			return nil
		end
	end)

	camera_distance = 2400
	GameRules:GetGameModeEntity():SetCameraDistanceOverride( camera_distance )



	-- PART 3 - Spawning heroes to autocast spells
	-- Setup a table of potential spawn positions

	-- Spawn Count
	local pugnaCount = 5
	local scawCount = 9
	-- Spawn Rows
	local scawRow = 2

	-- Spawn Radius
	local pugnaRadius = 900
	local scawRadius = 600
	local rotateVar = 0

	-- Spawn delay
	local pugnaDelay = 3
	local scawDelay = 16
	
	
	-- Spawn pugnas
	local vSpawnPosPugna = {}
	for i=1, pugnaCount do
		local rotate_distance = point + forwardVec * pugnaRadius
		local rotate_angle = QAngle(0,rotateVar,0)
		rotateVar = rotateVar + 360/pugnaCount
		local rotate_position = RotatePosition(point, rotate_angle, rotate_distance)
		table.insert(vSpawnPosPugna, rotate_position)
	end

	local pugna = {}

	for j = 1, pugnaCount do
		Timers:CreateTimer(pugnaDelay, function()
			local origin = table.remove( vSpawnPosPugna, 1 )
			local illusionForwardVec = (point - origin):Normalized()

			-- handle_UnitOwner needs to be nil, else it will crash the game.
			pugna[j] = CreateUnitByName("ritual_pugna", origin, false, caster, nil, caster:GetTeamNumber())
			pugna[j]:SetForwardVector((point - origin):Normalized())
			
			pugna[j]:AddAbility("ritual_pugna_life_drain")
			local lifeDrain = pugna[j]:FindAbilityByName("ritual_pugna_life_drain")
			lifeDrain:SetLevel(3)


			-- Set the unit as an illusion
			-- modifier_illusion controls many illusion properties like +Green damage not adding to the unit damage, not being able to cast spells and the team-only blue particle
			pugna[j]:AddNewModifier(caster, ability, "modifier_kill", { duration = maxTime - pugnaDelay, outgoing_damage = outgoingDamage, incoming_damage = incomingDamage })
			ability:ApplyDataDrivenModifier(caster, pugna[j], "modifier_icefrogged", {})

			-- Sets the illusion to begin channeling Fire Bomb
			if j > pugnaCount - 2 then
				Timers:CreateTimer( 0.322, function()
					pugna[j]:CastAbilityOnTarget(pugna[j + 2 - pugnaCount], lifeDrain, -1 )
				end)
			else
				Timers:CreateTimer( 0.322, function()
					pugna[j]:CastAbilityOnTarget(pugna[j + 2], lifeDrain, -1 )
				end)
			end
		end)
		pugnaDelay = pugnaDelay + 0.05
	end

	-- Spawn Scawmars
	local vSpawnPosScaw = {}
	for j = 1, scawRow do
		for i=1, scawCount do
			local rotate_distance = point + forwardVec * scawRadius
			local rotate_angle = QAngle(0,rotateVar,0)
			rotateVar = rotateVar + 360/scawCount
			local rotate_position = RotatePosition(point, rotate_angle, rotate_distance)
			table.insert(vSpawnPosScaw, rotate_position)
		end
		scawRadius = scawRadius + 322
	end

	for j = 1, scawRow do
		for k = 1, scawCount do
			Timers:CreateTimer(scawDelay, function()
				local origin = table.remove( vSpawnPosScaw, 1 )
				local illusionForwardVec = (point - origin):Normalized()

				-- handle_UnitOwner needs to be nil, else it will crash the game.
				local scaw = CreateUnitByName("npc_dota_hero_phoenix_ritual", origin, false, caster, nil, caster:GetTeamNumber())
				scaw:SetForwardVector((point - origin):Normalized())
				
				local fireBomb = scaw:AddAbility("scryer_fire_bomb")
				fireBomb:SetLevel(1)

				-- Set the unit as an illusion
				-- modifier_illusion controls many illusion properties like +Green damage not adding to the unit damage, not being able to cast spells and the team-only blue particle
				scaw:AddNewModifier(caster, ability, "modifier_kill", { duration = 4.8, outgoing_damage = outgoingDamage, incoming_damage = incomingDamage })
				ability:ApplyDataDrivenModifier(caster, scaw, "modifier_icefrogged", {})
				scaw:MakeIllusion()
				-- Sets the illusion to begin channeling Fire Bomb
				Timers:CreateTimer( 0.122, function()
					scaw:CastAbilityOnPosition(point, fireBomb, -1)
				end)

				-- calculates rotation
				scaw.speed = 800
				scaw.distance = scaw:GetAbsOrigin() - point
				scaw.distanceLength = scaw.distance:Length()
				scaw.randomSpeed = scaw.speed / scaw.distanceLength

				local height = 0
				scaw.increaseSpeed = scaw.randomSpeed / 8
				scaw.variableSpeed = scaw.increaseSpeed
				local jump = 0.6
				local gravity = 0.1

				if j == 2 then 
					scaw.randomSpeed = - scaw.randomSpeed 
					scaw.increaseSpeed = - scaw.increaseSpeed
					scaw.variableSpeed = - scaw.variableSpeed
				end

				Timers:CreateTimer( 0.322, function()
					if time > maxTime then 
						return nil
					end

					local ground_position = GetGroundPosition(scaw:GetAbsOrigin() , scaw)
					local height = height + jump
					local origin = caster:GetAbsOrigin()
					local distance = scaw:GetAbsOrigin() - point
					local vector = distance:Normalized()
					local newDistanceLength = distance:Length()
					local rotate_position = point + vector * newDistanceLength
					
					local rotate_angle = QAngle(0, scaw.randomSpeed, 0)
					local rotate_point = RotatePosition(point, rotate_angle, rotate_position)
					local randomDistance = newDistanceLength + scaw.increaseSpeed

					jump = jump + (gravity / 5)
					scaw:SetAbsOrigin(rotate_point + Vector(0,0,jump) )
					scaw.randomSpeed = scaw.randomSpeed + scaw.variableSpeed
					scaw.variableSpeed = scaw.variableSpeed / 1.03
					return 1/30
				end)
			end)
		end
		scawDelay = scawDelay + 1.5
	end
	

	local icefrogDelay = 30

	caster.icefrog = CreateUnitByName("npc_dota_hero_puck_ritual", point, false, caster, nil, caster:GetTeamNumber())
	FindClearSpaceForUnit(caster.icefrog,point,true)
	caster.icefrog:SetModelScale(2)
	ability:ApplyDataDrivenModifier(caster, caster.icefrog, "modifier_icefrogged", {Duration = icefrogDelay + 1})
	ability:ApplyDataDrivenModifier(caster, caster.icefrog, "modifier_kill", {Duration = icefrogDelay + 1})

	Timers:CreateTimer(icefrogDelay, function()
--		local icefrogSpell = caster.icefrog:FindAbilityByName("spawn_icefrog")
--		icefrogSpell:UpgradeAbility(true)
--		icefrogSpell:OnSpellStart()
		camera_distance = 1400
		GameRules:GetGameModeEntity():SetCameraDistanceOverride( camera_distance )
		caster:RemoveItem(ability)

		local item = CreateItem("item_icefrog_stand",nil,nil)
		CreateItemOnPositionSync(point, item)
	end)

	local venoCount = 3
	local venoRadius = 500
	local venoDelay = 5
	local venoUnit = "npc_dota_hero_venomancer_ritual"
	local venoSpell = "venomancer_venomous_gale"
	local venoUnitDelay = 0
	local venoDuration = 1

	CreateRitualUnits(keys, point, venoCount, venoRadius, venoDelay, venoUnit, venoSpell, venoUnitDelay, false, venoDuration)

	local vengeCount = 6
	local vengeRadius = 700
	local vengeDelay = 6
	local vengeUnit = "npc_dota_hero_vengefulspirit_ritual"
	local vengeSpell = "vengefulspirit_wave_of_terror"
	local vengeUnitDelay = 0
	local vengeDuration = 1

	CreateRitualUnits(keys, point, vengeCount, vengeRadius, vengeDelay, vengeUnit, vengeSpell, vengeUnitDelay, false, vengeDuration)

	local SDCount = 9
	local SDRadius = 800
	local SDDelay = 7
	local SDUnit = "npc_dota_hero_shadow_demon_ritual"
	local SDSpell = "shadow_demon_shadow_poison"
	local SDUnitDelay = 0
	local SDDuration = 1

	CreateRitualUnits(keys, point, SDCount, SDRadius, SDDelay, SDUnit, SDSpell, SDUnitDelay, false, SDDuration)

	local warlockCount = 4
	local warlockRadius = 350
	local warlockDelay = 8
	local warlockUnit = "npc_dota_hero_warlock_ritual"
	local warlockSpell = "warlock_upheaval"
	local warlockUnitDelay = 0
	local warlockDuration = 8

	CreateRitualUnits(keys, point, warlockCount, warlockRadius, warlockDelay, warlockUnit, warlockSpell, warlockUnitDelay, false, warlockDuration)

	local lichCount = 6
	local lichRadius = 550
	local lichDelay = 10
	local lichUnit = "npc_dota_hero_lich_ritual"
	local lichSpell = "lich_frost_shield"
	local lichUnitDelay = 0.25
	local lichDuration = 1

	CreateRitualUnits(keys, point, lichCount, lichRadius, lichDelay, lichUnit, lichSpell, lichUnitDelay, true, lichDuration)

	local ogre_magiCount = 3
	local ogre_magiRadius = 250
	local ogre_magiDelay = 12
	local ogre_magiUnit = "npc_dota_hero_ogre_magi_ritual"
	local ogre_magiSpell = "ogre_magi_bloodlust"
	local ogre_magiUnitDelay = 0
	local ogre_magiDuration = 1

	CreateRitualUnits(keys, point, ogre_magiCount, ogre_magiRadius, ogre_magiDelay, ogre_magiUnit, ogre_magiSpell, ogre_magiUnitDelay, true, ogre_magiDuration)

	local LCCount = 4
	local LCRadius = 400
	local LCDelay = 12.5
	local LCUnit = "npc_dota_hero_legion_commander_ritual"
	local LCSpell = "legion_commander_overwhelming_odds"
	local LCUnitDelay = 0
	local LCDuration = 2

	CreateRitualUnits(keys, point, LCCount, LCRadius, LCDelay, LCUnit, LCSpell, LCUnitDelay, false, LCDuration)

	CreateRitualUnitsWithCustomPositionAndRotation(keys, point, 4, 1000, 13, "npc_dota_hero_lina_ritual", "lina_dragon_slave", 0, QAngle(0, -90, 0), 200, 1)
	CreateRitualUnitsWithCustomPositionAndRotation(keys, point, 4, 1000, 13.5, "npc_dota_hero_death_prophet_ritual", "death_prophet_carrion_swarm", 0, QAngle(0, 90, 0), 200, 2)
	CreateRitualUnitsWithCustomPositionAndRotation(keys, point, 8, 1000, 14, "npc_dota_hero_tusk_ritual", "tusk_ice_shards", 0, QAngle(0, 40, 0), 800, 1)
	CreateRitualUnitsWithCustomPositionAndRotation(keys, point, 4, 1200, 15, "npc_dota_hero_obsidian_destroyer_ritual", "obsidian_destroyer_sanity_eclipse", 0, QAngle(0, -90, 0), 200, 1)
	CreateRitualUnitsWithCustomPositionAndRotation(keys, point, 7, 1000, 15, "npc_dota_hero_nevermore_ritual", "nevermore_shadowraze1", 0, QAngle(0, 0, 0), 200, 1)
	CreateRitualUnits(keys, point, 6, 600, 15.5, "npc_dota_hero_jakiro_ritual", "jakiro_dual_breath", 0, false, 1)
	CreateRitualUnitsWithCustomPositionAndRotation(keys, point, 4, 900, 17, "npc_dota_hero_obsidian_destroyer_ritual", "obsidian_destroyer_sanity_eclipse", 0, QAngle(0, 90, 0), 200, 1)
	CreateRitualUnitsWithCustomPositionAndRotation(keys, point, 7, 1000, 17, "npc_dota_hero_nevermore_ritual", "nevermore_shadowraze1", 0, QAngle(0, 180, 0), 200, 1)
	CreateRitualUnitsWithCustomPositionAndRotation(keys, point, 10, 1000, 18, "npc_dota_hero_magnataur_ritual", "magnataur_shockwave", 0, QAngle(0, -20, 0), 600, 1)
	CreateRitualUnitsWithCustomPositionAndRotation(keys, point, 7, 1000, 19, "npc_dota_hero_nevermore_ritual", "nevermore_shadowraze1", 0, QAngle(0,0,0), 200, 1)
	CreateRitualUnitsWithCustomPositionAndRotation(keys, point, 4, 600, 19, "npc_dota_hero_obsidian_destroyer_ritual", "obsidian_destroyer_sanity_eclipse", 0, QAngle(0, 180, 0), 200, 1)
	CreateRitualUnits(keys, point, 4, 1000, 19, "npc_dota_hero_crystal_maiden_ritual", "crystal_maiden_freezing_field", 0.25, false, 6)
--	CreateRitualUnits(keys, point, 4, 300, 21, "npc_dota_hero_terrorblade_ritual", "terrorblade_sunder", 0.1, true, 1)
	CreateRitualUnits(keys, point, 1, 400, 22, "npc_dota_hero_enigma_ritual", "mega_black_hole", 0.1, false, 4)
	CreateRitualUnitsWithCustomPositionAndRotation(keys, point, 10, 100, 23, "npc_dota_hero_morphling_ritual", "morphling_waveform", 0, QAngle(0,10,0), 900, 1)
	CreateRitualUnitsWithCustomPositionAndRotation(keys, point, 10, 800, 23, "npc_dota_hero_zuus_ritual", "zuus_lightning_bolt", 0.2, QAngle(0, 0, 0), 300, 1)
	CreateRitualUnitsEnemy(keys, point, 4, 500, 24, "npc_dota_hero_necrolyte_ritual", "necrolyte_reapers_scythe", 0.1, true, 1)
end



function CreateRitualUnits(keys, point, count, radius, delay, unit, spell, unitDelay, castOnFrog, duration)
	local caster = keys.caster
	local ability = keys.ability
	local forwardVec = caster:GetForwardVector()
	local rotateVar = 0

	-- Spawn units
	local units = {}


	local vSpawnPosUnit = {}
	for i = 1, count do
		local rotate_distance = point + forwardVec * radius
		local rotate_angle = QAngle(0,rotateVar,0)
		rotateVar = rotateVar + 360/count
		local rotate_position = RotatePosition(point, rotate_angle, rotate_distance)
		table.insert(vSpawnPosUnit, rotate_position)
	end

	for j = 1, count do
		Timers:CreateTimer(delay, function()
			local origin = table.remove( vSpawnPosUnit, 1 )
			-- handle_UnitOwner needs to be nil, else it will crash the game.
			units[j] = CreateUnitByName(unit, origin, false, caster, nil, caster:GetTeamNumber())
			units[j]:SetForwardVector((point - origin):Normalized())
			
			units[j]:AddAbility(spell)
			local spell = units[j]:FindAbilityByName(spell)
			spell:SetLevel(spell:GetMaxLevel())
			
			-- Set the unit as an illusion
			-- modifier_illusion controls many illusion properties like +Green damage not adding to the unit damage, not being able to cast spells and the team-only blue particle
			units[j]:AddNewModifier(caster, ability, "modifier_kill", { duration = duration, outgoing_damage = 322, incoming_damage = 322 })
			units[j]:MakeIllusion()
			ability:ApplyDataDrivenModifier(caster, units[j], "modifier_icefrogged", {})

			-- Cast spell
			Timers:CreateTimer( 0.1, function()
				if castOnFrog and caster.icefrog ~= nil then
					units[j]:CastAbilityOnTarget(caster.icefrog,spell,-1)
					-- print(spell:GetName())
					-- units[j]:SetCursorCastTarget(caster.icefrog)
					-- spell:OnSpellStart()
				else
					units[j]:CastAbilityOnPosition(point,spell,-1)
				end
			end)

		end)
		delay = delay + unitDelay
	end
end

function CreateRitualUnitsEnemy(keys, point, count, radius, delay, unit, spell, unitDelay, castOnFrog, duration)
	local caster = keys.caster
	local ability = keys.ability
	local forwardVec = caster:GetForwardVector()
	local rotateVar = 0

	-- Spawn units
	local units = {}


	local vSpawnPosUnit = {}
	for i = 1, count do
		local rotate_distance = point + forwardVec * radius
		local rotate_angle = QAngle(0,rotateVar,0)
		rotateVar = rotateVar + 360/count
		local rotate_position = RotatePosition(point, rotate_angle, rotate_distance)
		table.insert(vSpawnPosUnit, rotate_position)
	end

	for j = 1, count do
		Timers:CreateTimer(delay, function()
			local origin = table.remove( vSpawnPosUnit, 1 )
			-- handle_UnitOwner needs to be nil, else it will crash the game.
			units[j] = CreateUnitByName(unit, origin, false, caster, nil, 15)
			units[j]:SetForwardVector((point - origin):Normalized())
			
			units[j]:AddAbility(spell)
			local spell = units[j]:FindAbilityByName(spell)
			spell:SetLevel(spell:GetMaxLevel())
			
			-- Set the unit as an illusion
			-- modifier_illusion controls many illusion properties like +Green damage not adding to the unit damage, not being able to cast spells and the team-only blue particle
			units[j]:AddNewModifier(caster, ability, "modifier_kill", { duration = duration, outgoing_damage = 322, incoming_damage = 322 })
			units[j]:MakeIllusion()
			ability:ApplyDataDrivenModifier(caster, units[j], "modifier_icefrogged", {})

			Timers:CreateTimer( 0.1, function()
				if castOnFrog and caster.icefrog ~= nil then
					units[j]:SetCursorCastTarget(caster.icefrog)
					spell:OnSpellStart()
				else
					units[j]:CastAbilityOnPosition(point,spell,-1)
				end
			end)

		end)
		delay = delay + unitDelay
	end
end

function CreateRitualUnitsWithCustomPositionAndRotation(keys, point, count, radius, delay, unit, spell, unitDelay, rotation, distance, duration)
	local caster = keys.caster
	local ability = keys.ability
	local forwardVec = caster:GetForwardVector()
	local rotateVar = 0

	-- Spawn units
	local units = {}
	local vSpawnPosUnit = {}
	for i = 1, count do
		local rotate_distance = point + forwardVec * radius
		local rotate_angle = QAngle(0,rotateVar,0)
		rotateVar = rotateVar + 360/count
		local rotate_position = RotatePosition(point, rotate_angle, rotate_distance)
		table.insert(vSpawnPosUnit, rotate_position)
	end

	for j = 1, count do
		Timers:CreateTimer(delay, function()
			local origin = table.remove( vSpawnPosUnit, 1 )
			-- handle_UnitOwner needs to be nil, else it will crash the game.
			units[j] = CreateUnitByName(unit, origin, false, caster, nil, caster:GetTeamNumber())

			

			local forwardVec = (point - origin):Normalized()
			local rotationPoint = RotatePosition(origin, rotation, origin + forwardVec * distance)
			units[j]:SetForwardVector(forwardVec)
			units[j].rotationPoint = rotationPoint
			
			units[j]:AddAbility(spell)
			local spell = units[j]:FindAbilityByName(spell)
			spell:SetLevel(spell:GetMaxLevel())
		
			-- Set the unit as an illusion
			-- modifier_illusion controls many illusion properties like +Green damage not adding to the unit damage, not being able to cast spells and the team-only blue particle
			units[j]:AddNewModifier(caster, ability, "modifier_kill", { duration = duration, outgoing_damage = 322, incoming_damage = 322 })
			units[j]:MakeIllusion()
			ability:ApplyDataDrivenModifier(caster, units[j], "modifier_icefrogged", {})

			-- Cast spell
			Timers:CreateTimer( 0.1, function()
				units[j]:CastAbilityOnPosition(units[j].rotationPoint,spell,-1)
			end)

		end)
		delay = delay + unitDelay
	end
end
