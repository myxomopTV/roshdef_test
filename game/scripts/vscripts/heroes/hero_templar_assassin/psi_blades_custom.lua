LinkLuaModifier("modifier_templar_assassin_psi_blades_custom", "heroes/hero_templar_assassin/psi_blades_custom", LUA_MODIFIER_MOTION_NONE)


templar_assassin_psi_blades_custom = class({})

function templar_assassin_psi_blades_custom:OnSpellStart()
    self:GetCaster().split_shot = true
end

function templar_assassin_psi_blades_custom:GetIntrinsicModifierName()
    return "modifier_templar_assassin_psi_blades_custom"
end

modifier_templar_assassin_psi_blades_custom = class({
    IsHidden                = function(self) return true end,
    IsPurgable              = function(self) return false end,
    IsDebuff                = function(self) return false end,
    IsBuff                  = function(self) return true end,
    RemoveOnDeath           = function(self) return false end,
    DeclareFunctions        = function(self) return 
        {   MODIFIER_EVENT_ON_ATTACK,
            MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
        } end,
})

function modifier_templar_assassin_psi_blades_custom:OnCreated()
    if not IsServer() then return end
    
    local caster = self:GetCaster()
    caster.split = true
end

function modifier_templar_assassin_psi_blades_custom:OnAttack(params)
    if not IsServer() then return end
    local attacker = params.attacker
    local caster = self:GetCaster()
    local ability = self:GetAbility()
    
    if attacker == caster and caster.split == true  then

        local attack_range = caster:Script_GetAttackRange() + 50
--        local arrow_count = ability:GetSpecialValueFor("arrow_count")
        local attack_interval = ability:GetSpecialValueFor("attack_interval")
        local trigger_chance = ability:GetSpecialValueFor("trigger_chance")
        
        if RollPercentage(trigger_chance) or caster.split_shot  then
            caster.split_shot = false
            Timers:CreateTimer(attack_interval, function()
                local units = FindUnitsInRadius(caster:GetTeamNumber(), 
                                                caster:GetAbsOrigin(),
                                                nil,
                                                attack_range,
                                                DOTA_UNIT_TARGET_TEAM_ENEMY,
                                                DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_BUILDING, 
                                                DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE,
                                                FIND_ANY_ORDER, 
                                                false) 
                
                if caster.split == nil then
                    caster.split = true
                elseif caster.split == false then
                    return
                end
                
                caster.split = false 
 --               if arrow_count > #units  then 
                    arrow_count = #units
 --               end

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
            end)
        end
    end
    
end
function modifier_templar_assassin_psi_blades_custom:GetModifierAttackRangeBonus()
    return self:GetAbility():GetSpecialValueFor("attack_range_bonus")
end
