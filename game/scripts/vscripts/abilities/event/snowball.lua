
event_snowball = class({})

function event_snowball:GetCastRange()
	return self:GetSpecialValueFor("cast_range")
end

function event_snowball:OnSpellStart()
	local target = self:GetCursorTarget()
	local info = {
		EffectName = "particles/econ/events/snowball/snowball_projectile.vpcf",
		Ability = self,
		iMoveSpeed = 1000,
		Source = self:GetCaster(),
		Target = target,
		iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_2
	}

	ProjectileManager:CreateTrackingProjectile( info )
	EmitSoundOn( "Frostivus.Item.Snowball.Cast", self:GetCaster() )
end

function event_snowball:OnProjectileHit(hTarget, vLocation)
	if hTarget ~= nil and ( not hTarget:IsInvulnerable() ) and ( not hTarget:TriggerSpellAbsorb( self ) )  then
		local caster = self:GetCaster()
		local damage = self:GetSpecialValueFor("damage")

		EmitSoundOn( "Frostivus.Item.Snowball.Target", hTarget )
		DealDamage(caster, hTarget, damage, DAMAGE_TYPE_MAGICAL, nil, self)
	end
 end 

