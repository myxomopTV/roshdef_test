

if modifier_technologist_energized == nil then
    modifier_technologist_energized = class({})
end


function modifier_technologist_energized:IsHidden()
    return true
end

function modifier_technologist_energized:GetEffectName()
    return "particles/technologist/energized.vpcf"
end

function modifier_technologist_energized:GetAttributes() 
    return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_technologist_energized:OnCreated( event )
    if not IsServer() then return end

    local Target = self:GetParent()
    local Caster = self:GetCaster()
    local ability = self:GetAbility()
    local abilitylevel = ability:GetLevel()

    --Update modifier_technologist_energized_stack
    UpdateStacks(Target, Caster, ability)
end




if modifier_technologist_energized_stack == nil then
    modifier_technologist_energized_stack = class({})
end


function modifier_technologist_energized_stack:DestroyOnExpire()
    return true
end

function modifier_technologist_energized_stack:GetAttributes() 
    return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_technologist_energized_stack:GetTexture()
    return "zuus_thundergods_wrath"
end

function modifier_technologist_energized_stack:OnCreated()
    if not IsServer() then return end

    self.duration = 10
end

function modifier_technologist_energized_stack:OnDestroy()
    if not IsServer() then return end

    local Caster = self:GetCaster()
    local Target = self:GetParent()
    local ability = self:GetAbility()


    local int_dmg = ability:GetSpecialValueFro("zap_int_dmg_level") * Caster:GetIntellect() * ability:GetLevel()
    local zap_radius = ability:GetSpecialValueFro("zap_radius")    

    --Calculate number of stacks then explode and return energy
    local damage = self:GetStackCount()  * int_dmg

    --Caster:SetMana(Caster:GetMana() + self:GetStackCount())
    local mod = Caster:FindModifierByName("modifier_technologist_energy")
    mod:ModifyStacks(self:GetStackCount())
--    PopupNumbersFilter("energy",  Caster, self:GetStackCount(), Caster)

    local units = FindUnitsInRadius( Caster:GetTeamNumber(), Target:GetAbsOrigin(), nil, zap_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
    for k,unit in pairs(units) do
        lightningBolt = ParticleManager:CreateParticle("particles/units/heroes/hero_zuus/zuus_arc_lightning.vpcf", PATTACH_ABSORIGIN_FOLLOW, Target)
        ParticleManager:SetParticleControl(lightningBolt,1,Vector(unit:GetAbsOrigin().x,unit:GetAbsOrigin().y,unit:GetAbsOrigin().z+((unit:GetBoundingMaxs().z - unit:GetBoundingMins().z)/2)))
       
        lightningBolt2 = ParticleManager:CreateParticle("particles/units/heroes/hero_zuus/zuus_arc_lightning.vpcf", PATTACH_ABSORIGIN_FOLLOW, unit)
        ParticleManager:SetParticleControl(lightningBolt2,1,Vector(Caster:GetAbsOrigin().x,Caster:GetAbsOrigin().y,Caster:GetAbsOrigin().z+((Caster:GetBoundingMaxs().z - Caster:GetBoundingMins().z)/2)))

        DealDamage(Caster, unit, damage, DAMAGE_TYPE_MAGICAL, nil, ability)
--        PopupNumbersFilter("shock",unit, damage, Caster)
    end

    if not IsValidEntity(Target) and not Target:IsAlive() then return end
    local modTable = Target:FindAllModifiersByName("modifier_technologist_energized")
    for i=1,tablelength(modTable) do
        if modTable[i]:GetCaster() == Caster then
            modTable[i]:Destroy()
        end
    end
end

function modifier_technologist_energized_stack:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_ATTACK_LANDED,
    }

    return funcs
end

function modifier_technologist_energized_stack:OnAttackLanded(event)
    if not IsServer() then return end
    --PrintTable(event)
    local Caster = self:GetCaster()
    local Target = self:GetParent()
    if event.attacker ~= Caster then return end
    if event.target ~= Target then return end
    --DeepPrintTable(event)
    self:Destroy()
end



if modifier_technologist_energized_failsafe == nil then
    modifier_technologist_energized_failsafe = class({})
end


function modifier_technologist_energized_failsafe:IsHidden()
    return false
end

function modifier_technologist_energized_failsafe:GetTexture()
    return "wisp_spirits"
end

function modifier_technologist_energized_failsafe:DestroyOnExpire()
    return true
end

function modifier_technologist_energized_failsafe:OnCreated()
    if not IsServer() then return end
    local Caster = self:GetCaster()
    Caster:SetBaseManaRegen(0)
    self:SetDuration(10, true)
end

function modifier_technologist_energized_failsafe:OnDestroy()
    if not IsServer() then return end
    --self:GetCaster():SetMana(100)
end

function modifier_technologist_energized_failsafe:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_TAKEDAMAGE,
    }

    return funcs
end

function modifier_technologist_energized_failsafe:OnTakeDamage(event)
    local Caster = self:GetCaster()
    if not IsServer() then return end
    if event.unit ~= Caster and event.attacker ~= Caster then return end

    self:SetDuration(10, true)
end




function UpdateStacks(Target, Caster, ability)
    local modTable = Target:FindAllModifiersByName("modifier_technologist_energized")
    local modStackTable = Target:FindAllModifiersByName("modifier_technologist_energized_stack")
    local mod
    for k,v in pairs(modStackTable) do
        if v:GetCaster() == Caster then
            mod = v
            break
        end
    end

    local modsByCaster = {}
    for k,v in pairs(modTable) do
        if v:GetCaster() == Caster then
            table.insert(modsByCaster, v)
        end
    end

    if tablelength(modsByCaster) > 0 then
        if not mod then
            mod = Target:AddNewModifier(Caster, ability, "modifier_technologist_energized_stack", {duration = 10})
        end
        mod:SetStackCount(tablelength(modsByCaster))
        mod:SetDuration(10, true)
    end

    if not mod then return end

    if mod:GetStackCount() < 1 then
        mod:RemoveSelf()
    end
end





if modifier_technologist_energy == nil then
    modifier_technologist_energy = class({})
end


function modifier_technologist_energy:IsHidden()
    return false
end

function modifier_technologist_energy:HeroEffectPriority()
    return 100
end

function modifier_technologist_energy:GetTexture()
    return "rattletrap_power_cogs"
end

function modifier_technologist_energy:OnCreated( event )
    if not IsServer() then return end

    local Target = self:GetParent()
    local Caster = self:GetCaster()
    local ability = self:GetAbility()

    self:SetStackCount(100)
    self:StartIntervalThink(.03)
end

function modifier_technologist_energy:OnIntervalThink()
    if not IsServer() then return end

    local Target = self:GetParent()
    local Caster = self:GetCaster()
    local ability = self:GetAbility()

    Target:SetBaseManaRegen(0)
    Target:SetMana(self:GetStackCount())
end

function modifier_technologist_energy:ModifyStacks(amount)
    local Target = self:GetParent()
    self:SetStackCount(self:GetStackCount() + amount)
    Target:SetMana(self:GetStackCount())
end