 	
power_mult = 1
power_mult1 = 1

function Respoint (keys )
	Timers:CreateTimer(0.01,function()	          

		local caster = keys.caster 	--пробиваем IP усопшего
		caster.respoint = caster:GetAbsOrigin() -- определяем точку спавна
		caster.fw = caster:GetForwardVector()
		end)
end

function Upgrader(keys)	

	local caster= keys.caster
	local position = caster.respoint
	local name = caster:GetUnitName()
	local team = caster:GetTeam()
	local unit
	local respawn_time = GameRules.neutral_respawn
	local gold
	
	Timers:CreateTimer(respawn_time,function()	
		unit = CreateUnitByName(name, position + RandomVector( RandomFloat( 0, 50)), true, nil, nil, team)
		gold = unit:GetMinimumGoldBounty()*power_mult
		if gold >= 25000 then
			gold = 25000
		end
		unit:SetMaximumGoldBounty(gold)				
		unit:SetMinimumGoldBounty(gold)

		unit:SetForwardVector(caster.fw)
		unit:SetBaseDamageMin(unit:GetBaseDamageMin()*power_mult)
		unit:SetBaseDamageMax(unit:GetBaseDamageMax()*power_mult)				
		unit:SetPhysicalArmorBaseValue(unit:GetPhysicalArmorBaseValue()*power_mult1)
		local maxhp = unit:GetMaxHealth()*power_mult
		unit:SetBaseMaxHealth(maxhp)
		unit:SetMaxHealth(maxhp)	
		unit:SetHealth(maxhp)

	end)
	
	power_mult = power_mult * 2
	power_mult1 = power_mult1 + 1
end


function respawn_strong(keys)	

	local caster= keys.caster
	local position = caster.respoint
	local name = caster:GetUnitName()
	local team = caster:GetTeam()
	local respawn_time = GameRules.neutral_respawn
	
	if name == "npc_dota_elemental_1" then 	 name = "npc_dota_elemental_1_1" 
	elseif name == "npc_dota_elemental_1_1" then 	 name = "npc_dota_elemental_1" 
	elseif name == "npc_dota_elemental_2" then 	 name = "npc_dota_elemental_2_1" 
	elseif name == "npc_dota_elemental_2_1" then 	 name = "npc_dota_elemental_2" 
	elseif name == "npc_dota_elemental_3" then 	 name = "npc_dota_elemental_3_1" 
	elseif name == "npc_dota_elemental_3_1" then 	 name = "npc_dota_elemental_3" 
	elseif name == "npc_dota_elemental_4" then 	 name = "npc_dota_elemental_4_1" 
	elseif name == "npc_dota_elemental_4_1" then 	 name = "npc_dota_elemental_4" 
	end

	Timers:CreateTimer(respawn_time,function()	
	local unit = CreateUnitByName(name, position + RandomVector( RandomFloat( 0, 50)), true, nil, nil, team)
	unit:SetForwardVector(caster.fw)
		if name == "npc_dota_roshan2" and GameRules.MegaMode == 1 then
			Spawn:Upgrade2(unit,400)
			unit:SetPhysicalArmorBaseValue(75)
		end
	end)
end
	
function SpawnZombie1( keys )
if not keys.target:IsAlive() then
	local caster = keys.target	
	local caster_position = caster:GetAbsOrigin()
	if caster:GetUnitName() == "npc_dota_mad_chicken" or caster:GetUnitName() == "npc_dota_secret_chicken" then
		return
	end
	local unit = CreateUnitByName( "npc_dota_zombie1"  , caster_position + RandomVector( RandomFloat( 0, 50 ) ), true, nil, nil, DOTA_TEAM_BADGUYS )
	if GameRules.ZombieMode == 1 then
		unit:SetBaseDamageMin(unit:GetBaseDamageMin()*1.5)
		unit:SetBaseDamageMax(unit:GetBaseDamageMax()*1.5)				
		unit:SetPhysicalArmorBaseValue(unit:GetPhysicalArmorBaseValue()*1.5)
		unit:SetMaxHealth(unit:GetMaxHealth()*1.5)
		unit:SetHealth(unit:GetMaxHealth())
	end

	-- Destroy trees around the caster and target
end
end
	
function SpawnZombie2( keys )
if not keys.target:IsAlive() then
	local caster = keys.target	
	local caster_position = caster:GetAbsOrigin()
	if caster:GetUnitName() == "npc_dota_mad_chicken" or caster:GetUnitName() == "npc_dota_secret_chicken" then
		return
	end
	local unit = CreateUnitByName( "npc_dota_zombie2"  , caster_position + RandomVector( RandomFloat( 0, 50 ) ), true, nil, nil, DOTA_TEAM_BADGUYS )
	if GameRules.ZombieMode == 1 then
		unit:SetBaseDamageMin(unit:GetBaseDamageMin()*1.5)
		unit:SetBaseDamageMax(unit:GetBaseDamageMax()*1.5)				
		unit:SetPhysicalArmorBaseValue(unit:GetPhysicalArmorBaseValue()*1.5)
		unit:SetMaxHealth(unit:GetMaxHealth()*1.5)
		unit:SetHealth(unit:GetMaxHealth())
	end
	-- Destroy trees around the caster and target
end
end

function SpawnZombie3( keys )
if not keys.target:IsAlive() then
	local caster = keys.target	
	local caster_position = caster:GetAbsOrigin()
	if caster:GetUnitName() == "npc_dota_mad_chicken" or caster:GetUnitName() == "npc_dota_secret_chicken" then
		return
	end
	local unit = CreateUnitByName( "npc_dota_zombie3"  , caster_position + RandomVector( RandomFloat( 0, 50 ) ), true, nil, nil, DOTA_TEAM_BADGUYS )
	if GameRules.ZombieMode == 1 then
		unit:SetBaseDamageMin(unit:GetBaseDamageMin()*1.5)
		unit:SetBaseDamageMax(unit:GetBaseDamageMax()*1.5)				
		unit:SetPhysicalArmorBaseValue(unit:GetPhysicalArmorBaseValue()*1.5)
		unit:SetMaxHealth(unit:GetMaxHealth()*1.5)
		unit:SetHealth(unit:GetMaxHealth())
	end

	-- Destroy trees around the caster and target
end
end

function Respawn (keys )
	local caster= keys.caster
	local caster_position = caster:GetAbsOrigin()
	local name = caster:GetUnitName()
	local team = caster:GetTeam()
	local respawn_time = GameRules.neutral_respawn


	Timers:CreateTimer(respawn_time,function()	
		local unit = CreateUnitByName(name, caster_position + RandomVector( RandomFloat( 0, 50)), true, nil, nil, team)
	end)
end	
	
function Boss_Respawn (keys )
	local caster= keys.caster
--	local caster_position = caster:GetAbsOrigin()
	local position = caster.respoint
	local name = caster:GetUnitName()
	local team = caster:GetTeam()
	local respawn_time = GameRules.boss_respawn

	
	if name == "npc_dota_boss_fire_1" then name = "npc_dota_boss_fire_2"
	elseif name == "npc_dota_boss_fire_2" then name = "npc_dota_boss_fire_3"
	elseif name == "npc_dota_boss_vampire_1" then name = "npc_dota_boss_vampire_2"
	elseif name == "npc_dota_boss_vampire_2" then name = "npc_dota_boss_vampire_3"
	elseif name == "npc_dota_boss_forest_1" then name = "npc_dota_boss_forest_2"
	elseif name == "npc_dota_boss_forest_2" then name = "npc_dota_boss_forest_3"
	elseif name == "npc_dota_boss_water_1" then name = "npc_dota_boss_water_2"
	elseif name == "npc_dota_boss_water_2" then name = "npc_dota_boss_water_3"
	elseif name == "npc_dota_boss_wind_1" then name = "npc_dota_boss_wind_2"
	elseif name == "npc_dota_boss_wind_2" then name = "npc_dota_boss_wind_3"
	elseif name == "npc_dota_spider_boss_1" then name = "npc_dota_spider_boss_2"
	elseif name == "npc_dota_spider_boss_2" then name = "npc_dota_spider_boss_3"
	elseif name == "npc_dota_alliance_boss_1" then name = "npc_dota_alliance_boss_2"
	elseif name == "npc_dota_alliance_boss_2" then name = "npc_dota_alliance_boss_3"
	elseif name == "npc_dota_naga_boss_1" then name = "npc_dota_naga_boss_2"
	elseif name == "npc_dota_naga_boss_2" then name = "npc_dota_naga_boss_3"
	elseif name == "npc_dota_dire_forest_boss_1" then name = "npc_dota_dire_forest_boss_2"
	elseif name == "npc_dota_dire_forest_boss_2" then name = "npc_dota_dire_forest_boss_3"
	end

	Timers:CreateTimer(respawn_time,function()	
	local unit = CreateUnitByName(name, position + RandomVector( RandomFloat( 0, 50)), true, nil, nil, team)
	unit:SetForwardVector(caster.fw)
	end)
end	
	
function reincarnate(keys )
	local caster= keys.caster
	local caster_position = caster:GetAbsOrigin()
	local name = caster:GetUnitName()
	local team = caster:GetTeam()
--	if team == "DOTA_TEAM_BADGUYS" then team = "DOTA_TEAM_GOODGUYS"
--		elseif team == "DOTA_TEAM_GOODGUYS" then team = "DOTA_TEAM_BADGUYS"
--	end
	local unit = CreateUnitByName(name, caster_position + RandomVector( RandomFloat( 0, 50)), true, nil, nil, DOTA_TEAM_GOODGUYS)
	
end	

function Roshan_Soul_activate( keys )

	Spawn:NeutralSpawner1()
	GameRules.RoshanUpgrade = 1

end	

function MegaMode_activate()
	Spawn:MegaMode()
end
	
function CreatureLevelUp( keys )
	local caster = keys.caster	
	local name= caster:GetUnitName()
	local game_time=GameRules:GetDOTATime(false,false)
	caster:CreatureLevelUp(game_time)
	Say(nil,"GameTime =" .. game_time, false)
end		

