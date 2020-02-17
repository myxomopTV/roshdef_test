if modifier_technologist_array == nil then
    modifier_technologist_array = class({})
end


LinkLuaModifier( "modifier_technologist_energized", "heroes/technologist/modifiers/energy_system.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_technologist_energized_stack", "heroes/technologist/modifiers/energy_system.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_technologist_energized_failsafe", "heroes/technologist/modifiers/energy_system.lua", LUA_MODIFIER_MOTION_NONE )

function modifier_technologist_array:IsHidden()
    return true
end

function modifier_technologist_array:OnCreated( event )
    
    if not IsServer() then return end

    self:StartIntervalThink(.25)
end

function modifier_technologist_array:OnIntervalThink()
    local Caster = self:GetCaster()

    if not Caster.master:IsAlive() then
        for k,v in pairs(Caster.master.arrayTable) do
            if v == Caster then
                ReturnArray(Caster.master, k)
            end
        end
        return
    end

    Caster.master:AddNewModifier(Caster.master, Caster.master:FindAbilityByName("customability_technologist_floating_point"), "modifier_technologist_energized_failsafe", {duration = 10})

    --CheckGet target
    if Caster.arrayType == "heal" then
        CheckGetFriendlyTarget(self)
    elseif not IsValidTargetForUnit(Caster, Caster.arrayTarget) then
        Caster.arrayTarget = nil
        CheckGetAttackTarget(self)
    end

    if Caster.arrayTarget then
        --Fire effect
        ArrayFunctionTable[Caster.arrayType](self)
    else
        if Caster.beamParticle then
            ParticleManager:DestroyParticle(Caster.beamParticle, false)
            Caster.beamParticle = nil
        end
    end
end


ArrayFunctionTable = {
    ["flame"] = function(...) FlameBeam(...) end,
    ["freeze"] = function(...) FreezeBeam(...) end,
    ["heal"] = function(...) HealBeam(...) end,
}

function FlameBeam(modifier)
    local Caster = modifier:GetCaster()
    local Target = Caster.arrayTarget

    if not Caster.beamParticle then
        Dummies:SetKeyValue(Caster, "beamParticle", ParticleManager:CreateParticle("particles/technologist/flame_array.vpcf", PATTACH_ABSORIGIN_FOLLOW, Caster))
        Dummies:AddParticleIndex(Caster, Caster.beamParticle)
    end
    TransferBeamParticle(Caster, Target)

    local ability = Caster.master:FindAbilityByName("customability_technologist_floating_point")
    local damagePerc = (5 + (ability:GetLevel() * .83)) / 100
    local damage = damagePerc * Caster.master:GetIntellect()

    DealDamage(Caster.master, Target, damage, DAMAGE_TYPE_MAGICAL, nil, ability)
--    PopupNumbersFilter("fire", Target, damage, Caster)
end

function FreezeBeam(modifier)
    local Caster = modifier:GetCaster()
    local Target = Caster.arrayTarget

    if not Caster.beamParticle then
        Dummies:SetKeyValue(Caster, "beamParticle", ParticleManager:CreateParticle("particles/technologist/freeze_array.vpcf", PATTACH_ABSORIGIN_FOLLOW, Caster))
        Dummies:AddParticleIndex(Caster, Caster.beamParticle)
    end
    TransferBeamParticle(Caster, Target)
    LinkLuaModifier( "modifier_technologist_array_freeze", "heroes/technologist/modifiers/array.lua", LUA_MODIFIER_MOTION_NONE )

    local ability = Caster.master:FindAbilityByName("customability_technologist_floating_point")
    local modTable = Target:FindAllModifiersByName("modifier_technologist_array_freeze")
    local found = false
    for k,mod in pairs(modTable) do
        if mod.array == Caster then
            mod:SetDuration(.5, true)
            found = true
            break
        end
    end

    if not found then
        local mod = Target:AddNewModifier(Caster.master, ability, "modifier_technologist_array_freeze", {duration = .5})
        mod.array = Caster
    end
end

function HealBeam(modifier)
    local Caster = modifier:GetCaster()
    local Target = Caster.arrayTarget

    if not Caster.beamParticle then
        Dummies:SetKeyValue(Caster, "beamParticle", ParticleManager:CreateParticle("particles/technologist/heal_array.vpcf", PATTACH_ABSORIGIN_FOLLOW, Caster))
        Dummies:AddParticleIndex(Caster, Caster.beamParticle)
    end
    TransferBeamParticle(Caster, Target)

    local ability = Caster.master:FindAbilityByName("customability_technologist_floating_point")
    local healperc = (2.5 + (ability:GetLevel() * .42)) / 100
    local healamount = healperc * Caster.master:GetIntellect()

--    PopupNumbersFilter("heal", Target, healamount, Caster)
    Target:Heal(healamount, Caster.master)
end





if modifier_technologist_array_freeze == nil then
    modifier_technologist_array_freeze = class({})
end


function modifier_technologist_array_freeze:DestroyOnExpire()
    return true
end

function modifier_technologist_array_freeze:GetAttributes() 
    return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_technologist_array_freeze:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
    }

    return funcs
end

function modifier_technologist_array_freeze:GetModifierMoveSpeedBonus_Percentage()
    local Caster = self:GetCaster()
    local ability = self:GetAbility()
    local movePerc = (10 + (ability:GetLevel() / 2.5)) * -1
    return movePerc
end

function modifier_technologist_array_freeze:GetModifierAttackSpeedBonus_Constant()
    local Caster = self:GetCaster()
    local ability = self:GetAbility()
    local slowPerc = (10 + (ability:GetLevel() * .67)) * -1
    return slowPerc
end









function TransferBeamParticle(array, Target)
    ParticleManager:SetParticleControlEnt(array.beamParticle,1,Target,PATTACH_POINT_FOLLOW,"attach_hitloc",Target:GetAbsOrigin(),true)
end

function CheckGetFriendlyTarget(modifier)
    local Caster = modifier:GetCaster()

    if Caster.arrayTarget then
        if CheckTargetOutOfRange(Caster, Caster.arrayTarget) then Caster.arrayTarget = nil end
        if Caster.arrayTarget and not Caster.arrayTarget:HasModifier("modifier_in_combat") then Caster.arrayTarget = nil end
    end

    local units = FindUnitsInRadius( Caster:GetTeamNumber(), Caster:GetAbsOrigin(), nil, Caster.radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)

    local healTarget

    --Get the lowest health unit in range
    if tablelength(units) > 0 then
        for index,unit in pairs(units) do
            if unit:GetHealthPercent() < 100 then
                if healTarget == nil then
                    healTarget = unit
                end
                if unit:GetHealthPercent() < healTarget:GetHealthPercent() then
                    healTarget = unit
                end
            end
        end
    end

    --print("HealTarget is " .. healTarget:GetUnitName())

    if healTarget then
        if Caster.arrayTarget then
            if Caster.arrayTarget:GetHealthPercent() > healTarget:GetHealthPercent() then
                Dummies:SetKeyValue(Caster, "arrayTarget", healTarget)
            end
        else
            Dummies:SetKeyValue(Caster, "arrayTarget", healTarget)
        end
    else
        Dummies:SetKeyValue(Caster, "arrayTarget", nil)
    end
end

function CheckGetAttackTarget(modifier)
    local Caster = modifier:GetCaster()
    local units = FindUnitsInRadius( Caster:GetTeamNumber(), Caster:GetAbsOrigin(), nil, Caster.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
    for key,unit in pairs(units) do
        if IsValidTargetForUnit(Caster, unit) then
            Dummies:SetKeyValue(Caster, "arrayTarget", unit)
            break
        end
    end
end

function IsValidTargetForUnit(unit, Target)
    if not Target then return false end
    if Target:IsNull() then return false end
    if unit.arrayType == "heal" then
        if not Target:IsAlive() or CheckTargetOutOfRange(unit, Target) or not unit:CanEntityBeSeenByMyTeam(Target) or Target:GetTeamNumber() ~= unit:GetTeamNumber() then
            return false
        end
    else
        if not Target:IsAlive() or not IsVulnerable(Target) or CheckTargetOutOfRange(unit, Target) or not unit:CanEntityBeSeenByMyTeam(Target) or Target:GetTeamNumber() == unit:GetTeamNumber() then
            return false
        end
    end
    return true
end




function CheckTargetOutOfRange(unit, Target)
    if (unit:GetAbsOrigin() - Target:GetAbsOrigin()):Length2D() > unit.radius then
        return true
    end
    return false
end

function IsVulnerable(unit, damageType)

    if damageType == "attack" and unit:IsAttackImmune() then return false end
    if damageType == "magic" and unit:IsMagicImmune() then return false end
    if damageType == "both" and unit:IsMagicImmune() and unit:IsAttackImmune() then return false end

    if unit:IsInvulnerable() then return false end

    return true
end