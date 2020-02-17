greevil_naked_irrepressible = class({})

LinkLuaModifier("modifier_greevil_naked_irrepressible", "abilities/greevil_naked_irrepressible", LUA_MODIFIER_MOTION_NONE)

function greevil_naked_irrepressible:GetAbilityTextureName()
	return "greevil_naked_irrepressible"
end
function greevil_naked_irrepressible:GetIntrinsicModifierName()
	return "modifier_greevil_naked_irrepressible"
end

modifier_greevil_naked_irrepressible = class({
	IsPurgable = function() return false end,
})

function modifier_greevil_naked_irrepressible:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE
	}
end

function modifier_greevil_naked_irrepressible:GetModifierMoveSpeed_Absolute()
	return self:GetAbility():GetSpecialValueFor("movespeed")
end