
LinkLuaModifier( "modifier_bristleback_bristleback_custom", "heroes/hero_bristleback/bristleback_custom", LUA_MODIFIER_MOTION_NONE )

bristleback_bristleback_custom = class({})

function bristleback_bristleback_custom:GetIntrinsicModifierName()
	return "modifier_bristleback_bristleback_custom"
end

modifier_bristleback_bristleback_custom = class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return true end,
	DeclareFunctions		= function(self) return 
		{
	        MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
			MODIFIER_EVENT_ON_TAKEDAMAGE
		} end,
})

function modifier_bristleback_bristleback_custom:OnCreated()
	self.ability	= self:GetAbility()
	self.caster		= self:GetCaster()
	self.parent		= self:GetParent()
	
	-- AbilitySpecials
	self.front_damage_reduction		= 0
	self.side_damage_reduction		= self.ability:GetSpecialValueFor("side_damage_reduction")
	self.back_damage_reduction		= self.ability:GetSpecialValueFor("back_damage_reduction")
	self.side_angle					= self.ability:GetSpecialValueFor("side_angle")
	self.back_angle					= self.ability:GetSpecialValueFor("back_angle")
	self.quill_release_threshold	= self.ability:GetSpecialValueFor("quill_release_threshold")
	self.trigger_chance				= self.ability:GetSpecialValueFor("trigger_chance")
	
	self.cumulative_damage			= self.cumulative_damage or 0
end

function modifier_bristleback_bristleback_custom:GetModifierIncomingDamage_Percentage(keys)
	if self.parent:PassivesDisabled() then return 0 end

	local forwardVector			= self.caster:GetForwardVector()
	local forwardAngle			= math.deg(math.atan2(forwardVector.x, forwardVector.y))
			
	local reverseEnemyVector	= (self.caster:GetAbsOrigin() - keys.attacker:GetAbsOrigin()):Normalized()
	local reverseEnemyAngle		= math.deg(math.atan2(reverseEnemyVector.x, reverseEnemyVector.y))

	local difference = math.abs(forwardAngle - reverseEnemyAngle)

	--print(difference)
	

	
	-- There's 100% a more straightforward way to calculate this but I can't think properly right now
	if (difference <= (self.back_angle / 2)) or (difference >= (360 - (self.back_angle / 2))) then
		--print("Hit the back ", (self.back_damage_reduction), "%")
		local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_bristleback/bristleback_back_dmg.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
		ParticleManager:SetParticleControl(particle, 1, self.parent:GetAbsOrigin())
		ParticleManager:SetParticleControlEnt(particle, 1, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true)
		ParticleManager:ReleaseParticleIndex(particle)
	
		local particle2 = ParticleManager:CreateParticle("particles/units/heroes/hero_bristleback/bristleback_back_lrg_dmg.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
		ParticleManager:SetParticleControlEnt(particle2, 1, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true)
		ParticleManager:ReleaseParticleIndex(particle2)
		
		self.parent:EmitSound("Hero_Bristleback.Bristleback")
		
		return self.back_damage_reduction * (-1)
	elseif (difference <= (self.side_angle / 2)) or (difference >= (360 - (self.side_angle / 2))) then 
		--print("Hit the side", (self.side_damage_reduction), "%")
		local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_bristleback/bristleback_back_dmg.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
		ParticleManager:SetParticleControl(particle, 1, self.parent:GetAbsOrigin())
		ParticleManager:SetParticleControlEnt(particle, 1, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true)
		ParticleManager:ReleaseParticleIndex(particle)
		
		return self.side_damage_reduction * (-1)
	else
		--print("Hit the front")
		return self.front_damage_reduction * (-1)
	end
end

function modifier_bristleback_bristleback_custom:OnTakeDamage( keys )
	if keys.unit == self.parent then
		if self.parent:PassivesDisabled() or bit.band(keys.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION) == DOTA_DAMAGE_FLAG_REFLECTION then return end
	
		-- Pretty inefficient to calculate this stuff twice but I don't want to make these class variables due to how much damage might stack in a single frame...
		local forwardVector			= self.caster:GetForwardVector()
		local forwardAngle			= math.deg(math.atan2(forwardVector.x, forwardVector.y))
				
		local reverseEnemyVector	= (self.caster:GetAbsOrigin() - keys.attacker:GetAbsOrigin()):Normalized()
		local reverseEnemyAngle		= math.deg(math.atan2(reverseEnemyVector.x, reverseEnemyVector.y))

		local difference = math.abs(forwardAngle - reverseEnemyAngle)

		if (difference <= (self.back_angle / 2)) or (difference >= (360 - (self.back_angle / 2))) then

				if RollPercentage(self.trigger_chance) or (keys.damage > self.quill_release_threshold and RollPercentage(50)) then
				
				local ability_spray = self.caster:FindAbilityByName("bristleback_quill_spray_custom")
				if ability_spray and ability_spray:GetLevel() > 0 then
					ability_spray:DoSpray()
				end
			end
		end
	end
end