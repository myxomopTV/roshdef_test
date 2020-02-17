LinkLuaModifier("modifier_cuirass_cursed_stack", "items/custom/item_cuirass_cursed.lua", LUA_MODIFIER_MOTION_NONE)

function OnUnequip(keys)
	
	local item = keys.ability
	local caster = keys.caster
	local vLocation = caster:GetAbsOrigin()
	local vRandomVector = RandomVector(50)
	
	if item ~= nil then
		item:GetContainer():SetRenderColor(255,69,0)
		item:LaunchLoot(false, 150, 0.5, vLocation + vRandomVector)
	end
end

function CheckForStats (keys)
	local item = keys.ability
	local caster = keys.caster
	local vLocation = caster:GetAbsOrigin()
	
	local stats_required = item:GetSpecialValueFor( "stats_required" )
--	GameRules:SendCustomMessage("stats_required:"..stats_required,0,0)
	local item_stats_sum = item:GetSpecialValueFor( "str_bonus" ) + item:GetSpecialValueFor( "agi_bonus" ) + item:GetSpecialValueFor( "int_bonus" )
	local stats_sum = caster:GetStrength() + caster:GetAgility() + caster:GetIntellect()
	local hero_stats_sum =  stats_sum - item_stats_sum
	
--	GameRules:SendCustomMessage("stats_sum:"..stats_sum,0,0)	
--	GameRules:SendCustomMessage("item_stats_sum:"..item_stats_sum,0,0)	
--	GameRules:SendCustomMessage("hero_stats_sum:"..hero_stats_sum,0,0)	
if not caster:HasModifier("modifier_arc_warden_tempest_double")and caster:IsRealHero() then
	if stats_required > hero_stats_sum then
		Timers:CreateTimer(0.001, function() caster:DropItemAtPositionImmediate(item, vLocation) end)
		GameRules:SendCustomMessage("#Game_notification_cuirass_cursed_request_message",0,0)	
		GameRules:SendCustomMessage("<font color='#FFD700'>NOT ENOUGH </font><font color='#00FF00'>".. stats_required-hero_stats_sum .."</font>",0,0)	
		
	end
end
	
end

function OnOwnerDied( keys )

	local item = keys.ability
	local caster = keys.caster
	local vLocation = caster:GetAbsOrigin()

--	caster:DropItemAtPositionImmediate(item, vLocation)
	
end

function OnCreated( keys )

	local caster = keys.caster
	local item = keys.ability
	local vLocation = caster:GetAbsOrigin()

	if caster:IsRealHero() and caster.activated == nil then
		Timers:CreateTimer(0.01, function()
				caster.activated = true
				caster:ForceKill(true)
--				caster:DropItemAtPositionImmediate(item, vLocation)		
		end)
	end
end

function IncreaseStacks( keys )

	local ability = keys.ability
	local stack_max = ability:GetSpecialValueFor("stack_max")
	local caster = keys.caster
	local target = keys.target
	local StackModifier = "modifier_cuirass_cursed_stack"
    local currentStacks = caster:GetModifierStackCount(StackModifier, ability)

	caster:AddNewModifier( caster, ability, StackModifier , nil )
	local effect = "particles/units/heroes/hero_necrolyte/necrolyte_scythe_flare.vpcf"
	local pfx = ParticleManager:CreateParticle(effect, PATTACH_ABSORIGIN_FOLLOW, caster)
	ParticleManager:SetParticleControl(pfx, 1, caster:GetAbsOrigin()) -- Origin
	
	if currentStacks < stack_max then
		caster:SetModifierStackCount(StackModifier, ability, (currentStacks + 1))
	else	
		caster:ForceKill(true)
		caster:SetModifierStackCount(StackModifier, ability, (0))
	end
	caster:CalculateStatBonus()	
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

modifier_cuirass_cursed_stack = class({
	IsHidden 				= function(self) return false end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
--	GetAttributes 			= function(self) return MODIFIER_ATTRIBUTE_MULTIPLE end,
	DeclareFunctions		= function(self) return 
		{MODIFIER_PROPERTY_HEALTH_BONUS,
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT} end,
})

function modifier_cuirass_cursed_stack:GetModifierHealthBonus()
	return self:GetStackCount()*self:GetAbility():GetSpecialValueFor("stack_health")
end

function modifier_cuirass_cursed_stack:GetModifierConstantHealthRegen()
	return self:GetStackCount()*self:GetAbility():GetSpecialValueFor("stack_hp_reg")
end

