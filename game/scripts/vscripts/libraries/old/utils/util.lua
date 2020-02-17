function PrintTable(t, indent, done)
	--print ( string.format ('PrintTable type %s', type(keys)) )
    if type(t) ~= "table" then 
		print("Is not a table")
		return 
	end

    done = done or {}
    done[t] = true
    indent = indent or 0

    local l = {}
    for k, v in pairs(t) do
        table.insert(l, k)
    end

    table.sort(l)
    for k, v in ipairs(l) do
        -- Ignore FDesc
        if v ~= 'FDesc' then
            local value = t[v]

            if type(value) == "table" and not done[value] then
                done [value] = true
                print(string.rep ("\t", indent)..tostring(v)..":")
                PrintTable (value, indent + 2, done)
            elseif type(value) == "userdata" and not done[value] then
                done [value] = true
                print(string.rep ("\t", indent)..tostring(v)..": "..tostring(value))
                PrintTable ((getmetatable(value) and getmetatable(value).__index) or getmetatable(value), indent + 2, done)
            else
                if t.FDesc and t.FDesc[v] then
                    print(string.rep ("\t", indent)..tostring(t.FDesc[v]))
                else
                    print(string.rep ("\t", indent)..tostring(v)..": "..tostring(value))
                end
            end
        end
    end
end

function PrintKeys(tab)
    for key, value in pairs(tab) do
        Debug("Util", key)
    end
end

function SoftPrintTable(tab)
    for k,v in pairs(tab) do
        print(k, v)
    end
end

function SecondsToClock(seconds, bHours, bMins, bSecs)
    local seconds = tonumber(seconds)

    if seconds <= 0 then
        return "00:00:00";
    else
        hours = string.format("%02.f", math.floor(seconds/3600));
        mins = string.format("%02.f", math.floor(seconds/60 - (hours*60)));
        secs = string.format("%02.f", math.floor(seconds - hours*3600 - mins *60));
        if bHours and bMins and bSecs then
            return hours..":"..mins..":"..secs
        elseif bHours and bMins then
            return hours..":"..mins
        elseif bHours then
            return hours
        else
            return hours .. ":" .. mins
        end
    end
end

function SecondsToClockPretty(seconds)
    local seconds = tonumber(seconds)

    if seconds <= 0 then
        return "00:00:00";
    else
        hours = string.format("%2.f", math.floor(seconds/3600));
        mins = string.format("%2.f", math.floor(seconds/60 - (hours*60)));
        secs = string.format("%2.f", math.floor(seconds - hours*3600 - mins *60));

        return hours .. ' hours' .. ' and ' .. mins .. ' minutes'
    end
end



-- Colors
COLOR_NONE = '\x06'
COLOR_GRAY = '\x06'
COLOR_GREY = '\x06'
COLOR_GREEN = '\x0C'
COLOR_DPURPLE = '\x0D'
COLOR_SPINK = '\x0E'
COLOR_DYELLOW = '\x10'
COLOR_PINK = '\x11'
COLOR_RED = '\x12'
COLOR_LGREEN = '\x15'
COLOR_BLUE = '\x16'
COLOR_DGREEN = '\x18'
COLOR_SBLUE = '\x19'
COLOR_PURPLE = '\x1A'
COLOR_ORANGE = '\x1B'
COLOR_LRED = '\x1C'
COLOR_GOLD = '\x1D'



--============ Copyright (c) Valve Corporation, All rights reserved. ==========
--
--
--=============================================================================

--/////////////////////////////////////////////////////////////////////////////
-- Debug helpers
--
--  Things that are really for during development - you really should never call any of this
--  in final/real/workshop submitted code
--/////////////////////////////////////////////////////////////////////////////

-- if you want a table printed to console formatted like a table (dont we already have this somewhere?)
scripthelp_LogDeepPrintTable = "Print out a table (and subtables) to the console"
logFile = "log/log.txt"

function LogDeepSetLogFile( file )
    logFile = file
end

function LogEndLine ( line )
    AppendToLogFile(logFile, line .. "\n")
end

function _LogDeepPrintMetaTable( debugMetaTable, prefix )
    _LogDeepPrintTable( debugMetaTable, prefix, false, false )
    if getmetatable( debugMetaTable ) ~= nil and getmetatable( debugMetaTable ).__index ~= nil then
        _LogDeepPrintMetaTable( getmetatable( debugMetaTable ).__index, prefix )
    end
end

function _LogDeepPrintTable(debugInstance, prefix, isOuterScope, chaseMetaTables )
    prefix = prefix or ""
    local string_accum = ""
    if debugInstance == nil then
        LogEndLine( prefix .. "<nil>" )
        return
    end
    local terminatescope = false
    local oldPrefix = ""
    if isOuterScope then  -- special case for outer call - so we dont end up iterating strings, basically
        if type(debugInstance) == "table" then
            LogEndLine( prefix .. "{" )
            oldPrefix = prefix
            prefix = prefix .. "   "
            terminatescope = true
        else
            LogEndLine( prefix .. " = " .. (type(debugInstance) == "string" and ("\"" .. debugInstance .. "\"") or debugInstance))
        end
    end
    local debugOver = debugInstance

    -- First deal with metatables
    if chaseMetaTables == true then
        if getmetatable( debugOver ) ~= nil and getmetatable( debugOver ).__index ~= nil then
            local thisMetaTable = getmetatable( debugOver ).__index
            if vlua.find(_LogDeepprint_alreadyseen, thisMetaTable ) ~= nil then
                LogEndLine( string.format( "%s%-32s\t= %s (table, already seen)", prefix, "metatable", tostring( thisMetaTable ) ) )
            else
                LogEndLine(prefix .. "metatable = " .. tostring( thisMetaTable ) )
                LogEndLine(prefix .. "{")
                table.insert( _LogDeepprint_alreadyseen, thisMetaTable )
                _LogDeepPrintMetaTable( thisMetaTable, prefix .. "   ", false )
                LogEndLine(prefix .. "}")
            end
        end
    end

    -- Now deal with the elements themselves
    -- debugOver sometimes a string??
    for idx, data_value in pairs(debugOver) do
        if type(data_value) == "table" then
            if vlua.find(_LogDeepprint_alreadyseen, data_value) ~= nil then
                LogEndLine( string.format( "%s%-32s\t= %s (table, already seen)", prefix, idx, tostring( data_value ) ) )
            else
                local is_array = #data_value > 0
                local test = 1
                for idx2, val2 in pairs(data_value) do
                    if type( idx2 ) ~= "number" or idx2 ~= test then
                        is_array = false
                        break
                    end
                    test = test + 1
                end
                local valtype = type(data_value)
                if is_array == true then
                    valtype = "array table"
                end
                LogEndLine( string.format( "%s%-32s\t= %s (%s)", prefix, idx, tostring(data_value), valtype ) )
                LogEndLine(prefix .. (is_array and "[" or "{"))
                table.insert(_LogDeepprint_alreadyseen, data_value)
                _LogDeepPrintTable(data_value, prefix .. "   ", false, true)
                LogEndLine(prefix .. (is_array and "]" or "}"))
            end
        elseif type(data_value) == "string" then
            LogEndLine( string.format( "%s%-32s\t= \"%s\" (%s)", prefix, idx, data_value, type(data_value) ) )
        else
            LogEndLine( string.format( "%s%-32s\t= %s (%s)", prefix, idx, tostring(data_value), type(data_value) ) )
        end
    end
    if terminatescope == true then
        LogEndLine( oldPrefix .. "}" )
    end
end


function LogDeepPrintTable( debugInstance, prefix, isPublicScriptScope )
    prefix = prefix or ""
    _LogDeepprint_alreadyseen = {}
    table.insert(_LogDeepprint_alreadyseen, debugInstance)
    _LogDeepPrintTable(debugInstance, prefix, true, isPublicScriptScope )
end


--/////////////////////////////////////////////////////////////////////////////
-- Fancy new LogDeepPrint - handles instances, and avoids cycles
--
--/////////////////////////////////////////////////////////////////////////////

-- @todo: this is hideous, there must be a "right way" to do this, im dumb!
-- outside the recursion table of seen recurses so we dont cycle into our components that refer back to ourselves
_LogDeepprint_alreadyseen = {}


-- the inner recursion for the LogDeep print
function _LogDeepToString(debugInstance, prefix)
    local string_accum = ""
    if debugInstance == nil then
        return "LogDeep Print of NULL" .. "\n"
    end
    if prefix == "" then  -- special case for outer call - so we dont end up iterating strings, basically
        if type(debugInstance) == "table" or type(debugInstance) == "table" or type(debugInstance) == "UNKNOWN" or type(debugInstance) == "table" then
            string_accum = string_accum .. (type(debugInstance) == "table" and "[" or "{") .. "\n"
            prefix = "   "
        else
            return " = " .. (type(debugInstance) == "string" and ("\"" .. debugInstance .. "\"") or debugInstance) .. "\n"
        end
    end
    local debugOver = type(debugInstance) == "UNKNOWN" and getclass(debugInstance) or debugInstance
    for idx, val in pairs(debugOver) do
        local data_value = debugInstance[idx]
        if type(data_value) == "table" or type(data_value) == "table" or type(data_value) == "UNKNOWN" or type(data_value) == "table" then
            if vlua.find(_LogDeepprint_alreadyseen, data_value) ~= nil then
                string_accum = string_accum .. prefix .. idx .. " ALREADY SEEN " .. "\n"
            else
                local is_array = type(data_value) == "table"
                string_accum = string_accum .. prefix .. idx .. " = ( " .. type(data_value) .. " )" .. "\n"
                string_accum = string_accum .. prefix .. (is_array and "[" or "{") .. "\n"
                table.insert(_LogDeepprint_alreadyseen, data_value)
                string_accum = string_accum .. _LogDeepToString(data_value, prefix .. "   ")
                string_accum = string_accum .. prefix .. (is_array and "]" or "}") .. "\n"
            end
        else
            --string_accum = string_accum .. prefix .. idx .. "\t= " .. (type(data_value) == "string" and ("\"" .. data_value .. "\"") or data_value) .. "\n"
            string_accum = string_accum .. prefix .. idx .. "\t= " .. "\"" .. tostring(data_value) .. "\"" .. "\n"
        end
    end
    if prefix == "   " then
        string_accum = string_accum .. (type(debugInstance) == "table" and "]" or "}") .. "\n" -- hack for "proving" at end - this is DUMB!
    end
    return string_accum
end


scripthelp_LogDeepString = "Convert a class/array/instance/table to a string"

function LogDeepToString(debugInstance, prefix)
    prefix = prefix or ""
    _LogDeepprint_alreadyseen = {}
    table.insert(_LogDeepprint_alreadyseen, debugInstance)
    return _LogDeepToString(debugInstance, prefix)
end


scripthelp_LogDeepPrint = "Print out a class/array/instance/table to the console"

function LogDeepPrint(debugInstance, prefix)
    prefix = prefix or ""
    LogEndLine(LogDeepToString(debugInstance, prefix))
end

function StringStartsWith( fullstring, substring )
    local strlen = string.len(substring)
    local first_characters = string.sub(fullstring, 1 , strlen)
    return (first_characters == substring)
end

function split(inputstr, sep)
    if sep == nil then
        sep = "%s"
    end
    local t={} ; i=1
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
        t[i] = str
        i = i + 1
    end
    return t
end

function ApplyModifier( unit, modifier_name )
    GameRules.APPLIER:ApplyDataDrivenModifier(unit, unit, modifier_name, {})
end

function GetTrueName( object, objType )

    local name
    if objType == "item" then
        name = ADDON_ENGLISH_TABLE["DOTA_Tooltip_ability_" .. object:GetName()]
    end
    if objType == "ability" then
        name = ADDON_ENGLISH_TABLE["DOTA_Tooltip_ability_" .. object:GetName()]
    end
    if objType == "unit" then
        name = ADDON_ENGLISH_TABLE[object:GetUnitName()]
    end
    if objType == "unitname" then
        name = ADDON_ENGLISH_TABLE[object]
    end
    if objType == "itemname" or objType == "abilityname" then
        name = ADDON_ENGLISH_TABLE["DOTA_Tooltip_ability_" .. object]
    end
    if objType == "modifier" then
        name = ADDON_ENGLISH_TABLE["DOTA_Tooltip_" .. object:GetName()]
    end
    if not name and object.GetName then
        name = object:GetName()
    end
    if not name then
        return false
    end
    return name
end

--local _setHealth = CDota_BaseNPC.SetHealth, function CDOTA_BaseNPC:SetHealth(fHealth) if fHealth > 0 and fHealth < 1 then fHealth = 1 end _setHealth(self, fHealth) end

function GetRarityHTMLColor(item)
    local rarity = GetHandleKeyValue(item, "ItemQuality")

    local colors = {
        uncommon = "04FF00",
        rare = "0061FF",
        epic = "DC00FF",
        artifact = "FF9B00",
    }

    return colors[rarity] or "FFFFFF"
end

--todo: looks fairly reincrnation specific
function IsValidAbilityTarget(unit, target)
    if target:GetUnitName() == "dummy_unit_vulnerable"
    or target:GetUnitName() == "npc_dota_creature_harvest_dummy"
    or target:GetUnitName() == "dummy_unit_blocker"
    or target:GetUnitName() == "dummy_unit_vulnerable_location_quest"
    or target:GetUnitName() == "npc_dota_fish"
    or target:GetUnitName() == "npc_dota_creature_runecaster_double"
    or GetHandleKeyValue(target, "IsNPC")
    or GetHandleKeyValue(target, "IsShop")
    or GetHandleKeyValue(target, "IsRecipeStation")
    or GetHandleKeyValue(target, "IsBank")
    or GetHandleKeyValue(target, "IsAlchStation")
    or GetHandleKeyValue(target, "IsCookingStation")
    or GetHandleKeyValue(target, "IsFountain") then
        return false
    end
    return true
end

--todo: looks fairly reincarnation specific
--If the target is a unit the player is aware of. IE: Enemy or NPC, but not dummies or interactables
function IsGameActor(unit, target)
    if target:GetUnitName() == "dummy_unit_vulnerable"
    or target:GetUnitName() == "npc_dota_creature_harvest_dummy"
    or target:GetUnitName() == "dummy_unit_blocker"
    or target:GetUnitName() == "dummy_unit_vulnerable_location_quest"
    or GetHandleKeyValue(target, "IsCookingStation")
    or GetHandleKeyValue(target, "IsFountain") then
        return false
    end
    return true
end


function CanAct(unit)
    if unit:IsStunned() then return false end
    if unit:IsCommandRestricted() then return false end
    if unit:IsFrozen() then return false end
    if unit:IsNightmared() then return false end
    if unit.ai and unit.ai.denyAct then return false end

    return true
end

function MovePlayerUnitsToPoint(hero, point)
    local playerID
    if type(hero) == "number" then
        playerID = hero
        hero = PlayerResource:GetPlayer(hero):GetAssignedHero()
    end
    if not playerID then
        playerID = hero:GetPlayerOwnerID()
    end

    if not hero:IsRealHero() then
        hero = hero:GetPlayerOwner():GetAssignedHero()
    end

    --todo: ReIncarnation specific
    if hero:HasModifier("modifier_bladerider_blade_mount") then
        hero:CastAbilityImmediately(hero:FindAbilityByName("customability_bladerider_blade_mount"), hero:GetPlayerOwnerID())
    end

    local mod = hero:FindModifierByName("modifier_grapple")
    if mod then
        mod:Destroy()
    end


    PlayerResource:SetCameraTarget(playerID, hero)
    FindClearSpaceForUnit(hero, point, true)
    hero:Stop()

    local units = GetPlayerUnits(playerID)
    for k,unit in pairs(units) do
        if unit ~= hero then
            FindClearSpaceForUnit(unit, point, true)
            unit:Stop()
        end
    end

    --todo Coupled to zoning
    Zoning:ForceCheckZoning(hero)

    Timers:CreateTimer(.1, function()
        PlayerResource:SetCameraTarget(playerID, nil)
    end)
end

function GetPlayerUnits(playerID)
    local player = PlayerResource:GetPlayer(playerID)
    local hero

    --todo: Coupled to HeroService
    if not player then
        hero = HeroService:GetDisconnectedHero(playerID)
    else
        hero = player:GetAssignedHero()
    end

    local units = {}

    table.insert(units, hero)

    if hero.spiderally and IsValidEntity(hero.spiderally) then
        table.insert(units, hero.spiderally)
    end

    --todo companions are not decoupled from ReIncarnation
    if hero.companions then
        for index, companionTable in pairs(hero.companions) do
            if IsValidEntity(companionTable.unit) and companionTable.unit:IsAlive() then
                table.insert(units, companionTable.unit)
            end
        end
    end

    --todo very reincarnation specific
    if hero.zombieTable then
        for k,zombie in pairs(hero.zombieTable) do
            if type(zombie) == "table" and IsValidEntity(zombie) and zombie:IsAlive() then
                table.insert(units, zombie)
            end
        end
    end
    if IsValidEntity(hero.daemon) and hero.daemon:IsAlive() then
        table.insert(units, hero.daemon)
    end

    if IsValidEntity(hero.paegon) and hero.paegon:IsAlive() then
        table.insert(units, hero.paegon)
    else
        hero.paegon = nil
    end

    if IsValidEntity(hero.elemental) and hero.elemental:IsAlive() then
        table.insert(units, hero.elemental)
    end

    if IsValidEntity(hero.dominatedUnit) and hero.dominatedUnit:IsAlive() then
        table.insert(units, hero.dominatedUnit)
    end

    return units
end

function CustomDestroyParticle(particleID, bInstantly)
    if not particleID then return end
    if bInstantly == nil then bInstantly = false end
    ParticleManager:DestroyParticle(particleID, bInstantly)
    ParticleManager:ReleaseParticleIndex(particleID)
end

--todo: coupled to specific particles being available
function CreateSpellReticleParticle(parentUnit, point, radius, colorVector, timer, Player)
    local particlePath = "particles/reticles/basic_reticle.vpcf"
    if timer then
        particlePath = "particles/reticles/timed_reticle.vpcf"
    end

    local attach = PATTACH_ABSORIGIN
    if not point then
        attach = PATTACH_ABSORIGIN_FOLLOW
    end

    local reticleParticle
    if Player then
        reticleParticle = ParticleManager:CreateParticleForPlayer(particlePath, attach, parentUnit, Player)
    else
        reticleParticle = ParticleManager:CreateParticle(particlePath, attach, parentUnit)
    end
    if point then
        ParticleManager:SetParticleControl(reticleParticle,0,point)
    end
    ParticleManager:SetParticleControl(reticleParticle,1,Vector(radius or 100, 0, 0))
    ParticleManager:SetParticleControl(reticleParticle,2,colorVector or Vector(0,0,0))

    if timer then
        ParticleManager:SetParticleControl(reticleParticle,3,Vector(timer, 0, 0))

        Timers:CreateTimer(timer + .03, function()
            ParticleManager:DestroyParticle(reticleParticle, true)
            ParticleManager:ReleaseParticleIndex(reticleParticle)
        end)
    end

    return reticleParticle
end

function FindRandomPointInTraversableRadius(origin, radius, buffer)
    local check = false
    local point
    local buffer = buffer or 0

    if GridNav:IsBlocked(origin) or not GridNav:IsTraversable(origin) then return origin end

    while check == false do
        point = origin + RandomVector( RandomFloat( buffer, radius) )

        if GridNav:CanFindPath(origin, point) then
            check = true
        else
            radius = radius - 1
        end
        if radius < buffer then
            buffer = radius
        end
    end

    return point
end

--todo UnitTypes is a custom key?
function GetCustomUnitTypes(unit)
    local types = GetHandleKeyValue(unit, "UnitTypes")
    if not types then return end

    return split(types, " ")
end

--todo UnitTypes is a custom key?
function IsCustomUnitType(unit, unitType)
    local types = GetCustomUnitTypes(unit)
    if types and tablelength(types) > 0 then
        for index, string in pairs(types) do
            if string == unitType then
                return true
            end
        end
    end

    return false
end

--todo Class branches are tier/reincarnation specific
function GetClassBranchesForClassName(className)
    for unitName1,unitTable1 in pairs(CLASS_TREE) do
        --print("unitName1", unitName1)
        if className == unitName1 then return unitTable1 end
        for unitName2,unitTable2 in pairs(unitTable1) do
            --print("unitName2", unitName2)
            if className == unitName2 then return unitTable2 end
            for unitName3,unitTable3 in pairs(unitTable2) do
                --print("unitName3", unitName3)
                if className == unitName3 then return unitTable3 end
            end
        end
    end
end

--todo This is very reincarnation specific
function GetParentClassName(className)
    for unitName1,unitTable1 in pairs(CLASS_TREE) do
        if className == unitName1 then return "Unbidden" end
        for unitName2,unitTable2 in pairs(unitTable1) do
            if className == unitName2 then return unitName1 end
            for unitName3,unitTable3 in pairs(unitTable2) do
                if className == unitName3 then return unitName2 end
                for unitName4,unitTable4 in pairs(unitTable3) do
                    if className == unitName4 then return unitName3 end
                end
            end
        end
    end
end

--todo This is very reincarnation specific
function IsUnitSubClassOfClass(className, unit)
    if type(unit) == "table" then
        unit = unit:GetUnitName()
    end

    --print("checking if", unit, "is subclass of", className)

    if className == unit then return true end

    local tab = GetClassBranchesForClassName(className)
    for unitName1,unitTable1 in pairs(tab) do
        --print("- unitName1", unitName1)
        if unit == unitName1 then return true end
        for unitName2,unitTable2 in pairs(unitTable1) do
            --print("- unitName2", unitName2)
            if unit == unitName2 then return true end
            for unitName3,unitTable3 in pairs(unitTable2) do
                --print("- unitName3", unitName3)
                if unit == unitName3 then return true end
                for unitName4,unitTable4 in pairs(unitTable3) do
                    --print("- unitName4", unitName4)
                    if unit == unitName4 then return true end
                end
            end
        end
    end
    --print("was not subclass")
    return false
end

--Gets the KV value. Is passed the handle and the key as a string
function GetHandleKeyValue(objectHandle, key)
    ----print("GetHandleKeyValue Called for key: " .. key)
    local info = {}
    if not objectHandle then
        ----print("objectHandle was nil")
        info[key] = false
        return info[key]
    end
    local objectName
    if type(objectHandle) == "string" then
        objectName = objectHandle
    elseif objectHandle.GetName then
        objectName = objectHandle:GetName()
    end
    ----print("objectName is " .. objectName)

    info = ITEMSKV_TABLE[objectName]
    if not info then
        info = DOTAITEMSKV_TABLE[objectName]
    end
    if not info then
        info = ABILITYKV_TABLE[objectName]
    end
    if not info then
        if type(objectHandle) == "table" and objectHandle.IsCreature and objectHandle:IsCreature() then
            objectName = objectHandle:GetUnitName()
        end
        info = UNITSKV_TABLE[objectName]
    end
    if not info then
        objectName = Core:GetCustomHeroName(objectName)
        info = HEROKV_TABLE[objectName]
    end
    if not info then
        info = {}
        info[key] = false
    end

    return info[key]
end

function MoveTo(unit, target, orderType)

    local newOrder = {
        UnitIndex = unit:entindex(),
        OrderType = orderType,

        --TargetIndex = entToAttack:entindex(), --Optional.  Only used when targeting units
        --AbilityIndex = 0, --Optional.  Only used when casting abilities
        --Position = nil, --Optional.  Only used when targeting the ground
        --Queue = false --Optional.  Used for queueing up abilities
    }

    if orderType ~= DOTA_UNIT_ORDER_MOVE_TO_POSITION and orderType ~= DOTA_UNIT_ORDER_ATTACK_MOVE then
        newOrder.TargetIndex = target:entindex()
    else
        newOrder.Position = target
    end

    ExecuteOrderFromTable(newOrder)
end

function LookAtUnit(unit, target)
    local direction = (target:GetAbsOrigin() - unit:GetAbsOrigin()):Normalized()
    direction.z = 0
    unit:SetForwardVector(direction)
end

function deepcopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[deepcopy(orig_key)] = deepcopy(orig_value)
        end
        setmetatable(copy, deepcopy(getmetatable(orig)))
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

function tobool(s)
    if s == true or s=="true" or s=="1" or s==1 then
        return true
    end
    return false
end

function tablelength(T)
    if not T or type(T) ~= "table" then return 0 end
    local count = 0
    for _ in pairs(T) do count = count + 1 end
    return count
end

function SortTable(T)
    local tab = {}

    for k,v in pairs(T) do
        table.insert(tab, v)
    end

    return tab
end

function copyTable(datatable)
    local tblRes={}
    if type(datatable)=="table" then
        for k,v in pairs(datatable) do tblRes[k]=copyTable(v) end
    else
        tblRes=datatable
    end
    return tblRes
end

function pairsByKeys (t, f)
    local a = {}
    for n in pairs(t) do table.insert(a, n) end
    table.sort(a, f)
    local i = 0      -- iterator variable
    local iter = function ()   -- iterator function
        i = i + 1
        if a[i] == nil then
            return nil
        else
            return a[i], t[a[i]]
        end
    end
    return iter
end

function TableKeys(T)
    keys = {}
    for k, v in pairs(T) do
        table.insert(keys, k)
    end
    return keys
end

-- a function that makes dealing damage slightly faster.
function DealDamage(source, target, damage, dType, flags, ability)
    local dTable = {
        victim = target,
        attacker = source,
        damage = damage,
        damage_type = dType,
        damage_flags = flags,
        ability = ability
    }
    ApplyDamage(dTable)
end

-- theta is in radians.
function RotateVector2D(v,theta)
    local xp = v.x*math.cos(theta)-v.y*math.sin(theta)
    local yp = v.x*math.sin(theta)+v.y*math.cos(theta)
    return Vector(xp,yp,v.z):Normalized()
end


function ResolveItem(item)
    if type(item) == 'number' then
        return EntIndexToHScript(item)
    end

    if item and IsValidEntity(item) and item.IsItem and item:IsItem() then
        return item
    end

    return nil
end

function ResolveItemToId(itemId)
    if type(itemId) == 'number' then
        return itemId
    else
        itemId = itemId:GetEntityIndex()
        if(EntIndexToHScript(itemId)) then
            return itemId
        end
    end
    return nil
end