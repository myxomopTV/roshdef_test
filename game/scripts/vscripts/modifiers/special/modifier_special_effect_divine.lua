
if modifier_special_effect_divine == nil then
    modifier_special_effect_divine = class({})
end

function modifier_special_effect_divine:IsHidden()
	return true
end

function modifier_special_effect_divine:RemoveOnDeath()
	return false
end

function modifier_special_effect_divine:IsPurgable() 
	return false 
end

function modifier_special_effect_divine:GetTexture()
    return "terrorblade_metamorphosis"
end

function modifier_special_effect_divine:OnCreated()

	local parent = self:GetParent()
	local particleName1 = "particles/divine.vpcf"
--	local particleName1 = "particles/items_fx/magic_armlet/magic_armlet.vpcf"
	
	self.pfx1 = ParticleManager:CreateParticle( particleName1, PATTACH_OVERHEAD_FOLLOW, parent )
--	ParticleManager:SetParticleControlEnt(pfx1, 1, parent, PATTACH_POINT_FOLLOW, "attach_hitloc", parent:GetAbsOrigin(), true)
--	ParticleManager:SetParticleControlEnt(pfx1, 2, parent, PATTACH_POINT_FOLLOW, "attach_hitloc", parent:GetAbsOrigin(), true)
--	ParticleManager:SetParticleControlEnt(pfx1, 3, parent, PATTACH_POINT_FOLLOW, "attach_hitloc", parent:GetAbsOrigin(), true)

--	SetParticleControl(pfx1, 0, parent:GetAbsOrigin())
--	SetParticleControl(pfx1, 1, Vector (0,0,0))
--	SetParticleControl(pfx1, 2, Vector (0,0,0))
--	SetParticleControl(pfx1, 3, Vector (0,0,0))

	local particleName2 = "particles/econ/events/ti8/ti8_hero_effect.vpcf"
	self.pfx2 = ParticleManager:CreateParticle(particleName2,PATTACH_ABSORIGIN_FOLLOW,parent)
	
--	local pfx2 = ParticleManager:CreateParticle( particleName2, PATTACH_POINT_FOLLOW, parent )
--	ParticleManager:SetParticleControlEnt(pfx2,0,parent,PATTACH_POINT_FOLLOW,'attach_origin',parent:GetAbsOrigin(),true)
	--	ParticleManager:SetParticleControlEnt(pfx1, 5, parent, PATTACH_POINT_FOLLOW, "attach_hitloc", parent:GetAbsOrigin(), true)

end
function modifier_special_effect_divine:OnDestroy()
	ParticleManager:DestroyParticle(self.pfx1,true)
	ParticleManager:DestroyParticle(self.pfx2,true)
end

function modifier_special_effect_divine:GetAttributes()
    return  MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

function modifier_special_effect_divine:AllowIllusionDuplicate()
	return true
end