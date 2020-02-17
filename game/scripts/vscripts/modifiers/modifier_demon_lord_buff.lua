
if modifier_demon_lord_buff == nil then
    modifier_demon_lord_buff = class({})
end

function modifier_demon_lord_buff:IsHidden()
	return false
end

function modifier_demon_lord_buff:IsPurgable() 
	return false 
end

function modifier_demon_lord_buff:GetTexture()
    return "terrorblade_metamorphosis"
end

function modifier_demon_lord_buff:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE_UNIQUE,
		MODIFIER_PROPERTY_EXTRA_HEALTH_PERCENTAGE
	}

	return funcs
end


function modifier_demon_lord_buff:GetModifierBaseDamageOutgoing_Percentage()
	return 25
end


function modifier_demon_lord_buff:GetModifierAttackSpeedBonus_Constant()	
	return 25
end

--[[
function modifier_demon_lord_buff:GetModifierBaseDamageOutgoing_PercentageUnique()	
	return 25
end

function modifier_demon_lord_buff:GetModifierExtraHealthPercentage ()
	return 0.2
end


Adds the shapeshift haste particle to the unit when the modifier gets created]]
