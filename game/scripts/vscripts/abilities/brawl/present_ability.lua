present_ability = class({})

LinkLuaModifier("modifier_present_ability", "abilities/modifiers/modifier_present_ability", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_present_ability_hero", "abilities/modifiers/modifier_present_ability_hero", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_present_ability_present", "abilities/modifiers/modifier_present_ability_present", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_present_ability_present_greevil", "abilities/modifiers/modifier_present_ability_present_greevil", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_present_ability_red", "abilities/present_ability", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_present_ability_green", "abilities/present_ability", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_present_ability_blue", "abilities/present_ability", LUA_MODIFIER_MOTION_NONE)

function present_ability:GetIntrinsicModifierName()
	return "modifier_present_ability"
end

modifier_present_ability_red = class({IsPurgable = function() return false end, IsHidden = function() return true end,})
function modifier_present_ability_red:DeclareFunctions() return {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE} end
function modifier_present_ability_red:GetModifierMoveSpeedBonus_Percentage() return -30*self:GetStackCount() end

modifier_present_ability_green = class({IsPurgable = function() return false end, IsHidden = function() return true end,})
function modifier_present_ability_green:DeclareFunctions() return {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE} end
function modifier_present_ability_green:GetModifierMoveSpeedBonus_Percentage() return 10*self:GetStackCount() end

modifier_present_ability_blue = class({IsPurgable = function() return false end, IsHidden = function() return true end,})
function modifier_present_ability_blue:DeclareFunctions() return {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE} end
function modifier_present_ability_blue:GetModifierMoveSpeedBonus_Percentage() return -10*self:GetStackCount() end