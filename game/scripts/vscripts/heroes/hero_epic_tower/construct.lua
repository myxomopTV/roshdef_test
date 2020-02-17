LinkLuaModifier("modifier_epic_tower_construct", "heroes/hero_epic_tower/construct", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_epic_tower_construct_start", "heroes/hero_epic_tower/construct", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_epic_tower_construct_movement", "heroes/hero_epic_tower/construct", LUA_MODIFIER_MOTION_NONE)

epic_tower_construct_movement = class({})

function epic_tower_construct_movement:GetIntrinsicModifierName()
    return "modifier_epic_tower_construct_movement"
end

function epic_tower_construct_movement:OnSpellStart()
    local caster = self:GetCaster()

   caster:RemoveModifierByName("modifier_epic_tower_construct")
end 

epic_tower_construct_build = class({})

function epic_tower_construct_build:OnSpellStart()
    local caster = self:GetCaster()

   caster:AddNewModifier(caster, self, "modifier_epic_tower_construct", nil)
   caster:SwapAbilities("epic_tower_construct_build", "epic_tower_construct_movement", false, true)
end 

modifier_epic_tower_construct = class ({
    IsHidden = function(self) return true end, 
    RemoveOnDeath = function(self) return true end, 
    IsPurgable = function(self) return false end, 
    CheckState = function(self) return {
        [MODIFIER_STATE_ROOTED] = true,
    }end,
    DeclareFunctions        = function(self) return 
        {   MODIFIER_EVENT_ON_ATTACK,
            MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
            MODIFIER_PROPERTY_MODEL_SCALE,
        } end,
})

function modifier_epic_tower_construct:OnCreated()
    local ability = self:GetAbility()
    local caster = self:GetCaster()
    local level = ability:GetLevel()
    local build_duration = ability:GetSpecialValueFor("build_duration")
    local model_scale = 0

    if level <= 1 then
        model = "models/tower_1.vmdl"
        model_scale = 0.25
    elseif level == 2 then
        model = "models/tower_1.vmdl"
        model_scale = 0.35
    elseif level == 3 then
        model = "models/props_structures/tower_good.vmdl"
        model_scale = 0.4
    elseif level == 4 then
        model = "models/props_structures/tower_good.vmdl"
        model_scale = 0.5
    elseif level == 5 then
        model = "models/props_frostivus/frostivus_ancient/radiant_tower003_tinsel.vmdl"
        model_scale = 0.6
    elseif level >= 6 then
        model = "models/props_structures/tower_dragon_white.vmdl"
        model_scale = 0.7
    end

    caster:SetModel(model)
    caster:SetOriginalModel(model)
    caster:SetModelScale(model_scale)
    caster:AddNewModifier(caster, ability, "modifier_epic_tower_construct_start", {duration = build_duration})
    self:StartIntervalThink(build_duration/10)
end

function modifier_epic_tower_construct:OnDestroy()
    local ability = self:GetAbility()
    local level = ability:GetLevel()
    local model_scale = 1
   local caster = self:GetCaster()
   caster:SwapAbilities("epic_tower_construct_build", "epic_tower_construct_movement", true, false)

    if level <= 1 then
        model = "models/items/courier/mole_messenger/mole_messenger.vmdl"
    elseif level == 2 then
        model = "models/items/courier/mole_messenger/mole_messenger_lvl2.vmdl"
    elseif level == 3 then
        model = "models/items/courier/mole_messenger/mole_messenger_lvl3.vmdl"
    elseif level == 4 then
        model = "models/items/courier/mole_messenger/mole_messenger_lvl4.vmdl"
    elseif level == 5 then
        model = "models/items/courier/mole_messenger/mole_messenger_lvl5.vmdl"
    elseif level >= 6 then
        model = "models/items/courier/mole_messenger/mole_messenger_lvl6.vmdl"
    end

    caster:SetModel(model)
    caster:SetOriginalModel(model)
    caster:SetModelScale(model_scale)
end

function modifier_epic_tower_construct:OnIntervalThink()
    if self:GetStackCount() >= 10 then
        self:StartIntervalThink(-1)
    else
        self:IncrementStackCount()
    end
end

function modifier_epic_tower_construct:GetModifierModelScale()
    return self:GetStackCount()*10
end

function modifier_epic_tower_construct:OnAttack(params)
    if not IsServer() then return end
    local attacker = params.attacker
    local caster = self:GetCaster()
    local ability = self:GetAbility()
    
    if caster.split == nil then
        caster.split = true
    end

    if attacker == caster and caster.split == true  then
        local attack_range = caster:Script_GetAttackRange() + 50
        local arrow_count = ability:GetSpecialValueFor("arrow_count")
--        local trigger_chance = ability:GetSpecialValueFor("trigger_chance")        
--        if RollPercentage(trigger_chance)  then
        local units = FindUnitsInRadius(caster:GetTeamNumber(), 
                                        caster:GetAbsOrigin(),
                                        nil,
                                        attack_range,
                                        DOTA_UNIT_TARGET_TEAM_ENEMY,
                                        DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_BUILDING, 
                                        DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE,
                                        FIND_ANY_ORDER, 
                                        false) 


        caster.split = false 
        if arrow_count > #units  then 
                arrow_count = #units
        end

        local index = 1
        local arrow_deal = 0

        while arrow_deal < arrow_count   do
            if units[index] == params.target then
            --                     print("bingo!!!")
            else
                caster:PerformAttack(units[ index ], false, true, true, false, true, false, false)
                arrow_deal = arrow_deal + 1
            end 
            index = index + 1
        end

        caster.split = true
        --   		 end
    end    
end

function modifier_epic_tower_construct:GetModifierPhysicalArmorBonus()
    return self:GetAbility():GetSpecialValueFor("armor_bonus")
end


modifier_epic_tower_construct_start = class ({
    IsHidden = function(self) return false end, 
    CheckState = function(self) return {
        [MODIFIER_STATE_STUNNED] = true,
    }end,
})

modifier_epic_tower_construct_movement = class ({
    IsHidden = function(self) return true end, 
})

function modifier_epic_tower_construct_movement:CheckState()
    local state = {}
    state[MODIFIER_STATE_DISARMED] = true

    if self:GetCaster():HasModifier("modifier_epic_tower_construct") then
        return
    else
        return state
    end
end

