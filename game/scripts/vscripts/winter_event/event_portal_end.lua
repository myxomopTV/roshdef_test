LinkLuaModifier("modifier_event_portal_end", "winter_event/event_portal_end", LUA_MODIFIER_MOTION_NONE)

event_portal_end = class({})

function event_portal_end:GetIntrinsicModifierName()
	return "modifier_event_portal_end"
end
--------------------------------------------------------
------------------------------------------------------------ sa

modifier_event_portal_end = class({
	IsHidden 				= function(self) return false end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return true end,
})

function modifier_event_portal_end:OnCreated()
	if IsServer() then
		local ability = self:GetAbility()

		local parent = self:GetParent()
		parent.event = true
		local point = parent:GetAbsOrigin()
		local effect = "particles/econ/events/fall_major_2016/teleport_end_fm06_lvl2.vpcf"
		local pfx = ParticleManager:CreateParticle(effect, PATTACH_ABSORIGIN_FOLLOW, parent)
		ParticleManager:SetParticleControl(pfx, 0, point)
		ParticleManager:SetParticleControl(pfx, 1, point)
		self:AddParticle(pfx, true, false, 111, false, false)

		self:StartIntervalThink(0.1)		
	end
end

function modifier_event_portal_end:OnIntervalThink()
	local parent = self:GetParent()
	
	local units = FindUnitsInRadius(parent:GetTeamNumber(), 
									parent:GetAbsOrigin(),
									nil,
									75,
									DOTA_UNIT_TARGET_TEAM_BOTH,
									DOTA_UNIT_TARGET_BASIC, 
									DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NO_INVIS,
									FIND_CLOSEST, 
									false)
	for i = 1, #units do
		local unit = units[1]

		if unit.avatar == true then
			if FrostEvent.event_level == 1 then
				GiveGoldPlayers(2500)
				FrostEvent:EndEvent_1()
				EmitGlobalSound("event_gift")
			elseif FrostEvent.event_level == 2 then
				GiveGoldPlayers(2500)
				EmitGlobalSound("event_gift")
			elseif FrostEvent.event_level == 3 then
				GiveGoldPlayers(2500)
				EmitGlobalSound("event_gift")
			elseif FrostEvent.event_level == 4 then
				GiveGoldPlayers(2500)
				EmitGlobalSound("event_gift")
			elseif FrostEvent.event_level == 5 then
				GiveGoldPlayers(2500)
				EmitGlobalSound("event_gift")
				FrostEvent.available = false
			end
			unit:ForceKill(false)
			FrostEvent:EndRound()
			FrostEvent.event_level = FrostEvent.event_level + 1
		end	
	end
end
