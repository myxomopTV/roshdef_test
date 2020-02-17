LinkLuaModifier("modifier_strom_vortex_ball_thinker", "heroes/hero_storm/vortex_ball", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_strom_vortex_ball_pull", "heroes/hero_storm/vortex_ball", LUA_MODIFIER_MOTION_NONE)

storm_vortex_ball = class({})

function storm_vortex_ball:OnSpellStart()
	if IsServer() then
		-- Ability properties
		local caster			=	self:GetCaster()
		local point_loc			=	self:GetCursorPosition()
		local pull_duration		=	self:GetSpecialValueFor("pull_duration") 

		CreateModifierThinker(caster, self, "modifier_strom_vortex_ball_thinker", {duration =pull_duration}, point_loc, caster:GetTeam(), false)

	

	end
end

function storm_vortex_ball:GetCastRange()
	return self:GetSpecialValueFor("cast_range")
end

function storm_vortex_ball:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end

modifier_strom_vortex_ball_thinker = class({
	IsHidden 				= function(self) return false end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
})

function modifier_strom_vortex_ball_thinker:OnCreated()
	if IsServer() then
		local ability = self:GetAbility()
		local parent = self:GetParent()
		local point				=	parent:GetAbsOrigin()
		local lingering_sound	=	"Hero_StormSpirit.ElectricVortex"
		local cast_sound		=	"Hero_StormSpirit.ElectricVortexCast"
		-- Ability paramaters															-- #1 TALENT: more pull duration
		local pull_duration			=	ability:GetSpecialValueFor("pull_duration") 
		local speed =	ability:GetSpecialValueFor("pull_units_per_second") --+ caster:FindTalentValue("special_bonus_imba_storm_spirit_2")
		local electric_vortex_pull_distance = ability:GetSpecialValueFor("electric_vortex_pull_distance")

		-- Sound effect
		parent:EmitSound(cast_sound)
		EmitSoundOn(lingering_sound, parent)
		
		local enemies	=	FindUnitsInRadius(	parent:GetTeamNumber(),
			point,
			nil,
			ability:GetCastRange(),
			ability:GetAbilityTargetTeam(),
			ability:GetAbilityTargetType(),
			ability:GetAbilityTargetFlags(),
			FIND_ANY_ORDER,
			false)

		-- Apply vortex on nearby enemies
		for _,enemy in pairs(enemies) do
			local direction 		= 	(parent:GetAbsOrigin() - enemy:GetAbsOrigin()):Normalized()
			-- Apply vortex on enemy
			enemy:AddNewModifier(parent, ability, "modifier_strom_vortex_ball_pull", {duration = pull_duration, speed = speed, electric_vortex_pull_distance = electric_vortex_pull_distance} )
		end
	end
end
--- PULL MODIFIER
modifier_strom_vortex_ball_pull = modifier_strom_vortex_ball_pull or class({})

-- Modifier properties
function modifier_strom_vortex_ball_pull:IsHidden() 		  return false end
function modifier_strom_vortex_ball_pull:IsPurgable() 	  return false end
function modifier_strom_vortex_ball_pull:IsPurgeException() return true end
function modifier_strom_vortex_ball_pull:IsDebuff() 		  return true end
function modifier_strom_vortex_ball_pull:IsStunDebuff() 	  return true end
function modifier_strom_vortex_ball_pull:IsMotionController() return true end
function modifier_strom_vortex_ball_pull:GetMotionControllerPriority() return DOTA_MOTION_CONTROLLER_PRIORITY_LOW end

function modifier_strom_vortex_ball_pull:OnCreated( params )
	if IsServer() then
		-- Ability properties
		local parent	=	self:GetParent()
		local vortex_particle	=	"particles/units/heroes/hero_stormspirit/stormspirit_electric_vortex.vpcf"

		self.vortex_loc	=	self:GetCaster():GetAbsOrigin()
		-- Apply vortex particle on location
		self.vortex_particle_fx = ParticleManager:CreateParticle(vortex_particle, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
--		ParticleManager:SetParticleControl(self.vortex_particle_fx, 0, self:GetCaster():GetAbsOrigin())
		-- Apply vortex particle on target
		ParticleManager:SetParticleControlEnt(self.vortex_particle_fx, 1, parent, PATTACH_POINT_FOLLOW, "attach_hitloc", parent:GetAbsOrigin(), true)

		-- Motion controller (moves the target)
		self.speed = params.speed * FrameTime()

		--7.21d version (fixed distance instead of fixed speed)
		self.electric_vortex_pull_distance	= params.electric_vortex_pull_distance
		self.speed							= (self.electric_vortex_pull_distance / self:GetDuration()) * FrameTime()

		self:StartIntervalThink(FrameTime())
	end
end

function modifier_strom_vortex_ball_pull:OnRefresh()
	if not IsServer() then return end

	-- Custom Status Resist nonsense (need to learn how to make an all-encompassing function for this...)
	self:SetDuration(self:GetDuration() * (1 - self:GetParent():GetStatusResistance()), true)
end

function modifier_strom_vortex_ball_pull:OnIntervalThink()
	-- Check for motion controllers
	if not self:CheckMotionControllers() then
		return nil
	end

	-- Horizontal motion
	self:HorizontalMotion(self:GetParent(), FrameTime())
end

function modifier_strom_vortex_ball_pull:OnDestroy()
	if IsServer() then
		-- Find a clear space to stand on
		self:GetCaster():SetUnitOnClearGround()
	end
end

function modifier_strom_vortex_ball_pull:GetMotionControllerPriority()
	return DOTA_MOTION_CONTROLLER_PRIORITY_MEDIUM
end

function modifier_strom_vortex_ball_pull:CheckState()
	local state =
	{
		[MODIFIER_STATE_STUNNED] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true
	}
	return state
end

function modifier_strom_vortex_ball_pull:HorizontalMotion( unit, time )
	if IsServer() then

		-- Move the target
		local set_point = unit:GetAbsOrigin() + (self:GetCaster():GetAbsOrigin() - unit:GetAbsOrigin()):Normalized() * self.speed
		-- Stop moving when the vortex has been reached
--		if (unit:GetAbsOrigin() - self.vortex_loc):Length2D() > 50 then
		unit:SetAbsOrigin(Vector(set_point.x, set_point.y, GetGroundPosition(set_point, unit).z))
--		end
	end
end


function modifier_strom_vortex_ball_pull:DeclareFunctions()
	local decFuncs =
	{
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
	}
	return decFuncs
end

function modifier_strom_vortex_ball_pull:GetOverrideAnimation()
	return ACT_DOTA_FLAIL
end

function modifier_strom_vortex_ball_pull:OnDestroy()
	if IsServer() then
		-- Remove the vortex particle
		ParticleManager:DestroyParticle(self.vortex_particle_fx, false)
		ParticleManager:ReleaseParticleIndex(self.vortex_particle_fx)
		-- Stop making that noise
		StopSoundOn("Hero_StormSpirit.ElectricVortex",self:GetParent())

		-- Find a clear space to stand on
		self:GetParent():SetUnitOnClearGround()
	end
end

--- PULL MODIFIER (root only)
modifier_strom_vortex_ball_root = modifier_strom_vortex_ball_root or class({})

-- Modifier properties
function modifier_strom_vortex_ball_root:IsHidden() 		  return true end
function modifier_strom_vortex_ball_root:IsPurgable() 	  return false end
function modifier_strom_vortex_ball_root:IsPurgeException() return true end
function modifier_strom_vortex_ball_root:IsDebuff() 		  return true end
function modifier_strom_vortex_ball_root:IsStunDebuff() 	  return true end
function modifier_strom_vortex_ball_root:IsMotionController() return true end
function modifier_strom_vortex_ball_root:GetMotionControllerPriority() return DOTA_MOTION_CONTROLLER_PRIORITY_LOW end

function modifier_strom_vortex_ball_root:OnCreated( params )
	if IsServer() then
		-- Ability properties
		local vortex_particle = "particles/units/heroes/hero_stormspirit/stormspirit_electric_vortex_root.vpcf"

--		print(params.pos_x, params.pos_y, params.pos_z)
		self.vortex_loc	= Vector(params.pos_x, params.pos_y, params.pos_z)
--		print(self.vortex_loc)
		-- Apply vortex particle on location
		self.vortex_particle_fx = ParticleManager:CreateParticle(vortex_particle, PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
--		ParticleManager:SetParticleControl(self.vortex_particle_fx, 0, self.vortex_loc)
		-- Apply vortex particle on target
		ParticleManager:SetParticleControlEnt(self.vortex_particle_fx, 1, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self.vortex_loc, true)

		-- Motion controller (moves the target)
		self.speed = params.speed * FrameTime()

		--7.21d version (fixed distance instead of fixed speed)
		self.electric_vortex_pull_distance	= params.electric_vortex_pull_distance
		self.speed							= (self.electric_vortex_pull_distance / self:GetDuration()) * FrameTime()

		self:StartIntervalThink(FrameTime())
		
		-- Weird stuff with this not being affected by status resist so I'm forcing it here
		Timers:CreateTimer(FrameTime(), function()
			self:SetDuration(self:GetDuration() * (1 - self:GetParent():GetStatusResistance()), true)
		end)
	end
end

function modifier_strom_vortex_ball_root:OnRefresh()
	if not IsServer() then return end

	-- Custom Status Resist nonsense (need to learn how to make an all-encompassing function for this...)
	self:SetDuration(self:GetDuration() * (1 - self:GetParent():GetStatusResistance()), true)
end

function modifier_strom_vortex_ball_root:OnIntervalThink()
	-- Check for motion controllers
	if not self:CheckMotionControllers() then
		return nil
	end

	-- Horizontal motion
	self:HorizontalMotion(self:GetParent(), FrameTime())
end

function modifier_strom_vortex_ball_root:OnDestroy()
	if IsServer() then
		-- Find a clear space to stand on
		self:GetCaster():SetUnitOnClearGround()
	end
end

function modifier_strom_vortex_ball_root:GetMotionControllerPriority()
	return DOTA_MOTION_CONTROLLER_PRIORITY_MEDIUM
end

function modifier_strom_vortex_ball_root:CheckState()
	local state =
	{
		[MODIFIER_STATE_ROOTED] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true
	}
	return state
end

function modifier_strom_vortex_ball_root:HorizontalMotion( unit, time )
	if IsServer() then
		-- Move the target
		local set_point = unit:GetAbsOrigin() + (self.vortex_loc - unit:GetAbsOrigin()):Normalized() * self.speed
		-- Stop moving when the vortex has been reached
--		if (unit:GetAbsOrigin() - self.vortex_loc):Length2D() > 50 then
		unit:SetAbsOrigin(Vector(set_point.x, set_point.y, GetGroundPosition(set_point, unit).z))
--		end
	end
end


function modifier_strom_vortex_ball_root:DeclareFunctions()
	local decFuncs =
	{
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
	}
	return decFuncs
end

function modifier_strom_vortex_ball_root:GetOverrideAnimation()
	return ACT_DOTA_FLAIL
end

function modifier_strom_vortex_ball_root:OnDestroy()
	if IsServer() then
		-- Remove the vortex particle
		ParticleManager:DestroyParticle(self.vortex_particle_fx, false)
		ParticleManager:ReleaseParticleIndex(self.vortex_particle_fx)
		-- Stop making that noise
		StopSoundOn("Hero_StormSpirit.ElectricVortex", self:GetParent())

		-- Find a clear space to stand on
		self:GetParent():SetUnitOnClearGround()
	end
end
