
if modifier_special_effect_contest == nil then
    modifier_special_effect_contest = class({})
end

function modifier_special_effect_contest:IsHidden()
	return false
end

function modifier_special_effect_contest:IsPurgable() 
	return false 
end

function modifier_special_effect_contest:GetTexture()
    return "terrorblade_metamorphosis"
end

function modifier_special_effect_contest:OnCreated()

	local parent = self:GetParent()
	local particleName1 = "particles/units/heroes/hero_omniknight/omniknight_guardian_angel_wings.vpcf"
	local pfx1 = ParticleManager:CreateParticle( particleName1, PATTACH_ABSORIGIN_FOLLOW, parent )
	ParticleManager:SetParticleControlEnt(pfx1, 5, parent, PATTACH_POINT_FOLLOW, "attach_hitloc", parent:GetAbsOrigin(), true)

	local particleName2 = "particles/rainbow.vpcf"
	local pfx2 = ParticleManager:CreateParticle( particleName2, PATTACH_ABSORIGIN_FOLLOW, parent )
--	ParticleManager:SetParticleControlEnt(pfx1, 5, parent, PATTACH_POINT_FOLLOW, "attach_hitloc", parent:GetAbsOrigin(), true)

end

function modifier_special_effect_contest:GetAttributes()
    return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

function modifier_special_effect_contest:AllowIllusionDuplicate()
	return true
end