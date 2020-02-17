LinkLuaModifier("modifier_item_guardian_helm", "items/custom/item_guardian_helm", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_guardian_helm_buff", "items/custom/item_guardian_helm", LUA_MODIFIER_MOTION_NONE)

item_guardian_helm = class({})

function item_guardian_helm:GetIntrinsicModifierName()
	return "modifier_item_guardian_helm"
end
--------------------------------------------------------
------------------------------------------------------------
modifier_item_guardian_helm = class({
	IsHidden 				= function(self) return true end,
	DeclareFunctions		= function(self) return 
		{
			MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
			MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
			MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
			MODIFIER_PROPERTY_HEALTH_BONUS,
			MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		} end,
})
function modifier_item_guardian_helm:OnCreated()
	self:StartIntervalThink(0.1)
end

function modifier_item_guardian_helm:OnIntervalThink()
	local parent = self:GetParent()
	local strength = parent:GetStrength()

	self:SetStackCount(strength)
end
 
function modifier_item_guardian_helm:GetModifierHealthBonus()
	return self:GetAbility():GetSpecialValueFor("str_health")*self:GetStackCount()
end

function modifier_item_guardian_helm:GetModifierConstantHealthRegen()
	return self:GetAbility():GetSpecialValueFor("str_regen")*self:GetStackCount()
end

function modifier_item_guardian_helm:GetModifierBonusStats_Strength()
	return self:GetAbility():GetSpecialValueFor("bonus_str")
end

function modifier_item_guardian_helm:GetModifierBonusStats_Agility()
	return self:GetAbility():GetSpecialValueFor("bonus_agi")
end

function modifier_item_guardian_helm:GetModifierBonusStats_Intellect()
	return self:GetAbility():GetSpecialValueFor("bonus_int")
end


item_guardian_helm_1 = class(item_guardian_helm)
item_guardian_helm_2 = class(item_guardian_helm)
