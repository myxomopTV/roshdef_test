
if modifier_lich_lord_debuff == nil then
    modifier_lich_lord_debuff = class({})
end

function modifier_lich_lord_debuff:IsPurgable() 
	return false 
end

function modifier_lich_lord_debuff:IsHidden()
	return false
end

function modifier_lich_lord_debuff:IsDebuff()
	return true
end

function modifier_lich_lord_debuff:GetTexture()
    return "lich_frost_nova"
end

function modifier_lich_lord_debuff:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	}

	return funcs
end


function modifier_lich_lord_debuff:GetModifierMoveSpeedBonus_Percentage()
	return -25
end


function modifier_lich_lord_debuff:GetModifierAttackSpeedBonus_Constant()	
	return -25
end

