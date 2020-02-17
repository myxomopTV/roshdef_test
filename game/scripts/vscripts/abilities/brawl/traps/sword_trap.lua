sword_trap = class({})

LinkLuaModifier("modifier_sword_trap", "abilities/traps/sword_trap", LUA_MODIFIER_MOTION_NONE)

function sword_trap:GetIntrinsicModifierName()
	return "modifier_sword_trap"
end

function sword_trap:OnSpellStart()
	ProjectileManager:CreateLinearProjectile({
		Ability				= self,
		EffectName			= "",
		vSpawnOrigin		= self:GetCaster():GetOrigin(),
		fDistance			= 316,
		fStartRadius		= 30,
		fEndRadius			= 30,
		Source				= self:GetCaster(),
		bHasFrontalCone		= false,
		bReplaceExisting	= false,
		iUnitTargetTeam		= DOTA_UNIT_TARGET_TEAM_ENEMY,
		iUnitTargetFlags	= DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
		iUnitTargetType		= DOTA_UNIT_TARGET_HERO,
		bDeleteOnHit		= false,
		vVelocity			= self:GetCaster():GetForwardVector() * 2000,
		bProvidesVision 	= false,
		iSourceAttachment 	= DOTA_PROJECTILE_ATTACHMENT_HITLOCATION
	})

	self:GetCaster():StartGesture(ACT_DOTA_ATTACK)
end

function sword_trap:OnProjectileHit(target, location)
	if target ~= nil then
		ApplyDamage({
			victim = target,
			attacker = self:GetCaster(),
			damage = 75,
			damage_type = DAMAGE_TYPE_PURE,
			ability = self
		})
		target:AddNewModifier(self:GetCaster(), self, "modifier_bashed", {duration = 0.05})
		local hitPFX = ParticleManager:CreateParticle("particles/traps/sword_trap/sword_trap_hit.vpcf", PATTACH_ABSORIGIN, target)
		ParticleManager:SetParticleControl(hitPFX, 0, target:GetOrigin())
		ParticleManager:SetParticleControl(hitPFX, 1, self:GetCaster():GetOrigin())
		ParticleManager:SetParticleControl(hitPFX, 3, self:GetCaster():GetOrigin())
		ParticleManager:ReleaseParticleIndex(hitPFX)
		EmitSoundOn("SwordTrap.Hit", self:GetCaster())
		EmitSoundOn("SwordTrap.Hit.Blood", target)
	end
end

modifier_sword_trap = class({
	IsPurgable = function() return false end,
	IsHidden = function() return true end,
})

function modifier_sword_trap:CheckState()
	return {
		[MODIFIER_STATE_UNSELECTABLE] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_NOT_ON_MINIMAP] = true,
		[MODIFIER_STATE_PROVIDES_VISION] = false,
		[MODIFIER_STATE_ROOTED] = true,
		[MODIFIER_STATE_DISARMED] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_LOW_ATTACK_PRIORITY] = true,
		[MODIFIER_STATE_BLOCK_DISABLED] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_FLYING] = true,
		[MODIFIER_STATE_OUT_OF_GAME] = true,
		[MODIFIER_STATE_BLIND] = true
	}
end