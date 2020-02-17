--	Author: zimberzimber
--	Date:	19.2.2017

-- Attempt to implement A*-algorithm
-- https://github.com/lattejed/a-star-lua	


--CreateEmptyTalents("riki")
local LinkedModifiers = {}

---------------------------------------------------------------------
--------------------	Tricks of the Trade		---------------------
---------------------------------------------------------------------
if imba_riki_tricks_of_the_trade == nil then imba_riki_tricks_of_the_trade = class({}) end
LinkLuaModifier( "modifier_imba_riki_tricks_of_the_trade_primary", "heroes/hero_riki/tricks_of_the_trade.lua", LUA_MODIFIER_MOTION_NONE )		-- Hides the caster and damages all enemies in the AoE
LinkLuaModifier( "modifier_imba_riki_tricks_of_the_trade_secondary", "heroes/hero_riki/tricks_of_the_trade.lua", LUA_MODIFIER_MOTION_NONE )	-- Attacks a single enemy based on attack speed

function imba_riki_tricks_of_the_trade:GetAbilityTextureName()
   return "riki_tricks_of_the_trade"
end

function imba_riki_tricks_of_the_trade:GetBehavior()
	if self:GetCaster():HasScepter() then
		return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET + DOTA_ABILITY_BEHAVIOR_AOE + DOTA_ABILITY_BEHAVIOR_CHANNELLED + DOTA_ABILITY_BEHAVIOR_DONT_RESUME_ATTACK + DOTA_ABILITY_BEHAVIOR_DONT_RESUME_MOVEMENT + DOTA_ABILITY_BEHAVIOR_ROOT_DISABLES end
	return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_CHANNELLED + DOTA_ABILITY_BEHAVIOR_DONT_RESUME_ATTACK + DOTA_ABILITY_BEHAVIOR_DONT_RESUME_MOVEMENT + DOTA_ABILITY_BEHAVIOR_ROOT_DISABLES
end

function imba_riki_tricks_of_the_trade:IsNetherWardStealable()
	return false
end

function imba_riki_tricks_of_the_trade:GetChannelTime()
	return self:GetSpecialValueFor("duration")
end

function imba_riki_tricks_of_the_trade:GetCastRange()
	if self:GetCaster():HasScepter() then
		return self:GetSpecialValueFor("scepter_cast_range") end
		
	return self:GetSpecialValueFor("area_of_effect")
end

function imba_riki_tricks_of_the_trade:GetAOERadius()
	return self:GetSpecialValueFor("area_of_effect") end
	
function imba_riki_tricks_of_the_trade:OnSpellStart()
	if IsServer() then
		local caster = self:GetCaster()
		local origin = caster:GetAbsOrigin()
		local aoe = self:GetSpecialValueFor("area_of_effect")
		local target = self:GetCursorTarget()
		
		if caster:HasScepter() then
			origin = target:GetAbsOrigin() end
		
		caster:AddNewModifier(caster, self, "modifier_imba_riki_tricks_of_the_trade_primary", {})
		caster:AddNewModifier(caster, self, "modifier_imba_riki_tricks_of_the_trade_secondary", {})
			   
		local cast_particle = "particles/units/heroes/hero_riki/riki_tricks_cast.vpcf"
		local tricks_particle = "particles/units/heroes/hero_riki/riki_tricks.vpcf"
		local cast_sound = "Hero_Riki.TricksOfTheTrade.Cast"
		

		
		EmitSoundOnLocationWithCaster(origin, cast_sound, caster)
		EmitSoundOn(continuos_sound, caster)

		local caster_loc = caster:GetAbsOrigin()
		
		if caster:HasScepter() and target ~= caster then
			self.TricksParticle = ParticleManager:CreateParticle(tricks_particle, PATTACH_WORLDORIGIN, caster)
			

			ParticleManager:CreateParticle(cast_particle, PATTACH_WORLDORIGIN, nil)
		else
			self.TricksParticle = ParticleManager:CreateParticle(tricks_particle, PATTACH_WORLDORIGIN, caster)
			

			ParticleManager:CreateParticle(cast_particle, PATTACH_WORLDORIGIN, nil)
		end		
		
		ParticleManager:SetParticleControl(self.TricksParticle, 0, caster:GetAbsOrigin())
		ParticleManager:SetParticleControl(self.TricksParticle, 1, Vector(aoe, 0, aoe))
		ParticleManager:SetParticleControl(self.TricksParticle, 2, Vector(aoe, 0, aoe))
		
		caster:AddNoDraw()
	end
end

function imba_riki_tricks_of_the_trade:OnChannelThink()
	if IsServer() then
		local caster = self:GetCaster()
		local target = self:GetCursorTarget()
		if caster:HasScepter() and target and target ~= caster then
			origin = target:GetAbsOrigin()
			caster:SetAbsOrigin(origin)
			ParticleManager:SetParticleControl(self.TricksParticle, 0, origin)
			ParticleManager:SetParticleControl(self.TricksParticle, 3, origin)
		end
	end
end

function imba_riki_tricks_of_the_trade:OnChannelFinish()
	if IsServer() then
		local caster = self:GetCaster()
		FindClearSpaceForUnit(caster, caster:GetAbsOrigin(), true)
		caster:RemoveModifierByName("modifier_imba_riki_tricks_of_the_trade_primary")
		caster:RemoveModifierByName("modifier_imba_riki_tricks_of_the_trade_secondary")
	
		StopSoundEvent("Hero_Riki.TricksOfTheTrade", caster)
		ParticleManager:DestroyParticle(self.TricksParticle, false)
		ParticleManager:ReleaseParticleIndex(self.TricksParticle)
		self.TricksParticle = nil				
		
		local target = self:GetCursorTarget()
		caster:RemoveNoDraw()
		local end_particle = "particles/units/heroes/hero_riki/riki_tricks_end.vpcf"
		local particle = ParticleManager:CreateParticle(end_particle, PATTACH_ABSORIGIN, caster)
		ParticleManager:ReleaseParticleIndex(particle)
	end
end

----------------------------------------------
-----	Tricks of the Trade modifier	  ----
----------------------------------------------
if modifier_imba_riki_tricks_of_the_trade_primary == nil then modifier_imba_riki_tricks_of_the_trade_primary = class({}) end
function modifier_imba_riki_tricks_of_the_trade_primary:IsPurgable() return false end
function modifier_imba_riki_tricks_of_the_trade_primary:IsDebuff() return false end
function modifier_imba_riki_tricks_of_the_trade_primary:IsHidden() return false end

function modifier_imba_riki_tricks_of_the_trade_primary:DeclareFunctions()
	local funcs = { MODIFIER_PROPERTY_ATTACK_RANGE_BONUS, }
	return funcs
end

function modifier_imba_riki_tricks_of_the_trade_primary:GetModifierAttackRangeBonus()
	local ability = self:GetAbility()
	local aoe = ability:GetSpecialValueFor("area_of_effect")
	return aoe
end

function modifier_imba_riki_tricks_of_the_trade_primary:CheckState()
	if IsServer() then
		local state
		
		if self:GetParent():HasScepter() and self:GetAbility():GetCursorTarget() == self:GetParent() then
			state = {	[MODIFIER_STATE_INVULNERABLE] = true,
					--	[MODIFIER_STATE_UNSELECTABLE] = true,		Temporary Solution to self-casting getting cancelled
					--	[MODIFIER_STATE_OUT_OF_GAME] = true,		Side effects - Caster will still be selectable with drag-box, and will interact with skillshots (like meat hook)
						[MODIFIER_STATE_NOT_ON_MINIMAP] = true,
						[MODIFIER_STATE_NO_UNIT_COLLISION] = true,}
		else
			state = {	[MODIFIER_STATE_INVULNERABLE] = true,
						[MODIFIER_STATE_UNSELECTABLE] = true,
						[MODIFIER_STATE_OUT_OF_GAME] = true,
						[MODIFIER_STATE_NOT_ON_MINIMAP] = true,
						[MODIFIER_STATE_NO_UNIT_COLLISION] = true,}
		end
			
		return state
	end
end

function modifier_imba_riki_tricks_of_the_trade_primary:OnCreated()
	if IsServer() then
		local ability = self:GetAbility()
		local interval = ability:GetSpecialValueFor("attack_interval") + self:GetCaster():FindTalentValue("special_bonus_imba_riki_7")
		self:StartIntervalThink(interval)
	end
end

function modifier_imba_riki_tricks_of_the_trade_primary:OnIntervalThink()
	if IsServer() then
		local ability = self:GetAbility()
		local caster = ability:GetCaster()
		local origin = caster:GetAbsOrigin()
		
		if caster:HasScepter() then
			local target = ability:GetCursorTarget()
			origin = target:GetAbsOrigin()
			caster:SetAbsOrigin(origin)
		end

		local aoe = ability:GetSpecialValueFor("area_of_effect")
		
		local backstab_ability = caster:FindAbilityByName("cloak_and_dagger_datadriven")
		local backstab_particle = "particles/units/heroes/hero_riki/riki_backstab.vpcf"
		local backstab_sound = "Hero_Riki.Backstab"
		
		local targets = FindUnitsInRadius(caster:GetTeamNumber(), origin, nil, aoe, DOTA_UNIT_TARGET_TEAM_ENEMY , DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO , DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS, FIND_ANY_ORDER , false)
		for _,unit in pairs(targets) do
			if unit:IsAlive() and not unit:IsAttackImmune() then
				caster:PerformAttack(unit, true, true, true, false, false, false, false)
				
				if backstab_ability and backstab_ability:GetLevel() > 0 and not self:GetParent():PassivesDisabled() then
					local agility_damage_multiplier = backstab_ability:GetSpecialValueFor("agility_damage")
	                local previous_stack_count = 0
  		            local damage = caster:GetAgility() * agility_damage_multiplier
				
					if caster:HasModifier("modifier_slark_essence_shift_datadriven_buff_counter") then
					previous_stack_count = caster:GetModifierStackCount("modifier_slark_essence_shift_datadriven_buff_counter", caster)
						
					--We have to remove and replace the modifier so the duration will refresh (so it will show the duration of the latest Essence Shift).
					caster:RemoveModifierByNameAndCaster("modifier_slark_essence_shift_datadriven_buff_counter", caster)
					else previous_stack_count = 0
					end
					backstab_ability:ApplyDataDrivenModifier(caster, caster, "modifier_slark_essence_shift_datadriven_buff_counter", nil)
					caster:SetModifierStackCount("modifier_slark_essence_shift_datadriven_buff_counter", caster, previous_stack_count + 1)
					backstab_ability:ApplyDataDrivenModifier(caster, caster, "modifier_slark_essence_shift_datadriven_buff", nil)

			
					local particle = ParticleManager:CreateParticle(backstab_particle, PATTACH_ABSORIGIN_FOLLOW, unit) 
					ParticleManager:SetParticleControlEnt(particle, 1, unit, PATTACH_POINT_FOLLOW, "attach_hitloc", unit:GetAbsOrigin(), true)
					ParticleManager:ReleaseParticleIndex(particle)
					
					EmitSoundOn(backstab_sound, unit)
		            ApplyDamage({victim = unit, attacker = caster, damage = damage, damage_type = ability:GetAbilityDamageType(),damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION })
				end
			end
		end
	end
end

------------------------------------------------------
-----	Tricks of the Trade secondary attacks	  ----
------------------------------------------------------
if modifier_imba_riki_tricks_of_the_trade_secondary == nil then modifier_imba_riki_tricks_of_the_trade_secondary = class({}) end
function modifier_imba_riki_tricks_of_the_trade_secondary:IsPurgable() return false end
function modifier_imba_riki_tricks_of_the_trade_secondary:IsDebuff() return false end
function modifier_imba_riki_tricks_of_the_trade_secondary:IsHidden() return true end

function modifier_imba_riki_tricks_of_the_trade_secondary:OnCreated()
	if IsServer() then
		local parent = self:GetParent()
		local aps = parent:GetAttacksPerSecond()				
		if aps>=10 
			then	self:StartIntervalThink(0.1)			
			else	self:StartIntervalThink(1/aps)
		end
	end
end

function modifier_imba_riki_tricks_of_the_trade_secondary:OnIntervalThink()
	if IsServer() then
		local ability = self:GetAbility()
		local caster = ability:GetCaster()
		local origin = caster:GetAbsOrigin()
		
		if caster:HasScepter() then
			local target = ability:GetCursorTarget()
			origin = target:GetAbsOrigin()
			caster:SetAbsOrigin(origin)
		end

		local aoe = ability:GetSpecialValueFor("area_of_effect")
		
		local backstab_ability = caster:FindAbilityByName("cloak_and_dagger_datadriven")
		local backstab_particle = "particles/units/heroes/hero_riki/riki_backstab.vpcf"
		local backstab_sound = "Hero_Riki.Backstab"
		
		local targets = FindUnitsInRadius(caster:GetTeamNumber(), origin, nil, aoe, DOTA_UNIT_TARGET_TEAM_ENEMY , DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO , DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS, FIND_ANY_ORDER , false)
		for _,unit in pairs(targets) do
			if unit:IsAlive() and not unit:IsAttackImmune() then
				caster:PerformAttack(unit, true, true, true, false, false, false, false)
				
				if backstab_ability and backstab_ability:GetLevel() > 0 and not self:GetParent():PassivesDisabled() then
					local agility_damage_multiplier = backstab_ability:GetSpecialValueFor("agility_damage")/100
	                local previous_stack_count = 0
  		            local damage = caster:GetAgility() * agility_damage_multiplier
					
					if caster:HasModifier("modifier_slark_essence_shift_datadriven_buff_counter") then
					previous_stack_count = caster:GetModifierStackCount("modifier_slark_essence_shift_datadriven_buff_counter", caster)
						
					--We have to remove and replace the modifier so the duration will refresh (so it will show the duration of the latest Essence Shift).
					caster:RemoveModifierByNameAndCaster("modifier_slark_essence_shift_datadriven_buff_counter", caster)
					else previous_stack_count = 0
					end
					backstab_ability:ApplyDataDrivenModifier(caster, caster, "modifier_slark_essence_shift_datadriven_buff_counter", nil)
					caster:SetModifierStackCount("modifier_slark_essence_shift_datadriven_buff_counter", caster, previous_stack_count + 1)
					backstab_ability:ApplyDataDrivenModifier(caster, caster, "modifier_slark_essence_shift_datadriven_buff", nil)
					
					local particle = ParticleManager:CreateParticle(backstab_particle, PATTACH_ABSORIGIN_FOLLOW, unit) 
					ParticleManager:SetParticleControlEnt(particle, 1, unit, PATTACH_POINT_FOLLOW, "attach_hitloc", unit:GetAbsOrigin(), true)
					ParticleManager:ReleaseParticleIndex(particle)
					
					EmitSoundOn(backstab_sound, unit)
		            ApplyDamage({victim = unit, attacker = caster, damage = damage, damage_type = ability:GetAbilityDamageType(),damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION })
				end

				local caster = self:GetParent()
				local aps = caster:GetAttacksPerSecond()				
				self:StartIntervalThink(1/aps)				
				return
			end
		end
	end
end
-------------------------------------------
for LinkedModifier, MotionController in pairs(LinkedModifiers) do
	LinkLuaModifier(LinkedModifier, "heroes/hero_riki/tricks_of_the_trade.lua", MotionController)
end
-------------------------------------------