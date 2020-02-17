
LinkLuaModifier( "modifier_bristleback_viscous_goo_custom", "heroes/hero_bristleback/viscous_goo_custom", LUA_MODIFIER_MOTION_NONE )

bristleback_viscous_goo_custom = class({})

function bristleback_viscous_goo_custom:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end

function bristleback_viscous_goo_custom:OnSpellStart()
	local target = self:GetCursorTarget()
	local info = {
		EffectName = "particles/units/heroes/hero_bristleback/bristleback_viscous_nasal_goo.vpcf",
		Ability = self,
		iMoveSpeed = 1000,
		Source = self:GetCaster(),
		Target = target,
		iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_2
	}

	ProjectileManager:CreateTrackingProjectile( info )
	EmitSoundOn( "Hero_Bristleback.ViscousGoo.Cast", self:GetCaster() )
end

function bristleback_viscous_goo_custom:OnProjectileHit(hTarget, vLocation)
	if hTarget ~= nil and ( not hTarget:IsInvulnerable() ) and ( not hTarget:TriggerSpellAbsorb( self ) )  then
		local caster = self:GetCaster()
		local radius = self:GetSpecialValueFor("radius")
		local debuff_duration = self:GetSpecialValueFor("debuff_duration")

		EmitSoundOn( "Hero_Bristleback.ViscousGoo.Target", hTarget )
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
			enemy:RemoveModifierByName("modifier_bristleback_viscous_goo_custom")
			enemy:AddNewModifier(caster, self, "modifier_bristleback_viscous_goo_custom", {duration = debuff_duration})
			
		end
	end
 end 
--------------------------------------------------------------------------------

modifier_bristleback_viscous_goo_custom = class({
	IsHidden 				= function(self) return false end,
	IsPurgable 				= function(self) return true end,
	IsDebuff 				= function(self) return true end,
	IsBuff                  = function(self) return false end,
	RemoveOnDeath 			= function(self) return true end,
	DeclareFunctions		= function(self) return 
		{
			MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		} end,
})

function modifier_bristleback_viscous_goo_custom:OnCreated()
	if IsServer() then
		local ability = self:GetAbility()
		local interval = ability:GetSpecialValueFor("interval")
		self:StartIntervalThink(interval)
	end
end

function modifier_bristleback_viscous_goo_custom:OnIntervalThink()
	local caster = self:GetCaster()
	local parent = self:GetParent()
	local ability = self:GetAbility()
	local damage = ability:GetSpecialValueFor("interval_dmg")

	DealDamage(caster, parent, damage, DAMAGE_TYPE_PHYSICAL, nil, ability)
	self:IncrementStackCount()	
end

function modifier_bristleback_viscous_goo_custom:GetModifierPhysicalArmorBonus()
	return self:GetStackCount()*(-1)
end

function modifier_bristleback_viscous_goo_custom:GetEffectName()
	return "particles/units/heroes/hero_bristleback/bristleback_viscous_nasal_goo_debuff.vpcf"
end
