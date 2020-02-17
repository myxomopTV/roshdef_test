
if modifier_necro_lord_debuff == nil then
    modifier_necro_lord_debuff = class({})
end

function modifier_necro_lord_debuff:IsHidden()
	return false
end
function modifier_necro_lord_debuff:IsDebuff()
	return true
end

function modifier_necro_lord_debuff:IsPurgable() 
	return false 
end

function modifier_necro_lord_debuff:GetTexture()
    return "necrolyte_heartstopper_aura"
end

function modifier_necro_lord_debuff:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
	}

	return funcs
end


function modifier_necro_lord_debuff:GetModifierHealthRegenPercentage()
	return -0.5
end


