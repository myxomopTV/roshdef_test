roshan_frostivus_fire_breath = class({})

function roshan_frostivus_fire_breath:GetAbilityTextureName()
	return "roshan_frostivus_fire_breath"
end

function roshan_frostivus_fire_breath:GetCastAnimation()
	return ACT_DOTA_CAST_ABILITY_2
end

function roshan_frostivus_fire_breath:OnAbilityPhaseStart()
	self:GetCaster():EmitSound("RoshanFrost.FireBreath1")
	return true
end

function roshan_frostivus_fire_breath:OnAbilityPhaseInterrupted()
	self:GetCaster():StopSound("RoshanFrost.FireBreath1")
end

function roshan_frostivus_fire_breath:OnSpellStart()
	self.angle = -45
	self.projectile_count = self:GetSpecialValueFor("projectile_count")
	self.tick_interval = 0.125
	self.accumulatedTime = 0.0
	self.current_projectiles = 0
	self.distance = 900
	self.radius = self:GetSpecialValueFor("radius")

	self:GetCaster():EmitSound("RoshanFrost.FireBreath2")
end

function roshan_frostivus_fire_breath:OnChannelThink(flInterval)
	self.accumulatedTime = self.accumulatedTime + flInterval 
	if self.accumulatedTime >= self.tick_interval then
		self.accumulatedTime = self.accumulatedTime - self.tick_interval

		self:BreatheFire()
	end
end

function roshan_frostivus_fire_breath:BreatheFire()
	if self.current_projectiles <= self.projectile_count then
		local attach = self:GetCaster():ScriptLookupAttachment("attach_mouth")
		local location = self:GetCaster():GetAttachmentOrigin(attach)
		local velocity = RotatePosition(Vector(0,0,0), QAngle(0,self.angle,0), Vector(self:GetCaster():GetForwardVector().x, self:GetCaster():GetForwardVector().y, 0))
		ProjectileManager:CreateLinearProjectile({
			Ability				= self,
			EffectName			= "particles/generic_gameplay/roshan_frostivus/roshan_frostivus_fire_breathe.vpcf",
			vSpawnOrigin		= location,
			fDistance			= self.distance,
			fStartRadius		= self.radius,
			fEndRadius			= self.radius,
			Source				= self:GetCaster(),
			bHasFrontalCone		= false,
			bReplaceExisting	= false,
			iUnitTargetTeam		= DOTA_UNIT_TARGET_TEAM_ENEMY,
			iUnitTargetFlags	= DOTA_UNIT_TARGET_FLAG_NONE,
			iUnitTargetType		= DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			bDeleteOnHit		= false,
			vVelocity			= velocity * 1000,
			bProvidesVision		= false,
			iVisionRadius		= 0,
			iVisionTeamNumber	= self:GetCaster():GetTeamNumber(),
			iMoveSpeed			= 1000
		})
		self.angle = self.angle + (90/(self.projectile_count-2))

		self.current_projectiles = self.current_projectiles + 1
	end
end

function roshan_frostivus_fire_breath:OnProjectileHit(hTarget, vLocation)
	if hTarget ~= nil and not hTarget:IsInvulnerable() then
		ApplyDamage({
			victim = hTarget,
			attacker = self:GetCaster(),
			damage = self:GetAbilityDamage(),
			damage_type = self:GetAbilityDamageType(),
			ability = self
		})
	end
end