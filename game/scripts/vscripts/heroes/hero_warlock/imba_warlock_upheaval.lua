

-----------------------------
--        UPHEAVAL         --
-----------------------------

imba_warlock_upheaval = class({})
LinkLuaModifier("modifier_imba_upheaval", "heroes/hero_warlock/imba_warlock_upheaval.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_upheaval_debuff", "heroes/hero_warlock/imba_warlock_upheaval.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_upheaval_buff", "heroes/hero_warlock/imba_warlock_upheaval.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_upheaval_debuff_additive", "heroes/hero_warlock/imba_warlock_upheaval.lua", LUA_MODIFIER_MOTION_NONE)

function imba_warlock_upheaval:GetAbilityTextureName()
	return "warlock_upheaval"
end

function imba_warlock_upheaval:IsHiddenWhenStolen()
	return false
end

--[[
function imba_warlock_upheaval:GetChannelTime()
	local caster = self:GetCaster()
--	if caster:HasTalent("special_bonus_imba_warlock_6") then
--		return 0
--	end

	return self.BaseClass.GetChannelTime(self)
end
]]
function imba_warlock_upheaval:GetAOERadius()
	local ability = self
	local radius = ability:GetSpecialValueFor("radius")
	return radius
end

function imba_warlock_upheaval:OnSpellStart()
	-- Ability properties
	local caster = self:GetCaster()
	local ability = self
	local target_point = self:GetCursorPosition()
	local cast_response = "warlock_warl_ability_upheav_0"..math.random(1, 4)
	local sound_loop = "Hero_Warlock.Upheaval"
	local modifier_upheaval = "modifier_imba_upheaval"
	local modifier_duration = ability:GetSpecialValueFor("duration")

	-- Play cast response
	EmitSoundOn(cast_response, caster)

	-- Play cast sound
	EmitSoundOn(sound_loop, caster)

	-- Apply ModifierThinker on target location
	CreateModifierThinker(caster, ability, modifier_upheaval, {duration = modifier_duration}, target_point, caster:GetTeamNumber(), false)

	
end

function imba_warlock_upheaval:OnChannelFinish()
	local caster = self:GetCaster()
	local sound_loop = "Hero_Warlock.Upheaval"
	local sound_end = "Hero_Warlock.Upheaval.Stop"

	-- Stop looping sound
	StopSoundOn(sound_loop, caster)

	-- Play stop sound instead
	EmitSoundOn(sound_end, caster)

	-- If the caster was a demon, wait 2 seconds, then remove it from play
	if string.find(caster:GetUnitName(), "npc_imba_warlock_upheaval_demon") then
		Timers:CreateTimer(2, function()
			caster:Kill(ability, caster)
		end)
	end
end


-- Upheaval modifier
modifier_imba_upheaval = class({})

function modifier_imba_upheaval:OnCreated()
	-- Ability properties
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	self.parent = self:GetParent()
	self.team = self.caster:GetTeamNumber()
	self.point = self.parent:GetAbsOrigin()
	self.particle_upheaval = "particles/units/heroes/hero_warlock/warlock_upheaval.vpcf"
	self.modifier_debuff = "modifier_imba_upheaval_debuff"
	self.modifier_additive = "modifier_imba_upheaval_debuff_additive"
	self.modifier_golem_buff = "modifier_imba_upheaval_buff"

	-- Ability specials
	self.radius = self.ability:GetSpecialValueFor("radius")
	self.ms_slow_pct_per_tick = self.ability:GetSpecialValueFor("ms_slow_pct_per_tick")
	self.linger_duration = self.ability:GetSpecialValueFor("linger_duration")
	self.tick_interval = self.ability:GetSpecialValueFor("tick_interval")
	self.max_slow_pct = self.ability:GetSpecialValueFor("max_slow_pct")

	if IsServer() then
		-- Add particle effects
		self.particle_upheaval_fx = ParticleManager:CreateParticle(self.particle_upheaval, PATTACH_WORLDORIGIN, self.parent)
		ParticleManager:SetParticleControl(self.particle_upheaval_fx, 0, self.parent:GetAbsOrigin())
		ParticleManager:SetParticleControl(self.particle_upheaval_fx, 1, Vector(self.radius, 1, 1))
		self:AddParticle(self.particle_upheaval_fx, false, false, -1, false, false)

		-- Start thinking
		self:StartIntervalThink(self.tick_interval)
	end
end

function modifier_imba_upheaval:OnIntervalThink()


	-- Find all nearby enemies and apply the debuff
	local enemies = FindUnitsInRadius(self.team,
		self.point,
		nil,
		self.radius,
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		DOTA_UNIT_TARGET_FLAG_NONE,
		FIND_ANY_ORDER,
		false)

	for _,enemy in pairs(enemies) do
		local modifier_debuff_handler = enemy:AddNewModifier(self.caster, self.ability, self.modifier_debuff, nil)--{duration = self.linger_duration})
		enemy:AddNewModifier(self.caster, self.ability, self.modifier_additive, {duration = 1})--{duration = self.linger_duration})
		-- Insert the amount of slow in the new modifier
		if modifier_debuff_handler then
			--modifier_debuff_handler.slow = self.slow
			local modifier_stacks = modifier_debuff_handler:GetStackCount()
			modifier_debuff_handler:SetStackCount(modifier_stacks+1)
		end
	end
--[[
	-- Find Golems
	local units = FindUnitsInRadius(self.caster:GetTeamNumber(),
		self.parent:GetAbsOrigin(),
		nil,
		self.radius,
		DOTA_UNIT_TARGET_TEAM_FRIENDLY,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_PLAYER_CONTROLLED,
		FIND_ANY_ORDER,
		false)

	for _,unit in pairs(units) do
		--if string.find(unit:GetUnitName(), "npc_imba_warlock_golem") then
		if string.find(unit:GetUnitName(), "warlock_golem") then
			local modifier_golem_buff_handler = unit:AddNewModifier(self.caster, self.ability, self.modifier_golem_buff, {duration = (self.tick_interval * 2)})
			if modifier_golem_buff_handler then
				modifier_golem_buff_handler.radius = self.radius
				modifier_golem_buff_handler.center = self.parent:GetAbsOrigin()
			end
		end
	end
]]	
end


modifier_imba_upheaval_debuff = class({})

function modifier_imba_upheaval_debuff:OnCreated()
	-- Ability properties
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	self.parent = self:GetParent()
--	self.particle_debuff_hero = "particles/units/heroes/hero_warlock/warlock_upheaval_debuff.vpcf"
	self.particle_debuff_hero = "particles/units/heroes/hero_warlock/warlock_shadow_word_debuff.vpcf"
--	self.particle_debuff_creep = "particles/units/heroes/hero_warlock/warlock_upheaval_debuff_creep.vpcf"
	self.particle_debuff_creep = "particles/units/heroes/hero_warlock/warlock_shadow_word_debuff.vpcf"

	self.tick_interval = self.ability:GetSpecialValueFor("tick_interval")
	self.slow = self.ability:GetSpecialValueFor("slow_per_sec")*self.tick_interval
	self.damage = self.ability:GetSpecialValueFor("dmg_per_sec")*self.tick_interval

	-- Determine what particle to use, and add it
	if self.parent:IsHero() then
		self.particle_debuff_hero_fx = ParticleManager:CreateParticle(self.particle_debuff_hero, PATTACH_ABSORIGIN_FOLLOW, self.parent)
		ParticleManager:SetParticleControl(self.particle_debuff_hero_fx, 0, self.parent:GetAbsOrigin())
		ParticleManager:SetParticleControl(self.particle_debuff_hero_fx, 1, self.parent:GetAbsOrigin())
		self:AddParticle(self.particle_debuff_hero_fx, false, false, -1, false, false)
	else
		self.particle_debuff_creep_fx = ParticleManager:CreateParticle(self.particle_debuff_creep, PATTACH_ABSORIGIN_FOLLOW, self.parent)
		ParticleManager:SetParticleControl(self.particle_debuff_creep_fx, 0, self.parent:GetAbsOrigin())
		self:AddParticle(self.particle_debuff_creep_fx, false, false, -1, false, false)
	end

	if IsServer() then
		-- Start thinking
		self:StartIntervalThink(self.tick_interval)
	end
end

function modifier_imba_upheaval_debuff:IsHidden() return false end
function modifier_imba_upheaval_debuff:IsPurgable() return true end
function modifier_imba_upheaval_debuff:IsDebuff() return true end

function modifier_imba_upheaval_debuff:OnIntervalThink()
	if IsServer() then
		if not self.parent:HasModifier("modifier_imba_upheaval_debuff_additive") then
			local modifier_stacks = self:GetStackCount()
			if modifier_stacks > 0 then
				self:SetStackCount(modifier_stacks-1)
			else
				self:Destroy()
			end
		end
		DealDamage(self.caster, self.parent, self.damage*self:GetStackCount(), DAMAGE_TYPE_PURE, nil, self.ability)

	end
end

function modifier_imba_upheaval_debuff:DeclareFunctions()
	local decFuncs = {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT}

	return decFuncs
end

function modifier_imba_upheaval_debuff:GetModifierMoveSpeedBonus_Percentage()
	local stacks = self:GetStackCount()
	return self.slow * stacks * (-1)
end

function modifier_imba_upheaval_debuff:GetModifierAttackSpeedBonus_Constant()
	-- #2 Talent: Upheaval also reduces attack speed
--	if self.caster:HasTalent("special_bonus_imba_warlock_2") then
--		local stacks = self:GetStackCount()
--		return stacks * (-1)
--	end

	return nil
end

modifier_imba_upheaval_debuff_additive = class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,

})
