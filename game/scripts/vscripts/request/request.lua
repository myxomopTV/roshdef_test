--=======================================================
--
--  Author: HappyFeedFriends
--  Date Release: 21.01.2020
--  Date last patch 21.01.2020
--  Description: working with the server and managing servers with each other
--  Github: null
--
--=======================================================
if not _G.request then 
    request = class({})
    request.__http = 'http://roshan-defense.com/dota_api/'
    request.__authKey = GetDedicatedServerKeyV2("authKey")
    request.__players = {}
end

require('request/util')

function request:Init()
    ListenToGameEvent('npc_spawned', Dynamic_Wrap(request, 'OnNPCSpawned'), self)
    ListenToGameEvent('player_disconnect', Dynamic_Wrap(request, 'OnDisconnect'), self)
    ListenToGameEvent('game_rules_state_change', Dynamic_Wrap(request, 'OnGameRulesStateChange'), self)
    -- GameRules:GetGameModeEntity():SetModifyGoldFilter(Dynamic_Wrap(request, 'ModifyGoldFilter'), self)
    GameRules:GetGameModeEntity():SetDamageFilter( Dynamic_Wrap( request, "DamageFilter" ), request)
end

function request:DamageFilter(filterDamage)
    local attacker = filterDamage.entindex_attacker_const and EntIndexToHScript(filterDamage.entindex_attacker_const) 
    if not attacker then
        print('[DamageFilter] Unit damage not attacker!',EntIndexToHScript(filterDamage.entindex_victim_const):GetUnitName()) 
        return true 
    end 
    local ability,abilityName
    local victim = EntIndexToHScript(filterDamage.entindex_victim_const)
    local typeDamage = filterDamage.damagetype_const
    if filterDamage.entindex_inflictor_const then
        ability = EntIndexToHScript(filterDamage.entindex_inflictor_const )
        if ability and ability.GetAbilityName and ability:GetAbilityName() then
            abilityName = ability:GetAbilityName()
        end
    end

    if attacker:IsRealHero() then 
        local __data = request.__players[attacker:GetPlayerID()]
        if __data then
            __data.DamageAll = __data.DamageAll + filterDamage.damage
        end
    end
    return true
end

function request:OnGameRulesStateChange()
	local newState = GameRules:State_Get()
	if newState == DOTA_GAMERULES_STATE_CUSTOM_GAME_SETUP then
        request.__exports.PlayerEach(function(pID)
            request.__players[pID] = { -- base data players
                GameDurationPlayer = 0,
                DamageAll = 0,
            }
        end)
        request:OnLoadingData()
    end
end

function request:GameEnd(winTeam)
    winTeam = winTeam or DOTA_TEAM_GOODGUYS
    GameRules:SetGameWinner(winTeam)
    local IsSpeedRun = CustomNetTables:GetTableValue( "donate", 'GLOBAL')
    IsSpeedRun = IsSpeedRun and IsSpeedRun.use_donate ~= 0
    local _data = {
        players = {},
        const   = {
            GameMode = GetMapName(), -- map
            Difficuilt = GameRules.DIFFICULTY, 
            GameDuration = GameRules:GetDOTATime(false, false), 
            MatchID = tostring(GameRules:GetMatchID()),
            IsSpeedRun = not not IsSpeedRun,
        }
    }
    local __data = {}
    request.__exports.PlayerEach(function(pID)
        if not request.__exports.IsBot(pID) then 
            local steamID = tostring(PlayerResource:GetSteamID(pID))
            _data['players'][steamID] = request:GetDataPlayer(pID,winTeam)
            __data[pID] = {
                AgilityCandy   =  _data['players'][steamID].AgilityCandy,
                StrengthCandy  =  _data['players'][steamID].StrengthCandy,
                IntellectCandy =  _data['players'][steamID].IntellectCandy,
                Items          =  _data['players'][steamID].Items,
                TotalDamageTaken    = PlayerResource:GetCreepDamageTaken(pID,true), -- Client - GetTotalDamageTaken() return 0!...
                TotalDamage         = request.__players[pID] and request.__players[pID].DamageAll or 0,
                IsWin               = _data['players'][steamID].IsWinner,
                MMR                 = math.floor(math.floor(_data['players'][steamID].GameDurationPlayer)/60 * ( 1 + 0.5 * GameRules.DIFFICULTY)),
            }
        end
    end)
    CustomNetTables:SetTableValue('request', 'GameEnd',__data)
    if not GameRules:IsCheatMode() and not IsInToolsMode() then 
        request.__exports.RequestData('game_end',_data)     
    end
    Timers:CreateTimer(0.1,function()
        CustomGameEventManager:Send_ServerToAllClients('OnGameEnd', {
            GameData = __data,
        })
    end)

end

function request:OnLoadingData()
    local _data = {}

    request.__exports.PlayerEach(function(pID)
        if not request.__exports.IsBot(pID) then 
            local steamID = tostring(PlayerResource:GetSteamID(pID))
            _data[pID] = {
                steamID = steamID,
            }
        end
    end)

    request.__exports.RequestData('loading',_data,function(data)
        CustomNetTables:SetTableValue('request', 'leaderboards_speenRun', data.leaderboards_speenRun)
        CustomNetTables:SetTableValue('request', 'leaderboards', data.leaderboards)
        for k,v in pairs(data.Players) do
            CustomNetTables:SetTableValue('request', k , v)
        end
    end)
end

function request:GetDataPlayer(pID,teamWin)
    local unit = PlayerResource:GetSelectedHeroEntity(pID)
    local dotaTime = GameRules:GetDOTATime(false,false)
    local IsAbandoned = request:IsAbandonedPlayer(pID)
    local agility = unit:FindModifierByName('tome_agility_modifier')
    local strength = unit:FindModifierByName('tome_strenght_modifier')
    local intellect = unit:FindModifierByName('tome_intelect_modifier')
    return {
        GameDurationPlayer = IsAbandoned and request.__players[pID] and request.__players[pID].GameDurationPlayer or dotaTime,
        LastHit = PlayerResource:GetLastHits(pID),
        HeroName = unit:GetUnitName(), -- hero
        Level = unit:GetLevel(),
        Items = request:GetItems(unit),
        IsWinner = not IsAbandoned and teamWin == unit:GetTeamNumber(),
        XpAll = unit:GetCurrentXP(),
        IsAbandoned = IsAbandoned,
        AgilityCandy = agility and agility:GetStackCount() or 0,
        StrengthCandy = strength and agility:GetStackCount() or 0,
        IntellectCandy = intellect and agility:GetStackCount() or 0,
        Gold = PlayerResource:GetTotalEarnedGold(pID),
    }
end 

function request:OnDisconnect(keys)
    local pID = keys.PlayerID
    if request.__players[pID] then 
        request.__players[pID].GameDurationPlayer = GameRules:GetDOTATime(false,false)
    end
end

-- function request:ModifyGoldFilter(filterTable)
--     if not request.__players[filterTable.player_id_const] then return end
--     request.__players[filterTable.player_id_const].GoldAll = request.__players[filterTable.player_id_const].GoldAll + filterTable.gold
--     return true
-- end

function request:OnNPCSpawned(data)
    local SpawnedUnit = EntIndexToHScript(data.entindex)
    if not SpawnedUnit:IsNull() and SpawnedUnit:IsRealHero() then
        local pID = SpawnedUnit:GetPlayerID()
        if not request.__players[pID] then
            request.__players[pID] = { -- base data players
                GameDurationPlayer = 0,
                DamageAll = 0,
            }
        end
    end
end


function request:IsAbandonedPlayer(pID)
    return PlayerResource:GetConnectionState(pID) ~= DOTA_CONNECTION_STATE_CONNECTED
end

function request:GetItems(hUnit)
    local data = {}
    for i=0,DOTA_STASH_SLOT_6 do
        local current_item = hUnit:GetItemInSlot(i)
        if current_item  then
            data[i] = {
                sName = current_item:GetName(),
                iCharges = current_item:GetCurrentCharges(),
                fCooldown = current_item:GetCooldownTimeRemaining(),
                -- bIsStash = i >= DOTA_STASH_SLOT_1,
            }
        end
    end

    return data
end