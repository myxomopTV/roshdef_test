
LinkLuaModifier( "modifier_aniki_petrify", "heroes/hero_aniki/petrify", LUA_MODIFIER_MOTION_NONE )

aniki_petrify = class({})

function aniki_petrify:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	local duration = self:GetSpecialValueFor("duration")

	target:AddNewModifier(caster, self, "modifier_aniki_petrify", {duration = duration})
end

modifier_aniki_petrify = class({
	IsHidden 				= function(self) return false end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return true end,
	DeclareFunctions		= function(self) return 
		{
			MODIFIER_PROPERTY_TOTAL_CONSTANT_BLOCK,
		} end,
})

function modifier_aniki_petrify:OnCreated()
	if IsServer() then
		local parent = self:GetParent()
		parent:EmitSound("n_creep_Spawnlord.Freeze")

		local particle = "particles/units/heroes/hero_dark_willow/dark_willow_bramble_root.vpcf"
		local particle_fx = ParticleManager:CreateParticle(particle, PATTACH_ABSORIGIN_FOLLOW, parent)
		ParticleManager:SetParticleControlEnt(particle_fx, 0, caster, PATTACH_POINT_FOLLOW, "attach_feet", parent:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(particle_fx, 1, caster, PATTACH_POINT_FOLLOW, "attach_feet", parent:GetAbsOrigin(), true)
		self:AddParticle(particle_fx, true, false, 100, false, false)

		local particle1 = "particles/units/heroes/hero_dark_willow/dark_willow_bramble_swirl_dark.vpcf"
		local particle_fx1 = ParticleManager:CreateParticle(particle1, PATTACH_ABSORIGIN_FOLLOW, parent)
		ParticleManager:SetParticleControlEnt(particle_fx1, 0, caster, PATTACH_POINT_FOLLOW, "attach_feet", parent:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(particle_fx1, 1, caster, PATTACH_POINT_FOLLOW, "attach_feet", parent:GetAbsOrigin(), true)
		self:AddParticle(particle_fx1, true, false, 100, false, false)
	
	end
end
function modifier_aniki_petrify:GetModifierTotal_ConstantBlock()
	return self:GetAbility():GetSpecialValueFor("damage_block")
end
