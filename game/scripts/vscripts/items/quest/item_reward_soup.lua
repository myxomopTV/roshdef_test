LinkLuaModifier("modifier_item_reward_soup", "items/quest/item_reward_soup", LUA_MODIFIER_MOTION_NONE)

item_reward_soup = class({})

function item_reward_soup:OnSpellStart()
	local caster = self:GetCaster()

	caster:AddNewModifier(caster, self, "modifier_item_reward_soup", nil)
	EmitSoundOn("DOTA_Item.Cheese.Activate", caster)
	caster:RemoveItem(self)
end


modifier_item_reward_soup = class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	DeclareFunctions		= function(self) return 
		{	MODIFIER_PROPERTY_HEALTH_BONUS,
		} end,
})

function modifier_item_reward_soup:OnCreated()
	self.bonus_value = self:GetAbility():GetSpecialValueFor("bonus_value")
end

function modifier_item_reward_soup:GetModifierHealthBonus()
	return self.bonus_value
end

