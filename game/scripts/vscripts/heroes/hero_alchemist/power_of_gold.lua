
alchemist_power_of_gold = class({})

LinkLuaModifier("modifier_hero_alchemist_power_of_gold", "heroes/hero_alchemist/power_of_gold", LUA_MODIFIER_MOTION_NONE)

function alchemist_power_of_gold:GetIntrinsicModifierName()
  return "modifier_hero_alchemist_power_of_gold"
end


modifier_hero_alchemist_power_of_gold = class({})


function modifier_hero_alchemist_power_of_gold:OnCreated()
    if IsServer() then
        -- Insert new stack values
  		local gpm = PlayerResource:GetGoldPerMin(self:GetParent():GetPlayerID())
		self:SetStackCount(gpm)
		Timers:CreateTimer(1,function() self:OnCreated() end)
	end
end

function modifier_hero_alchemist_power_of_gold:IsHidden() return true end
function modifier_hero_alchemist_power_of_gold:IsPurgable() return false end
function modifier_hero_alchemist_power_of_gold:IsDebuff() return false end


function modifier_hero_alchemist_power_of_gold:DeclareFunctions()
    local decFunc = {MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE}

    return decFunc
end

function modifier_hero_alchemist_power_of_gold:GetModifierPreAttack_BonusDamage()	
 	return self:GetStackCount()*GameRules:GetGameTime()/60*self:GetAbility():GetSpecialValueFor("gold_percent")/100
end
