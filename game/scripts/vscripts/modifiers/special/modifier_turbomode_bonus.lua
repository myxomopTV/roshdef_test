
if modifier_turbomode_bonus == nil then
    modifier_turbomode_bonus = class({})
end

function modifier_turbomode_bonus:IsHidden()
	return false
end

function modifier_turbomode_bonus:IsBuff()
	return true
end

function modifier_turbomode_bonus:IsPurgable() 
	return false 
end

function modifier_turbomode_bonus:GetTexture()
    return "turbomode_bonus"
end


function modifier_turbomode_bonus:GetAttributes()
    return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end


function modifier_turbomode_bonus:AllowIllusionDuplicate()
	return true
end

function modifier_turbomode_bonus:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_EXP_RATE_BOOST,
--		MODIFIER_PROPERTY_BOUNTY_CREEP_MULTIPLIER,
--		MODIFIER_PROPERTY_BOUNTY_OTHER_MULTIPLIER,
	}

	return funcs
end


function modifier_turbomode_bonus:GetModifierPercentageExpRateBoost()
	return 100
end

function modifier_turbomode_bonus:GetModifierBountyCreepMultiplier()
	return 1000
end


function modifier_turbomode_bonus:GetModifierBountyOtherMultiplier()	
	return 1000
end