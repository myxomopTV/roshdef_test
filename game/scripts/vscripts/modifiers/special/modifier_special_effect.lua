
modifier_item_bonus_effect_blue = class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	AllowIllusionDuplicate 	= function(self) return true end,
})

function modifier_item_bonus_effect_blue:GetEffectName()
	return "particles/econ/events/ti7/ti7_hero_effect.vpcf"
end

modifier_item_bonus_effect_green = class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	AllowIllusionDuplicate 	= function(self) return true end,
})

function modifier_item_bonus_effect_green:GetEffectName()
	return "particles/econ/events/ti8/ti8_hero_effect.vpcf"
end

modifier_item_bonus_effect_pink = class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	AllowIllusionDuplicate 	= function(self) return true end,
})

function modifier_item_bonus_effect_pink:GetEffectName()
	return "particles/econ/events/ti9/ti9_emblem_effect.vpcf"
end

modifier_item_bonus_tier_divine = class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	AllowIllusionDuplicate 	= function(self) return true end,
})

function modifier_item_bonus_tier_divine:GetEffectName()
	return "particles/divine.vpcf"
end
function modifier_item_bonus_tier_divine:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end

modifier_item_bonus_tier_legendary = class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	AllowIllusionDuplicate 	= function(self) return true end,
})

function modifier_item_bonus_tier_legendary:GetEffectName()
	return "particles/legendary.vpcf"
end
function modifier_item_bonus_tier_legendary:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end

