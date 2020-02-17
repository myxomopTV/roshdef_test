--[[
	Author: Noya
	Date: April 5, 2015.
	FURION CAN YOU TP TOP? FURION CAN YOU TP TOP? CAN YOU TP TOP? FURION CAN YOU TP TOP? 
]]
function Teleport( event )
	local caster = event.caster
	local point = event.target_points[1]
	
    FindClearSpaceForUnit(caster, point, true)
    caster:Stop() 
    EndTeleport(event)   
end

function CreateTeleportParticles( event )
	local caster = event.caster
	local point = event.target_points[1]
--	local particleName = "particles/units/heroes/hero_furion/furion_teleport_end.vpcf"
	local start_pfx_name = 	"particles/items2_fx/teleport_start.vpcf"
	local end_pfx_name = 	"particles/items2_fx/teleport_end.vpcf"

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

function EndTeleport( event )
	local caster = event.caster
	ParticleManager:DestroyParticle(caster.start_pfx, false)
	ParticleManager:DestroyParticle(caster.end_pfx, false)
	caster:StopSound("Portal.Loop_Disappear")
end