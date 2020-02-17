item_craggy_coat_custom = class({})
LinkLuaModifier( "modifier_item_craggy_coat_custom", "modifiers/modifier_item_craggy_coat", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function item_craggy_coat_custom:GetIntrinsicModifierName()
	return "modifier_item_craggy_coat_custom"
end

--------------------------------------------------------------------------------

function item_craggy_coat_custom:Spawn()
	self.boulder_damage = self:GetSpecialValueFor( "boulder_damage" )
	self.boulder_stun_duration = self:GetSpecialValueFor( "boulder_stun_duration" )
end

--------------------------------------------------------------------------------

function item_craggy_coat_custom:OnProjectileHit( hTarget, vLocation )
	if IsServer() then
		if hTarget ~= nil and hTarget:IsMagicImmune() == false and hTarget:IsInvulnerable() == false then
			local damageinfo =
			{
				victim = hTarget,
				attacker = self:GetCaster(),
				damage = self.boulder_damage,
				damage_type = DAMAGE_TYPE_MAGICAL,
				ability = self,
			}
			ApplyDamage( damageinfo )
			EmitSoundOn( "n_mud_golem.Boulder.Target", hTarget )
			hTarget:AddNewModifier( self:GetCaster(), self, "modifier_stunned", { duration = self.boulder_stun_duration } )
		end
	end

	return true
end
