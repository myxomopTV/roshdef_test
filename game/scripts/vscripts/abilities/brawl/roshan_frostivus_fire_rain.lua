roshan_frostivus_fire_rain = class({})

function roshan_frostivus_fire_rain:GetAbilityTextureName()
	return "roshan_frostivus_fire_rain"
end

function roshan_frostivus_fire_rain:GetCastAnimation()
	return ACT_DOTA_CAST_ABILITY_4
end

function roshan_frostivus_fire_rain:GetChannelAnimation()
	return ACT_DOTA_CAST_ABILITY_4
end

function roshan_frostivus_fire_rain:OnSpellStart()
	self.damage = self:GetAbilityDamage()
	self.radius = self:GetSpecialValueFor("radius")
	self.count = self:GetSpecialValueFor("count")
	self.fireball_rate = self:GetSpecialValueFor("fireball_rate")

	self.accumulatedTime = 0.0
	self.fireballTarget = self:GetCaster():GetOrigin() + RandomVector(self.radius)
	self.direction = self.fireballTarget - self:GetCaster():GetOrigin() 
	self.fireballsCount = 0

	local direction = self.fireballTarget - self:GetCaster():GetOrigin()
	direction.z = 0.0
	direction = direction:Normalized()
	
	self:LaunchFireball(direction)
end

function roshan_frostivus_fire_rain:OnChannelThink(flInterval)
	self.accumulatedTime = self.accumulatedTime + flInterval 
	if self.accumulatedTime >= self.fireball_rate then
		self.accumulatedTime = self.accumulatedTime - self.fireball_rate

		self.fireballTarget = self:GetCaster():GetOrigin() + RandomVector(self.radius)

		local direction = self.fireballTarget - self:GetCaster():GetOrigin()
		direction.z = 0.0
		direction = direction:Normalized()

		self:LaunchFireball(direction)
	end
end

function roshan_frostivus_fire_rain:LaunchFireball(vDirection)
	self.fireballsCount = self.fireballsCount + 1

	local distance = (self.fireballTarget-self:GetCaster():GetOrigin()):Length2D()
	local flyTime = distance / 900
	local explodeOrigin = self.fireballTarget

	EmitSoundOn("Greevil.FireBall.Launch", self)

	local attach = self:GetCaster():ScriptLookupAttachment("attach_mouth")
	local location = self:GetCaster():GetAttachmentOrigin(attach)

	-- local FireballPFX = ParticleManager:CreateParticle("particles/untitled_particle_1.vpcf", PATTACH_POINT, self:GetCaster())
	-- ParticleManager:SetParticleControlEnt(FireballPFX, 0, self:GetCaster(), PATTACH_POINT, "attach_mouth", self:GetCaster():GetOrigin(), true)
	-- ParticleManager:SetParticleControl(FireballPFX, 1, self.fireballTarget)
	-- --ParticleManager:SetParticleControl(FireballPFX, 3, self.fireballTarget)
	-- ParticleManager:SetParticleControl(FireballPFX, 4, Vector(flyTime, 0, 0))
	-- ParticleManager:ReleaseParticleIndex(FireballPFX)

	-- local attach = self:GetCaster():ScriptLookupAttachment("attach_mouth")
	-- local location = self:GetCaster():GetAttachmentOrigin(attach)
	-- ProjectileManager:CreateLinearProjectile({
	-- 	Ability				= self,
	-- 	EffectName			= "particles/generic_gameplay/roshan_frostivus/roshan_frostivus_fire_rain.vpcf",
	-- 	vSpawnOrigin		= location,
	-- 	fDistance			= distance,
	-- 	fStartRadius		= 0,
	-- 	fEndRadius			= 0,
	-- 	Source				= self:GetCaster(),
	-- 	bHasFrontalCone		= false,
	-- 	bReplaceExisting	= false,
	-- 	iUnitTargetTeam		= DOTA_UNIT_TARGET_TEAM_NONE,
	-- 	iUnitTargetFlags	= DOTA_UNIT_TARGET_FLAG_NONE,
	-- 	iUnitTargetType		= DOTA_UNIT_TARGET_NONE,
	-- 	bDeleteOnHit		= false,
	-- 	vVelocity			= vDirection * 900,
	-- 	bProvidesVision		= false,
	-- 	iVisionRadius		= 0,
	-- 	iVisionTeamNumber	= self:GetCaster():GetTeamNumber(),
	-- 	iMoveSpeed			= 900
	-- })

	local thinker = CreateUnitByName("npc_dummy_unit", self.fireballTarget, false, self:GetCaster(), self:GetCaster(), self:GetCaster():GetTeamNumber())
	FindClearSpaceForUnit(thinker, thinker:GetAbsOrigin(), true)

	ProjectileManager:CreateTrackingProjectile({
		Ability = self,
		Target = thinker,
		Source = self:GetCaster(),
		EffectName = "particles/generic_gameplay/roshan_frostivus/roshan_frostivus_fire_rain.vpcf",
		iMoveSpeed = 900,
		bDodgeable = false,
		bProvidesVision = true,
		iVisionRadius = 400,
		iVisionTeamNumber = self:GetCaster():GetTeamNumber(),
		iSourceAttachment = self:GetCaster():ScriptLookupAttachment("attach_mouth")
	})

	-- Timers:CreateTimer(flyTime, function()
	-- 	EmitSoundOnLocationWithCaster(explodeOrigin, "Greevil.FireBall.Impact", self:GetCaster())
		
	-- 	local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), explodeOrigin, nil, 300, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	-- 	for _,enemy in pairs(enemies) do
	-- 		ApplyDamage({
	-- 			victim = enemy,
	-- 			attacker = self:GetCaster(),
	-- 			damage = self.damage,
	-- 			damage_type = self:GetAbilityDamageType(),
	-- 			ability = self
	-- 		})
	-- 	end

	-- 	-- ParticleManager:DestroyParticle(FireballPFX, true)
	-- 	-- ParticleManager:ReleaseParticleIndex(FireballPFX)
	-- end)

	if self.fireballsCount >= self.count then
		self:EndChannel(false)
	end
end

function roshan_frostivus_fire_rain:OnProjectileHit(hTarget, vLocation)
	if hTarget ~= nil then
		EmitSoundOnLocationWithCaster(hTarget:GetOrigin(), "Greevil.FireBall.Impact", self:GetCaster())
		
		local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), hTarget:GetOrigin(), nil, 300, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		for _,enemy in pairs(enemies) do
			ApplyDamage({
				victim = enemy,
				attacker = self:GetCaster(),
				damage = self.damage,
				damage_type = self:GetAbilityDamageType(),
				ability = self
			})
		end

		hTarget:Destroy()
	end
end