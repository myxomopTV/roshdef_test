LinkLuaModifier("modifier_survior_passive", "winter_event/survior_passive", LUA_MODIFIER_MOTION_NONE)

survior_passive = class({})

function survior_passive:GetIntrinsicModifierName()
	return "modifier_survior_passive"
end
--------------------------------------------------------
------------------------------------------------------------ sa

modifier_survior_passive = class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return true end,
})

function modifier_survior_passive:OnCreated()
	if IsServer() then
		local ability = self:GetAbility()

		local parent = self:GetParent()
		local point = parent:GetAbsOrigin()

		self:StartIntervalThink(0.1)		
	end
end

function modifier_survior_passive:OnIntervalThink()
	local parent = self:GetParent()
	local radius = self:GetAbility():GetSpecialValueFor("radius")
	
	local units = FindUnitsInRadius(parent:GetTeamNumber(), 
									parent:GetAbsOrigin(),
									nil,
									radius,
									DOTA_UNIT_TARGET_TEAM_ENEMY,
									DOTA_UNIT_TARGET_BASIC, 
									DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE,
									FIND_CLOSEST, 
									false)
	for _,unit in pairs (units) do
		local unit_name = unit:GetUnitName()
		print(unit_name)
		if unit_name == "npc_dota_event_ghoul_3" or unit_name == "npc_dota_event_mega_ghoul" then
			parent:ForceKill(false)
		end
	end
end
