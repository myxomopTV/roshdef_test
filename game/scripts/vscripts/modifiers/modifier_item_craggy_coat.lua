modifier_item_craggy_coat_custom = class({})

------------------------------------------------------------------------------

function modifier_item_craggy_coat_custom:IsHidden() 
	return true
end

--------------------------------------------------------------------------------

function modifier_item_craggy_coat_custom:IsPurgable()
	return false
end

----------------------------------------

function modifier_item_craggy_coat_custom:OnCreated( kv )
	self.bonus_strength = self:GetAbility():GetSpecialValueFor( "bonus_strength" )
	self.bonus_armor = self:GetAbility():GetSpecialValueFor( "bonus_armor" )
	self.boulder_chance = self:GetAbility():GetSpecialValueFor( "boulder_chance" )
	self.boulder_speed = self:GetAbility():GetSpecialValueFor( "boulder_speed" )
end

--------------------------------------------------------------------------------

function modifier_item_craggy_coat_custom:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_EVENT_ON_TAKEDAMAGE
	}
	return funcs
end

--------------------------------------------------------------------------------

function modifier_item_craggy_coat_custom:GetModifierBonusStats_Strength( params )
	return self.bonus_strength
end 

--------------------------------------------------------------------------------

function modifier_item_craggy_coat_custom:GetModifierPhysicalArmorBonus( params )
	return self.bonus_armor
end

--------------------------------------------------------------------------------

function modifier_item_craggy_coat_custom:OnTakeDamage( params )
	if IsServer() then
		if params.unit == self:GetParent() then
			local hAttacker = params.attacker
			if hAttacker ~= nil and RollPercentage( self.boulder_chance ) then
				local info = 
				{
					Target = hAttacker,
					Source = self:GetParent(),
					Ability = self:GetAbility(),
					iMoveSpeed = self.boulder_speed,
					vSourceLoc = self:GetParent():GetOrigin(),
					EffectName = "particles/neutral_fx/mud_golem_hurl_boulder.vpcf",
				}
				ProjectileManager:CreateTrackingProjectile( info )

				EmitSoundOn( "n_mud_golem.Boulder.Cast", self:GetParent() )
			end
		end
	end
	return 0 
end


--------------------------------------------------------------------------------