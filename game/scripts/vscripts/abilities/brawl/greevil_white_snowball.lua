greevil_white_snowball = class({})

LinkLuaModifier("modifier_greevil_white_snowball", "abilities/greevil_white_snowball", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_greevil_white_snowball_debuff", "abilities/greevil_white_snowball", LUA_MODIFIER_MOTION_NONE)

function greevil_white_snowball:GetAbilityTextureName()
	return "greevil_white_snowball"
end

function greevil_white_snowball:GetCastAnimation()
	return ACT_DOTA_CAST_ABILITY_1
end

function greevil_white_snowball:OnSpellStart()
	local distance = self:GetSpecialValueFor("distance")
	local speed = self:GetSpecialValueFor("speed")
	local radius = self:GetSpecialValueFor("radius")
	local travel_time = distance / speed
	local direction = self:GetCursorPosition() - self:GetCaster():GetOrigin()
	direction.z = 0.0
	direction = direction:Normalized()

	ProjectileManager:CreateLinearProjectile({
		Ability = self,
		EffectName = "",
		vSpawnOrigin = self:GetCaster():GetOrigin(),
		fDistance = distance,
		fStartRadius = radius,
		fEndRadius = radius,
		Source = self:GetCaster(),
		bHasFrontalCone = false,
		bReplaceExisting = false,
		iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
		iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
		iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		bDeleteOnHit = false,
		vVelocity = direction * speed,
		bProvidesVision = false,
		iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_HITLOCATION
	})

	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_greevil_white_snowball", {duration = travel_time})

	self:GetCaster():EmitSound("Greevil.Snowball.Spin")
end

function greevil_white_snowball:OnProjectileThink(vLocation)
	if self:GetCaster():HasModifier("modifier_greevil_white_snowball") then
		self:GetCaster():SetOrigin(Vector(vLocation.x, vLocation.y, GetGroundHeight(vLocation, self:GetCaster())))
		self:GetCaster():StartGesture(ACT_DOTA_CHANNEL_ABILITY_1)
		GridNav:DestroyTreesAroundPoint(vLocation, self:GetSpecialValueFor("radius"), false)
	end
end

function greevil_white_snowball:OnProjectileHit(hTarget, vLocation)
	if hTarget ~= nil and not hTarget:IsInvulnerable() then
		local damage = self:GetSpecialValueFor("damage")
		local gameTime = math.min(math.floor(GameRules:GetDOTATime(false, false)/60), GREEVIL_BUFF_TIME_LIMIT)
		damage = damage + self:GetSpecialValueFor("damage_per_minute") * gameTime

		ApplyDamage({
			victim = hTarget,
			attacker = self:GetCaster(),
			damage = damage,
			damage_type = self:GetAbilityDamageType(),
			ability = self
		})

		hTarget:AddNewModifier(self:GetCaster(), self, "modifier_greevil_white_snowball_debuff", {duration = self:GetSpecialValueFor("slow_duration")})
		hTarget:AddNewModifier(self:GetCaster(), self, "modifier_stunned", {duration = self:GetSpecialValueFor("stun_duration")})

		EmitSoundOn("Greevil.Snowball.Hit", hTarget)
	end
end

modifier_greevil_white_snowball = class({
	IsPurgable = function() return false end,
})

function modifier_greevil_white_snowball:CheckState()
	return {
		[MODIFIER_STATE_UNSELECTABLE] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_STUNNED] = true,
	}
end

function modifier_greevil_white_snowball:DeclareFunctions() 
	return {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION
	}
end

function modifier_greevil_white_snowball:GetOverrideAnimation()
	return ACT_DOTA_CHANNEL_ABILITY_1
end

if IsServer() then
	function modifier_greevil_white_snowball:OnCreated(kv)
		local nFXIndex = ParticleManager:CreateParticle("particles/greevils/greevil_white/greevil_white_spin.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		ParticleManager:SetParticleControlEnt(nFXIndex, 0, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self:GetParent():GetOrigin(), true)
		ParticleManager:SetParticleControlEnt(nFXIndex, 3, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self:GetParent():GetOrigin(), true)
		self:AddParticle(nFXIndex, false, false, -1, false, false)
	end
	function modifier_greevil_white_snowball:OnDestroy()
		FindClearSpaceForUnit(self:GetParent(), self:GetParent():GetOrigin(), true)
		self:GetParent():FadeGesture(ACT_DOTA_CHANNEL_ABILITY_1)
		self:GetParent():StopSound("Greevil.Snowball.Spin")
	end
end

modifier_greevil_white_snowball_debuff = class({
	IsPurgable = function() return false end,
})

function modifier_greevil_white_snowball_debuff:DeclareFunctions() 
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
	}
end

function modifier_greevil_white_snowball_debuff:GetModifierMoveSpeedBonus_Percentage()
	return -self:GetAbility():GetSpecialValueFor("speed_slow")
end