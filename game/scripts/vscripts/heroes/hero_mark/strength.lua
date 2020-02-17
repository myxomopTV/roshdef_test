
LinkLuaModifier( "modifier_mark_strength", "heroes/hero_mark/strength.lua", LUA_MODIFIER_MOTION_NONE )

mark_strength = class({})

function mark_strength:GetIntrinsicModifierName()
	return "modifier_mark_strength"
end

function mark_strength:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end

function mark_strength:OnSpellStart()
	local target = self:GetCursorTarget()
	local info = {
		EffectName = "particles/units/heroes/hero_sven/sven_spell_storm_bolt.vpcf",
		Ability = self,
		iMoveSpeed = 1000,
		Source = self:GetCaster(),
		Target = target,
		iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_2
	}

	ProjectileManager:CreateTrackingProjectile( info )
	EmitSoundOn( "Hero_Sven.StormBolt", self:GetCaster() )
end

function mark_strength:OnProjectileHit(hTarget, vLocation)
	if hTarget ~= nil and ( not hTarget:IsInvulnerable() ) and ( not hTarget:TriggerSpellAbsorb( self ) )  then
		local caster = self:GetCaster()
		local damage = self:GetSpecialValueFor("str_dmg")*caster:GetStrength() + self:GetSpecialValueFor("base_dmg")
		local radius = self:GetSpecialValueFor("radius")
		local stun_duration = self:GetSpecialValueFor("stun_duration")

		EmitSoundOn( "Hero_Sven.StormBoltImpact", hTarget )
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
			DealDamage(caster, enemy, damage, DAMAGE_TYPE_MAGICAL, nil, ability)
			enemy:AddNewModifier(caster, self, "modifier_stunned", {duration = stun_duration})
			
		end
	end
 end 
--------------------------------------------------------------------------------

modifier_mark_strength = class({
	IsHidden 				= function(self) return false end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return true end,
	DeclareFunctions		= function(self) return 
		{
		MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE,
		} end,
})

function modifier_mark_strength:OnCreated()
	if IsServer() then
		local ability = self:GetAbility()
		self.value_need = 1/ability:GetSpecialValueFor("str_mult")
		self.crit_chance = ability:GetSpecialValueFor("crit_chance")
		self:StartIntervalThink(1)
	end
end

function modifier_mark_strength:OnIntervalThink()
	local caster = self:GetCaster()
	local value = caster:GetStrength()
	local stack_count = math.floor(value/ self.value_need)

	self:SetStackCount(stack_count)
	
end


function modifier_mark_strength:GetModifierPreAttack_CriticalStrike()
	if RollPercentage( self.crit_chance) then
		return self:GetStackCount() + 100
	else
		return
	end
end
