LinkLuaModifier("basic_modifier", "abilities/ability_lua_example", LUA_MODIFIER_MOTION_NONE)

ability_lua_example = class({})

function ability_lua_example:GetIntrinsicModifierName()
	return "modifier_ability_lua_example"
end

basic_modifier = class({
	IsHidden 				= function(self) return false end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
--	GetAttributes 			= function(self) return MODIFIER_ATTRIBUTE_MULTIPLE end,
	DeclareFunctions		= function(self) return 
		{
			MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		} end,
})
function basic_modifier:GetModifierBonusStats_Strength()
	return self:GetStackCount() or 0
end
