
LinkLuaModifier( "modifier_ricko_tree_throw_debuff", "heroes/hero_ricko/tree_throw", LUA_MODIFIER_MOTION_NONE )

ricko_tree_throw = class({})

function ricko_tree_throw:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end

function ricko_tree_throw:OnSpellStart()
	local target = self:GetCursorTarget()
	local info = {
		EffectName = "particles/units/heroes/hero_tiny/tiny_tree_proj.vpcf",
		Ability = self,
		iMoveSpeed = 1000,
		Source = self:GetCaster(),
		Target = target,
		iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_2
	}

	ProjectileManager:CreateTrackingProjectile( info )
	EmitSoundOn( "tiny.tree_grab", self:GetCaster() )
end

function ricko_tree_throw:OnProjectileHit(hTarget, vLocation)
	if hTarget ~= nil and ( not hTarget:IsInvulnerable() ) and ( not hTarget:TriggerSpellAbsorb( self ) )  then
		local caster = self:GetCaster()
		local damage = self:GetSpecialValueFor("base_dmg")
		local radius = self:GetSpecialValueFor("radius")
		local stun_duration = self:GetSpecialValueFor("stun_duration")
		local debuff_duration = self:GetSpecialValueFor("debuff_duration")

		EmitSoundOn( "tiny.tree_impact", hTarget )
		local enemies = FindUnitsInRadius(caster:GetTeam(), 
										hTarget:GetAbsOrigin(), 
										nil, 
										radius, 
										DOTA_UNIT_TARGET_TEAM_ENEMY, 
										DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, 
										DOTA_UNIT_TARGET_FLAG_NONE, 
										FIND_ANY_ORDER, false)
		
		for i=1,#enemies do
			local enemy = enemies[i]
			DealDamage(caster, enemy, damage, DAMAGE_TYPE_PHYSICAL, nil, ability)
			enemy:AddNewModifier(caster, self, "modifier_stunned", {duration = stun_duration})
			enemy:AddNewModifier(caster, self, "modifier_ricko_tree_throw_debuff", {duration = debuff_duration})
			
		end
	end
 end 
--------------------------------------------------------------------------------

modifier_ricko_tree_throw_debuff = class({
	IsHidden 				= function(self) return false end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return true end,
	IsBuff                  = function(self) return false end,
	RemoveOnDeath 			= function(self) return true end,
	DeclareFunctions		= function(self) return 
		{
			MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		} end,
})

function modifier_ricko_tree_throw_debuff:GetModifierPhysicalArmorBonus()
	return self:GetAbility():GetSpecialValueFor("armor_decrease")*(-1)
end
