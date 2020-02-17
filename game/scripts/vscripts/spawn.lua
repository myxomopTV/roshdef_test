
if Spawn == nil then
	_G.Spawn = class({})
end
GameRules.UnitsFile = LoadKeyValues("scripts/npc/npc_units_custom.txt")

chicken_ticket_drop = false
final_boss = false

GameRules.DIFFICULTY = 0 	
GameRules.EndGame = 0

GameRules.DemonMode = 0
GameRules.ZombieMode = 0
GameRules.ChaosMode  = 0
GameRules.LichMode = 0
GameRules.NecroMode = 0

GameRules.MegaMode = 0
GameRules.RoshanUpgrade = 0

GameRules.Number_of_cursed = 0
GameRules.Maraphon_Round = 0

GameRules.drop_chance = 50

GameRules.neutral_respawn = 60
GameRules.boss_respawn = 300
GameRules.line_boss_interval = 600

if GetMapName() == "roshdef_turbo" then
	GameRules.neutral_respawn = GameRules.neutral_respawn/2
	GameRules.boss_respawn = GameRules.boss_respawn/2
	GameRules.line_boss_interval = GameRules.line_boss_interval/2
elseif GetMapName() == "roshdef_event" then
	GameRules.neutral_respawn = GameRules.neutral_respawn/2
	GameRules.boss_respawn = GameRules.boss_respawn/2
	GameRules.line_boss_interval = GameRules.line_boss_interval*100	
end

fractions = {
	["beastmaster"] = nil,
	["chen"] = nil,
	["antares"] = nil,
	["dragon"] = { ["jakiro"] = nil, ["wyvern"] = nil, units = {"npc_dota_dragon_child", "npc_dota_dragon_junior", "npc_dota_dragon_adult", "npc_dota_dragon_veteran", "npc_dota_dragon_myth", "npc_dota_roshan_dragon", "npc_dota_dragon1", "npc_dota_dragon2"} },
	["ursa"] = { ["ursa"] = nil, ["druid"] = nil, units = {"npc_dota_ursa_child", "npc_dota_ursa_junior", "npc_dota_ursa_adult", "npc_dota_ursa_veteran", "npc_dota_ursa_myth", "npc_dota_roshan_ursa", "npc_dota_ursa1", "npc_dota_ursa2"} },
	["centaur"] = { ["centaur"] = nil, ["leshrac"] = nil, units = {"npc_dota_centaur_child", "npc_dota_centaur_junior", "npc_dota_centaur_adult", "npc_dota_centaur_veteran", "npc_dota_centaur_myth", "npc_dota_roshan_centaur", "npc_dota_centaur1", "npc_dota_centaur2"} },
	["troll"] = { ["huskar"] = nil, ["troll"] = nil, units = {"npc_dota_troll_child", "npc_dota_troll_junior", "npc_dota_troll_adult", "npc_dota_troll_veteran", "npc_dota_troll_myth", "npc_dota_roshan_troll", "npc_dota_troll1", "npc_dota_troll2", "npc_dota_troll3", "npc_dota_troll4"} },
	["ogre"] = { ["ogre_magi"] = nil, units = {"npc_dota_ogre_child", "npc_dota_ogre_junior", "npc_dota_ogre_adult", "npc_dota_ogre_veteran", "npc_dota_ogre_myth", "npc_dota_roshan_ogre", "npc_dota_ogre1", "npc_dota_ogre2"} },
	["kobold"] = { ["meepo"] = nil, units = {"npc_dota_kobold_child", "npc_dota_kobold_junior", "npc_dota_kobold_adult", "npc_dota_kobold_veteran", "npc_dota_kobold_myth", "npc_dota_roshan_kobold", "npc_dota_kobold1", "npc_dota_kobold2", "npc_dota_kobold3", "npc_dota_kobold4"} },
	["satyr"] = { ["riki"] = nil, units = {"npc_dota_satyr_child", "npc_dota_satyr_junior", "npc_dota_satyr_adult", "npc_dota_satyr_veteran", "npc_dota_satyr_myth", "npc_dota_roshan_satyr", "npc_dota_satyr1", "npc_dota_satyr2", "npc_dota_satyr3"} },
	["wolf"] = { ["lycan"] = nil, units = {"npc_dota_wolf_child", "npc_dota_wolf_junior", "npc_dota_wolf_adult", "npc_dota_wolf_veteran", "npc_dota_wolf_myth", "npc_dota_roshan_wolf", "npc_dota_wolf1", "npc_dota_wolf2"} },
	["lizard"] = { ["disruptor"] = nil, units = {"npc_dota_lizard_child", "npc_dota_lizard_junior", "npc_dota_lizard_adult", "npc_dota_lizard_veteran", "npc_dota_lizard_myth", "npc_dota_roshan_lizard", "npc_dota_lizard1", "npc_dota_lizard2"} },
	["golem"] = { ["tiny"] = nil, units = {"npc_dota_golem_child", "npc_dota_golem_junior", "npc_dota_golem_adult", "npc_dota_golem_veteran", "npc_dota_golem_myth", "npc_dota_roshan_golem", "npc_dota_golem1", "npc_dota_golem2", "npc_dota_golem3", "npc_dota_golem4"} },
}

item_drop = {
--[[		{items = {"item_branches"}, chance = 5, duration = 5, limit = 3, units = {} },
		{items = {"item_branches"}, limit = 10, duration = 10, units = {"npc_dota_neutral_kobold","npc_dota_neutral_centaur_outrunner"} },--100% drop from list with limit and timer
		{items = {"item_belt_of_strength","item_boots_of_elves","item_robe"}, chance = 10, limit = 5, units = {"npc_dota_neutral_kobold","npc_dota_neutral_centaur_outrunner"}},--50% drop from list with limit
		{items = {"item_ogre_axe","item_blade_of_alacrity","item_staff_of_wizardry"}, chance = 75, units = {"npc_dota_neutral_black_dragon","npc_dota_neutral_centaur_khan"}},--75% drop from list
		{items = {"item_clarity","item_flask"}, chance = 25, duration = 10},-- global drop 25%
		{items = {"item_rapier"}, chance = 10, limit = 1},-- global drop 10% with limit 1
]]
		{items = {"item_banana"}, chance = 50, duration = 20,units = {"npc_dota_spider_1","npc_dota_spider_2","npc_dota_spider_3","npc_dota_spider_4","npc_dota_radiant_forest_1","npc_dota_radiant_forest_2","npc_dota_radiant_forest_3","npc_dota_radiant_forest_4",}},
		{items = {"item_fish"}, chance = 50, duration = 20, units = {"npc_dota_naga_1","npc_dota_naga_2","npc_dota_naga_3","npc_dota_naga_4","npc_dota_naga_5","npc_dota_naga_6","npc_dota_naga_7","npc_dota_naga_8",}},
		{items = {"item_meat"}, chance = 50, duration = 20,units = {"npc_dota_alliance_1","npc_dota_alliance_2","npc_dota_alliance_3","npc_dota_alliance_4","npc_dota_alliance_5","npc_dota_alliance_6","npc_dota_alliance_7","npc_dota_alliance_8",}},
		{items = {"item_life_essence"}, chance = 50, duration = 20,units = {"npc_dota_dire_forest_1","npc_dota_dire_forest_01","npc_dota_dire_forest_2","npc_dota_dire_forest_3","npc_dota_dire_forest_4","npc_dota_dire_forest_5"}},
		{items = {"item_fire_essence"}, chance = 100, duration = 20,units = {"npc_dota_elemental_1","npc_dota_elemental_1_1"}},
		{items = {"item_water_essence"}, chance = 100, duration = 20,units = {"npc_dota_elemental_2","npc_dota_elemental_2_1"}},
		{items = {"item_air_essence"}, chance = 100, duration = 20,units = {"npc_dota_elemental_3","npc_dota_elemental_3_1"}},
		{items = {"item_earth_essence"}, chance = 100, duration = 20, units = {"npc_dota_elemental_4","npc_dota_elemental_4_1"}},
		{items = {"item_chicken_game_ticket"}, chance = 0.5, duration = 60,limit = 1},
}

wave_boss = {
	[1] = {boss_name = {"npc_dota_boss_name1","npc_dota_boss_name1_minion"}, units_count={1,3}, music_name = "boss_music_1"}
}

for _,drop in ipairs(item_drop) do
	local items = drop.items or nil
	local items_num = #items
	local units = drop.units or nil
	local chance = drop.chance or 100
	local item = items[1]

	if (units and units[unit_name]) or units == nil then
		if items_num > 1 then
			item = items[RandomInt(1, #items)]
		end
--		RollitemDrop(npc, item, chance, duration)
	end
end

function GiveRaceBuff(unit, hero_name, race)
	local unit_name = unit:GetUnitName()
	local enum = fractions[race]
	local hero = enum[hero_name]

	if hero == nil or not hero:IsAlive() then
		return
	end
	
	local ability =	hero.race_buff 
	print(ability:GetName())
	print(hero:GetUnitName())
	
	for key, value in pairs(enum.units) do
		if value == unit_name then
			unit:AddNewModifier(hero, ability, "modifier_race_buff", {})			
		end
	end
end

function GiveAllRaceBuff(unit, hero_name)
	local unit_name = unit:GetUnitName()
	local hero = fractions[hero_name]

	if hero == nil or not hero:IsAlive() then
		return
	end
	
	local ability =	hero.race_buff 
--	print(ability:GetName())
--	print(hero:GetUnitName())
	for k, v in pairs(fractions) do
		local enum = v.units or nil
--		print("key = "..k)
		if enum then
			for key, value in pairs(enum) do
				if value == unit_name then
					unit:AddNewModifier(hero, ability, "modifier_race_buff", {})			
				end
			end
		end
	end
end

neutral_creeps = {
	["item_banana"] = {"npc_dota_spider_1","npc_dota_spider_2","npc_dota_spider_3","npc_dota_spider_4","npc_dota_radiant_forest_1","npc_dota_radiant_forest_2","npc_dota_radiant_forest_3","npc_dota_radiant_forest_4",},
	["item_fish"] = {"npc_dota_naga_1","npc_dota_naga_2","npc_dota_naga_3","npc_dota_naga_4","npc_dota_naga_5","npc_dota_naga_6","npc_dota_naga_7","npc_dota_naga_8",},
	["item_meat"] = {"npc_dota_alliance_1","npc_dota_alliance_2","npc_dota_alliance_3","npc_dota_alliance_4","npc_dota_alliance_5","npc_dota_alliance_6","npc_dota_alliance_7","npc_dota_alliance_8",},
	["item_life_essence"] = {"npc_dota_dire_forest_1","npc_dota_dire_forest_01","npc_dota_dire_forest_2","npc_dota_dire_forest_3","npc_dota_dire_forest_4","npc_dota_dire_forest_5"},
	["item_fire_essence"] = {"npc_dota_elemental_1","npc_dota_elemental_1_1"},
	["item_water_essence"] = {"npc_dota_elemental_2","npc_dota_elemental_2_1"},
	["item_air_essence"] = {"npc_dota_elemental_3","npc_dota_elemental_3_1"},
	["item_earth_essence"] = {"npc_dota_elemental_4","npc_dota_elemental_4_1"},
}

	
GameRules.upgradedata = {
	["type01"] = {dmg = 2, armor = 0.5 , hp = 40},
	["type02"] = {dmg = 5, armor = 0.5 , hp = 60},
	["type03"] = {dmg = 5, armor = 1 , hp = 100},
}

function Spawn:Upgrade1(unit,inc)
	if not unit:IsAlive() then
		return
	end

	local upgrade_mult=1.25
	unit:SetBaseDamageMin(unit:GetBaseDamageMin()*upgrade_mult)
	unit:SetBaseDamageMax(unit:GetBaseDamageMax()*upgrade_mult)				
	unit:SetPhysicalArmorBaseValue(unit:GetPhysicalArmorBaseValue()*upgrade_mult)
	unit:SetBaseMaxHealth(unit:GetBaseMaxHealth()*upgrade_mult)

end

function Spawn:Upgrade2(unit, multiplier)	
	if not unit:IsAlive() then
		return
	end
				
	local upgrade_mult= multiplier
	local maxhp = unit:GetMaxHealth()*upgrade_mult
	if maxhp < 1 then maxhp = 1 end
	
	unit:SetBaseDamageMin(unit:GetBaseDamageMin()*upgrade_mult)
	unit:SetBaseDamageMax(unit:GetBaseDamageMax()*upgrade_mult)				
	unit:SetPhysicalArmorBaseValue(unit:GetPhysicalArmorBaseValue()*upgrade_mult)
	unit:SetBaseMaxHealth(maxhp)
	unit:SetMaxHealth(maxhp)	
	unit:SetHealth(maxhp)
	
end

function Spawn:Upgrade3(unit, multiplier)	
	if not unit:IsAlive() then
		return
	end
		
	Timers:CreateTimer(0.03, function()				
			
		local upgrade_mult= multiplier
		local maxhp = unit:GetMaxHealth()*upgrade_mult
		if maxhp < 1 then maxhp = 1 end
		
		unit:SetBaseDamageMin(unit:GetBaseDamageMin()*upgrade_mult)
		unit:SetBaseDamageMax(unit:GetBaseDamageMax()*upgrade_mult)				
		unit:SetPhysicalArmorBaseValue(unit:GetPhysicalArmorBaseValue()*upgrade_mult)
		unit:SetBaseMaxHealth(maxhp)
		unit:SetMaxHealth(maxhp)	
		unit:SetHealth(maxhp)
	end)
end

function Spawn:Upgrade4(unit, multiplier, armor)	
	if not unit:IsAlive() then
		return
	end
		
	Timers:CreateTimer(0.02, function()				
			
		local upgrade_mult= multiplier
		local maxhp = unit:GetMaxHealth()*upgrade_mult
		if maxhp < 1 then maxhp = 1 end
		
		unit:SetBaseDamageMin(unit:GetBaseDamageMin()*upgrade_mult)
		unit:SetBaseDamageMax(unit:GetBaseDamageMax()*upgrade_mult)				
		unit:SetBaseMaxHealth(maxhp)
		unit:SetMaxHealth(maxhp)	
		unit:SetHealth(maxhp)
		if armor then
			unit:SetPhysicalArmorBaseValue(armor)
		end

	end)
end

function SetGoldMultiplier(unit , multiplier)
	
	unit:SetMaximumGoldBounty(unit:GetMaximumGoldBounty()*multiplier)				
	unit:SetMinimumGoldBounty(unit:GetMinimumGoldBounty()*multiplier)

end	

function Spawn:On_Difficult_Chosen( event )
    local difficulty = event.difficulty

	    GameRules.DIFFICULTY = difficulty

		CustomNetTables:SetTableValue('top_bar', 'Difficuilt', {
		DIFFICULTY = GameRules.DIFFICULTY
		})		
		local allCreatures = Entities:FindAllByClassname('npc_dota_creature')
		for i = 1, #allCreatures, 1 do
			local creature = allCreatures[i]
			local team = creature:GetTeam()
			local main_team = DOTA_TEAM_GOODGUYS

			if GetMapName() == "roshdef_event" then
				main_team = DOTA_TEAM_BADGUYS
			end		

			if team ~= main_team then
				if difficulty == 1 then Spawn:Upgrade2(creature, 1.5)
				elseif  difficulty == 2 then Spawn:Upgrade2(creature, 2)
				elseif  difficulty == 3 then Spawn:Upgrade2(creature, 3)
				end
			end
		end

end

function Spawn:InitGameMode()
	-- Register Panorama Listeners
	CustomGameEventManager:RegisterListener('On_Difficult_Chosen',Dynamic_Wrap(Spawn, 'On_Difficult_Chosen'))

	ListenToGameEvent('game_rules_state_change', Dynamic_Wrap(Spawn, 'OnGameRulesStateChange'), self)
	ListenToGameEvent("npc_spawned",Dynamic_Wrap( Spawn, 'OnNPCSpawned' ), self )
	ListenToGameEvent('entity_killed', Dynamic_Wrap(Spawn, 'OnEntityKilled'), self)

	print("Make buildings vulnerable")
    local allBuildings = Entities:FindAllByClassname('npc_dota_building')
    for i = 1, #allBuildings, 1 do
        local building = allBuildings[i]
        building:RemoveModifierByName('modifier_invulnerable')
		building:RemoveModifierByName("modifier_tower_truesight_aura")

		if GetMapName() == "roshdef_turbo" then
			SetGoldMultiplier(building , 2)
		end

		if GetMapName() == "roshdef_event" and building:GetTeam() == DOTA_TEAM_GOODGUYS then
			Spawn:Upgrade4(building, 10, nil)
			SetGoldMultiplier(building , 10)
		end
    end
	local main_team = DOTA_TEAM_GOODGUYS

	if GetMapName() == "roshdef_event" then
		main_team = DOTA_TEAM_BADGUYS
	end

	local allCreatures = Entities:FindAllByClassname('npc_dota_creature')
	for i = 1, #allCreatures, 1 do
		local creature = allCreatures[i]
		local name = creature:GetUnitName()
		creature.boss = GameRules.UnitsFile[name]["IsBossMonster"] or nil

		if GetMapName() == "roshdef_turbo" and creature:GetTeam() ~= main_team  then
			SetGoldMultiplier(creature , 2)
			Spawn:Upgrade3(creature, 0.75)
		end
		if name == "npc_dota_roshan1" and GetMapName() == "roshdef_event" then
			Spawn:Upgrade4(building, 20, 100)
		elseif name == "npc_dota_roshan2" and GetMapName() == "roshdef_event" then
			Spawn:Upgrade4(building, 20, 50)
		end

	end
	
--	local spectre = Entities:FindByModel(nil,"models/heroes/spectre/spectre.vmdl")
--	if spectre then spectre:SetTeam(DOTA_TEAM_BADGUYS) end

end

function Spawn:OnGameRulesStateChange()
	local newState = GameRules:State_Get()
		if newState == DOTA_GAMERULES_STATE_PRE_GAME then
			Spawn:SecretTreeSpawn()
			Spawn:SecretBoxSpawn()
	--		Spawn:DireTideTreeSpawner()
			--Spawn:BoxSpawner()
		elseif newState == DOTA_GAMERULES_STATE_TEAM_SHOWCASE then
		    for i = 0, 9 do
		        local hPlayer = PlayerResource:GetPlayer(i)
		        if PlayerResource:IsValidPlayerID(i) and hPlayer and not PlayerResource:HasSelectedHero(i) then
		            hPlayer:MakeRandomHeroSelection()
		        end
		    end			
			Spawn:SetWDToHost()			
		elseif newState == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
			EmitGlobalSound("narod_pognali")
			if GetMapName()=="roshdef_adventure" then
--				Spawn:NeutralSpawnerEvent()
			else
				Spawn:DireSpawner1()
				Spawn:NeutralSpawner()
				Spawn:DireBossSpawner()
			end
--			FrostEvent:StartEvent_1()
--			FrostEvent:StartEvent_2()

		end
end 

function Spawn:OnEntityKilled( keys )
	local killedUnit = EntIndexToHScript( keys.entindex_killed )
--	local killerUnit = EntIndexToHScript( keys.entindex_attacker )
	local name = killedUnit:GetUnitName()
	local team = killedUnit:GetTeam()

	if name == "npc_dota_thinker" or name == "npc_dota_dummy" or name == "npc_dota_mad_chicken" or  name == "npc_dota_secret_chicken" or killedUnit.event or killedUnit.avatar then
		return
	end
	
	if RollPercentage(25) and team == DOTA_TEAM_GOODGUYS and GameRules.MegaMode == 1 then
		DropItemWithTimer(killedUnit, "item_soul_vessel", 10)

	end

	if team ~= DOTA_TEAM_GOODGUYS then
		RollItemDrop(killedUnit)
	end
--[[
	if RollPercentage(GameRules.drop_chance) then
		for key,value in pairs(neutral_creeps) do
--			print("key = "..key)
			for _,creep in pairs (value) do
				if creep == name then
					DropItemWithTimer(killedUnit, key, 60)
				end
			end
		end
	end
]]
	
	if 		GameRules.ChaosMode == 1 then  Spawn:ChaosTrigger(killedUnit)
	elseif  GameRules.ZombieMode == 1 then Spawn:ZombieTrigger(killedUnit)
	end


	if 	name == "npc_dota_abomination_boss"		then 	GiveGoldPlayers(500)
		elseif name == "npc_dota_golem_boss" 	then	GiveGoldPlayers(1000)
		elseif name == "npc_dota_dead_witch" 	then	GiveGoldPlayers(1500)
		elseif name == "npc_dota_necronomicon_warrior_boss" 	then	GiveGoldPlayers(1000)
		elseif name == "npc_dota_necronomicon_archer_boss" 	then	GiveGoldPlayers(1000)
		elseif name == "npc_dota_nyx_boss" 		then	GiveGoldPlayers(3000)
		elseif name == "npc_dota_doom_boss" 	then	GiveGoldPlayers(4000)
		elseif name == "npc_dota_bloodseeker_boss" 	then	GiveGoldPlayers(5000)
		elseif name == "npc_dota_sans" 			then		GiveGoldPlayers(7500)
		elseif name == "npc_phantasm_1" 		then	GiveGoldPlayers(10000)
		elseif name == "npc_dota_gold_mine" 		then	GiveGoldPlayers(1000)
	end

--[[	
	if RollPercentage(1) then
		local unit_name = "npc_dota_halloween_pumpkin"
		local unit_fw = killedUnit:GetForwardVector()
		local position = killedUnit:GetAbsOrigin()		 
		local unit = CreateUnitByName(unit_name, position , true, nil, nil, DOTA_TEAM_NEUTRALS) 
		unit:SetForwardVector(unit_fw) 
		unit:AddNewModifier(unit, nil, "modifier_kill", { duration = 8 })
	
	end
]]	
	if name == "npc_dota_secret_tree1" or name == "npc_dota_secret_tree2" or name == "npc_dota_secret_tree3" or name == "npc_dota_secret_tree4" or name == "npc_dota_secret_tree5" or name == "npc_dota_halloween_treant" then
		local point = killedUnit:GetAbsOrigin()
		local newItem = CreateItem( "item_secret_branch", nil, nil )
		local drop = CreateItemOnPositionSync( point, newItem )
	elseif name == "npc_dota_secret_box"	then
		local point = killedUnit:GetAbsOrigin()
		local newItem = CreateItem( "item_candy", nil, nil )
		local drop = CreateItemOnPositionSync( point, newItem )
	elseif name == "npc_dota_gold_mine"	then
		local point = killedUnit:GetAbsOrigin()
		local newItem = CreateItem( "item_kirk", nil, nil )
		local drop = CreateItemOnPositionSync( point, newItem )
	elseif name == "npc_dota_spider_0"	then
		local point = killedUnit:GetAbsOrigin()
		local newItem = CreateItem( "item_spider_sack", nil, nil )
		local drop = CreateItemOnPositionSync( point, newItem )
	end
	if name == "npc_dota_dflag_guard1" then
		local point = Entities:FindByName( nil, "flag1point"):GetAbsOrigin() 
		local flag = Entities:FindByName( nil, "flag1")
		CreateUnitByName( "npc_dota_nflag_guard1"  , point + RandomVector( RandomFloat( 0, 50 ) ), true, nil, nil, DOTA_TEAM_GOODGUYS )
		flag:SetTeam(DOTA_TEAM_GOODGUYS)
	
	elseif name == "npc_dota_nflag_guard1" then
		local point = Entities:FindByName( nil, "flag1point"):GetAbsOrigin() 
		local flag = Entities:FindByName( nil, "flag1")
		CreateUnitByName( "npc_dota_dflag_guard1"  , point + RandomVector( RandomFloat( 0, 50 ) ), true, nil, nil, DOTA_TEAM_BADGUYS )
		flag:SetTeam(DOTA_TEAM_BADGUYS)
	
	elseif name == "npc_dota_dflag_guard2" then
		local point = Entities:FindByName( nil, "flag2point"):GetAbsOrigin() 
		local flag = Entities:FindByName( nil, "flag2")
		CreateUnitByName( "npc_dota_nflag_guard2" , point + RandomVector( RandomFloat( 0, 50 ) ), true, nil, nil, DOTA_TEAM_GOODGUYS )
		flag:SetTeam(DOTA_TEAM_GOODGUYS)
	
	elseif name == "npc_dota_nflag_guard2" then
		local point = Entities:FindByName( nil, "flag2point"):GetAbsOrigin() 
		local flag = Entities:FindByName( nil, "flag2")
		CreateUnitByName( "npc_dota_dflag_guard2"  , point + RandomVector( RandomFloat( 0, 50 ) ), true, nil, nil, DOTA_TEAM_BADGUYS )
		flag:SetTeam(DOTA_TEAM_BADGUYS)
	end
	
	if name== "npc_dota_wraith_king_frozen_throne" then
		self.DireSpawner= 1
 		chooseMode = true
		Spawn:PrintChoseModeMessage()
		EmitGlobalSound("wk_reincarnate")--global sound wk spawn
		if GetMapName() ~= "roshdef_adventure" then
			Spawn:DireSpawner2()		
		end
	end
	
	if name == "npc_dota_dire_forest_boss_3" then 
		local point = killedUnit:GetAbsOrigin()
		local unit = CreateUnitByName( "npc_dota_acult_ghost" , point, true, nil, nil, DOTA_TEAM_NEUTRALS )
		
		local point = Entities:FindByName( nil, "soul_stone_ritual"):GetAbsOrigin() 
		local unit = CreateUnitByName( "npc_dota_acult_mark" , point, true, nil, nil, DOTA_TEAM_NEUTRALS )
	end
	if name== "npc_dota_dbase2" then
		SendToConsole("stopsound")	
		local point1 = killedUnit:GetAbsOrigin() 
		local waypoint = Entities:FindByName( nil, "d_waypoint1") 
		Timers:CreateTimer(1, function() EmitGlobalSound("roshan_def.jojo") end)		
		
		Spawn:PrintFalseEndgameMessage()
		Timers:CreateTimer(45, function()  
       
       
			if GameRules.ZombieMode == 1 then name = "npc_dota_zombie_lord"
			elseif GameRules.ChaosMode == 1 then name = "npc_dota_chaos_lord"
			elseif GameRules.DemonMode == 1 then name = "npc_dota_demon_lord"
			EmitGlobalSound("terrorblade_spawn")
			elseif GameRules.LichMode == 1 then name = "npc_dota_lich_lord"
			elseif GameRules.NecroMode == 1 then name = "npc_dota_necro_lord"
			elseif GameRules.NecroMode == 0 then name = "npc_dota_necro_lord"

			end
			
            local unit = CreateUnitByName( name , point1 + RandomVector( RandomFloat( 0, 200 ) ), true, nil, nil, DOTA_TEAM_BADGUYS ) 
			unit:SetInitialGoalEntity( waypoint ) -- Посылаем мобов на наш way1, координаты которого мы записали в переменную 'waypoint'
		
		
		end)
	end

	if name == "npc_dota_papich" then
		EmitGlobalSound("Music_Frostivus.WK_killed")
	elseif name=="npc_dota_terrboss" or name=="npc_dota_zombie_lord" or name=="npc_dota_chaos_lord" or name=="npc_dota_demon_lord" or name=="npc_dota_lich_lord" or name=="npc_dota_necro_lord" then 
		SendToConsole("stopsound")	
		Timers:CreateTimer(1, function() EmitGlobalSound("roshan_def.portal2") end)				
		GameRules.EndGame = 1
		Spawn:PrintEndgameMessage1()
	elseif name=="npc_dota_roshan1" then
		SendToConsole("stopsound")
		if GameRules.MegaMode == 1 then
			Timers:CreateTimer(1, function() EmitGlobalSound("padal_sneg") end)		
			Spawn:PrintEndgameMessage3()
		else
			Timers:CreateTimer(1, function() EmitGlobalSound("kira_theme") end)		
			Spawn:PrintEndgameMessage2()	
		end
		
		GameRules.EndGame = 1
	end
	
	if name == "npc_dota_rock" then
		self.golem = 1
	elseif  name == "npc_dota_ursa3" then
		self.wolf=1
		local child_name = "npc_dota_wolf_child"
		local child_fw = killedUnit:GetForwardVector()
		local position = killedUnit:GetAbsOrigin()
		Timers:CreateTimer(2, function() 
		local unit = CreateUnitByName(child_name, position , true, nil, nil, DOTA_TEAM_GOODGUYS) 
		unit:SetForwardVector(child_fw) end)
		GameRules:SendCustomMessage("#Game_notification_wolf_announce",0,0)	
	elseif  name == "npc_dota_spider_boss_1" then
		self.ursa=1
		local child_name = "npc_dota_ursa_child"
		local child_fw = killedUnit:GetForwardVector()
		local position = killedUnit:GetAbsOrigin()
		Timers:CreateTimer(2, function() 
		local unit = CreateUnitByName(child_name, position , true, nil, nil, DOTA_TEAM_GOODGUYS) 
		unit:SetForwardVector(child_fw) end)
		
		GameRules:SendCustomMessage("#Game_notification_ursa_announce",0,0)	
	elseif  name == "npc_dota_boss_forest_1" then
		self.satyr=1
		local child_name = "npc_dota_satyr_child"
		local child_fw = killedUnit:GetForwardVector()
		local position = killedUnit:GetAbsOrigin()
		Timers:CreateTimer(2, function() 
		local unit = CreateUnitByName(child_name, position , true, nil, nil, DOTA_TEAM_GOODGUYS) 
		unit:SetForwardVector(child_fw) end)
		GameRules:SendCustomMessage("#Game_notification_satyr_announce",0,0)	
	elseif  name == "npc_dota_naga_boss_1" then
		self.ogre=1
		local child_name = "npc_dota_ogre_child"
		local child_fw = killedUnit:GetForwardVector()
		local position = killedUnit:GetAbsOrigin()
		Timers:CreateTimer(2, function() 
		local unit = CreateUnitByName(child_name, position , true, nil, nil, DOTA_TEAM_GOODGUYS) 
		unit:SetForwardVector(child_fw) end)
		GameRules:SendCustomMessage("#Game_notification_ogre_announce",0,0)	
	elseif  name == "npc_dota_boss_wind_1" then
		self.centaur=1
		local child_name = "npc_dota_centaur_child"
		local child_fw = killedUnit:GetForwardVector()
		local position = killedUnit:GetAbsOrigin()
		Timers:CreateTimer(2, function() 
		local unit = CreateUnitByName(child_name, position , true, nil, nil, DOTA_TEAM_GOODGUYS) 
		unit:SetForwardVector(child_fw) end)
		GameRules:SendCustomMessage("#Game_notification_centaur_announce",0,0)	
	elseif  name == "npc_dota_boss_vampire_1" then
		self.dragon=1
		local child_name = "npc_dota_dragon_child"
		local child_fw = killedUnit:GetForwardVector()
		local position = killedUnit:GetAbsOrigin()
		Timers:CreateTimer(2, function() 
		local unit = CreateUnitByName(child_name, position , true, nil, nil, DOTA_TEAM_GOODGUYS) 
		unit:SetForwardVector(child_fw) end)
		GameRules:SendCustomMessage("#Game_notification_dragon_announce",0,0)	
	elseif  name == "npc_dota_boss_water_1" then
		self.golem=2
		local child_name = "npc_dota_golem_child"
		local child_fw = killedUnit:GetForwardVector()
		local position = killedUnit:GetAbsOrigin()
		Timers:CreateTimer(2, function() 
		local unit = CreateUnitByName(child_name, position , true, nil, nil, DOTA_TEAM_GOODGUYS) 
		unit:SetForwardVector(child_fw) end)
		GameRules:SendCustomMessage("#Game_notification_golem_announce",0,0)	
	elseif  name == "npc_dota_boss_fire_1" then
		self.kobold=1
		local child_name = "npc_dota_kobold_child"
		local child_fw = killedUnit:GetForwardVector()
		local position = killedUnit:GetAbsOrigin()
		Timers:CreateTimer(2, function() 
		local unit = CreateUnitByName(child_name, position , true, nil, nil, DOTA_TEAM_GOODGUYS) 
		unit:SetForwardVector(child_fw) end)
		GameRules:SendCustomMessage("#Game_notification_kobold_announce",0,0)	
	elseif  name == "npc_dota_alliance_boss_1" then
		self.troll=1
		local child_name = "npc_dota_troll_child"
		local child_fw = killedUnit:GetForwardVector()
		local position = killedUnit:GetAbsOrigin()
		Timers:CreateTimer(2, function() 
		local unit = CreateUnitByName(child_name, position , true, nil, nil, DOTA_TEAM_GOODGUYS) 
		unit:SetForwardVector(child_fw) end)		
		
		GameRules:SendCustomMessage("#Game_notification_troll_announce",0,0)	
	elseif  name == "npc_dota_dire_forest_boss_1" then
		self.lizard = 1
		local child_name = "npc_dota_lizard_child"
		local child_fw = killedUnit:GetForwardVector()
		local position = killedUnit:GetAbsOrigin()
		Timers:CreateTimer(2, function() 
		local unit = CreateUnitByName(child_name, position , true, nil, nil, DOTA_TEAM_GOODGUYS) 
		unit:SetForwardVector(child_fw) end)		
		
		GameRules:SendCustomMessage("#Game_notification_lizard_announce",0,0)	
	end
	
	if name == "npc_cursed_warrior" then
		GameRules.Number_of_cursed = GameRules.Number_of_cursed - 1
		print("Number_of_cursed="..GameRules.Number_of_cursed)
		if GameRules.Number_of_cursed == 0 then
			SendToConsole("stopsound")
		end
	end
		
end

function RollItemDrop(unit)
	local unit_name = unit:GetUnitName()

	for _,drop in ipairs(item_drop) do
		local items = drop.items or nil
		local items_num = #items
		local units = drop.units or nil -- если юниты не были определены, то срабатывает для любого
		local chance = drop.chance or 100 -- если шанс не был определен, то он равен 100
		local loot_duration = drop.duration or nil -- длительность жизни предмета на земле
		local limit = drop.limit or nil -- лимит предметов
		local item_name = items[1] -- название предмета
		local roll_chance = RandomFloat(0, 100)
			
		if units then 
			for _,current_name in pairs(units) do
				if current_name == unit_name then
					units = nil
					break
				end
			end
		end

		if units == nil and (limit == nil or limit > 0) and roll_chance < chance then
			if limit then
				drop.limit = drop.limit - 1
			end

			if items_num > 1 then
				item_name = items[RandomInt(1, #items)]
			end

			local spawnPoint = unit:GetAbsOrigin()	
			local newItem = CreateItem( item_name, nil, nil )
			local drop = CreateItemOnPositionForLaunch( spawnPoint, newItem )
			local dropRadius = RandomFloat( 50, 100 )

			newItem:LaunchLootInitialHeight( false, 0, 150, 0.5, spawnPoint + RandomVector( dropRadius ) )
			if loot_duration then
				newItem:SetContextThink( "KillLoot", function() return KillLoot( newItem, drop ) end, loot_duration )
			end
		end
	end	
end

function KillLoot( item, drop )

	if drop:IsNull() then
		return
	end

	local nFXIndex = ParticleManager:CreateParticle( "particles/items2_fx/veil_of_discord.vpcf", PATTACH_CUSTOMORIGIN, drop )
	ParticleManager:SetParticleControl( nFXIndex, 0, drop:GetOrigin() )
	ParticleManager:SetParticleControl( nFXIndex, 1, Vector( 35, 35, 25 ) )
	ParticleManager:ReleaseParticleIndex( nFXIndex )
--	EmitGlobalSound("Item.PickUpWorld")

	UTIL_Remove( item )
	UTIL_Remove( drop )
end

function Spawn:ChaosTrigger(killedUnit)
	local trigger_chance = 50
	local damage = 200 + killedUnit:GetMaxHealth()*0.1
	local point = killedUnit:GetAbsOrigin()
	local damage_radius = 250
--	local particle = "particles/units/heroes/hero_nevermore/nevermore_shadowraze.vpcf"
	local particle = "particles/econ/items/shadow_fiend/sf_fire_arcana/sf_fire_arcana_shadowraze.vpcf"
	
	if RandomInt(1,99)<= trigger_chance and killedUnit:GetTeam() ~= DOTA_TEAM_GOODGUYS then
		local particleIndex = ParticleManager:CreateParticle(particle, PATTACH_ABSORIGIN, killedUnit)
		local units = FindUnitsInRadius(killedUnit:GetTeam(), point, nil, damage_radius, DOTA_UNIT_TARGET_TEAM_ENEMY,
											DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false)
		for k, unit in ipairs(units) do
			local damage_table = {
									attacker = killedUnit,
									victim = unit,
									ability = nil,
									damage_type = DAMAGE_TYPE_PURE,
									damage = damage
								}
			ApplyDamage(damage_table)
		end
		EmitSoundOnLocationWithCaster(point, "Hero_Nevermore.Shadowraze" ,killedUnit)
		--EmitSoundOnLocationForAllies( point, "Hero_Nevermore.Shadowraze", units )
	end
end

function Spawn:ZombieTrigger(killedUnit)
	local trigger_chance = 35
	local point = killedUnit:GetAbsOrigin()
	local hp = 35
	local dmg = 50
	local armor = 100
	local bounty = 10
	local experience = 10


	local name = "npc_dota_template_zombie"
	local team = killedUnit:GetTeam()
	if RandomInt(1,100)<= trigger_chance and killedUnit:GetTeam() ~= DOTA_TEAM_GOODGUYS and not killedUnit.zombie then
		
		Timers:CreateTimer(2,function()	
			local unit = CreateUnitByName(name, point + RandomVector( RandomFloat( 0, 50)), true, nil, nil, team)
			unit:SetMaxHealth(killedUnit:GetMaxHealth()*hp/100+1)
			unit:SetBaseMaxHealth(killedUnit:GetMaxHealth()*hp/100+1)
			unit:SetHealth(killedUnit:GetMaxHealth()*hp/100+1)
			unit:SetBaseDamageMin(killedUnit:GetBaseDamageMin()*dmg/100)
			unit:SetBaseDamageMax(killedUnit:GetBaseDamageMax()*dmg/100)				
			unit:SetPhysicalArmorBaseValue(killedUnit:GetPhysicalArmorBaseValue()*armor/100)
			unit.zombie = true
--			unit:SetMaximumGoldBounty(killedUnit:GetMaximumGoldBounty()*bounty/100)				
--			unit:SetMinimumGoldBounty(killedUnit:GetMinimumGoldBounty()*bounty/100)
--			unit:SetDeathXP(killedUnit:GetDeathXP()*experience/100)
		end)
	end
end
function Spawn:PrintEndgameMessage1()
	EmitGlobalSound("announcer_dlc_glados_ann_glados_gamemode_17")
	
	Timers:CreateTimer(5, function() GameRules:SendCustomMessage("<font color='#DBA901'><br>Game will end in 85 seconds</font>",0,0) end)
	Timers:CreateTimer(10, function() GameRules:SendCustomMessage("#Game_notification_end_game_message",0,0) end)

	--Send stats
	Timers:CreateTimer(87, function() GameRules:SendCustomMessage("<font color='#DBA901'>3</font>",0,0) end)
	Timers:CreateTimer(88, function() GameRules:SendCustomMessage("<font color='#DBA901'>2</font>",0,0) end)
	Timers:CreateTimer(89, function() GameRules:SendCustomMessage("<font color='#DBA901'>1...</font>",0,0) end)
	Timers:CreateTimer(90, function() GameRules:SetGameWinner(DOTA_TEAM_GOODGUYS) end)
end

function Spawn:PrintEndgameMessage2()

	Timers:CreateTimer(5, function() GameRules:SendCustomMessage("<font color='#DBA901'><br>Game will end in 15 seconds</font>",0,0) end)
	Timers:CreateTimer(10, function() GameRules:SendCustomMessage("#Game_notification_end_game_message",0,0) end)

	--Send stats
	Timers:CreateTimer(12, function() GameRules:SendCustomMessage("<font color='#DBA901'>3</font>",0,0) end)
	Timers:CreateTimer(13, function() GameRules:SendCustomMessage("<font color='#DBA901'>2</font>",0,0) end)
	Timers:CreateTimer(14, function() GameRules:SendCustomMessage("<font color='#DBA901'>1...</font>",0,0) end)
	Timers:CreateTimer(15, function() GameRules:SetGameWinner(DOTA_TEAM_BADGUYS) end)
end

function Spawn:PrintEndgameMessage3()

	Timers:CreateTimer(5, function() GameRules:SendCustomMessage("<font color='#DBA901'><br>Game will end in 85 seconds</font>",0,0) end)
	Timers:CreateTimer(10, function() GameRules:SendCustomMessage("#Game_notification_end_game_message",0,0) end)

	--Send stats
	Timers:CreateTimer(87, function() GameRules:SendCustomMessage("<font color='#DBA901'>3</font>",0,0) end)
	Timers:CreateTimer(88, function() GameRules:SendCustomMessage("<font color='#DBA901'>2</font>",0,0) end)
	Timers:CreateTimer(89, function() GameRules:SendCustomMessage("<font color='#DBA901'>1...</font>",0,0) end)
	Timers:CreateTimer(90, function() GameRules:SetGameWinner(DOTA_TEAM_BADGUYS) end)
end

function Spawn:PrintFalseEndgameMessage()

	Timers:CreateTimer(5, function() GameRules:SendCustomMessage("<font color='#DBA901'><br>Conragulations !Game will end in 40 seconds</font>",0,0) end)
	Timers:CreateTimer(10, function() GameRules:SendCustomMessage("#Game_notification_end_game_message",0,0) end)

	--Send stats
	Timers:CreateTimer(42, function() GameRules:SendCustomMessage("<font color='#DBA901'>3</font>",0,0) end)
	Timers:CreateTimer(43, function() GameRules:SendCustomMessage("<font color='#DBA901'>2</font>",0,0) end)
	Timers:CreateTimer(44, function() GameRules:SendCustomMessage("<font color='#DBA901'>1...</font>",0,0) end)
	Timers:CreateTimer(45, function() GameRules:SendCustomMessage("<font color='#DBA901'>Yes. I lie :) </font>",0,0) end)
	
end

chooseMode = false

function Spawn:PrintChoseModeMessage()
	if not chooseMode then
		return
	else
		chooseMode = false
	end
	GameRules:SendCustomMessage("#Game_notification_chose_boss_mode_message",0,0)
	for index = 0,5 do
		local player = PlayerResource:GetPlayer(index)
		if player and GameRules:PlayerHasCustomGameHostPrivileges(player) and IsServer() then
			CustomGameEventManager:Send_ServerToPlayer( player, "choose_boss_start", {} )
			print("index = "..index)
		end
	end
	
	Timers:CreateTimer(60, function()		
		if final_boss == false and IsServer() then
			Timers:CreateTimer(1, function() GameRules:SendCustomMessage("<font color='#DBA901'>3</font>",0,0) end)
			Timers:CreateTimer(2, function() GameRules:SendCustomMessage("<font color='#DBA901'>2</font>",0,0) end)
			Timers:CreateTimer(3, function() GameRules:SendCustomMessage("<font color='#DBA901'>1...</font>",0,0) end)

			final_boss = true
			CustomGameEventManager:Send_ServerToPlayer( GetListenServerHost(), "choose_boss_end", {} )
			Timers:CreateTimer(3, function()
				local int = math.random(1,5)
				if 		int <= 1 then 	Spawn:ZombieMode()
				elseif int <= 2 then	Spawn:ChaosMode()
				elseif int <= 3 then 	Spawn:DemonMode()
				elseif int <= 4 then 	Spawn:LichMode()
				elseif int <= 5 then 	Spawn:NecroMode()
				elseif int ~= 5 then 	Spawn:NecroMode()
				end
			end)
		end
	end)

end

function Spawn:ZombieMode()

	GameRules:SendCustomMessage("#Game_notification_zombie_mode_message1",0,0)
	GameRules:SendCustomMessage("#Game_notification_zombie_mode_message2",0,0)
	EmitGlobalSound("undying_undying_big_attack_10")
	GameRules.ZombieMode = 1
	
end

function Spawn:ChaosMode()

	GameRules:SendCustomMessage("#Game_notification_chaos_mode_message1",0,0)
	GameRules:SendCustomMessage("#Game_notification_chaos_mode_message2",0,0)
	EmitGlobalSound("nevermore_nev_arc_level_07")
	GameRules.ChaosMode = 1
	
end

function Spawn:DemonMode()

	GameRules:SendCustomMessage("#Game_notification_demon_mode_message1",0,0)
	GameRules:SendCustomMessage("#Game_notification_demon_mode_message2",0,0)
	EmitGlobalSound("terrorblade_terr_levelup_06")	
	GameRules.DemonMode = 1
	
end

function Spawn:LichMode()

	GameRules:SendCustomMessage("#Game_notification_lich_mode_message1",0,0)
	GameRules:SendCustomMessage("#Game_notification_lich_mode_message2",0,0)
	EmitGlobalSound("lich_lich_ability_chain_06")
	GameRules.LichMode = 1
	
end

function Spawn:NecroMode()

	GameRules:SendCustomMessage("#Game_notification_necro_mode_message1",0,0)
	GameRules:SendCustomMessage("#Game_notification_necro_mode_message2",0,0)
	EmitGlobalSound("necrolyte_necr_spawn_03")
	GameRules.NecroMode = 1
	
end

function Spawn:MegaMode()
--	local roshan = Entities:FindByModel(nil,"models/creeps/roshan/roshan.vmdl")
--	while roshan:GetUnitName()~="npc_dota_roshan1" do
--		roshan = Entities:FindByModel(roshan,"models/creeps/roshan/roshan.vmdl")
--	end
	local unit = Entities:FindByName( nil, "roshan")
	if unit ~= nil then Spawn:Upgrade4(unit, 100, 200)	 end
	
--	Spawn:Upgrade2(unit,400)
	for i=1,3 do
		local unit = Entities:FindByName( nil, "roshan_guard"..i)
		if unit ~= nil then Spawn:Upgrade4(unit, 100, 100) end
	end
	Spawn:SetSameTeam()
	Spawn:MegaNeutralSpawner()
	GameRules.MegaMode = 1
	
end

function Spawn:OnNPCSpawned(keys)

	--if centaur_const==1 then Say(nil,"Spawn:OnNPCSpawned works !!!"  , false) end 
	--Say(nil,"Spawn:OnNPCSpawned works !!!"  , false)
	local npc = EntIndexToHScript(keys.entindex)
	local name = npc:GetUnitName()
	local team = npc:GetTeam()
	local main_team = DOTA_TEAM_GOODGUYS

	if name == "npc_dota_thinker" or npc.event then
		return
	end
	
	if name == "npc_dota_event_enemy_1" or name == "npc_dota_event_enemy_2" or name == "npc_dota_event_enemy_3" or name == "npc_dota_event_enemy_4" or name == "npc_dota_event_enemy_5" or name == "npc_dota_event_mega_ghoul" then
		return
	end

	if npc:IsCreature() then
		npc.boss = GameRules.UnitsFile[name]["IsBossMonster"] or nil
	else
		npc.boss = nil
	end

	if GetMapName() == "roshdef_event" then
		main_team = DOTA_TEAM_BADGUYS
	end

	if GetMapName() == "roshdef_turbo" then
		if (team ~= main_team and not npc:IsRealHero() ) then
			SetGoldMultiplier(npc , 2)
			Spawn:Upgrade3(npc, 0.75)
		end
	end
	
	local ability = npc:FindAbilityByName("set_color") 
	if ability then ability:SetLevel(1) end

	if team ~= DOTA_TEAM_GOODGUYS then
		npc:AddNewModifier(npc, nil, "modifier_invulnerable", {duration = 0.1})
	end
	
	if npc:IsRealHero() or npc:IsControllableByAnyPlayer() then
		npc:AddNewModifier(npc, nil, "modifier_bloodseeker_thirst", nil)	
	end
--	npc:AddNewModifier(npc, nil, "modifier_special_effect_contest", {})
--	npc:AddNewModifier(npc, nil, "modifier_special_effect_donator", {})

	if (team ~= main_team and GameRules.DIFFICULTY == 1 and not npc:IsRealHero() ) then 	Spawn:Upgrade2(npc, 1.5)
		elseif (team ~= main_team and GameRules.DIFFICULTY == 2 and not npc:IsRealHero()) then 	Spawn:Upgrade2(npc, 2)
		elseif (team ~= main_team and GameRules.DIFFICULTY == 3 and not npc:IsRealHero()) then 	Spawn:Upgrade2(npc, 3)
	end

	if (team == DOTA_TEAM_BADGUYS and GameRules.DemonMode == 1) then 	npc:AddNewModifier(npc, nil, "modifier_demon_lord_buff", {})
	elseif (team == DOTA_TEAM_GOODGUYS and GameRules.LichMode == 1) then 	npc:AddNewModifier(npc, nil, "modifier_lich_lord_debuff", {})
	elseif (team == DOTA_TEAM_GOODGUYS and GameRules.NecroMode == 1) then 	npc:AddNewModifier(npc, nil, "modifier_necro_lord_debuff", {})
	end

--npc:AddNewModifier(npc, nil, "modifier_demon_lord_buff", {})
--npc:AddNewModifier(npc, nil, "modifier_insane", {})
	
	if npc:IsRealHero() and npc.FirstSpawned == nil then -- 
			npc.FirstSpawned = true
				
			if name ~= "npc_dota_hero_wisp" or name ~= "npc_dota_hero_antimage" then 
				--npc:AddAbility("penguin_sledding_ride")
				local ability = npc:FindAbilityByName("penguin_sledding_ride") 
				if ability then ability:SetLevel(1) end
			end
			
--			npc:AddNewModifier(npc, nil, "modifier_your_armor", {})
			if GetMapName() == "roshdef_turbo" then
				Timers:CreateTimer(0.1, function()
					npc:AddNewModifier(npc, nil, "modifier_turbomode_bonus", {})
				end)
			end			
				
			local ability = npc:GetAbilityByIndex(3)
			ability:SetLevel(1)

			if name=="npc_dota_hero_centaur" 
				then local ability = npc:FindAbilityByName("inherit_centaur_buff") 
				ability:SetLevel(1)
				fractions["centaur"]["centaur"]= npc
				npc.race_buff = ability
			elseif name=="npc_dota_hero_leshrac" 
				then local ability = npc:FindAbilityByName("inherit_leshrac_buff") 
				ability:SetLevel(1)
				fractions["centaur"]["leshrac"]= npc
				npc.race_buff = ability
			elseif name=="npc_dota_hero_riki" 
				then local ability = npc:FindAbilityByName("inherit_riki_buff") 
				ability:SetLevel(1)
				fractions["satyr"]["riki"]= npc
				npc.race_buff = ability
			elseif name=="npc_dota_hero_lycan" 
				then local ability = npc:FindAbilityByName("inherit_lycan_buff") 
				ability:SetLevel(1)
				fractions["wolf"]["lycan"]= npc
				npc.race_buff = ability
			elseif name=="npc_dota_hero_ursa" 
				then local ability = npc:FindAbilityByName("inherit_ursa_buff") 
				ability:SetLevel(1)
				fractions["ursa"]["ursa"]= npc
				npc.race_buff = ability
			elseif name=="npc_dota_hero_lone_druid" 
				then local ability = npc:FindAbilityByName("inherit_druid_buff") 
				ability:SetLevel(1)
				fractions["ursa"]["druid"]= npc
				npc.race_buff = ability
			elseif name=="npc_dota_hero_jakiro" 
				then local ability = npc:FindAbilityByName("inherit_jakiro_buff") 
				ability:SetLevel(1)
				fractions["dragon"]["jakiro"]= npc
				npc.race_buff = ability
			elseif name=="npc_dota_hero_winter_wyvern" 
				then local ability = npc:FindAbilityByName("inherit_wyvern_buff") 
				ability:SetLevel(1)
				fractions["dragon"]["wyvern"]= npc
				npc.race_buff = ability
			elseif name=="npc_dota_hero_ogre_magi" 
				then local ability = npc:FindAbilityByName("inherit_ogre_buff") 
				ability:SetLevel(1)
				fractions["ogre"]["ogre_magi"]= npc
				npc.race_buff = ability
			elseif name=="npc_dota_hero_tiny" 
				then local ability = npc:FindAbilityByName("inherit_tiny_buff") 
				ability:SetLevel(1)
				fractions["golem"]["tiny"]= npc
				npc.race_buff = ability
			elseif name=="npc_dota_hero_troll_warlord" 
				then local ability = npc:FindAbilityByName("inherit_troll_buff") 
				ability:SetLevel(1)
				fractions["troll"]["troll"]= npc
				npc.race_buff = ability
			elseif name=="npc_dota_hero_huskar" 
				then local ability = npc:FindAbilityByName("inherit_huskar_buff") 
				ability:SetLevel(1)
				fractions["troll"]["huskar"]= npc
				npc.race_buff = ability
			elseif name=="npc_dota_hero_meepo" 
				then local ability = npc:FindAbilityByName("inherit_meepo_buff") 				
				ability:SetLevel(1)
				fractions["kobold"]["meepo"]= npc
				npc.race_buff = ability
			elseif name=="npc_dota_hero_pangolier" 
				then local ability = npc:FindAbilityByName("pangolier_greed") 				
				ability:SetLevel(1)
			elseif name=="npc_dota_hero_beastmaster" 
				then local ability = npc:FindAbilityByName("inherit_beastmaster_buff") 				
				ability:SetLevel(1)
				fractions["beastmaster"]= npc
				npc.race_buff = ability
			elseif name=="npc_dota_hero_chen" 
				then local ability = npc:FindAbilityByName("inherit_chen_buff") 				
				ability:SetLevel(1)
				fractions["chen"]= npc
				npc.race_buff = ability
			elseif name=="npc_dota_hero_dragon_knight" 
				then local ability = npc:FindAbilityByName("inherit_antares_buff") 				
				ability:SetLevel(1)
				fractions["antares"]= npc
				npc.race_buff = ability
			elseif name=="npc_dota_hero_disruptor" 
				then local ability = npc:FindAbilityByName("inherit_disruptor_buff") 				
				ability:SetLevel(1)
				fractions["lizard"]["disruptor"]= npc
				npc.race_buff = ability
				local ability = npc:FindAbilityByName("disruptor_glimpse_custom_active") 	
				ability:SetLevel(1)
			elseif name=="npc_dota_hero_wisp" 
				then local ability = npc:FindAbilityByName("wisp_powerup_dmg") 				
				ability:SetLevel(1)
				local ability = npc:FindAbilityByName("wisp_powerup_armor") 				
				ability:SetLevel(1)
				local ability = npc:FindAbilityByName("wisp_powerup_hp") 				
				ability:SetLevel(1)
				local ability = npc:FindAbilityByName("wisp_powerup_as") 				
				ability:SetLevel(1)
				local ability = npc:FindAbilityByName("wisp_powerup_ms") 				
				ability:SetLevel(1)
				local ability = npc:FindAbilityByName("wisp_infest") 				
				ability:SetLevel(1)
				local ability = npc:FindAbilityByName("wisp_consume") 				
				ability:SetLevel(1)
			elseif name=="npc_dota_hero_keeper_of_the_light" then 
				local ability = npc:FindAbilityByName("epic_tower_upgrade_attack") 				
				ability:SetLevel(1)
				local ability = npc:FindAbilityByName("epic_tower_upgrade_as") 				
				ability:SetLevel(1)
				local ability = npc:FindAbilityByName("epic_tower_upgrade_health") 				
				ability:SetLevel(1)
				local ability = npc:FindAbilityByName("epic_tower_construct_build") 				
				ability:SetLevel(1)
				local ability = npc:FindAbilityByName("epic_tower_construct_movement") 				
				ability:SetLevel(1)
			elseif name=="npc_dota_hero_antimage" 
				then local ability = npc:FindAbilityByName("jacob_powerup_dmg") 			
				ability:SetLevel(1)
				local ability = npc:FindAbilityByName("jacob_powerup_armor") 				
				ability:SetLevel(1)
				local ability = npc:FindAbilityByName("jacob_powerup_hp") 				
				ability:SetLevel(1)
				local ability = npc:FindAbilityByName("jacob_powerup_as") 				
				ability:SetLevel(1)
				local ability = npc:FindAbilityByName("jacob_powerup_ms") 				
				ability:SetLevel(1)
				local ability = npc:FindAbilityByName("jacob_infest") 				
				ability:SetLevel(1)
				local ability = npc:FindAbilityByName("jacob_consume") 				
				ability:SetLevel(1)
			elseif name=="npc_dota_hero_obsidian_destroyer" 
				then local ability = npc:FindAbilityByName("mark_strength") 				
				ability:SetLevel(1)
				local ability = npc:FindAbilityByName("mark_agility") 				
				ability:SetLevel(1)
				local ability = npc:FindAbilityByName("mark_intellect") 				
				ability:SetLevel(1)
				local ability = npc:FindAbilityByName("mark_developer_present") 			
				ability:SetLevel(1)
			end

		
						
		
	end
		
	--Say(nil,npc:GetUnitName()  , false)
	if npc:GetTeam()== DOTA_TEAM_GOODGUYS then
		GiveRaceBuff(npc, "jakiro", "dragon")
		GiveRaceBuff(npc, "wyvern", "dragon")
		GiveRaceBuff(npc, "ursa", "ursa")
		GiveRaceBuff(npc, "druid", "ursa")
		GiveRaceBuff(npc, "centaur", "centaur")
		GiveRaceBuff(npc, "leshrac", "centaur")
		GiveRaceBuff(npc, "troll", "troll")
		GiveRaceBuff(npc, "huskar", "troll")
		GiveRaceBuff(npc, "ogre_magi", "ogre")
		GiveRaceBuff(npc, "meepo", "kobold")
		GiveRaceBuff(npc, "riki", "satyr")
		GiveRaceBuff(npc, "lycan", "wolf")
		GiveRaceBuff(npc, "tiny", "golem")
		GiveRaceBuff(npc, "disruptor", "lizard")
		
		GiveAllRaceBuff(npc, "beastmaster")
		GiveAllRaceBuff(npc, "chen")
		GiveAllRaceBuff(npc, "antares")
	
	end
	
end

function Spawn:SecretBoxSpawn() -- Функция начнет выполняться, когда начнется матч( на часах будет 00:00 ).
	print("that work !!!")
	local k = math.random(1,5)
	print("k= "..k)
	local point = Entities:FindByName( nil, "secret_chest_"..k):GetAbsOrigin() 
	if point then print("point available !!!") end
	local unit = CreateUnitByName( "npc_dota_secret_box" , point, true, nil, nil, DOTA_TEAM_NEUTRALS ) 
 end
function Spawn:SecretTreeSpawn() -- Функция начнет выполняться, когда начнется матч( на часах будет 00:00 ).
	function SpawnSecretTree(point_index, tree_type)
		local trees = Entities:FindAllByName("secret_tree_"..point_index)
		local length = #trees
		if length == 0 then
			print("secret_tree_"..point_index.." not detected !")
		else
			local tree = trees[RandomInt(1,length)]
			local point = tree:GetAbsOrigin() 
			local unit = CreateUnitByName( "npc_dota_secret_tree"..tree_type , point, true, nil, nil, DOTA_TEAM_NEUTRALS ) 				
		end
	end
	SpawnSecretTree(1, 1)
	SpawnSecretTree(2, 3)
	SpawnSecretTree(3, 4)
	SpawnSecretTree(4, 1)
	SpawnSecretTree(5, 5)
	SpawnSecretTree(6, 4)
	SpawnSecretTree(7, 4)
	SpawnSecretTree(8, 2)
	SpawnSecretTree(9, 2)
	SpawnSecretTree(10, 2)
	SpawnSecretTree(11, 3)
 end
 function Spawn:DireTideTreeSpawner() -- Функция начнет выполняться, когда начнется матч( на часах будет 00:00 ).
		for i=3,11 do
			for k=1,5 do
				local point = Entities:FindByName( nil, "secret_tree_"..i.."_"..k):GetAbsOrigin() 
				local unit = CreateUnitByName( "npc_dota_halloween_treant" , point, true, nil, nil, DOTA_TEAM_BADGUYS ) 
			end
		end
		
 end
 
function Spawn:DireSpawner1() -- Функция начнет выполняться, когда начнется матч( на часах будет 00:00 ).
      local point = Entities:FindByName( nil, "dmpoint1"):GetAbsOrigin() 
      local point1 = Entities:FindByName( nil, "drpoint1"):GetAbsOrigin() 
      local waypoint = Entities:FindByName( nil, "d_waypoint11") 
      local return_time = 30 -- Записываем в переменную значение '10'
      Timers:CreateTimer(20, function()  
       
       
         
         for i=1, 4 do -- Произведет нижние действия столько раз, сколько указано в ROUND_UNITS. То есть в нашем случае создаст 2 юнита.
              local unit = CreateUnitByName( "npc_dota_dire1" , point + RandomVector( RandomFloat( 0, 200 ) ), true, nil, nil, DOTA_TEAM_BADGUYS ) 
         unit:SetInitialGoalEntity( waypoint ) -- Посылаем мобов на наш way1, координаты которого мы записали в переменную 'waypoint'
         end
		 if GameRules:GetDOTATime(false,false)>300 then
			local unit = CreateUnitByName( "npc_dota_dire2", point + RandomVector( RandomFloat( 0, 200 ) ), true, nil, nil, DOTA_TEAM_BADGUYS ) 
         unit:SetInitialGoalEntity( waypoint ) -- Посылаем мобов на наш way1, координаты которого мы записали в переменную 'waypoint'
         end
		 if GameRules:GetDOTATime(false,false)>900 then
				local unit = CreateUnitByName( "npc_dota_dire3" , point + RandomVector( RandomFloat( 0, 200 ) ), true, nil, nil, DOTA_TEAM_BADGUYS ) 
				unit:SetInitialGoalEntity( waypoint ) -- Посылаем мобов на наш way1, координаты которого мы записали в переменную 'waypoint'

		end
		 if GameRules:GetDOTATime(false,false)>1500 then
			if RandomInt(1,100)>50 then
				local unit = CreateUnitByName( "npc_dota_dire4_1" , point + RandomVector( RandomFloat( 0, 200 ) ), true, nil, nil, DOTA_TEAM_BADGUYS ) 
				unit:SetInitialGoalEntity( waypoint ) -- Посылаем мобов на наш way1, координаты которого мы записали в переменную 'waypoint'
			else
				local unit = CreateUnitByName( "npc_dota_dire4_2" , point + RandomVector( RandomFloat( 0, 200 ) ), true, nil, nil, DOTA_TEAM_BADGUYS ) 
				unit:SetInitialGoalEntity( waypoint ) -- Посылаем мобов на наш way1, координаты которого мы записали в переменную 'waypoint'
			end
		end
		
		if GameRules:GetDOTATime(false,false)>2100 then
		
			if RandomInt(1,100)>50 then
				local unit = CreateUnitByName( "npc_dota_dire5_1" , point + RandomVector( RandomFloat( 0, 200 ) ), true, nil, nil, DOTA_TEAM_BADGUYS ) 
				unit:SetInitialGoalEntity( waypoint ) -- Посылаем мобов на наш way1, координаты которого мы записали в переменную 'waypoint'
			elseif RandomInt(1,100)<101 then
				local unit = CreateUnitByName( "npc_dota_dire5_2", point + RandomVector( RandomFloat( 0, 200 ) ), true, nil, nil, DOTA_TEAM_BADGUYS ) 
				unit:SetInitialGoalEntity( waypoint ) -- Посылаем мобов на наш way1, координаты которого мы записали в переменную 'waypoint'
			end
		end

		 for j=1,1 do
			local unit = CreateUnitByName( "npc_dota_direr1", point1 + RandomVector( RandomFloat( 0, 200 ) ), true, nil, nil, DOTA_TEAM_BADGUYS ) 
         unit:SetInitialGoalEntity( waypoint ) -- Посылаем мобов на наш way1, координаты которого мы записали в переменную 'waypoint'
         end
		 
		 if GameRules:GetDOTATime(false,false)>600 then
			local unit = CreateUnitByName( "npc_dota_direr2" , point1 + RandomVector( RandomFloat( 0, 200 ) ), true, nil, nil, DOTA_TEAM_BADGUYS ) 
         unit:SetInitialGoalEntity( waypoint ) -- Посылаем мобов на наш way1, координаты которого мы записали в переменную 'waypoint'
         end
		 if GameRules:GetDOTATime(false,false)>1200 then
			if RandomInt(1,100)>67 then
				local unit = CreateUnitByName( "npc_dota_direr3_1" , point1 + RandomVector( RandomFloat( 0, 200 ) ), true, nil, nil, DOTA_TEAM_BADGUYS ) 
				unit:SetInitialGoalEntity( waypoint ) -- Посылаем мобов на наш way1, координаты которого мы записали в переменную 'waypoint'
			elseif RandomInt(1,100)>50 then
				local unit = CreateUnitByName( "npc_dota_direr3_2" , point1 + RandomVector( RandomFloat( 0, 200 ) ), true, nil, nil, DOTA_TEAM_BADGUYS ) 
				unit:SetInitialGoalEntity( waypoint ) -- Посылаем мобов на наш way1, координаты которого мы записали в переменную 'waypoint'
			elseif RandomInt(1,100)<101 then
				local unit = CreateUnitByName( "npc_dota_direr3_3", point1 + RandomVector( RandomFloat( 0, 200 ) ), true, nil, nil, DOTA_TEAM_BADGUYS ) 
				unit:SetInitialGoalEntity( waypoint ) -- Посылаем мобов на наш way1, координаты которого мы записали в переменную 'waypoint'
			end
         end
		 
		 if GameRules:GetDOTATime(false,false)>2100 then
		
			
				local unit = CreateUnitByName( "npc_dota_direr4" , point + RandomVector( RandomFloat( 0, 200 ) ), true, nil, nil, DOTA_TEAM_BADGUYS ) 
				unit:SetInitialGoalEntity( waypoint ) -- Посылаем мобов на наш way1, координаты которого мы записали в переменную 'waypoint'
		
		end
          if self.DireSpawner~= 1  then return return_time  end-- Возвращаем таймеру время, через которое он должен снова сработать. Когда пройдет последний раунд таймер получит значение 'nil' и выключится.
      end)
end	
function Spawn:DireSpawner2() -- Функция начнет выполняться, когда начнется матч( на часах будет 00:00 ).
      local point = Entities:FindByName( nil, "dmpoint2"):GetAbsOrigin() 
      local point1 = Entities:FindByName( nil, "drpoint2"):GetAbsOrigin() 
      local waypoint = Entities:FindByName( nil, "d_waypoint1") 
      local return_time = 30 -- Записываем в переменную значение '10'
      Timers:CreateTimer(10, function()  
--		if GameRules.EndGame ~= 1 then
		   
			 
			 for i=1, 4 do -- Произведет нижние действия столько раз, сколько указано в ROUND_UNITS. То есть в нашем случае создаст 2 юнита.
				local unit = CreateUnitByName( "npc_dota_dire" .. 1, point + RandomVector( RandomFloat( 0, 200 ) ), true, nil, nil, DOTA_TEAM_BADGUYS ) 
				unit:SetInitialGoalEntity( waypoint ) -- Посылаем мобов на наш way1, координаты которого мы записали в переменную 'waypoint'
			 end
			 
				local unit = CreateUnitByName( "npc_dota_dire" .. 2, point + RandomVector( RandomFloat( 0, 200 ) ), true, nil, nil, DOTA_TEAM_BADGUYS ) 
			 unit:SetInitialGoalEntity( waypoint ) -- Посылаем мобов на наш way1, координаты которого мы записали в переменную 'waypoint'
			 
			 
				local unit = CreateUnitByName( "npc_dota_dire" .. 3, point + RandomVector( RandomFloat( 0, 200 ) ), true, nil, nil, DOTA_TEAM_BADGUYS ) 
			 unit:SetInitialGoalEntity( waypoint ) -- Посылаем мобов на наш way1, координаты которого мы записали в переменную 'waypoint'
			 
			
				if RandomInt(1,100)>50 then
					local unit = CreateUnitByName( "npc_dota_dire4_1" , point + RandomVector( RandomFloat( 0, 200 ) ), true, nil, nil, DOTA_TEAM_BADGUYS ) 
					unit:SetInitialGoalEntity( waypoint ) -- Посылаем мобов на наш way1, координаты которого мы записали в переменную 'waypoint'
				else
					local unit = CreateUnitByName( "npc_dota_dire4_2", point + RandomVector( RandomFloat( 0, 200 ) ), true, nil, nil, DOTA_TEAM_BADGUYS ) 
					unit:SetInitialGoalEntity( waypoint ) -- Посылаем мобов на наш way1, координаты которого мы записали в переменную 'waypoint'
				end
			
				if RandomInt(1,100)>50 then
					local unit = CreateUnitByName( "npc_dota_dire5_1" , point + RandomVector( RandomFloat( 0, 200 ) ), true, nil, nil, DOTA_TEAM_BADGUYS ) 
					unit:SetInitialGoalEntity( waypoint ) -- Посылаем мобов на наш way1, координаты которого мы записали в переменную 'waypoint'
				elseif RandomInt(1,100)<101 then
					local unit = CreateUnitByName( "npc_dota_dire5_2", point + RandomVector( RandomFloat( 0, 200 ) ), true, nil, nil, DOTA_TEAM_BADGUYS ) 
					unit:SetInitialGoalEntity( waypoint ) -- Посылаем мобов на наш way1, координаты которого мы записали в переменную 'waypoint'
				end

			if GameRules.NecroMode == 1 	then  	 unit = CreateUnitByName( "npc_dota_necro_spawn", point1 + RandomVector( RandomFloat( 0, 200 ) ), true, nil, nil, DOTA_TEAM_BADGUYS )
											else 	 unit = CreateUnitByName( "npc_dota_direr1", point1 + RandomVector( RandomFloat( 0, 200 ) ), true, nil, nil, DOTA_TEAM_BADGUYS ) 
			end
			 unit:SetInitialGoalEntity( waypoint ) -- Посылаем мобов на наш way1, координаты которого мы записали в переменную 'waypoint'
			 
			 
			if GameRules.LichMode == 1 	then  	 unit = CreateUnitByName( "npc_dota_lich_spawn", point1 + RandomVector( RandomFloat( 0, 200 ) ), true, nil, nil, DOTA_TEAM_BADGUYS )
										else 	 unit = CreateUnitByName( "npc_dota_direr2", point1 + RandomVector( RandomFloat( 0, 200 ) ), true, nil, nil, DOTA_TEAM_BADGUYS ) 
			end unit:SetInitialGoalEntity( waypoint ) -- Посылаем мобов на наш way1, координаты которого мы записали в переменную 'waypoint'
			
			 
				if RandomInt(1,100)>67 then
					local unit = CreateUnitByName( "npc_dota_direr3_1" , point1 + RandomVector( RandomFloat( 0, 200 ) ), true, nil, nil, DOTA_TEAM_BADGUYS ) 
					unit:SetInitialGoalEntity( waypoint ) -- Посылаем мобов на наш way1, координаты которого мы записали в переменную 'waypoint'
				elseif RandomInt(1,100)>50 then
					local unit = CreateUnitByName( "npc_dota_direr3_2" , point1 + RandomVector( RandomFloat( 0, 200 ) ), true, nil, nil, DOTA_TEAM_BADGUYS ) 
					unit:SetInitialGoalEntity( waypoint ) -- Посылаем мобов на наш way1, координаты которого мы записали в переменную 'waypoint'
				elseif RandomInt(1,100)<101 then
					local unit = CreateUnitByName( "npc_dota_direr3_3" , point1 + RandomVector( RandomFloat( 0, 200 ) ), true, nil, nil, DOTA_TEAM_BADGUYS ) 
					unit:SetInitialGoalEntity( waypoint ) -- Посылаем мобов на наш way1, координаты которого мы записали в переменную 'waypoint'
				end
				local unit = CreateUnitByName( "npc_dota_direr4", point1 + RandomVector( RandomFloat( 0, 200 ) ), true, nil, nil, DOTA_TEAM_BADGUYS ) 
			 unit:SetInitialGoalEntity( waypoint )
			 
			 if GameRules.ChaosMode == 1 then 
				if RandomInt(1,100)<26 then
					local unit = CreateUnitByName( "npc_dota_chaos_minion" , point1 + RandomVector( RandomFloat( 0, 200 ) ), true, nil, nil, DOTA_TEAM_BADGUYS ) 
					unit:SetInitialGoalEntity( waypoint ) -- Посылаем мобов на наш way1, координаты которого мы записали в переменную 'waypoint'			
				end
			 end
			 
			 if GameRules.DemonMode == 1 then 
				if RandomInt(1,100)<26 then
					local unit = CreateUnitByName( "npc_dota_demon_splitter" , point1 + RandomVector( RandomFloat( 0, 200 ) ), true, nil, nil, DOTA_TEAM_BADGUYS ) 
					unit:SetInitialGoalEntity( waypoint ) -- Посылаем мобов на наш way1, координаты которого мы записали в переменную 'waypoint'			
				end
			 end
--		end 
          if GameRules.EndGame ~= 1 then return return_time end -- Возвращаем таймеру время, через которое он должен снова сработать. Когда пройдет последний раунд таймер получит значение 'nil' и выключится.
      end)
end

function Spawn:NeutralSpawner() -- Функция начнет выполняться, когда начнется матч( на часах будет 00:00 ).
      local point = Entities:FindByName( nil, "nmpoint"):GetAbsOrigin() 
      local point1 = Entities:FindByName( nil, "nrpoint"):GetAbsOrigin() 
      local waypoint = Entities:FindByName( nil, "n_waypoint1") 
      local dire_point = Entities:FindByName( nil, "n_waypoint19"):GetAbsOrigin()
	  local return_time = 30 -- Записываем в переменную значение '10'
      Timers:CreateTimer(20, function()  
       
		if GameRules.RoshanUpgrade ~= 1 and GameRules.MegaMode ~= 1  then
         
			 for i=1, 4 do -- Произведет нижние действия столько раз, сколько указано в ROUND_UNITS. То есть в нашем случае создаст 2 юнита.
				 local unit
				 if RandomInt(1,100)>20 then  unit = CreateUnitByName( "npc_dota_kobold2", point + RandomVector( RandomFloat( 0, 200 ) ), true, nil, nil, DOTA_TEAM_GOODGUYS )
				else  unit = CreateUnitByName( "npc_dota_kobold3", point + RandomVector( RandomFloat( 0, 200 ) ), true, nil, nil, DOTA_TEAM_GOODGUYS )
				end
				--unit:MoveToPositionAggressive(Entities:FindByName( nil, "n_waypoint10"):GetAbsOrigin())
				AttackMove( unit, dire_point )
				--unit:SetInitialGoalEntity( waypoint ) -- Посылаем мобов на наш way1, координаты которого мы записали в переменную 'waypoint'
			 end
			 if (self.golem==2)  then
				local unit
				if RandomInt(1,100)>20 then  unit = CreateUnitByName( "npc_dota_golem3", point + RandomVector( RandomFloat( 0, 200 ) ), true, nil, nil, DOTA_TEAM_GOODGUYS )
				else unit = CreateUnitByName( "npc_dota_golem4", point + RandomVector( RandomFloat( 0, 200 ) ), true, nil, nil, DOTA_TEAM_GOODGUYS )
				end
				AttackMove( unit, dire_point )
--				unit:SetInitialGoalEntity( waypoint ) -- Посылаем мобов на наш way1, координаты которого мы записали в переменную 'waypoint'
			 elseif (self.golem==1)  then
				local unit
				if RandomInt(1,100)>20 then  unit = CreateUnitByName( "npc_dota_golem1", point + RandomVector( RandomFloat( 0, 200 ) ), true, nil, nil, DOTA_TEAM_GOODGUYS )
				else  unit = CreateUnitByName( "npc_dota_golem2", point + RandomVector( RandomFloat( 0, 200 ) ), true, nil, nil, DOTA_TEAM_GOODGUYS )
				end
				AttackMove( unit, dire_point )
--				unit:SetInitialGoalEntity( waypoint ) -- Посылаем мобов на наш way1, координаты которого мы записали в переменную 'waypoint'

			 end
			 if self.ursa==1 then
				local unit
				if RandomInt(1,100)>20 then  unit = CreateUnitByName( "npc_dota_ursa1", point + RandomVector( RandomFloat( 0, 200 ) ), true, nil, nil, DOTA_TEAM_GOODGUYS )
				else  unit = CreateUnitByName( "npc_dota_ursa2", point + RandomVector( RandomFloat( 0, 200 ) ), true, nil, nil, DOTA_TEAM_GOODGUYS )
				end         
				AttackMove( unit, dire_point )
--				unit:SetInitialGoalEntity( waypoint ) -- Посылаем мобов на наш way1, координаты которого мы записали в переменную 'waypoint'
			 end
			 if self.ogre==1 then
				
				if RandomInt(1,100)>20 then  unit = CreateUnitByName( "npc_dota_ogre1", point + RandomVector( RandomFloat( 0, 200 ) ), true, nil, nil, DOTA_TEAM_GOODGUYS )
				else  unit = CreateUnitByName( "npc_dota_ogre2", point + RandomVector( RandomFloat( 0, 200 ) ), true, nil, nil, DOTA_TEAM_GOODGUYS )
				end         
				AttackMove( unit, dire_point )
--				unit:SetInitialGoalEntity( waypoint ) -- Посылаем мобов на наш way1, координаты которого мы записали в переменную 'waypoint'
			 end
			 if self.DireSpawner~=1 then
				local unit
				if RandomInt(1,100)>20 then  unit = CreateUnitByName( "npc_dota_troll1", point + RandomVector( RandomFloat( 0, 200 ) ), true, nil, nil, DOTA_TEAM_GOODGUYS )
				else  unit = CreateUnitByName( "npc_dota_troll2", point + RandomVector( RandomFloat( 0, 200 ) ), true, nil, nil, DOTA_TEAM_GOODGUYS )
				end
							
				AttackMove( unit, dire_point )
--				unit:SetInitialGoalEntity( waypoint ) -- Посылаем мобов на наш way1, координаты которого мы записали в переменную 'waypoint'
			 elseif self.DireSpawner==1 then
				local unit
				if RandomInt(1,100)>20 then  unit = CreateUnitByName( "npc_dota_troll3", point + RandomVector( RandomFloat( 0, 200 ) ), true, nil, nil, DOTA_TEAM_GOODGUYS )
				else  unit = CreateUnitByName( "npc_dota_troll4", point + RandomVector( RandomFloat( 0, 200 ) ), true, nil, nil, DOTA_TEAM_GOODGUYS )
				end
				AttackMove( unit, dire_point )
--				 unit:SetInitialGoalEntity( waypoint ) -- Посылаем мобов на наш way1, координаты которого мы записали в переменную 'waypoint'
			 end 
			 
			 if self.wolf==1 then
				local unit
				if RandomInt(1,100)>20 then  unit = CreateUnitByName( "npc_dota_wolf1", point + RandomVector( RandomFloat( 0, 200 ) ), true, nil, nil, DOTA_TEAM_GOODGUYS )
				else  unit = CreateUnitByName( "npc_dota_wolf2", point + RandomVector( RandomFloat( 0, 200 ) ), true, nil, nil, DOTA_TEAM_GOODGUYS )
				end         
				AttackMove( unit, dire_point )
--				unit:SetInitialGoalEntity( waypoint ) -- Посылаем мобов на наш way1, координаты которого мы записали в переменную 'waypoint'
			 end
			 if self.satyr==1 then
				local unit
				if RandomInt(1,100)>20 then  unit = CreateUnitByName( "npc_dota_satyr2", point + RandomVector( RandomFloat( 0, 200 ) ), true, nil, nil, DOTA_TEAM_GOODGUYS )
				else  unit = CreateUnitByName( "npc_dota_satyr3", point + RandomVector( RandomFloat( 0, 200 ) ), true, nil, nil, DOTA_TEAM_GOODGUYS )
				end
				AttackMove( unit, dire_point )
--			 unit:SetInitialGoalEntity( waypoint ) -- Посылаем мобов на наш way1, координаты которого мы записали в переменную 'waypoint'
			 end
			 if self.dragon==1 then
				local unit
				if RandomInt(1,100)>20 then  unit = CreateUnitByName( "npc_dota_dragon1", point + RandomVector( RandomFloat( 0, 200 ) ), true, nil, nil, DOTA_TEAM_GOODGUYS )
				else  unit = CreateUnitByName( "npc_dota_dragon2", point + RandomVector( RandomFloat( 0, 200 ) ), true, nil, nil, DOTA_TEAM_GOODGUYS )
				end
				AttackMove( unit, dire_point )
--				unit:SetInitialGoalEntity( waypoint ) -- Посылаем мобов на наш way1, координаты которого мы записали в переменную 'waypoint'
			 end
			 if self.lizard==1 then
				local unit
				if RandomInt(1,100)>20 then  unit = CreateUnitByName( "npc_dota_lizard1", point + RandomVector( RandomFloat( 0, 200 ) ), true, nil, nil, DOTA_TEAM_GOODGUYS )
				else  unit = CreateUnitByName( "npc_dota_lizard2", point + RandomVector( RandomFloat( 0, 200 ) ), true, nil, nil, DOTA_TEAM_GOODGUYS )
				end
				AttackMove( unit, dire_point )
--				unit:SetInitialGoalEntity( waypoint ) -- Посылаем мобов на наш way1, координаты которого мы записали в переменную 'waypoint'
			 end
			 if self.centaur==1 then
				local unit
				if RandomInt(1,100)>20 then  unit = CreateUnitByName( "npc_dota_centaur1", point + RandomVector( RandomFloat( 0, 200 ) ), true, nil, nil, DOTA_TEAM_GOODGUYS )
				else  unit = CreateUnitByName( "npc_dota_centaur2", point + RandomVector( RandomFloat( 0, 200 ) ), true, nil, nil, DOTA_TEAM_GOODGUYS )
				end          
				AttackMove( unit, dire_point )
--			unit:SetInitialGoalEntity( waypoint ) -- Посылаем мобов на наш way1, координаты которого мы записали в переменную 'waypoint'
			 end
		end
		 if GameRules.RoshanUpgrade ~= 1 and GameRules.MegaMode ~= 1 then return return_time end
		  
		end)
end	


function Spawn:NeutralSpawnerEvent() -- Функция начнет выполняться, когда начнется матч( на часах будет 00:00 ).
      local point = Entities:FindByName( nil, "nmpoint"):GetAbsOrigin() 
      local point1 = Entities:FindByName( nil, "nrpoint"):GetAbsOrigin() 
      local waypoint = Entities:FindByName( nil, "n_waypoint1") 
      local dire_point = Entities:FindByName( nil, "n_waypoint19"):GetAbsOrigin()
	  local return_time = 30 -- Записываем в переменную значение '10'
	  local wave_number = 0
      Timers:CreateTimer(20, function()  
       
		if GameRules.MegaMode == 0 and GameRules.EndGame == 0 then
			 for i=1, 3 do -- Произведет нижние действия столько раз, сколько указано в ROUND_UNITS. То есть в нашем случае создаст 2 юнита.
				local unit = CreateUnitByName( "npc_dota_kobold3", point + RandomVector( RandomFloat( 0, 200 ) ), true, nil, nil, DOTA_TEAM_GOODGUYS )
				Spawn:Upgrade4(unit, 5, 10+wave_number*0.25)
				AttackMove( unit, dire_point )
			 end
			 
			local unit = CreateUnitByName( "npc_dota_satyr3", point1 + RandomVector( RandomFloat( 0, 200 ) ), true, nil, nil, DOTA_TEAM_GOODGUYS )
				Spawn:Upgrade4(unit, 5, 10+wave_number*0.25)
			AttackMove( unit, dire_point )

       
			 if GameRules:GetDOTATime(false,false)>300 then
				local unit = CreateUnitByName( "npc_dota_wolf2", point + RandomVector( RandomFloat( 0, 200 ) ), true, nil, nil, DOTA_TEAM_GOODGUYS )
				Spawn:Upgrade4(unit, 5, 10+wave_number*0.25)
				AttackMove( unit, dire_point )
			 end        

			 if GameRules:GetDOTATime(false,false)>600 then
				local unit = CreateUnitByName( "npc_dota_ursa2", point + RandomVector( RandomFloat( 0, 200 ) ), true, nil, nil, DOTA_TEAM_GOODGUYS )
				Spawn:Upgrade4(unit, 5, 10+wave_number*0.25)
				AttackMove( unit, dire_point )
			 end        

			 if GameRules:GetDOTATime(false,false)>900 then
				local unit = CreateUnitByName( "npc_dota_golem4", point + RandomVector( RandomFloat( 0, 200 ) ), true, nil, nil, DOTA_TEAM_GOODGUYS )
				Spawn:Upgrade4(unit, 5, 10+wave_number*0.25)
				AttackMove( unit, dire_point )
			 end 
			 
			 if GameRules:GetDOTATime(false,false)>1200 then
				local unit = CreateUnitByName( "npc_dota_troll4", point1 + RandomVector( RandomFloat( 0, 200 ) ), true, nil, nil, DOTA_TEAM_GOODGUYS )
				Spawn:Upgrade4(unit, 5, 15+wave_number*0.25)
				AttackMove( unit, dire_point )
			 end        

			 if GameRules:GetDOTATime(false,false)>1500 then
				local unit = CreateUnitByName( "npc_dota_ogre2", point + RandomVector( RandomFloat( 0, 200 ) ), true, nil, nil, DOTA_TEAM_GOODGUYS )
				Spawn:Upgrade4(unit, 5, 15+wave_number*0.25)
				AttackMove( unit, dire_point )
			 end 
			 
			 if GameRules:GetDOTATime(false,false)>1800 then
				local unit = CreateUnitByName( "npc_dota_centaur2", point + RandomVector( RandomFloat( 0, 200 ) ), true, nil, nil, DOTA_TEAM_GOODGUYS )
				Spawn:Upgrade4(unit, 5, 25+wave_number*0.5)
				AttackMove( unit, dire_point )
			 end        

			 if GameRules:GetDOTATime(false,false)>2100 then
				local unit = CreateUnitByName( "npc_dota_dragon2", point1 + RandomVector( RandomFloat( 0, 200 ) ), true, nil, nil, DOTA_TEAM_GOODGUYS )
				Spawn:Upgrade4(unit, 5, 25+wave_number*0.5)
				AttackMove( unit, dire_point )
			 end  

			 if GameRules:GetDOTATime(false,false)>2400 then
				local unit = CreateUnitByName( "npc_dota_lizard2", point1 + RandomVector( RandomFloat( 0, 200 ) ), true, nil, nil, DOTA_TEAM_GOODGUYS )
				Spawn:Upgrade4(unit, 5, 25+wave_number*0.5)
				AttackMove( unit, dire_point )
			 end  
			 
			wave_number = wave_number + 1

		end
		return return_time 
		  
		end)
end	


function Spawn:MegaNeutralSpawner() -- Функция начнет выполняться, когда начнется матч( на часах будет 00:00 ).
      local point = Entities:FindByName( nil, "nmpoint"):GetAbsOrigin() 
      local point1 = Entities:FindByName( nil, "nrpoint"):GetAbsOrigin() 
      local waypoint = Entities:FindByName( nil, "n_waypoint1") 
      local dire_point = Entities:FindByName( nil, "n_waypoint19"):GetAbsOrigin()
      local return_time = 30 -- Записываем в переменную значение '10'
      Timers:CreateTimer(0, function()  
       
		if GameRules.EndGame ~= 1 then
         
			for i=1, 4 do -- Произведет нижние действия столько раз, сколько указано в ROUND_UNITS. То есть в нашем случае создаст 2 юнита.
				local unit = CreateUnitByName( "npc_dota_kobold3", point + RandomVector( RandomFloat( 0, 200 ) ), true, nil, nil, DOTA_TEAM_GOODGUYS )
				  AttackMove( unit, dire_point )
				  Spawn:Upgrade2(unit,30)
				  unit:SetPhysicalArmorBaseValue(25)
			end        
        
		 	local unit = CreateUnitByName( "npc_dota_golem4", point + RandomVector( RandomFloat( 0, 200 ) ), true, nil, nil, DOTA_TEAM_GOODGUYS )		
				  AttackMove( unit, dire_point )
				  Spawn:Upgrade2(unit,30)
				  unit:SetPhysicalArmorBaseValue(75)

		 
			local unit = CreateUnitByName( "npc_dota_ursa2", point + RandomVector( RandomFloat( 0, 200 ) ), true, nil, nil, DOTA_TEAM_GOODGUYS )
			      AttackMove( unit, dire_point )
				  Spawn:Upgrade2(unit,30)
 				  unit:SetPhysicalArmorBaseValue(50)
        
			local unit = CreateUnitByName( "npc_dota_ogre2", point + RandomVector( RandomFloat( 0, 200 ) ), true, nil, nil, DOTA_TEAM_GOODGUYS )
			      AttackMove( unit, dire_point )
				  Spawn:Upgrade2(unit,30)
 				  unit:SetPhysicalArmorBaseValue(75)
        
			local unit = CreateUnitByName( "npc_dota_troll4", point + RandomVector( RandomFloat( 0, 200 ) ), true, nil, nil, DOTA_TEAM_GOODGUYS )			
				  AttackMove( unit, dire_point )
				  Spawn:Upgrade2(unit,30)
				  unit:SetPhysicalArmorBaseValue(25)
		  
		 
			local unit = CreateUnitByName( "npc_dota_wolf2", point + RandomVector( RandomFloat( 0, 200 ) ), true, nil, nil, DOTA_TEAM_GOODGUYS )
				  AttackMove( unit, dire_point )
 				  Spawn:Upgrade2(unit,30)
				  unit:SetPhysicalArmorBaseValue(50)

			local unit = CreateUnitByName( "npc_dota_satyr3", point + RandomVector( RandomFloat( 0, 200 ) ), true, nil, nil, DOTA_TEAM_GOODGUYS )
			      AttackMove( unit, dire_point )
				  Spawn:Upgrade2(unit,30)
				  unit:SetPhysicalArmorBaseValue(50)

			local unit = CreateUnitByName( "npc_dota_dragon2", point + RandomVector( RandomFloat( 0, 200 ) ), true, nil, nil, DOTA_TEAM_GOODGUYS )
				  AttackMove( unit, dire_point )
				  Spawn:Upgrade2(unit,30)
				  unit:SetPhysicalArmorBaseValue(100)

			local unit = CreateUnitByName( "npc_dota_lizard2", point + RandomVector( RandomFloat( 0, 200 ) ), true, nil, nil, DOTA_TEAM_GOODGUYS )
				  AttackMove( unit, dire_point )
				  Spawn:Upgrade2(unit,30)
				  unit:SetPhysicalArmorBaseValue(100)

			local unit = CreateUnitByName( "npc_dota_centaur2", point + RandomVector( RandomFloat( 0, 200 ) ), true, nil, nil, DOTA_TEAM_GOODGUYS )
				  AttackMove( unit, dire_point )
				  Spawn:Upgrade2(unit,30)
				  unit:SetPhysicalArmorBaseValue(100)
		end
        
		 if GameRules.EndGame ~= 1 then return return_time end
		  
		end)
end	

function Spawn:NeutralSpawner1() -- Функция начнет выполняться, когда начнется матч( на часах будет 00:00 ).
      local point = Entities:FindByName( nil, "nmpoint"):GetAbsOrigin() 
      local point1 = Entities:FindByName( nil, "nrpoint"):GetAbsOrigin() 
      local waypoint = Entities:FindByName( nil, "n_waypoint1") 
      local return_time = 30 -- Записываем в переменную значение '10'
      Timers:CreateTimer(0, function()  
       
       if GameRules.MegaMode ~= 1 then
         
         for i=1, 4 do -- Произведет нижние действия столько раз, сколько указано в ROUND_UNITS. То есть в нашем случае создаст 2 юнита.
             local unit
			 if RandomInt(1,100)<5 then  unit = CreateUnitByName( "npc_dota_roshan3", point + RandomVector( RandomFloat( 0, 200 ) ), true, nil, nil, DOTA_TEAM_GOODGUYS )
			else  unit = CreateUnitByName( "npc_dota_roshan_kobold", point + RandomVector( RandomFloat( 0, 200 ) ), true, nil, nil, DOTA_TEAM_GOODGUYS )
			end        
			unit:SetInitialGoalEntity( waypoint ) -- Посылаем мобов на наш way1, координаты которого мы записали в переменную 'waypoint'
         end
		 if (self.golem==1)  then
			local unit
			if RandomInt(1,100)<5 then  unit = CreateUnitByName( "npc_dota_roshan3", point + RandomVector( RandomFloat( 0, 200 ) ), true, nil, nil, DOTA_TEAM_GOODGUYS )
			else unit = CreateUnitByName( "npc_dota_roshan_golem", point + RandomVector( RandomFloat( 0, 200 ) ), true, nil, nil, DOTA_TEAM_GOODGUYS )
			end
			unit:SetInitialGoalEntity( waypoint ) -- Посылаем мобов на наш way1, координаты которого мы записали в переменную 'waypoint'
        
		 end
		 if self.ursa==1 then
			local unit
			if RandomInt(1,100)<5 then  unit = CreateUnitByName( "npc_dota_roshan3", point + RandomVector( RandomFloat( 0, 200 ) ), true, nil, nil, DOTA_TEAM_GOODGUYS )
			else  unit = CreateUnitByName( "npc_dota_roshan_ursa", point + RandomVector( RandomFloat( 0, 200 ) ), true, nil, nil, DOTA_TEAM_GOODGUYS )
			end        
			unit:SetInitialGoalEntity( waypoint ) -- Посылаем мобов на наш way1, координаты которого мы записали в переменную 'waypoint'
         end
		 if self.ogre==1 then
			local unit
			if RandomInt(1,100)<5 then  unit = CreateUnitByName( "npc_dota_roshan3", point + RandomVector( RandomFloat( 0, 200 ) ), true, nil, nil, DOTA_TEAM_GOODGUYS )
			else  unit = CreateUnitByName( "npc_dota_roshan_ogre", point + RandomVector( RandomFloat( 0, 200 ) ), true, nil, nil, DOTA_TEAM_GOODGUYS )
			end         unit:SetInitialGoalEntity( waypoint ) -- Посылаем мобов на наш way1, координаты которого мы записали в переменную 'waypoint'
         end
		 
			local unit
			if RandomInt(1,100)<5 then  unit = CreateUnitByName( "npc_dota_roshan3", point + RandomVector( RandomFloat( 0, 200 ) ), true, nil, nil, DOTA_TEAM_GOODGUYS )
			else  unit = CreateUnitByName( "npc_dota_roshan_troll", point + RandomVector( RandomFloat( 0, 200 ) ), true, nil, nil, DOTA_TEAM_GOODGUYS )
			end
						
			unit:SetInitialGoalEntity( waypoint ) -- Посылаем мобов на наш way1, координаты которого мы записали в переменную 'waypoint'
		  
		 
		 if self.wolf==1 then
			local unit
			if RandomInt(1,100)<5 then  unit = CreateUnitByName( "npc_dota_roshan3", point + RandomVector( RandomFloat( 0, 200 ) ), true, nil, nil, DOTA_TEAM_GOODGUYS )
			else  unit = CreateUnitByName( "npc_dota_roshan_wolf", point + RandomVector( RandomFloat( 0, 200 ) ), true, nil, nil, DOTA_TEAM_GOODGUYS )
			end         
			unit:SetInitialGoalEntity( waypoint ) -- Посылаем мобов на наш way1, координаты которого мы записали в переменную 'waypoint'
         end
		 if self.satyr==1 then
			local unit
			if RandomInt(1,100)<5 then  unit = CreateUnitByName( "npc_dota_roshan3", point + RandomVector( RandomFloat( 0, 200 ) ), true, nil, nil, DOTA_TEAM_GOODGUYS )
			else  unit = CreateUnitByName( "npc_dota_roshan_satyr", point + RandomVector( RandomFloat( 0, 200 ) ), true, nil, nil, DOTA_TEAM_GOODGUYS )
			end
         unit:SetInitialGoalEntity( waypoint ) -- Посылаем мобов на наш way1, координаты которого мы записали в переменную 'waypoint'
         end
		 if self.dragon==1 then
			local unit
			if RandomInt(1,100)<5 then  unit = CreateUnitByName( "npc_dota_roshan3", point + RandomVector( RandomFloat( 0, 200 ) ), true, nil, nil, DOTA_TEAM_GOODGUYS )
			else  unit = CreateUnitByName( "npc_dota_roshan_dragon", point + RandomVector( RandomFloat( 0, 200 ) ), true, nil, nil, DOTA_TEAM_GOODGUYS )
			end
			unit:SetInitialGoalEntity( waypoint ) -- Посылаем мобов на наш way1, координаты которого мы записали в переменную 'waypoint'
         end
		 if self.centaur==1 then
			local unit
			if RandomInt(1,100)<5 then  unit = CreateUnitByName( "npc_dota_roshan3", point + RandomVector( RandomFloat( 0, 200 ) ), true, nil, nil, DOTA_TEAM_GOODGUYS )
			else  unit = CreateUnitByName( "npc_dota_roshan_centaur", point + RandomVector( RandomFloat( 0, 200 ) ), true, nil, nil, DOTA_TEAM_GOODGUYS )
			end          
		unit:SetInitialGoalEntity( waypoint ) -- Посылаем мобов на наш way1, координаты которого мы записали в переменную 'waypoint'
         end
	   end
		 return  return_time
		end)
end	

function UpdateNettables(bIsStop) 
	CustomNetTables:SetTableValue('BossTimer', 'Timer',{
		time = bIsStop and type(bIsStop) == 'boolean' and -1 or GameRules:GetDOTATime(false,false) + GameRules.line_boss_interval + 1 + (bIsStop or 0)
	})
end
function Spawn:DireBossSpawner() -- Функция начнет выполняться, когда начнется матч( на часах будет 00:00 ).
      local point = Entities:FindByName( nil, "dmpoint2"):GetAbsOrigin() 
      local point1 = Entities:FindByName( nil, "drpoint2"):GetAbsOrigin() 
      local waypoint = Entities:FindByName( nil, "d_waypoint1") 
      local return_time = 30 -- Записываем в переменную значение '10'
	  local spawn_interval = GameRules.line_boss_interval
	  UpdateNettables(10)
      Timers:CreateTimer(10, function()  
         Timers:CreateTimer(spawn_interval, function()
			EmitGlobalSound("roshan_def.boss")
			GameRules:SendCustomMessage("#Game_notification_boss_spawn_abomination",0,0)		 
			local unit = CreateUnitByName( "npc_dota_abomination_boss" , point + RandomVector( RandomFloat( 0, 200 ) ), true, nil, nil, DOTA_TEAM_BADGUYS ) 
			unit:SetInitialGoalEntity( waypoint ) -- Посылаем мобов на наш way1, координаты которого мы записали в переменную 'waypoint'
         	UpdateNettables()
         end)
         Timers:CreateTimer(spawn_interval*2, function()
			EmitGlobalSound("roshan_def.boss")
			GameRules:SendCustomMessage("#Game_notification_boss_spawn_fire_golem",0,0)		 
			local unit = CreateUnitByName( "npc_dota_golem_boss" , point + RandomVector( RandomFloat( 0, 200 ) ), true, nil, nil, DOTA_TEAM_BADGUYS ) 
			unit:SetInitialGoalEntity( waypoint ) -- Посылаем мобов на наш way1, координаты которого мы записали в переменную 'waypoint'
         	UpdateNettables()
         end)
         Timers:CreateTimer(spawn_interval*3, function()
			EmitGlobalSound("roshan_def.boss")
			GameRules:SendCustomMessage("#Game_notification_boss_spawn_witch",0,0)		 
			local unit = CreateUnitByName( "npc_dota_dead_witch" , point + RandomVector( RandomFloat( 0, 200 ) ), true, nil, nil, DOTA_TEAM_BADGUYS ) 
			unit:SetInitialGoalEntity( waypoint ) -- Посылаем мобов на наш way1, координаты которого мы записали в переменную 'waypoint'
 
			local unit = CreateUnitByName( "forest_dota_dead_ghost" , point1 + RandomVector( RandomFloat( 0, 200 ) ), true, nil, nil, DOTA_TEAM_BADGUYS ) 
			unit:SetInitialGoalEntity( waypoint ) -- Посылаем мобов на наш way1, координаты которого мы записали в переменную 'waypoint'

			local unit = CreateUnitByName( "forest_dota_dead_ghost" , point1 + RandomVector( RandomFloat( 0, 200 ) ), true, nil, nil, DOTA_TEAM_BADGUYS ) 
			unit:SetInitialGoalEntity( waypoint ) -- Посылаем мобов на наш way1, координаты которого мы записали в переменную 'waypoint'
			UpdateNettables()
		end)
         Timers:CreateTimer(spawn_interval*4, function()
			EmitGlobalSound("roshan_def.boss")
			GameRules:SendCustomMessage("#Game_notification_boss_spawn_necronomicon",0,0)		 
			local unit = CreateUnitByName( "npc_dota_necronomicon_warrior_boss" , point + RandomVector( RandomFloat( 0, 200 ) ), true, nil, nil, DOTA_TEAM_BADGUYS ) 
			unit:SetInitialGoalEntity( waypoint ) -- Посылаем мобов на наш way1, координаты которого мы записали в переменную 'waypoint'
 
			local unit = CreateUnitByName( "npc_dota_necronomicon_archer_boss" , point1 + RandomVector( RandomFloat( 0, 200 ) ), true, nil, nil, DOTA_TEAM_BADGUYS ) 
			unit:SetInitialGoalEntity( waypoint ) -- Посылаем мобов на наш way1, координаты которого мы записали в переменную 'waypoint'
			UpdateNettables()
        end)
         Timers:CreateTimer(spawn_interval*5, function()
			EmitGlobalSound("roshan_def.boss")
			GameRules:SendCustomMessage("#Game_notification_boss_spawn_nyx",0,0)		 
			local unit = CreateUnitByName( "npc_dota_nyx_boss" , point + RandomVector( RandomFloat( 0, 200 ) ), true, nil, nil, DOTA_TEAM_BADGUYS ) 
			unit:SetInitialGoalEntity( waypoint ) -- Посылаем мобов на наш way1, координаты которого мы записали в переменную 'waypoint'
        	UpdateNettables()
         end)
         Timers:CreateTimer(spawn_interval*6, function()
			EmitGlobalSound("roshan_def.boss")
			GameRules:SendCustomMessage("#Game_notification_boss_spawn_doom",0,0)
		 
			local unit = CreateUnitByName( "npc_dota_doom_boss" , point + RandomVector( RandomFloat( 0, 200 ) ), true, nil, nil, DOTA_TEAM_BADGUYS ) 
			unit:SetInitialGoalEntity( waypoint ) -- Посылаем мобов на наш way1, координаты которого мы записали в переменную 'waypoint'
 
			local unit = CreateUnitByName( "npc_dota_doom_minion" , point1 + RandomVector( RandomFloat( 0, 200 ) ), true, nil, nil, DOTA_TEAM_BADGUYS ) 
			unit:SetInitialGoalEntity( waypoint ) -- Посылаем мобов на наш way1, координаты которого мы записали в переменную 'waypoint'

			local unit = CreateUnitByName( "npc_dota_doom_minion" , point1 + RandomVector( RandomFloat( 0, 200 ) ), true, nil, nil, DOTA_TEAM_BADGUYS ) 
			unit:SetInitialGoalEntity( waypoint ) -- Посылаем мобов на наш way1, координаты которого мы записали в переменную 'waypoint'

			local unit = CreateUnitByName( "npc_dota_doom_minion" , point1 + RandomVector( RandomFloat( 0, 200 ) ), true, nil, nil, DOTA_TEAM_BADGUYS ) 
			unit:SetInitialGoalEntity( waypoint ) -- Посылаем мобов на наш way1, координаты которого мы записали в переменную 'waypoint'
 			UpdateNettables()
        end)
         Timers:CreateTimer(spawn_interval*7, function()
			EmitGlobalSound("roshan_def.boss")
			GameRules:SendCustomMessage("#Game_notification_boss_spawn_seeker",0,0)		 
			local unit = CreateUnitByName( "npc_dota_bloodseeker_boss" , point + RandomVector( RandomFloat( 0, 200 ) ), true, nil, nil, DOTA_TEAM_BADGUYS ) 
			unit:SetInitialGoalEntity( waypoint ) -- Посылаем мобов на наш way1, координаты которого мы записали в переменную 'waypoint'
        	UpdateNettables()
         end)
         Timers:CreateTimer(spawn_interval*8, function()
         	UpdateNettables()
		--	EmitGlobalSound("roshan_def.boss")
		--	GameRules:SendCustomMessage("#Game_notification_boss_spawn_never",0,0)		 
			local unit = CreateUnitByName( "npc_dota_sans" , point + RandomVector( RandomFloat( 0, 200 ) ), true, nil, nil, DOTA_TEAM_BADGUYS ) 
			unit:SetInitialGoalEntity( waypoint ) -- Посылаем мобов на наш way1, координаты которого мы записали в переменную 'waypoint'
         end)
         Timers:CreateTimer(spawn_interval*9, function()
         	UpdateNettables()
			EmitGlobalSound("roshan_def.boss")
			GameRules:SendCustomMessage("#Game_notification_boss_spawn_spectre",0,0)		 
			local unit = CreateUnitByName( "npc_phantasm_1" , point + RandomVector( RandomFloat( 0, 200 ) ), true, nil, nil, DOTA_TEAM_BADGUYS ) 
			unit:SetInitialGoalEntity( waypoint ) -- Посылаем мобов на наш way1, координаты которого мы записали в переменную 'waypoint'
         end)
         Timers:CreateTimer(spawn_interval*10, function()
         	UpdateNettables()
			EmitGlobalSound("roshan_def.boss")
			GameRules:SendCustomMessage("#Game_notification_boss_spawn_cursed_warriors",0,0)		 
			GameRules.Number_of_cursed = 12
			Timers:CreateTimer(1, function()
				if GameRules.Number_of_cursed ~= 0 then 
					EmitGlobalSound("Sandopolis")
					return 145 -- repeat time
				end
			end
			)
			for i=1,12 do 
				local unit = CreateUnitByName( "npc_cursed_warrior" , point + RandomVector( RandomFloat( 0, 200 ) ), true, nil, nil, DOTA_TEAM_BADGUYS ) 
				unit:SetInitialGoalEntity( waypoint ) 
			end
		 end)
         Timers:CreateTimer(spawn_interval*11, function()
         	UpdateNettables()
			EmitGlobalSound("roshan_def.boss")
			GameRules:SendCustomMessage("#Game_notification_boss_spawn_plague_wagon",0,0)		 

			local unit = CreateUnitByName( "npc_dota_plague_wagon" , point + RandomVector( RandomFloat( 0, 200 ) ), true, nil, nil, DOTA_TEAM_BADGUYS ) 
			
			ExecuteOrderFromTable({
				UnitIndex = unit:entindex(),
				OrderType = DOTA_UNIT_ORDER_ATTACK_MOVE,
				Position = point,
				Queue = false,
			})			
		 end)
  
 			Timers:CreateTimer(spawn_interval*12, function()
 			UpdateNettables()
			EmitGlobalSound("roshan_def.boss")
			GameRules:SendCustomMessage("#Game_notification_boss_maraphon",0,0)		 

			 Timers:CreateTimer(10, function()
				local unit = CreateUnitByName( "npc_dota_abomination_boss" , point + RandomVector( RandomFloat( 0, 200 ) ), true, nil, nil, DOTA_TEAM_BADGUYS ) 
				unit:SetInitialGoalEntity( waypoint ) -- Посылаем мобов на наш way1, координаты которого мы записали в переменную 'waypoint'
			 end)
			 Timers:CreateTimer(20, function()
				local unit = CreateUnitByName( "npc_dota_golem_boss" , point + RandomVector( RandomFloat( 0, 200 ) ), true, nil, nil, DOTA_TEAM_BADGUYS ) 
				unit:SetInitialGoalEntity( waypoint ) -- Посылаем мобов на наш way1, координаты которого мы записали в переменную 'waypoint'
			 end)
			 Timers:CreateTimer(30, function()
				local unit = CreateUnitByName( "npc_dota_dead_witch" , point + RandomVector( RandomFloat( 0, 200 ) ), true, nil, nil, DOTA_TEAM_BADGUYS ) 
				unit:SetInitialGoalEntity( waypoint ) -- Посылаем мобов на наш way1, координаты которого мы записали в переменную 'waypoint'
	 
				local unit = CreateUnitByName( "forest_dota_dead_ghost" , point1 + RandomVector( RandomFloat( 0, 200 ) ), true, nil, nil, DOTA_TEAM_BADGUYS ) 
				unit:SetInitialGoalEntity( waypoint ) -- Посылаем мобов на наш way1, координаты которого мы записали в переменную 'waypoint'

				local unit = CreateUnitByName( "forest_dota_dead_ghost" , point1 + RandomVector( RandomFloat( 0, 200 ) ), true, nil, nil, DOTA_TEAM_BADGUYS ) 
				unit:SetInitialGoalEntity( waypoint ) -- Посылаем мобов на наш way1, координаты которого мы записали в переменную 'waypoint'

			end)
			 Timers:CreateTimer(40, function()
				local unit = CreateUnitByName( "npc_dota_necronomicon_warrior_boss" , point + RandomVector( RandomFloat( 0, 200 ) ), true, nil, nil, DOTA_TEAM_BADGUYS ) 
				unit:SetInitialGoalEntity( waypoint ) -- Посылаем мобов на наш way1, координаты которого мы записали в переменную 'waypoint'
	 
				local unit = CreateUnitByName( "npc_dota_necronomicon_archer_boss" , point1 + RandomVector( RandomFloat( 0, 200 ) ), true, nil, nil, DOTA_TEAM_BADGUYS ) 
				unit:SetInitialGoalEntity( waypoint ) -- Посылаем мобов на наш way1, координаты которого мы записали в переменную 'waypoint'

			end)
			 Timers:CreateTimer(50, function()
				local unit = CreateUnitByName( "npc_dota_nyx_boss" , point + RandomVector( RandomFloat( 0, 200 ) ), true, nil, nil, DOTA_TEAM_BADGUYS ) 
				unit:SetInitialGoalEntity( waypoint ) -- Посылаем мобов на наш way1, координаты которого мы записали в переменную 'waypoint'
			 end)
			 Timers:CreateTimer(60, function()
			 
				local unit = CreateUnitByName( "npc_dota_doom_boss" , point + RandomVector( RandomFloat( 0, 200 ) ), true, nil, nil, DOTA_TEAM_BADGUYS ) 
				unit:SetInitialGoalEntity( waypoint ) -- Посылаем мобов на наш way1, координаты которого мы записали в переменную 'waypoint'
	 
				local unit = CreateUnitByName( "npc_dota_doom_minion" , point1 + RandomVector( RandomFloat( 0, 200 ) ), true, nil, nil, DOTA_TEAM_BADGUYS ) 
				unit:SetInitialGoalEntity( waypoint ) -- Посылаем мобов на наш way1, координаты которого мы записали в переменную 'waypoint'

				local unit = CreateUnitByName( "npc_dota_doom_minion" , point1 + RandomVector( RandomFloat( 0, 200 ) ), true, nil, nil, DOTA_TEAM_BADGUYS ) 
				unit:SetInitialGoalEntity( waypoint ) -- Посылаем мобов на наш way1, координаты которого мы записали в переменную 'waypoint'

				local unit = CreateUnitByName( "npc_dota_doom_minion" , point1 + RandomVector( RandomFloat( 0, 200 ) ), true, nil, nil, DOTA_TEAM_BADGUYS ) 
				unit:SetInitialGoalEntity( waypoint ) -- Посылаем мобов на наш way1, координаты которого мы записали в переменную 'waypoint'
	 
			end)
			 Timers:CreateTimer(70, function()
				local unit = CreateUnitByName( "npc_dota_bloodseeker_boss" , point + RandomVector( RandomFloat( 0, 200 ) ), true, nil, nil, DOTA_TEAM_BADGUYS ) 
				unit:SetInitialGoalEntity( waypoint ) -- Посылаем мобов на наш way1, координаты которого мы записали в переменную 'waypoint'
			 end)
			 Timers:CreateTimer(80, function()
				local unit = CreateUnitByName( "npc_dota_sans" , point + RandomVector( RandomFloat( 0, 200 ) ), true, nil, nil, DOTA_TEAM_BADGUYS ) 
				unit:SetInitialGoalEntity( waypoint ) -- Посылаем мобов на наш way1, координаты которого мы записали в переменную 'waypoint'
			 end)
			 Timers:CreateTimer(90, function()
				local unit = CreateUnitByName( "npc_phantasm_1" , point + RandomVector( RandomFloat( 0, 200 ) ), true, nil, nil, DOTA_TEAM_BADGUYS ) 
				unit:SetInitialGoalEntity( waypoint ) -- Посылаем мобов на наш way1, координаты которого мы записали в переменную 'waypoint'
			 end)
			 Timers:CreateTimer(100, function()
				for i=1,12 do 
					local unit = CreateUnitByName( "npc_cursed_warrior" , point + RandomVector( RandomFloat( 0, 200 ) ), true, nil, nil, DOTA_TEAM_BADGUYS ) 
					unit:SetInitialGoalEntity( waypoint ) 
				end
			 end)
			 Timers:CreateTimer(110, function()
				local unit = CreateUnitByName( "npc_dota_plague_wagon" , point + RandomVector( RandomFloat( 0, 200 ) ), true, nil, nil, DOTA_TEAM_BADGUYS ) 
				
				ExecuteOrderFromTable({
					UnitIndex = unit:entindex(),
					OrderType = DOTA_UNIT_ORDER_ATTACK_MOVE,
					Position = point,
					Queue = false,
				})			
			 end)			 
			end)
      	end)
 		Timers:CreateTimer(spawn_interval*13, function() 
  			UpdateNettables(true)
  			Spawn:InfiniteMaraphon() 
  		end)
	
end

function Spawn:InfiniteMaraphon()
    local point = Entities:FindByName( nil, "dmpoint2"):GetAbsOrigin() 
    local point1 = Entities:FindByName( nil, "drpoint2"):GetAbsOrigin() 
    local waypoint = Entities:FindByName( nil, "d_waypoint1") 

	Timers:CreateTimer(1, function()
		EmitGlobalSound("SatanBal")
		return 213 -- repeat time
	
	end)
		 
	Timers:CreateTimer(1, function()GameRules:SendCustomMessage("#Game_notification_infinite_maraphon",0,0)	end)

	Timers:CreateTimer(1, function()
		EmitGlobalSound("roshan_def.boss")
		local int = math.random(1,7)
		UpdateNettables(60 - GameRules.line_boss_interval)
		
			if int == 1 then
				GameRules:SendCustomMessage("#Game_notification_boss_spawn_abomination",0,0)		 
				local unit = CreateUnitByName( "npc_dota_abomination_boss" , point + RandomVector( RandomFloat( 0, 200 ) ), true, nil, nil, DOTA_TEAM_BADGUYS ) 
				unit:SetInitialGoalEntity( waypoint ) -- Посылаем мобов на наш way1, координаты которого мы записали в переменную 'waypoint'
				Spawn:Upgrade2(unit,500)
				Spawn:Upgrade2(unit,GameRules.Maraphon_Round/2.5)
				unit:SetPhysicalArmorBaseValue(175)
			elseif int == 2 then
				GameRules:SendCustomMessage("#Game_notification_boss_spawn_fire_golem",0,0)		 
				local unit = CreateUnitByName( "npc_dota_golem_boss" , point + RandomVector( RandomFloat( 0, 200 ) ), true, nil, nil, DOTA_TEAM_BADGUYS ) 
				unit:SetInitialGoalEntity( waypoint ) -- Посылаем мобов на наш way1, координаты которого мы записали в переменную 'waypoint'
				Spawn:Upgrade2(unit,400)
				Spawn:Upgrade2(unit,GameRules.Maraphon_Round/2.5)
				unit:SetPhysicalArmorBaseValue(175)
			elseif int == 3 then
				GameRules:SendCustomMessage("#Game_notification_boss_spawn_necronomicon",0,0)		 
				local unit = CreateUnitByName( "npc_dota_necronomicon_warrior_boss" , point + RandomVector( RandomFloat( 0, 200 ) ), true, nil, nil, DOTA_TEAM_BADGUYS ) 
				unit:SetInitialGoalEntity( waypoint ) -- Посылаем мобов на наш way1, координаты которого мы записали в переменную 'waypoint'
				Spawn:Upgrade2(unit,200)
				Spawn:Upgrade2(unit,GameRules.Maraphon_Round/2.5)
				unit:SetPhysicalArmorBaseValue(175)
	 
				local unit = CreateUnitByName( "npc_dota_necronomicon_archer_boss" , point1 + RandomVector( RandomFloat( 0, 200 ) ), true, nil, nil, DOTA_TEAM_BADGUYS ) 
				unit:SetInitialGoalEntity( waypoint ) -- Посылаем мобов на наш way1, координаты которого мы записали в переменную 'waypoint'
				Spawn:Upgrade2(unit,200)
				Spawn:Upgrade2(unit,GameRules.Maraphon_Round/2.5)
				unit:SetPhysicalArmorBaseValue(150)

			elseif int == 4 then
				GameRules:SendCustomMessage("#Game_notification_boss_spawn_nyx",0,0)		 
				local unit = CreateUnitByName( "npc_dota_nyx_boss" , point + RandomVector( RandomFloat( 0, 200 ) ), true, nil, nil, DOTA_TEAM_BADGUYS ) 
				unit:SetInitialGoalEntity( waypoint ) -- Посылаем мобов на наш way1, координаты которого мы записали в переменную 'waypoint'
				Spawn:Upgrade2(unit,60)
				Spawn:Upgrade2(unit,GameRules.Maraphon_Round/2.5)
				unit:SetPhysicalArmorBaseValue(175)
			elseif int == 5 then
				GameRules:SendCustomMessage("#Game_notification_boss_spawn_doom",0,0)		 
			 
				local unit = CreateUnitByName( "npc_dota_doom_boss" , point + RandomVector( RandomFloat( 0, 200 ) ), true, nil, nil, DOTA_TEAM_BADGUYS ) 
				unit:SetInitialGoalEntity( waypoint ) -- Посылаем мобов на наш way1, координаты которого мы записали в переменную 'waypoint'
				Spawn:Upgrade2(unit,40)
				Spawn:Upgrade2(unit,GameRules.Maraphon_Round/2.5)
				unit:SetPhysicalArmorBaseValue(175)
	 
				local unit = CreateUnitByName( "npc_dota_doom_minion" , point1 + RandomVector( RandomFloat( 0, 200 ) ), true, nil, nil, DOTA_TEAM_BADGUYS ) 
				unit:SetInitialGoalEntity( waypoint ) -- Посылаем мобов на наш way1, координаты которого мы записали в переменную 'waypoint'
				Spawn:Upgrade2(unit,40)
				Spawn:Upgrade2(unit,GameRules.Maraphon_Round/2.5)
				unit:SetPhysicalArmorBaseValue(125)

				local unit = CreateUnitByName( "npc_dota_doom_minion" , point1 + RandomVector( RandomFloat( 0, 200 ) ), true, nil, nil, DOTA_TEAM_BADGUYS ) 
				unit:SetInitialGoalEntity( waypoint ) -- Посылаем мобов на наш way1, координаты которого мы записали в переменную 'waypoint'
				Spawn:Upgrade2(unit,40)
				Spawn:Upgrade2(unit,GameRules.Maraphon_Round/2.5)
				unit:SetPhysicalArmorBaseValue(125)

				local unit = CreateUnitByName( "npc_dota_doom_minion" , point1 + RandomVector( RandomFloat( 0, 200 ) ), true, nil, nil, DOTA_TEAM_BADGUYS ) 
				unit:SetInitialGoalEntity( waypoint ) -- Посылаем мобов на наш way1, координаты которого мы записали в переменную 'waypoint'
				Spawn:Upgrade2(unit,40)
				Spawn:Upgrade2(unit,GameRules.Maraphon_Round/2.5)
				unit:SetPhysicalArmorBaseValue(125)
	 
			elseif int == 6 then
				GameRules:SendCustomMessage("#Game_notification_boss_spawn_seeker",0,0)		 
				local unit = CreateUnitByName( "npc_dota_bloodseeker_boss" , point + RandomVector( RandomFloat( 0, 200 ) ), true, nil, nil, DOTA_TEAM_BADGUYS ) 
				unit:SetInitialGoalEntity( waypoint ) -- Посылаем мобов на наш way1, координаты которого мы записали в переменную 'waypoint'
				Spawn:Upgrade2(unit,16)
				Spawn:Upgrade2(unit,GameRules.Maraphon_Round/2.5)
				unit:SetPhysicalArmorBaseValue(175)
			elseif int == 7 then
				GameRules:SendCustomMessage("#Game_notification_boss_spawn_spectre",0,0)		 
				local unit = CreateUnitByName( "npc_phantasm_1" , point + RandomVector( RandomFloat( 0, 200 ) ), true, nil, nil, DOTA_TEAM_BADGUYS ) 
				unit:SetInitialGoalEntity( waypoint ) -- Посылаем мобов на наш way1, координаты которого мы записали в переменную 'waypoint'
				Spawn:Upgrade2(unit,8)
				Spawn:Upgrade2(unit,GameRules.Maraphon_Round/2.5)
				unit:SetPhysicalArmorBaseValue(175)
				
			end
			 
			GameRules.Maraphon_Round = GameRules.Maraphon_Round + 1
		return 60
	end
)
end

function Spawn:SetSameTeam()
	local team = DOTA_TEAM_BADGUYS

	GameRules:SetCustomGameTeamMaxPlayers( team, PlayerResource:GetPlayerCount() )

	for i=0,4 do
		local hero = PlayerResource:GetSelectedHeroEntity(i)
		if hero then 
			hero:SetTeam(team)
			PlayerResource:SetCustomTeamAssignment(i,team)
		end
	end
	--GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_GOODGUYS, 0 )


end

function Spawn:SetWDToHost()
	local wd_dire = Entities:FindByName(nil, "wd_dire")
	if wd_dire then
		local host = PlayerResource:GetPlayer(0)
		wd_dire:SetOwner(host)
		wd_dire:SetControllableByPlayer(0, false)
	end
	
	local wd_radiant = Entities:FindByName(nil, "wd_radiant")
	if wd_radiant then
		local host = PlayerResource:GetPlayer(0)
		wd_radiant:SetOwner(host)
		wd_radiant:SetControllableByPlayer(0, false)
	end
end

CustomGameEventManager:RegisterListener( "choose_boss_chose", function( a, keyee )
	print( a, keyee )
	if IsServer() then
		local boss = keyee.bossname
		if final_boss == true then
			return
		end
		final_boss = true	
		
		print(final_boss)
		if boss == "zombie" then
			Spawn:ZombieMode()
		elseif boss == "chaos" then
			Spawn:ChaosMode()
		elseif boss == "demon" then 
			Spawn:DemonMode()
		elseif boss == "lich" then
			Spawn:LichMode()
		elseif boss == "necro" then
			Spawn:NecroMode()
		end
	end
end )