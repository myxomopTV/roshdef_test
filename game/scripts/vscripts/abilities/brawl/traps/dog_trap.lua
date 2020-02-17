dog_trap = class({})

LinkLuaModifier("modifier_dog_trap", "abilities/traps/dog_trap", LUA_MODIFIER_MOTION_NONE)

function dog_trap:GetIntrinsicModifierName()
	return "modifier_dog_trap"
end

function dog_trap:OnSpellStart()
	ProjectileManager:CreateLinearProjectile({
		Ability				= self,
		EffectName			= "particles/fire_trap/trap_breathe_fire.vpcf",
		vSpawnOrigin		= self:GetCaster():GetOrigin() + self:GetCaster():GetForwardVector() * 100,
		fDistance			= 1000,
		fStartRadius		= 100,
		fEndRadius			= 100,
		Source				= self:GetCaster(),
		bHasFrontalCone		= false,
		bReplaceExisting	= false,
		iUnitTargetTeam		= DOTA_UNIT_TARGET_TEAM_ENEMY,
		iUnitTargetFlags	= DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
		iUnitTargetType		= DOTA_UNIT_TARGET_HERO,
		bDeleteOnHit		= false,
		vVelocity			= self:GetCaster():GetForwardVector() * 1000,
		bProvidesVision 	= false,
		iSourceAttachment 	= DOTA_PROJECTILE_ATTACHMENT_HITLOCATION
	})

	self:GetCaster():StartGesture(ACT_DOTA_ATTACK)
end

function dog_trap:OnProjectileHit(target, location)
	if target ~= nil then
		ApplyDamage({
			victim = target,
			attacker = self:GetCaster(),
			damage = target:GetMaxHealth() * 0.25,
			damage_type = DAMAGE_TYPE_PURE,
			ability = self
		})
	end
end

modifier_dog_trap = class({
	IsPurgable = function() return false end,
	IsHidden = function() return true end,
})

function modifier_dog_trap:CheckState()
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