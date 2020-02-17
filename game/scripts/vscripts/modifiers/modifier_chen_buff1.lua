modifier_chen_buff1 = class({})

function modifier_chen_buff1:DeclareFunctions()
	local funcs = 
	{

		MODIFIER_PROPERTY_EXTRA_HEALTH_PERCENTAGE

	}

	return funcs
end


function modifier_chen_buff1:IsHidden()
	return true
end


function modifier_chen_buff1:IsPurgable() 
	return false 
end

function modifier_chen_buff1:GetModifierExtraHealthPercentage ()
	return 0.1
end




