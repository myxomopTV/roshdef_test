LinkLuaModifier("modifier_disruptor_static_storm_custom", "heroes/hero_disruptor/static_storm_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_disruptor_static_storm_custom_debuff", "heroes/hero_disruptor/static_storm_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_disruptor_static_storm_custom_debuff_aura", "heroes/hero_disruptor/static_storm_custom", LUA_MODIFIER_MOTION_NONE)

disruptor_static_storm_custom = disruptor_static_storm_custom or class ({})

function disruptor_static_storm_custom:GetAOERadius()	
		local radius = self:GetSpecialValueFor("radius")	
		return radius	
end

function disruptor_static_storm_custom:OnSpellStart()
	if IsServer() then
		-- Ability properties
		local caster = self:GetCaster()	
		local ability = self
		local target_point = self:GetCursorPosition()		
		local cast_response = "disruptor_dis_staticstorm_0"..RandomInt(1, 5)
		local sound_end = "Hero_Disruptor.StaticStorm.End"
		local scepter = caster:HasScepter()
		local modifier_static_storm = "modifier_disruptor_static_storm_custom"
		-- Ability specials
		local scepter_duration = ability:GetSpecialValueFor("scepter_duration")
		local duration = ability:GetSpecialValueFor("duration")	
		-- if has scepter, assign appropriate values	
		if scepter then
			duration = scepter_duration
		end
		
		
		
		
		--Who's that poke'mon?
		local pikachu_probability = 10
		
		if RollPercentage(pikachu_probability) then
			--PIKACHUUUUUUUUUU
			EmitSoundOn("Imba.DisruptorPikachu", caster)
		elseif RollPercentage(65) then
			--It's....just disruptor
			EmitSoundOn(cast_response, caster)
		end
		
		CreateModifierThinker(caster, ability, modifier_static_storm, {duration = duration, target_point_x = target_point.x, target_point_y = target_point.y, target_point_z = target_point.z}, target_point, caster:GetTeamNumber(), false)
	end
end


---------------------------------------------------
--		Static Storm Modifier
---------------------------------------------------
modifier_disruptor_static_storm_custom = modifier_disruptor_static_storm_custom or class({})

function modifier_disruptor_static_storm_custom:IsHidden()	return true end
function modifier_disruptor_static_storm_custom:IsPassive()	return true end

function modifier_disruptor_static_storm_custom:OnCreated(keys)
	if IsServer() then
		self.caster = self:GetCaster()
		self.target = self:GetParent()
		self.ability = self:GetAbility()
		self.radius = self.ability:GetSpecialValueFor("radius")
		self.interval = self.ability:GetSpecialValueFor("interval")
		self.sound_cast = "Hero_Disruptor.StaticStorm"
		local scepter = self.caster:HasScepter()
		self.sound_end = "Hero_Disruptor.StaticStorm.End"
		self.debuff_aura = "modifier_disruptor_static_storm_custom_debuff_aura"
		--ability specials
		local initial_damage = self.ability:GetSpecialValueFor("initial_damage")
		self.damage_increase_pulse = self.ability:GetSpecialValueFor("damage_increase_pulse")
		self.max_damage = self.ability:GetSpecialValueFor("max_damage")
		self.scepter_max_damage = self.ability:GetSpecialValueFor("scepter_max_damage")
		self.damage_increase_enemy = self.ability:GetSpecialValueFor("damage_increase_enemy")	
		self.duration = self.ability:GetSpecialValueFor("duration")	
		self.scepter_duration = self.ability:GetSpecialValueFor("scepter_duration")	
		--fuck you vectors
		self.target_point = Vector(keys.target_point_x, keys.target_point_y, keys.target_point_z)
		self.particle_storm = "particles/units/heroes/hero_disruptor/disruptor_static_storm.vpcf"

		EmitSoundOn(self.sound_cast, self.caster)

		self.particle_storm_fx = ParticleManager:CreateParticle(self.particle_storm, PATTACH_WORLDORIGIN, self.caster)
		ParticleManager:SetParticleControl(self.particle_storm_fx, 0,self.target_point)
		ParticleManager:SetParticleControl(self.particle_storm_fx, 1, Vector(self.radius, self.radius, self.radius))
		ParticleManager:SetParticleControl(self.particle_storm_fx, 2, Vector(self.duration, 0, 0))
--		self:AddParticle( nFXIndex2, false, false, -1, false, false )




		self.max_damage = self.max_damage
		self.scepter_max_damage = self.scepter_max_damage
		
		self.damage_increase_pulse = self.damage_increase_pulse
			
		-- if has scepter, assign appropriate values	
		if scepter then
			self.duration = self.scepter_duration
			self.max_damage = self.scepter_max_damage			
		end

		-- Assign variables for pulses
		self.current_damage = initial_damage
		self.damage_increase_from_enemies = 0
		self.pulse_num = 0
		self.max_pulses = self.duration / self.interval
		
		-- Bootleg check for allowing longer particle effects
		self.particle_timer = 0

		CreateModifierThinker(self.caster, self.ability, self.debuff_aura, {duration = self.duration}, self.target_point, self.caster:GetTeamNumber(), false)
		self:StartIntervalThink(self.interval)
	end
end

function modifier_disruptor_static_storm_custom:OnIntervalThink()

	self.particle_timer = self.particle_timer + self.interval
	
	if self.particle_timer >= 7 then -- seems like default particle duration?
		-- Destroy and recreate
		--ParticleManager:DestroyParticle(self.particle_storm_fx, false)
		self.particle_storm_fx = ParticleManager:CreateParticle(self.particle_storm, PATTACH_WORLDORIGIN, self.caster)
		ParticleManager:SetParticleControl(self.particle_storm_fx, 0,self.target_point)
		ParticleManager:SetParticleControl(self.particle_storm_fx, 1, Vector(self.radius, 0, 0))
		ParticleManager:SetParticleControl(self.particle_storm_fx, 2, Vector(self.duration, 0, 0))
		self.particle_timer = 0
	end

	local enemies_in_field = FindUnitsInRadius(self.caster:GetTeamNumber(),
									self.target_point,
									nil,
									self.radius,
									DOTA_UNIT_TARGET_TEAM_ENEMY,
									DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
									DOTA_UNIT_TARGET_FLAG_NONE,
									FIND_ANY_ORDER,
									false)
									
	self.bonus_damage_per_enemy = #enemies_in_field * self.damage_increase_enemy
	for _,enemy in pairs(enemies_in_field) do
		-- Deal damage to appropriate enemies			
		if not enemy:IsMagicImmune() and not enemy:IsInvulnerable() then
					
			local damageTable = {victim = enemy,
								attacker = self.caster,
								damage = self.current_damage,
								ability = self.ability,
								damage_type = DAMAGE_TYPE_MAGICAL}
								
			ApplyDamage(damageTable)			
				
		end
	end
		self.pulse_num = self.pulse_num + 1
		self.current_damage = self.current_damage + self.damage_increase_pulse + self.damage_increase_from_enemies + self.bonus_damage_per_enemy
		self.damage_increase_from_enemies = 0 --reset
		
		-- Check if maximum damage was reached
		if self.current_damage > self.max_damage then
			self.current_damage = self.max_damage
		end
		
		-- Check if there are still more pulses, stop timer if not 
		if self.pulse_num < self.max_pulses then
			return self.interval
		else
			return nil
		end	
end

function modifier_disruptor_static_storm_custom:OnDestroy()
	if IsServer() then
		local caster = self:GetCaster()
		ParticleManager:DestroyParticle(self.particle_storm_fx, false)
		StopSoundEvent(self.sound_cast, caster)
		EmitSoundOnLocationWithCaster(self.target_point, self.sound_end, self.caster)
	end
end
---------------------------------------------------
--	Static Storm silence and mute aura
---------------------------------------------------

modifier_disruptor_static_storm_custom_debuff_aura = class({})

function modifier_disruptor_static_storm_custom_debuff_aura:OnCreated()
	self.ability = self:GetAbility()
	self.radius = self.ability:GetSpecialValueFor("radius")
end

function modifier_disruptor_static_storm_custom_debuff_aura:GetAuraRadius()	return self.radius	end
function modifier_disruptor_static_storm_custom_debuff_aura:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_INVULNERABLE	end
function modifier_disruptor_static_storm_custom_debuff_aura:GetAuraSearchTeam()	return DOTA_UNIT_TARGET_TEAM_ENEMY 	end
function modifier_disruptor_static_storm_custom_debuff_aura:GetAuraSearchType()	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end
function modifier_disruptor_static_storm_custom_debuff_aura:GetModifierAura() return "modifier_disruptor_static_storm_custom_debuff" end
function modifier_disruptor_static_storm_custom_debuff_aura:IsAura() return true end
function modifier_disruptor_static_storm_custom_debuff_aura:IsHidden() return true end
function modifier_disruptor_static_storm_custom_debuff_aura:IsPurgable() return false end

---------------------------------------------------
--	Static Storm silence and mute aura modifier
---------------------------------------------------

modifier_disruptor_static_storm_custom_debuff = class ({})

function modifier_disruptor_static_storm_custom_debuff:OnCreated()
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	self.target = self:GetParent()	
	self.scepter = self.caster:HasScepter()		
end

function modifier_disruptor_static_storm_custom_debuff:GetEffectName()	return "particles/generic_gameplay/generic_silenced.vpcf" end
function modifier_disruptor_static_storm_custom_debuff:GetEffectAttachType() return PATTACH_OVERHEAD_FOLLOW end
function modifier_disruptor_static_storm_custom_debuff:IsDebuff() return true end
function modifier_disruptor_static_storm_custom_debuff:IsHidden() return false end
function modifier_disruptor_static_storm_custom_debuff:IsPurgable()	return false end
function modifier_disruptor_static_storm_custom_debuff:DeclareFunctions()	
	return {MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,} 
end

function modifier_disruptor_static_storm_custom_debuff:CheckState()	
	if self.scepter then
		state = { [MODIFIER_STATE_SILENCED] = true,
				  [MODIFIER_STATE_MUTED] = true,}
	else
		state = { [MODIFIER_STATE_SILENCED] = true}	
	end
	return state	
end

function modifier_disruptor_static_storm_custom_debuff:GetModifierMagicalResistanceBonus()
	return self:GetAbility():GetSpecialValueFor("reduce_mag_resist")*(-1)
end