--models/items/courier/snowl/snowl.vmdl
--models/items/courier/basim/basim.vmdl
--models/courier/baby_winter_wyvern/baby_winter_wyvern.vmdl

if FrostEvent == nil then
	_G.FrostEvent = class({})
end
FrostEvent.event_level = 1
FrostEvent.event_init = false
FrostEvent.event_avatars = {}
FrostEvent.available = true
FrostEvent.players_ingame = 0

function FrostEvent:InitGameMode()
	ListenToGameEvent("npc_spawned",Dynamic_Wrap( self, 'OnNPCSpawned' ), self )
	ListenToGameEvent('entity_killed', Dynamic_Wrap(self, 'OnEntityKilled'), self)
	ListenToGameEvent('entity_hurt', Dynamic_Wrap(self, 'OnEntityHurt'), self)
end

function FrostEvent:OnEntityKilled( keys )
	local killedUnit = EntIndexToHScript( keys.entindex_killed )
	local killerUnit = EntIndexToHScript( keys.entindex_attacker )
	local name = killedUnit:GetUnitName()
	local team = killedUnit:GetTeam()
	local point = killedUnit:GetAbsOrigin()

	if name == "npc_dota_rock" then
		CreateUnitByName( "npc_dota_event_portal_start" , point, true, nil, nil, DOTA_TEAM_NEUTRALS )
	end
	if killedUnit.box_type then
		local box_type = killedUnit.box_type 
	--	killedUnit:SetModel("models/gameplay/breakingcrate_dest.vmdl")
	--	killedUnit:SetOriginalModel("models/gameplay/breakingcrate_dest.vmdl")
		killedUnit:AddNoDraw()

		if box_type == "simple" then
			GiveGoldPlayers(10)
			local effect = "particles/units/heroes/hero_zuus/zeus_taunt_coin.vpcf"
			local pfx = ParticleManager:CreateParticle(effect, PATTACH_WORLDORIGIN, nil)
			ParticleManager:SetParticleControl(pfx, 0, point)
			ParticleManager:ReleaseParticleIndex(pfx)
--			DropItemWithTimerGround(killedUnit, "item_event_gold_bag", 10)
		elseif box_type == "bonus" then
			DropItemWithTimerGround(killedUnit, "item_event_gold_coin", 10)
		elseif box_type == "upgrade" then
			local ability = killerUnit:FindAbilityByName("event_land_mine")
			if ability then
				ability:SetLevel(ability:GetLevel() + 1)
			end
		elseif box_type == "enemy" then
			local unit = CreateUnitByName( "npc_dota_event_ghoul_1" , point, true, nil, nil, DOTA_TEAM_NEUTRALS )
			unit.event = true
		elseif box_type == "big_enemy" then
			local unit = CreateUnitByName( "npc_dota_event_ghoul_2" , point, true, nil, nil, DOTA_TEAM_NEUTRALS )
			unit.event = true
		elseif box_type == "item" then
			DropItemWithTimerGround(killedUnit, "item_event_gift_1", 10)
		elseif box_type == "black" then	
			local roll_number = RandomInt(1, 100)
			if roll_number <= 35 then
				local unit = CreateUnitByName( "npc_dota_event_ghoul_1" , point, true, nil, nil, DOTA_TEAM_NEUTRALS )
				unit.event = true
			elseif roll_number <= 50 then
				local unit = CreateUnitByName( "npc_dota_event_ghoul_2" , point, true, nil, nil, DOTA_TEAM_NEUTRALS )
				unit.event = true
			elseif roll_number <= 75 then
				local ability = killerUnit:FindAbilityByName("event_land_mine")
				if ability then
					ability:SetLevel(ability:GetLevel() + 1)
				end
			elseif roll_number <= 95 then
				DropItemWithTimerGround(killedUnit, "item_event_gold_coin", 10)
			elseif roll_number <= 100 then
				DropItemWithTimerGround(killedUnit, "item_event_gift_1", 10)
			end
		end
	end
	
	if killedUnit.avatar == true then 
		killedUnit.hero:RemoveModifierByName("modifier_event_portal_start_hidden")

--		PlayerResource:SetCameraTarget(killedUnit.player, killedUnit.hero)
		killedUnit.hero:Stop()
		Timers:CreateTimer(0.1, function()
			PlayerResource:SetCameraTarget(killedUnit.player, nil)
			PlayerResource:SetOverrideSelectionEntity(killedUnit.player, nil)

		end)

		self.event_avatars[killedUnit:entindex()] = nil
		self.players_ingame = self.players_ingame - 1
		print("players_ingame = "..self.players_ingame)
--[[		for i = #self.event_avatars, 1, -1 do
			if killedUnit == self.event_avatars[i] then
				self.players_ingame = self.players_ingame - 1
				table.remove(self.event_avatars, i)
			end
		end]]

		Timers:CreateTimer(5, function()
			killedUnit.hero.event_valid = true
		end)

	end	

	if killedUnit:GetUnitName() == "npc_dota_event_mega_ghoul" then
		GiveGoldPlayers(5000)
		self.event_level = self.event_level + 1
		self.event_init   = false
		self.available = false
		self:EndRound()		
	end

	if killedUnit.defense then
		self.defense_enemy_count = self.defense_enemy_count - 1
		GiveGoldPlayers(10)
		local effect = "particles/units/heroes/hero_zuus/zeus_taunt_coin.vpcf"
		local pfx = ParticleManager:CreateParticle(effect, PATTACH_WORLDORIGIN, nil)
		ParticleManager:SetParticleControl(pfx, 0, point)
		ParticleManager:ReleaseParticleIndex(pfx)

		if self.defense_init == false and self.defense_enemy_count == 0 then
			if self.defense_lvl == 5 then
				GiveGoldPlayers(2500)
				EmitGlobalSound("event_gift")

				self.event_level = self.event_level + 1
				self.event_init   = false
				self:EndRound()						
			else
				self.defense_lvl = self.defense_lvl + 1
				self.defense_init = false
				self:StartEvent_3()
			end
		end
	end	

end

function FrostEvent:OnEntityHurt(keys)
--	DeepPrintTable(keys)
	local npc = EntIndexToHScript(keys.entindex_killed)

	if npc:GetUnitName() == "npc_dota_event_tree" then
		print("event tree atacked !")
		if npc:GetHealth() <= 0 then
			npc:SetHealth(npc:GetMaxHealth())
			self.event_init   = false
			self.defense_init = false
			self:EndRound()						

			for i = #self.defense_enemies, 1, -1 do
				if IsValidEntity(self.defense_enemies[i]) and self.defense_enemies[i]:IsAlive()  then
					self.defense_enemies[i]:RemoveSelf()
				end
				table.remove(self.defense_enemies, i)
			end
		end
	end			
end

function FrostEvent:OnNPCSpawned(keys)

	--if centaur_const==1 then Say(nil,"FrostEvent:OnNPCSpawned works !!!"  , false) end 
	--Say(nil,"FrostEvent:OnNPCSpawned works !!!"  , false)
	local npc = EntIndexToHScript(keys.entindex)
	local name = npc:GetUnitName()
	local team = npc:GetTeam()
	local main_team = DOTA_TEAM_GOODGUYS
 	
end

function FrostEvent:StartEvent_1()
	local max_length = 10000
	local max_width = 5000
--	local center = Entities:FindByName(nil, ""):GetAbsOrigin()

	local max_point = Entities:FindByName(nil, "event_1_max_point"):GetAbsOrigin()
	local min_point = Entities:FindByName(nil, "event_1_min_point"):GetAbsOrigin()
	local length = max_point.x - min_point.x
	local width = max_point.y - min_point.y
	print("length ="..length)
	print("width ="..width)

	local count_length = math.floor(length/80)
	local count_width = math.floor(width/80)
	local count_box = count_length * count_width
	local delta_length = length/count_length
	local delta_width = width/count_width
	print("count_length ="..count_length)
	print("count_width ="..count_width)

	local box_bonus = 1
	local box_enemy = 2
	local box_big_enemy = 1
	local box_upgrade = 10
	local box_black = 1
	local box_item = 1
	local box_simple = count_box - box_bonus - box_enemy - box_big_enemy - box_upgrade - box_black - box_item

	local box_list = {
		{box_type ="simple"		, box_count = box_simple},
		{box_type ="bonus"		, box_count = box_bonus},
		{box_type ="enemy"		, box_count = box_enemy},
		{box_type ="big_enemy"	, box_count = box_big_enemy},
		{box_type ="upgrade"	, box_count = box_upgrade},
		{box_type ="black"		, box_count = box_black},
		{box_type ="item"		, box_count = box_item},
	}
	local boxes = {}
	event_box = {}
	local k = 1

	for _,box in ipairs(box_list) do
		for i=1,box.box_count do
			boxes[k] = box.box_type
			k = k + 1
		end
	end

	local k = 1

	for i=1, count_length do
		for j=1, count_width do
			local jndex = j
			if i % 2 == 0 then
				jndex = count_width - j + 1
			end
			k = k + 1
			Timers:CreateTimer(0.1*k, function()
				local box_index = RandomInt(1, #boxes)
				local box_type = boxes[box_index]
				table.remove(boxes, box_index)

				local box_color = {255,255,255}
				if box_type=="upgrade" then
					box_color = {255,255,0}
				elseif box_type=="bonus" then
	--				box_color = {0,255,255}
				elseif box_type=="enemy" then
	--				box_color = {255,0,255}
				elseif box_type=="big_enemy" then
	--				box_color = {0,0,255}
				elseif box_type=="upgrade" then
					box_color = {255,0,0}
				elseif box_type=="item" then
	--				box_color = {0,255,0}
				elseif box_type=="black" then
					box_color = {0,0,0}
				end

				local point = min_point + Vector(delta_length*i, delta_width*jndex, 0)

				local box = CreateUnitByName("npc_dota_snow_box", point, false, nil, nil, DOTA_TEAM_NEUTRALS)
				box.box_type = box_type
				box.event = true
				table.insert(event_box, box)
				box:SetRenderColor( box_color[1], box_color[2] , box_color[3] )
				print("box["..i.."]["..jndex.."] = "..box_type)
			end)		
		end
	end
end

function FrostEvent:EndEvent_1()
	for _, box in pairs(event_box) do
		if IsValidEntity(box) and box:IsAlive() then
			box.box_type = nil
			box:RemoveSelf()
		end
	end
end

function FrostEvent:StartEvent_2()
	unit_patrul = {
		"event_circle_point_1", "event_circle_point_2", "event_circle_point_3", "event_circle_point_4", 
		"event_patrul_point_41", "event_patrul_point_11", "event_patrul_point_21", "event_patrul_point_31"
	}
	local cell_number = 15
	local row_number  = 3
	local secret_index = RandomInt(4, 15)

	for _,corner_point in pairs(unit_patrul) do
		local point = Entities:FindByName(nil, corner_point):GetAbsOrigin()
		local unit = CreateUnitByName("npc_dota_event_ghoul_3", point, false, nil, nil, DOTA_TEAM_NEUTRALS)
		unit:SetInitialWaypoint(corner_point)
		unit.event = true
	end

	for i=1,cell_number do
		local cells = Entities:FindAllByName("cell_"..i)
		local current_types = {"up","down","side"}
		if i == secret_index then
		 	current_types = {"secret","down","down"}
		end
		for j=1,row_number do
			local index = RandomInt(1, #current_types)
			local value = current_types[index]
			table.remove(current_types, index)
--			cells_list[i][j] = value
			cells[j].cell_index = i
			cells[j].cell_type = value
			print("cells["..i.."]["..j.."] = "..value)
		end
	end

end

FrostEvent.defense_lvl = 1
FrostEvent.defense_init = true
FrostEvent.defense_enemies = {}



function FrostEvent:StartEvent_3()
	FrostEvent.defense_init = true
	FrostEvent.defense_enemy_count = 0
	local defense_units = {
		[1] = { unit_1 = 60, unit_2 = 0, unit_3 = 0, unit_4 = 0, unit_5 = 0},
		[2] = { unit_1 = 20, unit_2 = 0, unit_3 = 0, unit_4 = 0, unit_5 = 0},
		[3] = { unit_1 = 30, unit_2 = 0, unit_3 = 0, unit_4 = 0, unit_5 = 0},
		[4] = { unit_1 = 45, unit_2 = 0, unit_3 = 0, unit_4 = 0, unit_5 = 0},
		[5] = { unit_1 = 30, unit_2 = 0, unit_3 = 0, unit_4 = 0, unit_5 = 1},
	}
	local current_units = defense_units[FrostEvent.defense_lvl]
	local round_timer = 60
	local current_time = GameRules:GetGameTime()
	self.defense_end_time = current_time + round_timer

	if current_units.unit_1 > 0 then
		self.unit_interval_1  = round_timer/ current_units.unit_1
		self.unit_spawntime_1 = current_time + self.unit_interval_1
	else
		self.unit_interval_1 = nil
	end

	if current_units.unit_2 > 0 then
		self.unit_interval_2  = round_timer/ current_units.unit_2
		self.unit_spawntime_2 = current_time + self.unit_interval_2
	else
		self.unit_interval_2 = nil
	end

	if current_units.unit_3 > 0 then
		self.unit_interval_3  = round_timer/ current_units.unit_3
		self.unit_spawntime_3 = current_time + self.unit_interval_3
	else
		self.unit_interval_3 = nil
	end

	if current_units.unit_4 > 0 then
		self.unit_interval_4  = round_timer/ current_units.unit_4
		self.unit_spawntime_4 = current_time + self.unit_interval_4
	else
		self.unit_interval_4 = nil
	end

	if current_units.unit_5 > 0 then
		self.unit_interval_5  = round_timer/ current_units.unit_5
		self.unit_spawntime_5 = current_time + self.unit_interval_5
	else
		self.unit_interval_5 = nil
	end

	GameRules:GetGameModeEntity():SetThink( "DefenseThink", self, "GlobalThink", 0.1 )
end

function FrostEvent:DefenseThink()
	local current_time = GameRules:GetGameTime()
	if self.defense_init == false or self.defense_end_time < current_time then
		self.defense_init = false
		return 
	end

	local event_tree = Entities:FindByName(nil, "event_tree")
	local enemy_points = Entities:FindAllByName("event_defense_enemy_point")

	if self.unit_interval_1 and self.unit_spawntime_1 <= current_time then
		self.unit_spawntime_1 = current_time + self.unit_interval_1
		for i=1, FrostEvent.players_ingame do
			local point = enemy_points[RandomInt(1, #enemy_points)]:GetAbsOrigin()
			local unit = CreateUnitByName( "npc_dota_event_enemy_1" , point, true, nil, nil, DOTA_TEAM_NEUTRALS )
			unit:SetForceAttackTarget(event_tree)
			unit.event = true
			unit.defense = true
			FrostEvent.defense_enemy_count = FrostEvent.defense_enemy_count + 1
			table.insert(FrostEvent.defense_enemies,unit)
		end
	end

	if self.unit_interval_2 and self.unit_spawntime_2 <= current_time then
		self.unit_spawntime_2 = current_time + self.unit_interval_2
		for i=1, FrostEvent.players_ingame do
			local point = enemy_points[RandomInt(1, #enemy_points)]:GetAbsOrigin()
			local unit = CreateUnitByName( "npc_dota_event_enemy_2" , point, true, nil, nil, DOTA_TEAM_NEUTRALS )
			unit:SetForceAttackTarget(event_tree)
			unit.event = true
			unit.defense = true
			FrostEvent.defense_enemy_count = FrostEvent.defense_enemy_count + 1
			table.insert(FrostEvent.defense_enemies,unit)
		end
	end

	if self.unit_interval_3 and self.unit_spawntime_3 <= current_time then
		self.unit_spawntime_3 = current_time + self.unit_interval_3
		for i=1, FrostEvent.players_ingame do
			local point = enemy_points[RandomInt(1, #enemy_points)]:GetAbsOrigin()
			local unit = CreateUnitByName( "npc_dota_event_enemy_3" , point, true, nil, nil, DOTA_TEAM_NEUTRALS )
			unit:SetForceAttackTarget(event_tree)
			unit.event = true
			unit.defense = true
			FrostEvent.defense_enemy_count = FrostEvent.defense_enemy_count + 1
			table.insert(FrostEvent.defense_enemies,unit)
		end
	end

	if self.unit_interval_4 and self.unit_spawntime_4 <= current_time then
		self.unit_spawntime_4 = current_time + self.unit_interval_4
		for i=1, FrostEvent.players_ingame do
			local point = enemy_points[RandomInt(1, #enemy_points)]:GetAbsOrigin()
			local unit = CreateUnitByName( "npc_dota_event_enemy_4" , point, true, nil, nil, DOTA_TEAM_NEUTRALS )
			unit:SetForceAttackTarget(event_tree)
			unit.event = true
			unit.defense = true
			FrostEvent.defense_enemy_count = FrostEvent.defense_enemy_count + 1
			table.insert(FrostEvent.defense_enemies,unit)
		end
	end

	if self.unit_interval_5 and self.unit_spawntime_5 <= current_time then
		self.unit_spawntime_5 = current_time + self.unit_interval_5
		for i=1, FrostEvent.players_ingame do
			local point = enemy_points[RandomInt(1, #enemy_points)]:GetAbsOrigin()
			local unit = CreateUnitByName( "npc_dota_event_enemy_5" , point, true, nil, nil, DOTA_TEAM_NEUTRALS )
			unit:SetForceAttackTarget(event_tree)
			unit.event = true
			unit.defense = true
			FrostEvent.defense_enemy_count = FrostEvent.defense_enemy_count + 1
			table.insert(FrostEvent.defense_enemies,unit)
		end
	end

	return 0.1
end

function FrostEvent:StartEvent_5()
	unit_patrul = {
		"event_boss_patrul_11", "event_boss_patrul_21", "event_boss_patrul_32", "event_boss_patrul_42", 
	}
	local cell_number = 15
	local row_number  = 3
	local secret_index = RandomInt(4, 15)

	for _,corner_point in pairs(unit_patrul) do
		local point = Entities:FindByName(nil, corner_point):GetAbsOrigin()
		local unit = CreateUnitByName("npc_dota_event_ghoul_3", point, false, nil, nil, DOTA_TEAM_NEUTRALS)
		unit:SetInitialWaypoint(corner_point)
		unit.event = true
	end

	local point = Entities:FindByName(nil, "event_boss_spawn_point"):GetAbsOrigin()
	local unit = CreateUnitByName("npc_dota_event_mega_ghoul", point, false, nil, nil, DOTA_TEAM_NEUTRALS)
	unit.event = true

end

function FrostEvent:EndRound()
	FrostEvent.event_init   = false
	local avatars = FrostEvent.event_avatars
	for _,avatar in pairs(avatars) do
		avatar:ForceKill(false)
	end
--[[	for i = #avatars, 1, -1 do
			avatars[i]:ForceKill(false)
		end]]	
end
FrostEvent:InitGameMode()