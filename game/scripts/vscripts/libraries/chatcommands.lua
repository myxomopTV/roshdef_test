--[[
A basic chat command library

Requirements:
Add require('libraries/chatcommands')  before InitGameMode() is called

Add this line to your InitGameMode() function.  (If you are using barebones, you'll have to uncomment or change the default one)
ListenToGameEvent("player_chat", Dynamic_Wrap(CheatCommands, 'OnPlayerChat'), self)
]]

if not ChatCommands then
  ChatCommands = class({})
end

--Developer ID's to be set
if not DEVELOPER_IDS then
  DEVELOPER_IDS = {
    [37654428] = true,
    [52214406] = true,
  }
end
if not TESTER_IDS then
  TESTER_IDS = {
    [49129750] = true,
    [47591958] = true,
    [72632440] = true,
    [93387204] = true,
    [66349662] = true,
    [44964187] = true,
    [89928375] = true,
    [127538205] = true,
    [134972283] = true,
    [86306396] = true,
    [114369584] = true,
    [117501733] = true, -- bloodinfect
  }
end


TestersPermissionsGranted = false
TestersFullPermissionsGranted = false

CHEAT_CODES = {
    --Basic Cheat commands
    ["db"]       = function(...) ChatCommands:Debug(...) end,
    ["tel"]   = function(...) ChatCommands:TeleportCommand(...) end,
    ["allowtesters"] = function(...)  ChatCommands:AllowTesters(...) end,
    ["time"]      = function(...) ChatCommands:ChangeTime(...) end,
    ["toggledebug"] = function(...) ChatCommands:ToggleDebug(...) end,
    
    --Custom Cheat commands
    ["OP"]    = function(...) ChatCommands:DevShortcut(...) end,
    ["DEVEXIT"] = function(...) ChatCommands:DevExit(...) end,
    ["CC"]       = function(...) ChatCommands:ChangeClass(...) end,
    ["layer"] = function(...) ChatCommands:WorldLayerCommand(...) end,
    ["gm"]       = function(...) ChatCommands:GodMode(...) end,
    ["refill"] = function(...) ChatCommands:RefillPotionsCommand(...) end,
    ["PRINTTABLE"] = function(...) ChatCommands:PrintTableCommand(...) end,
    ["teamstest"] = function(...)  ChatCommands:TeamsTestCommand(...) end,
    ["events"] = function(...) Events:EventCommand(...) end,
    ["recipe"] = function(...) Events:RecipeCommand(...) end,
    ["IsIndoors"] = function(...) ChatCommands:IsIndoorsCommand(...) end,
    ["stats"] = function(...) ChatCommands:StatsCommand(...) end,
    ["gas"] = function(...) ChatCommands:GetSortedDPS(...) end,
    ["gold"] = function(...) ChatCommands:Gold(...) end,
    ["setspawn"] = function(...) ChatCommands:SetSpawn(...) end,
    ["movevertical"] = function(...) ChatCommands:MoveVertical(...) end,
    ["camdistance"] = function(...) ChatCommands:CameraDistance(...) end,
    ["time"] = function(...) ChatCommands:DayNight(...) end,
    ["fog"] = function(...) ChatCommands:ToggleFog(...) end,
    ["wearables"] = function(...) ChatCommands:Wearables(...) end,
    ["allitems"] = function(...) ChatCommands:GetItemNames(...) end,
}

PLAYER_COMMANDS = {
    --Basic player commands
    ["suicide"]       = function(...) ChatCommands:Suicide(...) end,
    ["steamid"]       = function(...) ChatCommands:SteamID(...) end,
    ["playerid"]     = function(...) ChatCommands:PlayerID(...) end,
    ["roll"]       = function(...) ChatCommands:RollCommand(...) end,
    ["version"]   = function(...) ChatCommands:Version(...) end,
    ["unstuck"] = function(...) ChatCommands:Unstuck(...) end,
    ["test"]      = function(...) ChatCommands:Test(...) end,
    ["getfor"]     = function(...) ChatCommands:GetForwardVectorCommand(...) end,
    
    --Custom player commands
    ["help"]      = function(...) ChatCommands:Help(...) end,
    ["exit"]    = function(...) ChatCommands:ExitDungeon(...) end,
    ["zoningcount"] = function(...) ChatCommands:ZoningCount(...) end,
    ["weather"] = function(...) ChatCommands:WeatherCommand(...) end,
    ["popup"] = function(...) ChatCommands:PopupCommand(...) end,
    ["save"]       = function(...) SaveLoad:SaveCommand(...) end,
    ["deleteall"]       = function(...) SaveLoad:DeleteAllCommand(...) end,
}

Cheats = {
    "-lvlup",
    "-levelbots",
    "-gold",
    "-item",
    "-givebots",
    "-refresh",
    "-respawn",
    "-startgame",
    "-spawncreeps",
    "-spawnneutrals",
    "-disablecreepspawn",
    "-enablecreepspawn",
    "-spawnrune",
    "-killwards",
    "-createhero",
    "-dumpbots",
    "-wtf",
    "-unwtf",
    "-allvision",
    "-normalvision",
}

--developer
--moderator
--tester
--player

function ChatCommands:RegisterCommand(txtCode, callback, permission_needed)
    if not permission_needed or permission_needed == "developer" then
        CHEAT_CODES[txtCode] = function(...) callback(self, ...) end
    elseif permission_needed == "player" then
        PLAYER_COMMANDS[txtCode] = function(...) callback(self, ...) end
    end
end

function ChatCommands:Activate()
    ChatCommands:RegisterCommand("debugloadedlua", Dynamic_Wrap(ChatCommands, "DebugLoadedLua"))
    ChatCommands:RegisterCommand("toggleminimap", Dynamic_Wrap(ChatCommands, "ToggleMinimap"))
    ChatCommands:RegisterCommand("map", Dynamic_Wrap(ChatCommands, "ToggleMinimap"))
    ChatCommands:RegisterCommand("showexpperlevel", Dynamic_Wrap(ChatCommands, "ShowExpPerLevel"))
    ChatCommands:RegisterCommand("getexpfromto", Dynamic_Wrap(ChatCommands, "GetExpFromTo"))
    ChatCommands:RegisterCommand("loadrefresh", Dynamic_Wrap(ChatCommands, "LoadRefresh"), "player")
    ChatCommands:RegisterCommand("resetabilities", Dynamic_Wrap(ChatCommands, "ResetAbilities"))
    ChatCommands:RegisterCommand("debugallcalls", Dynamic_Wrap(ChatCommands, "DebugAllCalls"))
    ChatCommands:RegisterCommand("stats", Dynamic_Wrap(ChatCommands, "ListStats"))

    ChatCommands:RegisterCommand("debugtarget", Dynamic_Wrap(ChatCommands, "GetCursorTarget"))
    CustomGameEventManager:RegisterListener("debug_modifiers_callback", Dynamic_Wrap(ChatCommands, "GetCursorTarget_Callback"))


    ChatCommands:RegisterCommand("testunits", Dynamic_Wrap(ChatCommands, "TestUnits"))

    ChatCommands:RegisterCommand("checkvis", function(self, playerID)
        ChatCommands:GetCursorTarget(playerID, 'vision')

    end)
end

function ChatCommands:GetCursorTarget(playerID, param)
    local unit = PlayerResource:GetPlayer(playerID):GetAssignedHero()

    if param ~= 'self' then
        CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(playerID), "get_cursor_target", {callbackString = param})
    else
        local mods = unit:FindAllModifiers()
        for key, value in pairs(mods) do
            Debug(value:GetName(), value)
        end
        print("************")
    end
end

function ChatCommands:GetCursorTarget_Callback(args)
    local playerID = args.playerID
    local entities = args.entities
    local callbackString = args.callbackString

    if callbackString == 'modifiers' then
        ChatCommands:DebugSelfModifiers_Callback(args)
    elseif callbackString == 'quests' then
        ChatCommands:DebugUnitQuests(args)
    elseif callbackString == 'vision' then
        ChatCommands:DebugUnitVision(args)
    end
end

function ChatCommands:DebugUnitVision(args)
    local playerID = args.PlayerID or args.playerID
    local entities = args.entities

    for index, entityInfo in pairs(entities) do
        local target = EntIndexToHScript(entityInfo.entityIndex)
        if target then
            print("Checking vision of ", target:GetUnitName())
            print("Current Vision: ", target:GetCurrentVisionRange())
            print("Day Vision: ", target:GetDayTimeVisionRange())
            print("Night Vision: ", target:GetNightTimeVisionRange())
            print("Provides Vision: ", target:ProvidesVision())
            print("==============")
        end
    end
end

function ChatCommands:DebugUnitQuests(args)
    local playerID = args.playerID
    local entities = args.entities

    for index, entityInfo in pairs(entities) do
        local target = EntIndexToHScript(entityInfo.entityIndex)
        if(target) then
            local unitName = target:GetUnitName()
            print("**unit.QuestNotifications***")
            PrintTable(target.QuestNotifications)
            print("**injectedParticlesByPath**")
            PrintTable(Cosmetics.injectedParticlesByPath[unitName])
            print("**injectedParticlesByRef***")
            PrintTable(Cosmetics.injectedParticlesByRef[unitName])
            print("*****")
            PrintTable(Cosmetics.injectedParticles[unitName])
            print("*****")
        end
    end

end

function ChatCommands:DebugSelfModifiers_Callback(args)
    local playerID = args.playerID
    local entities = args.entities

    for index, entityInfo in pairs(entities) do
        local target = EntIndexToHScript(entityInfo.entityIndex)
        if(target) then
            Debug("DebugModifiers", target:GetUnitName(), " modifier information")
            local mods = target:FindAllModifiers()
            for key, value in pairs(mods) do
                Debug(value:GetName(), value)
            end
            print("************")
        end
    end
end

function ChatCommands:ToggleMinimap(playerID)
    CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(playerID), "toggle_default_minimap", {})
end

function ChatCommands:DebugAllCalls(playerID)
    DebugAllCalls()
end

function ChatCommands:ToggleDebug(playerID, section)
    DEBUG_HIDE_SECTIONS[section] = not DEBUG_HIDE_SECTIONS[section]
end

function ChatCommands:DebugLoadedLua(playerID)
    print("****DebugLoadedLua****")
    PrintTable(package.loaded)
    print("**********************")
end

function ChatCommands:ShowExpPerLevel(playerID)
    local xpNeededForEachLevel = {}
    local lastXP = 0
    for index, xp in pairs(XP_PER_LEVEL_TABLE) do
        xpNeededForEachLevel[index] = xp - lastXP
        lastXP = xp
    end
    PrintTable(xpNeededForEachLevel)
end

function ChatCommands:GetExpFromTo(playerID, fromXp, toXp)
    fromXp = tonumber(fromXp)
    toXp = tonumber(toXp)

    print(XP_PER_LEVEL_TABLE[toXp] - XP_PER_LEVEL_TABLE[fromXp])
end

function IsCheatCommand( text )
    for k,cheat in pairs(Cheats) do
        if string.match(text, cheat) then
            return true
        end
    end
    return false
end

function IsDeveloper(steamID)

    for id, bool in pairs(DEVELOPER_IDS) do
        if steamID == id then return true end
    end

    return false
end

function IsTester(steamID)

    for id, bool in pairs(TESTER_IDS) do
        if steamID == id then return true end
    end

    return false
end

-- A player has typed something into the chat
function ChatCommands:OnPlayerChat(keys)
    local text = keys.text
    local userID = keys.userid
    ----print("userID is " .. userID)
    if userID ~= -1 then
        local playerID = self.vUserIds[keys.userid]:GetPlayerID()

        if IsCheatCommand(keys.text) then
            Notifications:Top(playerID, {text="!!CHEATS ARE NOT ALLOWED!!", style={color="red", ["font-size"]="25px"}, duration = 5})
            Notifications:Top(playerID, {text="!!SAVING IS NOT POSSIBLE IF CHEATS WERE ENABLED!!", style={color="red", ["font-size"]="25px"}, duration = 5})
            GameRules.cheats = true
            return false
        end

        local steam_id = PlayerResource:GetSteamAccountID(playerID)
        -- Handle '-command'
        if StringStartsWith(text, "-") then
            text = string.sub(text, 2, string.len(text))

            local input = split(text)
            local command = input[1]
            if CHEAT_CODES[command] and (IsDeveloper(steam_id) or IsTester(steam_id)) then
                ------print('Command:',command, "Player:",playerID, "Parameters",input[2], input[3], input[4])
                CHEAT_CODES[command](playerID, input[2], input[3], input[4])
            elseif PLAYER_COMMANDS[command] then
                PLAYER_COMMANDS[command](playerID, input[2], input[3], input[4])
            end
        end
    end
end

function ChatCommands:LoadRefresh(playerID, steamID)
    steamID = tonumber(steamID)
    if(PlayerService:IsTruePlayerDeveloper(playerID)) then
        SaveLoad.overrideSteamId[playerID] = steamID or nil
    end

    local tableName = SaveLoad.charactersTableNames[playerID]
    for key, value in pairs(PlayerTables:GetAllTableValues(tableName)) do
        PlayerTables:DeleteTableKey(tableName, key)
    end

    tableName = SaveLoad.globalTableNames[playerID]
    for key, value in pairs(PlayerTables:GetAllTableValues(tableName)) do
        PlayerTables:DeleteTableKey(tableName, key)
    end

    SaveLoad:PullSaveData(playerID)
end

function ChatCommands:IsIndoorsCommand(pID, args)
    local player = PlayerResource:GetPlayer(pID)
    local hero = player:GetAssignedHero()
    local indoors = hero.indoors
    print("[ChatCommands] hero indoor status: ", indoors)
end

function ChatCommands:StatsCommand(pID, args)
    local player = PlayerResource:GetPlayer(pID)
    local hero = player:GetAssignedHero()
    local playerName = PlayerResource:GetPlayerName(pID)

    local modTable = hero:FindAllModifiers()

    print("Player", pID)
    print("PlayerName", playerName)
    print("PlayerTeam", PlayerResource:GetTeam(pID))
    print("Hero", hero:GetUnitName())
    print("HeroTeam", hero:GetTeamNumber())

    for k,mod in pairs(modTable) do
        print("Mod" .. k, mod:GetName())
    end
end

function ChatCommands:GetSortedDPS(pID, bHealth)
    --local player = PlayerResource:GetPlayer(pID)
    --local hero = player:GetAssignedHero()
    --local playerName = PlayerResource:GetPlayerName(pID)
    local updatedUnitsTable = LoadKeyValues("scripts/npc/npc_units_custom.txt")
    local file = io.open("../../dota_addons/reincarnation/all_dps.txt", 'w')

    file:write("=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=\n")
    file:write("GetSortedDPS()\n")
    file:write("=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=\n")
    local tab = {}

    for unitName, unitTable in pairs(updatedUnitsTable) do
        -- print("-------------------" .. unitName .. "---------------------")
        local zone = unitTable.RegularZone or "Misc"
        local boss = false

        if not unitTable.IsNPC and not unitTable.IsShop and not unitTable.HideDpsLog then
            local level = unitTable.Level or 1
            local health = unitTable.StatusHealth or 0
            local armor = 0
            local magicResist = 0
            local effectiveHealth = health
            local damage = 0
            local attackRate = 0
            local dps = 0

            if unitTable.ArmorPhysical then
                armor = unitTable.ArmorPhysical
                local damageMult = .06 * armor / (1 + .06 * math.abs(armor))
                effectiveHealth = effectiveHealth + (effectiveHealth * damageMult)
            end

            if unitTable.MagicalResistance then
                magicResist = unitTable.MagicalResistance
            end

            if unitTable.AttackRate and tonumber(unitTable.AttackRate) > 0 and unitTable.AttackDamageMin and unitTable.AttackDamageMax then
                attackRate = unitTable.AttackRate
                damage = (unitTable.AttackDamageMin + unitTable.AttackDamageMax) / 2
                local attacksPerSecond = (100 * .01) / attackRate
                dps = attacksPerSecond * damage
            end

            if unitTable.Boss then boss = true end

            if not tab[zone] then
                tab[zone] = {}
            end

            table.insert(tab[zone], {unitName = unitName, effectiveHealth = effectiveHealth, dps = dps, boss = boss, armor = armor, magicResist = magicResist, health = health, damage = damage, attackRate = attackRate, level = level})

            --print("Effective Health", effectiveHealth)
            --print("DPS", dps)
        end
    end

    local tab2 = {}
    for zone,zoneTable in pairs(tab) do
        local tabCopy = zoneTable
        for i=1, tablelength(zoneTable) do
            local unitName
            local num
            local t
            local index
            for i,j in pairs(tabCopy) do
                if not bHealth then
                    if not num or j.dps < num then
                        t = j
                        num = j.dps
                        index = i
                    end
                else
                    if not num or j.effectiveHealth < num then
                        t = j
                        num = j.effectiveHealth
                        index = i
                    end
                end
            end

            tabCopy[index] = nil

            if not tab2[zone] then
                tab2[zone] = {}
            end
            table.insert(tab2[zone], t)
        end
    end

    for zone,zoneTable in pairs(tab2) do
        local num = 0
        local value = tablelength(zoneTable)
        local avgDPS = 0
        local startDPS
        for i=1,tablelength(zoneTable) do
            if zoneTable[i].dps > 0 then
                num = num + zoneTable[i].dps
                if not startDPS then startDPS = i end
            else
                value = value - 1
            end
        end
        avgDPS = num / value

        num = 0
        value = tablelength(zoneTable)
        local avgEHP = 0
        local startEHP
        for i=1,tablelength(zoneTable) do
            if zoneTable[i].effectiveHealth > 1 then
                num = num + zoneTable[i].effectiveHealth
                if not startEHP then startEHP = i end
            else
                value = value - 1
            end
        end
        avgEHP = num / value

        file:write("########################### " .. zone .. " ###########################\n")
        file:write("Avg DPS     ", math.floor(avgDPS), "\n")
        file:write("DPS Spread  ", math.floor(zoneTable[startDPS].dps), "-", math.floor(zoneTable[tablelength(zoneTable)].dps), "\n")
        file:write("Avg EHP     ", math.floor(avgEHP), "\n")
        file:write("EHP Spread  ", math.floor(zoneTable[startEHP].effectiveHealth), "-", math.floor(zoneTable[tablelength(zoneTable)].effectiveHealth), "\n")
    end

    file:write("\n\n\n\n")

    for zone,zoneTable in pairs(tab2) do
        local num = 0
        local value = tablelength(zoneTable)
        local avgDPS = 0
        local startDPS
        for i=1,tablelength(zoneTable) do
            if zoneTable[i].dps > 0 then
                num = num + zoneTable[i].dps
                if not startDPS then startDPS = i end
            else
                value = value - 1
            end
        end
        avgDPS = num / value

        num = 0
        value = tablelength(zoneTable)
        local avgEHP = 0
        local startEHP
        for i=1,tablelength(zoneTable) do
            if zoneTable[i].effectiveHealth > 1 then
                num = num + zoneTable[i].effectiveHealth
                if not startEHP then startEHP = i end
            else
                value = value - 1
            end
        end
        avgEHP = num / value

        file:write("########################### " .. zone .. " ###########################\n")
        file:write("Avg DPS     ", math.floor(avgDPS), "\n")
        file:write("DPS Spread  ", math.floor(zoneTable[startDPS].dps), "-", math.floor(zoneTable[tablelength(zoneTable)].dps), "\n")
        file:write("Avg EHP     ", math.floor(avgEHP), "\n")
        file:write("EHP Spread  ", math.floor(zoneTable[startEHP].effectiveHealth), "-", math.floor(zoneTable[tablelength(zoneTable)].effectiveHealth), "\n")
        for i=1,tablelength(tab2[zone]) do
            if not tab2[zone][i].boss then
                file:write("-------",string.format("%3.0f",math.floor(zoneTable[i].level)),"---------------------------" .. string.gsub(zoneTable[i].unitName, "npc_dota_creature_", "") .. "\n")
            else
                file:write("=======",string.format("%3.0f",math.floor(zoneTable[i].level)),"===========================[[" .. string.gsub(zoneTable[i].unitName, "npc_dota_creature_", "") .. "]]\n")
            end
            file:write("Effective Health", string.format("%6.0f",math.floor(zoneTable[i].effectiveHealth)) .. " ", "(He:" .. zoneTable[i].health .. "  Ar:" .. zoneTable[i].armor .. "  MR:" .. zoneTable[i].magicResist .. ")\n")
            file:write("DPS             ", string.format("%6.0f",math.floor(zoneTable[i].dps)) .. " ", "(Da:" .. zoneTable[i].damage .. "  AR:" .. string.format("%.2f",zoneTable[i].attackRate) .. ")\n")
        end
    end




    file:write("*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*\n")
    file:write("*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*\n")
end

function ChatCommands:GetItemNames(pID)
    local file = io.open("../../dota_addons/reincarnation/other_items.txt", 'w')

    file:write("=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=\n")
    file:write("GetItemNames()\n")
    file:write("=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=\n")
    file:write("itemname / ID / rarity\n")
    file:write("___________________________________________________________________________\n")
    local questCopy = QUESTSKV_TABLE.Quests

    local lines = 0
    for itemRef, itemInfo in pairs(InventoryService.itemKV) do
        if(itemInfo.IsEquipment ~= 1 and itemInfo.IsEquipment ~= '1') then
            if lines > 4 then
                file:write("---------------------------------------------------------------------------\n")
                lines = 0
            end

            local itemId = itemInfo.ID or 'unknown'
            local rarity = itemInfo.ItemQuality or 'unknown'

            file:write(itemRef, ' | ' , itemId, ' | ', ' | ', rarity,  "\n")

            lines = lines + 1
        end
    end

    file:write("*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*\n")
    file:write("*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*\n")
end


function ChatCommands:GetSortedQuests(pID)
    QUESTSKV_TABLE = LoadKeyValues("scripts/kv/quests.kv")
    local file = io.open("../../dota_addons/reincarnation/all_quests.txt", 'w')

    file:write("=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=\n")
    file:write("GetSortedQuests()\n")
    file:write("=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=\n")
    file:write("Inactive / ID / Repeatable / Name | Stages / Exp / Gold\n")
    file:write("___________________________________________________________________________\n")
    local questCopy = QUESTSKV_TABLE.Quests

    local lines = 0

    for questID,questTable in pairsByKeys(questCopy) do
        if lines > 4 then
            file:write("---------------------------------------------------------------------------\n")
            lines = 0
        end
        local activeString = "- "
        if questTable.inactive and tobool(questTable.inactive) == true then
            activeString = "X "
        end

        local questIDString = questID .. "    "
        if tobool(questTable.repeatable) == true then
            questIDString = questID .. "++++"
        end

        local questNameLength = 20
        local questNameString = string.sub(questTable.name, 1, questNameLength)
        local length = string.len(questNameString)
        if questNameLength - length > 0 then
            for i=1,questNameLength - length do
                questNameString = questNameString .. " "
            end
        end
        questNameString = questNameString .. "  "

        local stages = 0
        local exp = 0
        local gold = 0

        for index,stageTable in pairs(questTable.stages) do
            stages = stages + 1
            if stageTable.onCompletion and stageTable.onCompletion.rewards then
                exp = exp + (stageTable.onCompletion.rewards.exp or 0)
                gold = gold + (stageTable.onCompletion.rewards.gold or 0)
            end
        end

        stages = string.sub(stages .. "                      ", 1, 6)
        exp = string.sub("Exp:" .. exp .. "                          ", 1, 14)
        gold = string.sub("Gold:" .. gold .. "                       ", 1, 15)

        file:write(activeString, questIDString, questNameString, "  |  ", stages, exp, gold,"\n")

        lines = lines + 1
    end

    file:write("*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*\n")
    file:write("*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*\n")
end


function ChatCommands:GetForwardVectorCommand(pid)
    print("Forward Vector is")
    print(PlayerResource:GetPlayer(pid):GetAssignedHero():GetForwardVector())
end

function ChatCommands:TeamsTestCommand(pID, testParam)

    Teams:ChangePlayersTeam(pID)

end

function ChatCommands:ChangeTime(pID, time)
    GameRules:SetTimeOfDay(tonumber(time))
end


function ChatCommands:WorldLayerCommand(pID, layerName)

    if WorldLayersActiveTable == nil then
        WorldLayersActiveTable = {}
    end

    if layerName == "camp" then
        if WorldLayersActiveTable.camp == nil then
            WorldLayersActiveTable.camp = {}
        end
        if WorldLayersActiveTable.camp[pID] == nil then
            WorldLayersActiveTable.camp[pID] = false
        end

        if WorldLayersActiveTable.camp[pID] == false then
            Entities:FindByName(nil, "Encampment_world_layer_relay"):Trigger()
            WorldLayersActiveTable.camp[pID] = true
        else
            Entities:FindByName(nil, "Encampment_world_layer_relay_end"):Trigger()
            WorldLayersActiveTable.camp[pID] = false
        end
    end

end

function ChatCommands:AllowTesters(pID, permissions)
    local steam_id = PlayerResource:GetSteamAccountID(pID)
    if not IsDeveloper(steam_id) then return end

    if permissions == "full" then
        TestersFullPermissionsGranted = true
    end
    TestersPermissionsGranted = true

end

function ChatCommands:Help(pID)
    local player = PlayerResource:GetPlayer(pID)
    ShowGenericPopupToPlayer( player, "popup_title_help", "popup_body_help", "", "", DOTA_SHOWGENERICPOPUP_TINT_SCREEN )
end

function ChatCommands:RollCommand(pID)
    local player = PlayerResource:GetPlayer(pID)
    local hero = player:GetAssignedHero()
    Say(player, "I rolled a: " .. RandomInt(0, 100), false)
end

function ChatCommands:Suicide(pID)
    local player = PlayerResource:GetPlayer(pID)
    local hero = player:GetAssignedHero()
    local herohealthcheck = hero:GetMaxHealth() * 0.75

    if MOD_CLASS.BCanSuicide then
        local bCanSuicide, message = MOD_CLASS:BCanSuicide(pID)
        if not bCanSuicide then
            Notifications:Top(pID, {text=message, style={color="red", ["font-size"]="25px", ["margin-left"]="15px"}, duration = 5})
            return false
        end
    end

    if (player and hero:GetHealth() > herohealthcheck) or PlayerService:IsTruePlayerDeveloper(pID) then
        hero:ForceKill(true)
    else
        Notifications:Top(pID, {text="Suicide requires above 75% Health", style={color="red", ["font-size"]="25px", ["margin-left"]="15px"}, duration = 5})
    end
end

function ChatCommands:SteamID(pID)
    local steam_id = PlayerResource:GetSteamAccountID(pID)
    local player = PlayerResource:GetPlayer(pID)
    Say(player,"Player " .. pID .. "'s steam ID is " .. steam_id, false)
end

function ChatCommands:PlayerID(pID)
    local player = PlayerResource:GetPlayer(pID)
    say(player,"Player " .. pID .. "'s player ID is " .. playerID, false)
end

function ChatCommands:ExitDungeon(pID)
    if DungeonsService:AttemptRemovePlayerFromDungeon(pID, true) then
        Notifications:Top(pID, {text="You are in shock from your escape from the dungeon", style={color="red", ["font-size"]="25px", ["margin-left"]="15px"}, duration = 7})
        ApplyModifier( PlayerResource:GetPlayer(pID):GetAssignedHero(), "modifier_stun_global")
    end
end

function ChatCommands:DevExit(pID)
    DungeonsService:AttemptRemovePlayerFromDungeon(pID)

    --Notifications:Top(pID, {text="You are in shock from your escape from the dungeon", style={color="red", ["font-size"]="25px", ["margin-left"]="15px"}, duration = 5})
    --ApplyModifier( PlayerResource:GetPlayer(pID):GetAssignedHero(), "modifier_stun_global")
end

function ChatCommands:Version(pID)
    Say(nil,"Version: " .. _Version, false)
end

function ChatCommands:TeleportCommand(pID, playerNum)

    local hero

    for i=0, PlayerResource:GetPlayerCount() - 1 do
        if tonumber(playerNum) == i then
            hero = PlayerResource:GetPlayer(i):GetAssignedHero()
        end
    end
    if not hero then
        hero = PlayerResource:GetPlayer(pID):GetAssignedHero()
    end

    MovePlayerUnitsToPoint(hero, hero.cursorPos)
end

--This function gets the cursor -> world vector position
function ChatCommands:GetCursorPos( ... )
    local t = {...}

    if type(t[1]) == "table" then
        local keys = t[1]
        local pID = keys.PlayerID
        if PlayerResource:GetPlayer(pID):GetAssignedHero().cursorCallback then
            local cp = keys.cursor_pos
            local v = Vector(cp["0"], cp["1"], cp["2"])
            PlayerResource:GetPlayer(pID):GetAssignedHero().cursorCallback(pID,v)
            PlayerResource:GetPlayer(pID):GetAssignedHero().cursorCallback = nil
        end
        return keys
    else
        local pID = t[1]
        local fun = t[2]
        PlayerResource:GetPlayer(pID):GetAssignedHero().cursorCallback = fun
        CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(pID), "cursor_pos", {})
    end
end

function ChatCommands:DevShortcut(pID, paramaters)

    local player = PlayerResource:GetPlayer(pID)
    local hero = player:GetAssignedHero()

    local class = "basic"

    --ChatCommands:ChangeClass(pID, class)

    if(paramaters == "dungeon") then

        local class = "priest"

        Timers:CreateTimer({
                               endTime = .2,
                               callback = function()
                                   player:GetAssignedHero():GetAbilityByIndex(1):SetLevel(10)
                                   player:GetAssignedHero():GetAbilityByIndex(2):SetLevel(10)
                                   player:GetAssignedHero():GetAbilityByIndex(3):SetLevel(10)
                                   player:GetAssignedHero():GetAbilityByIndex(4):SetLevel(10)
                                   return false
                               end
                           })

        Inventories:ChangeInventoryOwner(player:GetAssignedHero())
        player:GetAssignedHero():SetAbsOrigin(Entities:FindByName(nil, "desolate_stockade_entrance"):GetAbsOrigin())

    elseif paramaters == "test" then
        player:GetAssignedHero():SetAbsOrigin(Entities:FindByName(nil, "butchers_sepulcher_entrance"):GetAbsOrigin())
    elseif paramaters == "camp" then
        player:GetAssignedHero():SetAbsOrigin(Entities:FindByName(nil, "desolate_waste_spawn"):GetAbsOrigin())
    elseif paramaters == "enchanted" then
        player:GetAssignedHero():SetAbsOrigin(Entities:FindByName(nil, "enchanted_forest_exit"):GetAbsOrigin())
    elseif paramaters == "abyss" then
        MovePlayerUnitsToPoint(player:GetAssignedHero(), Entities:FindByName(nil, "abyss_stronghold_start"):GetAbsOrigin())
    else
        MovePlayerUnitsToPoint(player:GetAssignedHero(), Entities:FindByName(nil, "sunken_city_entrance"):GetAbsOrigin())
    end

    ChatCommands:ChangeClass(pID, class)


end

function ChatCommands:SetSpawn(pID, paramaters)

    local player = PlayerResource:GetPlayer(pID)
    local hero = player:GetAssignedHero()

    local location = paramaters
    local hLocation = Entities:FindByName(nil, location)

    if(hLocation == nil) then
        local point = hero:GetAbsOrigin()
        hero:SetHomeLocationToVector({x = point.x, y = point.y, z = point.z})
    else
        hero:SetHomeLocation(hLocation)
        --set saves spawn location to the point
    end
end

function ChatCommands:RefillPotionsCommand(pid, param)
    Potions:RefillAllPotions(pid)
end



function ChatCommands:ChangeClass(playerID, class)
    local player = PlayerResource:GetPlayer(playerID)
    local hero = player:GetAssignedHero()
    local steamID = PlayerResource:GetSteamAccountID(playerID)

    local testerDenied = {
        --"arcanist",
        --"cultist",
        --"elementalist",
        --"exile",
        --"lancer",
        --"hunter",
        --"monk",
        --"runecaster",
        --"wetboy",
        --"swordsman",
        --"barbarian",
        --"marksman",
        --"priest",
        --"bladerider",
        --"daeagon",
        --"paragon",
        --"technologist",
        --"chronomancer",
        --"trickster",
        --"fencer",
        --"witch",
        --"shadow",
        --"zerker",
        --"druid"
    }


    if IsTester(steamID) then
        if not TestersFullPermissionsGranted then
            if not TestersPermissionsGranted then
                for k,v in pairs(testerDenied) do
                    if v == class then return end
                end
            end
        end
    end

    if CLASS_REFERENCE_TABLE[class] == nil then
        GameRules:SendCustomMessage("Class Change options:", 0, 0)
        GameRules:SendCustomMessage("basic", 0, 0)
        GameRules:SendCustomMessage("devout", 0, 0)
        GameRules:SendCustomMessage("ranger", 0, 0)
        GameRules:SendCustomMessage("warrior", 0, 0)
        GameRules:SendCustomMessage("arcanist", 0, 0)
        GameRules:SendCustomMessage("cultist", 0, 0)
        GameRules:SendCustomMessage("elementalist", 0, 0)
        GameRules:SendCustomMessage("exile", 0, 0)
        GameRules:SendCustomMessage("hunter", 0, 0)
        GameRules:SendCustomMessage("monk", 0, 0)
        GameRules:SendCustomMessage("runecaster", 0, 0)
        GameRules:SendCustomMessage("wetboy", 0, 0)
        GameRules:SendCustomMessage("zerker", 0, 0)

    else
        local modTable = player:GetAssignedHero():FindAllModifiers()
        for index,mod in pairs(modTable) do
            player:GetAssignedHero():RemoveModifierByName(mod:GetName())
        end

        ClassChange:FreshChangeClass(playerID, CLASS_REFERENCE_TABLE[class])
        --Quests:ClassChange(pID, CLASS_REFERENCE_TABLE[class])
        --PlayerResource:ReplaceHeroWith(pID, CLASS_REFERENCE_TABLE[class], 0, 0)
    end

    --Inventories:ChangeInventoryOwner(player:GetAssignedHero())
    --Cosmetics:ActivateSoulConsumeParticles(pID)
end

function ChatCommands:Debug(pID, level)
    local player = PlayerResource:GetPlayer(pID)
    local hero = player:GetAssignedHero()
    local level = level
    local steamID = PlayerResource:GetSteamAccountID(pID)
    ----print("Debug")

    --if IsTester(steamID) and not TestersFullPermissionsGranted then return end
    if not IsTester(steamID) and not IsDeveloper(steamID) then return end

    local startingLevel = hero:GetLevel()


    if player then
        PlayerResource:ModifyGold(pID, 5000, true, 0)
        if not level then
            level = 20
        end
        for i=1,level do
            local thisLevel = startingLevel - 1 + i
            local xpToGrant = (XP_PER_LEVEL_TABLE[thisLevel] or 0) - hero:GetCurrentXP()
            hero:AddExperience(xpToGrant, 0, false, false)
            --hero:HeroLevelUp(false)
        end
        hero:SetMana(hero:GetMaxMana())
        hero:SetHealth(hero:GetMaxHealth())
    end
end

function ChatCommands:Gold(pID, gold)
    local player = PlayerResource:GetPlayer(pID)
    local hero = player:GetAssignedHero()
    local level = level
    local steamID = PlayerResource:GetSteamAccountID(pID)
    ----print("Debug")

    --if IsTester(steamID) and not TestersFullPermissionsGranted then return end
    if not IsTester(steamID) and not IsDeveloper(steamID) then return end

    if player then
        PlayerResource:ModifyGold(pID, tonumber(gold), true, 0)
    end
end

function ChatCommands:GodMode(pID)
    local player = PlayerResource:GetPlayer(pID)
    local hero = player:GetAssignedHero()
    ----print("God Mode")
    if player and hero:HasModifier("modifier_god_mode") == false then
        ApplyModifier(hero, "modifier_god_mode")
    elseif player and hero:HasModifier("modifier_god_mode") == true then
        hero:RemoveModifierByName("modifier_god_mode")
    end
end

function ChatCommands:Test(pID)
    local player = PlayerResource:GetPlayer(pID)
    local hero = player:GetAssignedHero()

    local str = "Hello World"

    print(str)
    print(string.lower(str))
end

function ChatCommands:PrintTableCommand(pID, tablename)

    if _G[tableName] == "table" then
        PrintTable(_G[tableName])
    else
        print("table not found")
    end

end

function ChatCommands:Unstuck(pID)
    local hero = PlayerResource:GetPlayer(pID):GetAssignedHero()

    FindClearSpaceForUnit(hero, hero:GetAbsOrigin(), true)
end

function ChatCommands:WeatherCommand(pID, option)
    local hero = PlayerResource:GetPlayer(pID):GetAssignedHero()
    if option == "off" then
        DISABLEDWEATHER[pID] = true
    elseif option == "on" then
        DISABLEDWEATHER[pID] = false
    else
        if DISABLEDWEATHER[pID] then
            DISABLEDWEATHER[pID] = false
        else
            DISABLEDWEATHER[pID] = true
        end
    end
    if DISABLEDWEATHER[pID] then
        Notifications:Top(pID, {text="Weather will no longer be applied upon moving into a new area", style={color="red", ["font-size"]="25px"}, duration = 3})

        for k,weather in pairs(hero.weather) do
            ParticleManager:DestroyParticle(weather.particle, false)
            ParticleManager:ReleaseParticleIndex(weather.particle)
            hero.weather[k] = nil
        end
    else
        Notifications:Top(pID, {text="Weather will be applied upon moving into a new area", style={color="green", ["font-size"]="25px"}, duration = 3})
    end

    StartAcediaAmbient(hero)
end

function ChatCommands:PopupCommand(pID, option)
    if option == "enabled" then
        Popup:SetPlayerSetting(pID, POPUPS_ENABLED)
    elseif option == "disabled" then
        Popup:SetPlayerSetting(pID, POPUPS_DISABLED)
    elseif option == "limited" then
        Popup:SetPlayerSetting(pID, POPUPS_ENABLED_FOR_PLAYER)
    else
        --Cycle
        Popup:CyclePopupSetting(pID)
    end
end

function ChatCommands:ZoningCount(pID, steamID)

    local fHero = PlayerResource:GetPlayer(pID):GetAssignedHero()
    local modCount = fHero:GetModifierCount()
    local counter = 1
    while modCount >= counter do
        local modName = fHero:GetModifierNameByIndex(counter)
        print("[Barebones] - " .. modName)
        counter = counter + 1
    end

end

function ChatCommands:RecipeCommand(pID, type, key)
    Recipes:LearnNewRecipeGroup(pID, type, key)
end

function ChatCommands:MoveVertical(pID, amount)
    local hero = PlayerResource:GetPlayer(pID):GetAssignedHero()
    PlayerResource:SetCameraTarget(pID, hero)

    Timers:CreateTimer(function()
        local origin = hero:GetAbsOrigin()
        origin.z = origin.z - tonumber(amount) or 1
        hero:SetAbsOrigin(origin)

        return .03
    end)
end

function ChatCommands:CameraDistance(pID, amount)
    local hero = PlayerResource:GetPlayer(pID):GetAssignedHero()
    PlayerResource:SetCameraTarget(pID, hero)

    CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(pID), "camera_position", { position = tonumber(amount)})

    PlayerResource:SetCameraTarget(pID, nil)
end

function ChatCommands:DayNight(pID, param)
    if param == "night" then
        GameRules:SetTimeOfDay(0.75)
        return
    end
    GameRules:SetTimeOfDay(0.25)
end

function ChatCommands:ListStats(pID)
    local player = PlayerResource:GetPlayer(pID)
    local hero = player:GetAssignedHero()

    print("Hero Health: ", hero:GetHealth())
    print("Hero Mana: ", hero:GetMana())
end

function ChatCommands:ToggleFog(pID)
    if GameRules:GetGameModeEntity():GetFogOfWarDisabled() then
        GameRules:GetGameModeEntity():SetFogOfWarDisabled(false)
        return
    end
    GameRules:GetGameModeEntity():SetFogOfWarDisabled(true)
end

function ChatCommands:Wearables(pID, arg)
    if arg == "show" then
        Cosmetics:LoadDefaultWearables(PlayerResource:GetPlayer(pID):GetAssignedHero())
    end

    if arg == "hide" then
        Cosmetics:HideWearables(PlayerResource:GetPlayer(pID):GetAssignedHero())
    end
end

function ChatCommands:ResetAbilities(pID)
    local hero = PlayerResource:GetPlayer(pID):GetAssignedHero()
    local inherentAbilities = GetHandleKeyValue(hero, "InherentAbilities")

    local inherentLevels = 0
    for i=0,24 do
        local ability = hero:GetAbilityByIndex(i)
        if ability then
            ability:SetLevel(0)

            if(inherentAbilities) then
                for k,abilityName in pairs(inherentAbilities) do
                    if ability:GetName() == abilityName then
                        ability:SetLevel(1)
                        inherentLevels = inherentLevels + 1
                    end
                end
            end
        end
    end

    local level = hero:GetLevel()
    hero:SetAbilityPoints(level - inherentLevels)
end

function ChatCommands:TestUnits(pID, arg)
    local hero = PlayerResource:GetPlayer(pID):GetAssignedHero()

    Timers:CreateTimer(function()
        local dummy = CreateUnitByName("dummy_unit_vulnerable", hero:GetAbsOrigin(), true, hero, hero, hero:GetTeam())

        print(arg)
        if arg == "destroy" then
            dummy:Destroy()
        elseif arg == "util" then
            UTIL_Remove(dummy)
        elseif arg == "util2" then
            UTIL_RemoveImmediate(dummy)
        else
            dummy:RemoveSelf()
        end
        return .03
    end)
end

--Event:BindActivate(ChatCommands)