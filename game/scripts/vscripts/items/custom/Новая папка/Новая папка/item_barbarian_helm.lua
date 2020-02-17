LinkLuaModifier("modifier_item_barbarian_helm", "items/custom/item_barbarian_helm", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_barbarian_helm_buff", "items/custom/item_barbarian_helm", LUA_MODIFIER_MOTION_NONE)

item_barbarian_helm = class({})

function item_barbarian_helm:GetIntrinsicModifierName()
	return "modifier_item_barbarian_helm"
end
--------------------------------------------------------
------------------------------------------------------------
modifier_item_barbarian_helm = class({
	IsHidden 				= function(self) return true end,
	DeclareFunctions		= function(self) return 
		{
			MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
			MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
			MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
			MODIFIER_PROPERTY_EXTRA_HEALTH_BONUS,
			MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
			MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
			MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		} end,
})
function modifier_item_barbarian_helm:OnCreated()
	self:StartIntervalThink(0.1)
end

function modifier_item_barbarian_helm:OnIntervalThink()
	local parent = self:GetParent()
	local strength = parent:GetStrength()

	self:SetStackCount(strength)
	parent:CalculateStatBonus()
end
 
function modifier_item_barbarian_helm:GetModifierExtraHealthBonus()
	return self:GetAbility():GetSpecialValueFor("str_health")*self:GetStackCount()
end

function modifier_item_barbarian_helm:GetModifierConstantHealthRegen()
	return self:GetAbility():GetSpecialValueFor("str_regen")*self:GetStackCount()
end

function modifier_item_barbarian_helm:GetModifierBonusStats_Strength()
	return self:GetAbility():GetSpecialValueFor("bonus_str")
end

function modifier_item_barbarian_helm:GetModifierBonusStats_Agility()
	return self:GetAbility():GetSpecialValueFor("bonus_agi")
end

function modifier_item_barbarian_helm:GetModifierBonusStats_Intellect()
	return self:GetAbility():GetSpecialValueFor("bonus_int")
end

function modifier_item_barbarian_helm:GetModifierPhysicalArmorBonus()
	return self:GetAbility():GetSpecialValueFor("bonus_armor")
end

function modifier_item_barbarian_helm:GetModifierIncomingDamage_Percentage()
	return self:GetAbility():GetSpecialValueFor("bonus_resist")*(-1)
end

item_barbarian_helm_1 = class(item_barbarian_helm)
item_barbarian_helm_2 = class(item_barbarian_helm)
