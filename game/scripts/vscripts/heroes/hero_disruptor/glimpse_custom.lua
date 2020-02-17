LinkLuaModifier("modifier_disruptor_glimpse_custom_thinker", "heroes/hero_disruptor/glimpse_custom", LUA_MODIFIER_MOTION_NONE)

disruptor_glimpse_custom = class({})

function disruptor_glimpse_custom:GetCastRange()
	return self:GetSpecialValueFor("cast_range")
end

function disruptor_glimpse_custom:OnSpellStart()
	local caster = self:GetCaster()
	caster.glimpse_target = self:GetCursorTarget()

	caster:SwapAbilities("disruptor_glimpse_custom", "disruptor_glimpse_custom_active", false, true) 
end

disruptor_glimpse_custom_active = class({})

function disruptor_glimpse_custom_active:OnSpellStart()
	if IsServer() then
		local caster	=	self:GetCaster()
		local ability	=	self
		local target	=	caster.glimpse_target
		local new_position	=	self:GetCursorPosition()	
		local cast_sound = "Hero_Disruptor.Glimpse.Target"
		local delay = ability:GetSpecialValueFor("move_delay")
		local cast_response = "disruptor_dis_glimpse_0"..math.random(1,5)

		-- Roll cast response
		if RollPercentage(75) then
			EmitSoundOn(cast_response, caster)
		end

		caster:SwapAbilities("disruptor_glimpse_custom_active", "disruptor_glimpse_custom", false, true) 
	
		local glimpse_ability = caster:FindAbilityByName("disruptor_glimpse_custom")
		glimpse_ability:UseResources(false, false, true)
			
		if IsValidEntity(target) and target:IsAlive() then
			local thinker = target:AddNewModifier(caster, self, "modifier_disruptor_glimpse_custom_thinker", {})

			EmitSoundOn(cast_sound, target)	
			thinker:BeginGlimpse(target, new_position)
		end
	end
end
modifier_disruptor_glimpse_custom_thinker = class({})

function modifier_disruptor_glimpse_custom_thinker:IsHidden()
	return true
end

function modifier_disruptor_glimpse_custom_thinker:IsPurgable()
	return true
end

function modifier_disruptor_glimpse_custom_thinker:OnCreated( kv )
	if IsServer() then		
		-- Ability properties
		self.caster = self:GetCaster()
		self.ability = self:GetAbility()
		self.parent = self:GetParent()

		-- Ability specials
		self.move_delay = self.ability:GetSpecialValueFor("move_delay")		
		self.projectile_speed = self.ability:GetSpecialValueFor("projectile_speed")
		self.vision_radius = self.ability:GetSpecialValueFor("vision_radius")
		self.vision_duration = self.ability:GetSpecialValueFor("vision_duration")		
	end
end

function modifier_disruptor_glimpse_custom_thinker:OnIntervalThink()
	if IsServer() then
		if self.flExpireTime ~= -1 and GameRules:GetGameTime() > self.flExpireTime then
			if self.hThinker then
				self.hThinker:EndGlimpse(self:GetCaster(), self:GetAbility(), self:GetParent(), self.glimpse_position)

			end
			self.flExpireTime = -1
			self.hThinker = nil
		end
	end
end

function modifier_disruptor_glimpse_custom_thinker:BeginGlimpse(target, new_position)
	if IsServer() then				
		local hUnit = target
		local vNewLocation = new_position
		local caster = self:GetCaster()
	   	local vDirection = ( vNewLocation - target:GetOrigin()):Normalized()

		self.move_delay = self:GetSpecialValueFor("move_delay")		
		self.projectile_speed = self:GetSpecialValueFor("projectile_speed")
		self.vision_radius = self:GetSpecialValueFor("vision_radius")
		self.vision_duration = self:GetSpecialValueFor("vision_duration")		

		if hUnit and vNewLocation then
			local vVelocity = ( vNewLocation - hUnit:GetOrigin())
			vVelocity.z = 0.0

			local flDist = vVelocity:Length2D()
			vVelocity = vVelocity:Normalized()

			local flDuration = math.max(0.05, math.min(self.move_delay, flDist / self.projectile_speed))
			
			local projectile =
			{
				Ability = self:GetAbility(),
				EffectName = "particles/units/heroes/hero_disruptor/disruptor_glimpse_travel.vpcf",
				vSpawnOrigin = hUnit:GetOrigin(), 
				fDistance = flDist,
				Source = self:GetCaster(),                				
				vVelocity = vVelocity * ( flDist / flDuration ),
				fStartRadius = 0,
				fEndRadius = 0,				
				bProvidesVision = false,
				iVisionRadius = self.vision_radius,
				iVisionTeamNumber = caster:GetTeamNumber(),
			}			  

			ProjectileManager:CreateLinearProjectile(projectile)                      

			local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_disruptor/disruptor_glimpse_travel.vpcf", PATTACH_CUSTOMORIGIN, nil )
			ParticleManager:SetParticleControlEnt( nFXIndex, 0, hUnit, PATTACH_ABSORIGIN_FOLLOW, nil, hUnit:GetOrigin(), true )
			ParticleManager:SetParticleControl( nFXIndex, 1, vNewLocation )
			ParticleManager:SetParticleControl( nFXIndex, 2, Vector( flDuration, flDuration, flDuration ) )
			self:AddParticle( nFXIndex, false, false, -1, false, false )

			local nFXIndex2 = ParticleManager:CreateParticle( "particles/units/heroes/hero_disruptor/disruptor_glimpse_targetend.vpcf", PATTACH_CUSTOMORIGIN, nil )
			ParticleManager:SetParticleControlEnt( nFXIndex2, 0, hUnit, PATTACH_ABSORIGIN_FOLLOW, nil, hUnit:GetOrigin(), true )
			ParticleManager:SetParticleControl( nFXIndex2, 1, vNewLocation )
			ParticleManager:SetParticleControl( nFXIndex2, 2, Vector( flDuration, flDuration, flDuration ) )
			self:AddParticle( nFXIndex2, false, false, -1, false, false )

			local nFXIndex3 = ParticleManager:CreateParticle( "particles/units/heroes/hero_disruptor/disruptor_glimpse_targetstart.vpcf", PATTACH_CUSTOMORIGIN, nil )
			ParticleManager:SetParticleControlEnt( nFXIndex3, 0, hUnit, PATTACH_ABSORIGIN_FOLLOW, nil, hUnit:GetOrigin(), true )
			ParticleManager:SetParticleControl( nFXIndex3, 2, Vector( flDuration, flDuration, flDuration ) )
			self:AddParticle( nFXIndex3, false, false, -1, false, false )
			
			EmitSoundOnLocationForAllies( vNewLocation, "Hero_Disruptor.GlimpseNB2017.Destination", self:GetCaster() )
			
--			local buff = hUnit:FindModifierByName( "modifier_imba_glimpse" )
--			if buff then
				self.hThinker = self
				self:StartIntervalThink(0.1)
				self.glimpse_position =  new_position
				self.flExpireTime = GameRules:GetGameTime() + flDuration 						
--			end			
		end		
	end
end

function modifier_disruptor_glimpse_custom_thinker:EndGlimpse(caster, ability, hUnit, new_position)	
	if hUnit and not hUnit:IsMagicImmune() then

		AddFOWViewer(caster:GetTeamNumber(), new_position, self.vision_radius, self.vision_duration, false)
		FindClearSpaceForUnit( hUnit, new_position, true)
		hUnit:Interrupt()
		
		-- #5 Talent: Glimpse into Kinetic Field expands Glimpse Storm inside the Kinetic Field
		-- Check if the target is glimpsed into Kinetic Field
		if caster:HasTalent("special_bonus_imba_disruptor_5") then
			hUnit:AddNewModifier(caster, ability, "modifier_glimpse_talent_indicator", {duration = 0.1})
		end
		
		self:Destroy()		    	    		
	end
end
