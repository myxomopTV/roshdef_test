roshan_frostivus_slam = class({})

function roshan_frostivus_slam:GetAbilityTextureName()
	return "roshan_frostivus_slam"
end

function roshan_frostivus_slam:GetCastAnimation()
	return ACT_DOTA_CAST_ABILITY_1
end

function roshan_frostivus_slam:OnAbilityPhaseStart()
	self:GetCaster():EmitSound("RoshanFrost.WaveOfForce.Start")
	return true
end

function roshan_frostivus_slam:OnAbilityPhaseInterrupted()
	self:GetCaster():StopSound("RoshanFrost.WaveOfForce.Start")
end

function roshan_frostivus_slam:OnSpellStart()
	self.radius = self:GetSpecialValueFor("radius")
	local waveRadius = self:GetSpecialValueFor("wave_radius")
	local waveSpeed = self:GetSpecialValueFor("wave_speed")
	local waves = self:GetSpecialValueFor("waves")
	local angleStep = 360 / waves
	self.hitTarget = {}

	self:GetCaster():EmitSound("RoshanFrost.Slam")
	self:GetCaster():EmitSound("RoshanFrost.WaveOfForce.Cast")

	local slamCastPFX = ParticleManager:CreateParticle("particles/neutral_fx/roshan_slam.vpcf", PATTACH_ABSORIGIN, self:GetCaster())
	ParticleManager:SetParticleControl(slamCastPFX, 0, self:GetCaster():GetOrigin() + Vector(0, 0, 50))
	ParticleManager:SetParticleControl(slamCastPFX, 1, Vector(self.radius, self.radius, self.radius))
	ParticleManager:ReleaseParticleIndex(slamCastPFX)

	for i = 1, waves do
		local velocity = RotatePosition(Vector(0,0,0), QAngle(0,angleStep*i,0), Vector(self:GetCaster():GetForwardVector().x, self:GetCaster():GetForwardVector().y, 0))
		ProjectileManager:CreateLinearProjectile({
			Ability				= self,
			EffectName			= "particles/generic_gameplay/roshan_frostivus/roshan_frostivus_hugeslam.vpcf",
			vSpawnOrigin		= self:GetCaster():GetOrigin() + Vector(0, 0, 50),
			fDistance			= self.radius,
			fStartRadius		= waveRadius,
			fEndRadius			= waveRadius,
			Source				= self:GetCaster(),
			bHasFrontalCone		= false,
			bReplaceExisting	= false,
			iUnitTargetTeam		= DOTA_UNIT_TARGET_TEAM_ENEMY,
			iUnitTargetFlags	= DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
			iUnitTargetType		= DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			bDeleteOnHit		= false,
			vVelocity			= velocity * waveSpeed,
			bProvidesVision		= false,
			iVisionRadius		= 0,
			iVisionTeamNumber	= self:GetCaster():GetTeamNumber(),
			iMoveSpeed			= waveSpeed
		})
	end

	local traps = Entities:FindAllByClassnameWithin("npc_dota_creep_neutral", self:GetCaster():GetOrigin(), self.radius*2)
	for _,trap in pairs(traps) do
		if trap ~= nil and trap:GetUnitName() == "npc_gaser_trap" then
			local gaserTrapAbility = trap:FindAbilityByName("gaser_trap")
			if gaserTrapAbility ~= nil then
				local hitHeroes = FindUnitsInRadius(trap:GetTeamNumber(), trap:GetOrigin(), nil, 150, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
				for _,hitHero in pairs(hitHeroes) do
					hitHero:AddNewModifier(self:GetCaster(), gaserTrapAbility, "modifier_gaser_trap_debuff", {duration = 1.6})
				end

				local splashFX = ParticleManager:CreateParticle("particles/ice_gaser_trap.vpcf", PATTACH_WORLDORIGIN, nil)
				ParticleManager:SetParticleControl(splashFX, 0, trap:GetOrigin())
				ParticleManager:ReleaseParticleIndex(splashFX)

				EmitSoundOnLocationWithCaster(trap:GetOrigin(), "IceGaserTrap.Release", trap)
			end
		end
	end
end

function roshan_frostivus_slam:OnProjectileHit(hTarget, vLocation)
	if hTarget ~= nil and not hTarget:IsInvulnerable() and not table.contains(self.hitTarget, hTarget) then
		table.insert(self.hitTarget, hTarget)
		
		ApplyDamage({
			victim = hTarget,
			attacker = self:GetCaster(),
			damage = self:GetAbilityDamage(),
			damage_type = self:GetAbilityDamageType(),
			ability = self
		})

		local knockbackPos = self:GetCaster():GetOrigin() + (hTarget:GetOrigin() - self:GetCaster():GetOrigin()):Normalized() * self.radius
		local knockbackDistance = (knockbackPos - hTarget:GetOrigin()):Length2D()
		local knockbackSpeed = self:GetSpecialValueFor("knockback_speed")

		hTarget:RemoveModifierByName("modifier_knockback")
		hTarget:AddNewModifier(caster, ability, "modifier_knockback", {
			should_stun = 1,
			knockback_duration = knockbackDistance / knockbackSpeed,
			duration = knockbackDistance / knockbackSpeed,
			knockback_distance = knockbackDistance,
			knockback_height = 0,
			center_x = self:GetCaster():GetOrigin().x,
			center_y = self:GetCaster():GetOrigin().y,
			center_z = self:GetCaster():GetOrigin().z
		})
	end
end