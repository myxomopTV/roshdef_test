LinkLuaModifier("modifier_item_soup", "items/quest/item_soup", LUA_MODIFIER_MOTION_NONE)

item_soup = class({})

function item_soup:OnSpellStart()
	local caster = self:GetCaster()

	caster:AddNewModifier(caster, self, "modifier_item_soup", nil)
	EmitSoundOn("DOTA_Item.Cheese.Activate", caster)
	caster:RemoveItem(self)
end


modifier_item_soup = class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	DeclareFunctions		= function(self) return 
		{	MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
			MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
			MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
			MODIFIER_PROPERTY_MODEL_SCALE,
		} end,
})

function modifier_item_soup:OnCreated()
	self.bonus_value = self:GetAbility():GetSpecialValueFor("bonus_value")
end

function modifier_item_soup:GetModifierBonusStats_Strength()
	return self.bonus_value
end

function modifier_item_soup:GetModifierBonusStats_Agility()
	return self.bonus_value
end

function modifier_item_soup:GetModifierBonusStats_Intellect()
	return self.bonus_value
end

function modifier_item_soup:GetModifierModelScale()
	return 50
end