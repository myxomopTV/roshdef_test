



function SetColor(data)

	local moob = data.caster
	local name = moob:GetUnitName()
	
	local a = 255
	local b = 255
	local c = 255


	if name == "npc_dota_direr3_1" then
		a = 255
		b = 15
		c = 0
	elseif name == "npc_dota_event_enemy_1" then
		a = 65 
		b = 105
		c = 225
	elseif name == "npc_dota_event_enemy_2" then
		a = 0
		b = 0
		c = 205
	elseif name == "npc_dota_event_enemy_3" then
		a = 205
		b = 0
		c = 0
	elseif name == "npc_dota_event_enemy_4" then
		a = 225
		b = 225
		c = 0
	elseif name == "npc_dota_event_enemy_5" then
		a = 128
		b = 0
		c = 128
	elseif name == "npc_dota_direr3_2" then
		a = 0
		b = 0
		c = 205
	elseif name == "npc_dota_direr3_3" then
		a = 25
		b = 255
		c = 0
	elseif name == "npc_dota_" then
		a = 255
		b = 0
		c = 0
	elseif name == "npc_dota_elemental_4" then
		a = 119
		b = 49
		c = 0
	elseif name == "npc_dota_hero_winter_wyvern" then
		a = 0
		b = 0
		c = 255
	elseif name == "npc_riki_shadow" then
		a = 0
		b = 0
		c = 0
	elseif name == "npc_dota_greevil_lord_egg_weak" then
		a = 255
		b = 153
		c = 51
	elseif name == "npc_dota_greevil_lord_egg_medium" then
		a = 0
		b = 0
		c = 255
	elseif name == "npc_dota_greevil_lord_egg_strong" then
		a = 75
		b = 0
		c = 130
	elseif name == "npc_dota_greevil_lord_tower_fire" then
		a = 255
		b = 0
		c = 0
	elseif name == "npc_dota_greevil_lord_tower_ice" then
		a = 0
		b = 255
		c = 255
	elseif name == "npc_dota_greevil_lord_tower_earth" then
		a = 153
		b = 102
		c = 0
	elseif name == "npc_dota_greevil_lord_tower_storm" then
		a = 255
		b = 255
		c = 0
	elseif name == "npc_dota_greevil_lord_tower_support_red" then
		a = 255
		b = 0
		c = 0
	elseif name == "npc_dota_greevil_lord_tower_support_yellow" then
		a = 255
		b = 255
		c = 0
	elseif name == "npc_dota_greevil_lord_tower_support_green" then
		a = 173
		b = 255
		c = 47
	elseif name == "npc_dota_greevil_lord_tower_support_blue" then
		a = 70
		b = 130
		c = 100
	elseif name == "npc_dota_greevil_lord_tower_support_orange" then
		a = 255
		b = 130
		c = 0
	elseif name == "npc_dota_greevil_lord_titan_egg" then
		a = 255
		b = 0
		c = 0
	elseif name == "npc_dota_secret_tree4" then
		a = 71
		b = 100
		c = 27
	elseif name == "npc_dota_secret_tree5" then
		a = 93
		b = 94
		c = 31
	elseif name == "npc_dota_big_spider_cocoon" then
		a = 173
		b = 255
		c = 47
	elseif name == "npc_dota_broodmother_cocoon" then
		a = 0
		b = 128
		c = 0
	elseif name == "npc_dota_broodmother_guard_cocoon" then
		a = 255
		b = 25
		c = 25
		elseif name == "npc_dota_big_spider" then
		a = 173
		b = 255
		c = 47
	end	


--	GameRules:GetGameModeEntity():SetContextThink(string.format("RespawnThink_%d",moob:GetEntityIndex()), 
--		function()
		moob:SetRenderColor(a, b, c)
--		end,
--		data.Time)		

end


