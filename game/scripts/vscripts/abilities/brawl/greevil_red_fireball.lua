greevil_red_fireball = class({})

function greevil_red_fireball:GetAbilityTextureName()
	return "greevil_red_fireball"
end

function greevil_red_fireball:GetCastAnimation()
	return ACT_DOTA_CAST_ABILITY_2
end

function greevil_red_fireball:GetChannelAnimation()
	return ACT_DOTA_CHANNEL_ABILITY_2
end

function greevil_red_fireball:OnSpellStart()
	self.radius = 150
	self.damage = self:GetSpecialValueFor("damage")
	self.count = self:GetSpecialValueFor("count")
	self.fireball_rate = self:GetSpecialValueFor("fireball_rate")
	local gameTime = math.min(math.floor(GameRules:GetDOTATime(false, false)/60), GREEVIL_BUFF_TIME_LIMIT)
	self.damage = self.damage + self:GetSpecialValueFor("damage_per_minute") * gameTime

	self.targetLocation = self:GetCursorTarget()
	self.accumulatedTime = 0.0
	self.direction = self.targetLocation:GetOrigin() - self:GetCaster():GetOrigin() 
	self.fireballsCount = 0
	self.fireballTarget = RandomRadius(self.targetLocation:GetOrigin(), self.radius)

	local direction = self.fireballTarget - self:GetCaster():GetOrigin()
	direction.z = 0.0
	direction = direction:Normalized()
	
	self:LaunchFireball(direction)
end

function greevil_red_fireball:OnChannelThink(flInterval)
	self.accumulatedTime = self.accumulatedTime + flInterval 
	if self.accumulatedTime >= self.fireball_rate then
		self.accumulatedTime = self.accumulatedTime - self.fireball_rate

		self.fireballTarget = RandomRadius(self.targetLocation:GetOrigin(), self.radius)

		local direction = self.fireballTarget - self:GetCaster():GetOrigin()
		direction.z = 0.0
		direction = direction:Normalized()

		self:LaunchFireball(direction)
	end
end

function greevil_red_fireball:LaunchFireball(vDirection)
	self.fireballsCount = self.fireballsCount + 1

	local distance = (self.fireballTarget-self:GetCaster():GetOrigin()):Length2D()
	local flyTime = distance / 900
	local explodeOrigin = self.fireballTarget

	EmitSoundOn("Greevil.FireBall.Launch", self)

	ProjectileManager:CreateLinearProjectile({
		Ability = self,
		EffectName = "particles/greevils/greevil_red/greevil_red_fireball.vpcf",
		vSpawnOrigin = self:GetCaster():GetOrigin() + Vector(0, 0, 150),
		fDistance = distance,
		fStartRadius = 0,
		fEndRadius = 0,
		Source = self:GetCaster(),
		bHasFrontalCone = false,
		bReplaceExisting = false,
		iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
		iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
		iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		bDeleteOnHit = false,
		vVelocity = vDirection * 900,
		bProvidesVision = false,
		iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_1
	})

	Timers:CreateTimer(flyTime, function()
		EmitSoundOnLocationWithCaster(explodeOrigin, "Greevil.FireBall.Impact", self:GetCaster())
		
		local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), explodeOrigin, nil, 150, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		for _,enemy in pairs(enemies) do
			ApplyDamage({
				victim = enemy,
				attacker = self:GetCaster(),
				damage = self.damage,
				damage_type = self:GetAbilityDamageType(),
				ability = self
			})
		end
	end)

	if self.fireballsCount >= self.count then
		self:EndChannel(false)
	end
end