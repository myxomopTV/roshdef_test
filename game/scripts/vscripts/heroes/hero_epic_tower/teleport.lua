LinkLuaModifier("modifier_epic_tower_teleport", "heroes/hero_epic_tower/teleport", LUA_MODIFIER_MOTION_NONE)

epic_tower_teleport = class({})

function epic_tower_teleport:OnSpellStart()
	local point = self:GetCursorPosition()
	self.point = point
	local caster = self:GetCaster()
	print("ggg")

	local start_pfx_name = 	"particles/items2_fx/teleport_start.vpcf"
	local end_pfx_name = 	"particles/items2_fx/teleport_end.vpcf"
	caster:EmitSound("Portal.Loop_Disappear")

	caster.start_pfx = ParticleManager:CreateParticle(start_pfx_name, PATTACH_WORLDORIGIN, caster)
	ParticleManager:SetParticleControl(caster.start_pfx, 0, caster:GetAbsOrigin())
	ParticleManager:SetParticleControl(caster.start_pfx, 2, Vector(255,255,0))
	ParticleManager:SetParticleControl(caster.start_pfx, 3, caster:GetAbsOrigin())
	ParticleManager:SetParticleControl(caster.start_pfx, 4, caster:GetAbsOrigin())
	ParticleManager:SetParticleControl(caster.start_pfx, 5, Vector(3,0,0))
	ParticleManager:SetParticleControl(caster.start_pfx, 6, caster:GetAbsOrigin())

	caster.end_pfx = ParticleManager:CreateParticle(end_pfx_name, PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(caster.end_pfx, 0, point)
	ParticleManager:SetParticleControl(caster.end_pfx, 1, point)
	ParticleManager:SetParticleControl(caster.end_pfx, 4, Vector(1,0,0))
	ParticleManager:SetParticleControl(caster.end_pfx, 5, point)
	ParticleManager:SetParticleControlEnt(caster.end_pfx, 3, caster, PATTACH_CUSTOMORIGIN, "attach_hitloc", point, true)

end	

function epic_tower_teleport:OnChannelFinish( bInterrupted )	
	local caster = self:GetCaster()

	if bInterrupted == false then
	    FindClearSpaceForUnit(caster, self.point, true)
	    caster:EmitSound("Portal.Hero_Disappear")
	    caster:EmitSound("Portal.Hero_Appear")
	    caster:Stop() 
	end

	ParticleManager:DestroyParticle(caster.start_pfx, false)
	ParticleManager:ReleaseParticleIndex(caster.start_pfx)
	ParticleManager:DestroyParticle(caster.end_pfx, false)
	ParticleManager:ReleaseParticleIndex(caster.end_pfx)
	caster:StopSound("Portal.Loop_Disappear")
end

function epic_tower_teleport:GetIntrinsicModifierName()
	return "modifier_epic_tower_teleport"
end	

modifier_epic_tower_teleport = class ({
	IsHidden = function(self) return true end,	
	CheckState = function(self) return {
		[MODIFIER_STATE_ROOTED] = true,
	}end,
	DeclareFunctions = function(self) return {
		MODIFIER_PROPERTY_IGNORE_CAST_ANGLE
	}end,
})

function modifier_epic_tower_teleport:GetModifierIgnoreCastAngle()
	return 1
end	