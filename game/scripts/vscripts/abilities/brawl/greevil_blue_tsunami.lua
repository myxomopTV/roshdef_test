greevil_blue_tsunami = class({})

function greevil_blue_tsunami:GetAbilityTextureName()
	return "greevil_blue_tsunami"
end

function greevil_blue_tsunami:GetCastAnimation()
	return ACT_DOTA_CAST_ABILITY_1
end

function greevil_blue_tsunami:GetChannelAnimation()
	return ACT_DOTA_CHANNEL_ABILITY_1
end

function greevil_blue_tsunami:OnSpellStart()
	self.damage = self:GetSpecialValueFor("damage")
	self.radius = self:GetSpecialValueFor("radius")
	self.tick_interval = 0.4
	self.range = self:GetSpecialValueFor("range")
	self.count = math.floor(self:GetChannelTime() / self.tick_interval)
	local gameTime = math.min(math.floor(GameRules:GetDOTATime(false, false)/60), GREEVIL_BUFF_TIME_LIMIT)
	self.damage = self.damage + self:GetSpecialValueFor("damage_per_minute") * gameTime

	self.target = self:GetCursorTarget()
	self.accumulatedTime = 0.0
	self.tsunamiesLaunched = 0

	local direction = self.target:GetOrigin() - self:GetCaster():GetOrigin()
	direction.z = 0.0
	direction = direction:Normalized()
	
	self:LaunchTsunami(direction)
end

function greevil_blue_tsunami:OnChannelThink(flInterval)
	self.accumulatedTime = self.accumulatedTime + flInterval 
	if self.accumulatedTime >= self.tick_interval then
		self.accumulatedTime = self.accumulatedTime - self.tick_interval

		local direction = self.target:GetOrigin() - self:GetCaster():GetOrigin()
		direction.z = 0.0
		direction = direction:Normalized()

		self:LaunchTsunami(direction)
	end
end

function greevil_blue_tsunami:OnProjectileHit(hTarget, vLocation)
	if hTarget ~= nil and not hTarget:IsInvulnerable() then
		ApplyDamage({
			victim = hTarget,
			attacker = self:GetCaster(),
			damage = self.damage,
			damage_type = self:GetAbilityDamageType(),
			ability = self
		})
		local direction = hTarget:GetOrigin() + (hTarget:GetOrigin() - self:GetCaster():GetOrigin()):Normalized() * -50
		hTarget:RemoveModifierByName("modifier_knockback")
		hTarget:AddNewModifier(self:GetCaster(), self, "modifier_knockback", {
			should_stun = 0,
			knockback_duration = 0.1,
			duration = 0.1,
			knockback_distance = 25,
			knockback_height = 15,
			center_x = direction.x,
			center_y = direction.y,
			center_z = direction.z
		})

		EmitSoundOn("Greevil.Tsunami.Hit", hTarget)
	end
end

function greevil_blue_tsunami:LaunchTsunami(vDirection)
	self.tsunamiesLaunched = self.tsunamiesLaunched + 1

	ProjectileManager:CreateLinearProjectile({
		Ability = self,
		EffectName = "particles/greevils/greevil_blue/greevil_blue_tsunami.vpcf",
		vSpawnOrigin = self:GetCaster():GetOrigin(),
		fDistance = self.range,
		fStartRadius = self.radius,
		fEndRadius = self.radius,
		Source = self:GetCaster(),
		bHasFrontalCone = false,
		bReplaceExisting = false,
		iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
		iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
		iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		bDeleteOnHit = false,
		vVelocity = vDirection * 1200,
		bProvidesVision = false,
		iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_1
	})

	EmitSoundOn("Greevil.Tsunami.Cast", self:GetCaster())

	if self.tsunamiesLaunched >= self.count then
		self:EndChannel(false)
	end
end