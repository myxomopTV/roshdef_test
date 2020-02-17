LinkLuaModifier("modifier_acult_ghost", "abilities/acult_ghost", LUA_MODIFIER_MOTION_NONE)

acult_ghost = class({})

function acult_ghost:GetIntrinsicModifierName()
	return "modifier_acult_ghost"
end

modifier_acult_ghost = class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	CheckState		= function(self) return 
		{
--			[MODIFIER_STATE_UNSELECTABLE] = true,
			[MODIFIER_STATE_INVULNERABLE] = true,
			[MODIFIER_STATE_NO_HEALTH_BAR] = true,
			[MODIFIER_STATE_BLIND] = true,
			[MODIFIER_STATE_NOT_ON_MINIMAP] = true,
--			[MODIFIER_STATE_ROOTED] = true,
			[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		} end,
})
function modifier_acult_ghost:OnCreated()
	if IsServer() then
		Timers:CreateTimer(0.1, function()
			local ability = self:GetAbility()
			local caster = self:GetCaster()
			local point = Entities:FindByName( nil, "ritual_ghost") 
			if point then	
				caster:MoveToPosition(point:GetAbsOrigin())
			end
--			EmitSoundOn("Hero_Necrolyte.ReapersScythe.Cast.ti7", caster)
			
			Timers:CreateTimer(3, function()
				self:StartIntervalThink(0.03)
			end)
		end)
	end
end

function modifier_acult_ghost:GetEffectName()
	return "particles/units/heroes/hero_skeletonking/wraith_king_ambient.vpcf"
end

function modifier_acult_ghost:OnIntervalThink()
	local caster = self:GetCaster()
	local ability = self:GetAbility()
	
	local units = FindUnitsInRadius(caster:GetTeamNumber(), 
									caster:GetAbsOrigin(),
									nil,
									600,
									DOTA_UNIT_TARGET_TEAM_ENEMY,
									DOTA_UNIT_TARGET_HERO, 
									DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
									FIND_CLOSEST, 
									false)
	local unit = units[1]
	if unit then
		local unit_point = unit:GetAbsOrigin()
		local caster_point = caster:GetAbsOrigin()
		local forward_vector = 	unit_point - caster_point
		caster:SetForwardVector(forward_vector)
	end

end
