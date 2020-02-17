
if modifier_special_effect_legendary == nil then
    modifier_special_effect_legendary = class({})
end

function modifier_special_effect_legendary:IsHidden()
	return true
end

function modifier_special_effect_legendary:RemoveOnDeath()
	return false
end

function modifier_special_effect_legendary:IsPurgable() 
	return false 
end

function modifier_special_effect_legendary:OnCreated()

	local parent = self:GetParent()
	local particleName1 = "particles/legendary.vpcf"
--	local particleName1 = "particles/items_fx/magic_armlet/magic_armlet.vpcf"
	
	self.pfx1 = ParticleManager:CreateParticle( particleName1, PATTACH_OVERHEAD_FOLLOW, parent )
--	ParticleManager:SetParticleControlEnt(pfx1, 1, parent, PATTACH_POINT_FOLLOW, "attach_hitloc", parent:GetAbsOrigin(), true)
--	ParticleManager:SetParticleControlEnt(pfx1, 2, parent, PATTACH_POINT_FOLLOW, "attach_hitloc", parent:GetAbsOrigin(), true)
--	ParticleManager:SetParticleControlEnt(pfx1, 3, parent, PATTACH_POINT_FOLLOW, "attach_hitloc", parent:GetAbsOrigin(), true)

--	SetParticleControl(pfx1, 0, parent:GetAbsOrigin())
--	SetParticleControl(pfx1, 1, Vector (0,0,0))
--	SetParticleControl(pfx1, 2, Vector (0,0,0))
--	SetParticleControl(pfx1, 3, Vector (0,0,0))

	local particleName2 = "particles/econ/events/ti7/ti7_hero_effect.vpcf"
	self.pfx2 = ParticleManager:CreateParticle(particleName2,PATTACH_ABSORIGIN_FOLLOW,parent)

end

function modifier_special_effect_legendary:OnDestroy()
	ParticleManager:DestroyParticle(self.pfx1,true)
	ParticleManager:DestroyParticle(self.pfx2,true)
end
function modifier_special_effect_legendary:GetAttributes()
    return  MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

function modifier_special_effect_legendary:AllowIllusionDuplicate()
	return true
end

modifier_item_bonus_effect_green = class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
})

function modifier_item_bonus_effect_green:GetEffectName()
	return "particles/econ/events/ti7/ti7_hero_effect.vpcf"
end

modifier_item_bonus_effect_blue = class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
})

function modifier_item_bonus_effect_blue:GetEffectName()
	return "particles/econ/events/ti8/ti8_hero_effect.vpcf"
end

modifier_item_bonus_effect_pink = class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
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
})

function modifier_item_bonus_tier_legendary:GetEffectName()
	return "particles/legendary.vpcf"
end
function modifier_item_bonus_tier_legendary:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end

