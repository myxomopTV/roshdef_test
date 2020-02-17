
if modifier_special_effect_mark == nil then
    modifier_special_effect_mark = class({})
end

function modifier_special_effect_mark:IsHidden()
	return true
end

function modifier_special_effect_mark:RemoveOnDeath()
	return false
end

function modifier_special_effect_mark:IsPurgable() 
	return false 
end

function modifier_special_effect_mark:GetTexture()
    return "terrorblade_metamorphosis"
end

function modifier_special_effect_mark:OnCreated()

	local parent = self:GetParent()
	local particleName1 = "particles/divine.vpcf"
	
	self.pfx1 = ParticleManager:CreateParticle( particleName1, PATTACH_OVERHEAD_FOLLOW, parent )

	local particleName2 = "particles/econ/events/ti9/ti9_emblem_effect.vpcf"
	self.pfx2 = ParticleManager:CreateParticle(particleName2,PATTACH_ABSORIGIN_FOLLOW,parent)

end
function modifier_special_effect_mark:OnDestroy()
	ParticleManager:DestroyParticle(self.pfx1,true)
	ParticleManager:DestroyParticle(self.pfx2,true)
end

function modifier_special_effect_mark:GetAttributes()
    return  MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

function modifier_special_effect_mark:AllowIllusionDuplicate()
	return true
end