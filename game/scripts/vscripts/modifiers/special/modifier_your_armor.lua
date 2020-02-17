GameRules.HeroesFile = LoadKeyValues("scripts/npc/npc_heroes_custom.txt")

if modifier_your_armor == nil then modifier_your_armor = class({}) end
function modifier_your_armor:IsHidden() return true end
function modifier_your_armor:RemoveOnDeath() return false end
function modifier_your_armor:IsDebuff() return false end
function modifier_your_armor:IsPurgable() return false end

function modifier_your_armor:OnCreated()
    if IsServer() then
 
 
        self:StartIntervalThink(0.03)
    end
end
 
 
function modifier_your_armor:OnIntervalThink()
    if IsServer() then
        local parent = self:GetParent()
        local hero_name = parent:GetUnitName()
 
--		print("hero_name ="..hero_name)
        local base_armor = 0--GameRules.HeroesFile[hero_name]["ArmorPhysical"]
--		print("base armor ="..base_armor)
        local base_armor_per_agi = 0.16
        local your_armor_per_agi = 0.02
--[[		
        if parent:GetPrimaryAttribute() == 1 then
            base_armor_per_agi = 0.2
            your_armor_per_agi = 0.025
        end
 ]]      
        local agility = parent:GetAgility()
        local armor_value = base_armor + agility*(your_armor_per_agi - base_armor_per_agi )
       
        parent:SetPhysicalArmorBaseValue(armor_value)
 
    end
end