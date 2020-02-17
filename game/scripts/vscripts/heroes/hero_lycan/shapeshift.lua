LinkLuaModifier("modifier_shapeshift_model_lua", "heroes/hero_lycan/modifiers/modifier_shapeshift_model_lua.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_shapeshift_speed_lua", "heroes/hero_lycan/modifiers/modifier_shapeshift_speed_lua.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier( "modifier_lycan_boss_shapeshift_transform", "modifiers/modifier_lycan_boss_shapeshift_transform", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_lycan_boss_shapeshift", "modifiers/modifier_lycan_boss_shapeshift", LUA_MODIFIER_MOTION_NONE )

function HalfShapeshiftStart( keys )
	local caster = keys.caster
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local duration = ability:GetSpecialValueFor( "transformation_time" )
	local shapeshift_duration = ability:GetSpecialValueFor( "duration" )
--	local duration = ability:GetLevelSpecialValueFor("transformation_time", ability_level)

		EmitSoundOn( "lycan_lycan_ability_shapeshift_0"..RandomInt(1,6), caster )
		caster:AddNewModifier( caster, ability, "modifier_lycan_boss_shapeshift_transform", { Duration = duration } )
	local ultimate_ability_lvl = caster:FindAbilityByName("lycan_ultimate_shapeshift_datadriven"):GetLevel()
	print("ultimate_ability_level = "..ultimate_ability_lvl)
	if 	ultimate_ability_lvl == 1 then
		local enemies = FindUnitsInRadius( 
									caster:GetTeamNumber(),
									caster:GetOrigin(),
									caster,
									5000,
									DOTA_UNIT_TARGET_TEAM_FRIENDLY,
									DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
									DOTA_UNIT_TARGET_FLAG_PLAYER_CONTROLLED,
									FIND_CLOSEST,
									false )
		 
		for i = 1, #enemies do
			local enemy = enemies[i]
			if enemy ~= nil then
				ability:ApplyDataDrivenModifier(caster, enemy, "modifier_shapeshift_crit_datadriven", {Duration = shapeshift_duration})
				enemy:AddNewModifier(caster, ability, "modifier_shapeshift_speed_lua", {Duration = shapeshift_duration})
			end
		end
	end
end

function CheckForNight( keys )
	local caster = keys.caster
	local ability = keys.ability
	local modifier = keys.modifier
	local modifier1 = keys.modifier1

	local ultimate_ability_lvl = caster:FindAbilityByName("lycan_ultimate_shapeshift_datadriven"):GetLevel()
--	print("ultimate_ability_level = "..ultimate_ability_lvl)
	if 	ultimate_ability_lvl == 0 then
		if not GameRules:IsDaytime() then
	--	if  GameRules:IsDaytime() then
			ability:ApplyDataDrivenModifier(caster, caster, modifier, {})
			if caster:HasModifier(modifier1) then caster:RemoveModifierByName(modifier1) end
		else
			if caster:HasModifier(modifier) then caster:RemoveModifierByName(modifier) end
		end
	else
		ability:ApplyDataDrivenModifier(caster, caster, modifier, {})
		if caster:HasModifier(modifier1) then caster:RemoveModifierByName(modifier1) end	
	end
end

--[[Author: Pizzalol
	Date: 26.09.2015.
	Applies the shapeshift speed modifier if the target is owned by the caster]]
function ShapeshiftHaste( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local modifier = keys.modifier
	
	local duration = ability:GetLevelSpecialValueFor("aura_interval", ability_level)
	local caster_owner = caster:GetPlayerOwner() 
	local target_owner = target:GetPlayerOwner() 

	-- If they are the same then apply the modifier
	if caster_owner == target_owner then
		target:AddNewModifier(caster, ability, "modifier_shapeshift_speed_lua", {Duration = duration})
		ability:ApplyDataDrivenModifier(caster, target, modifier, {Duration = duration})
	end
end

--[[Applies the speed and model change Lua modifiers upon cast]]
function ShapeshiftStart( keys )
	local caster = keys.caster
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1

	local duration = ability:GetLevelSpecialValueFor("duration", ability_level)

--	caster:AddNewModifier(caster, ability, "modifier_shapeshift_speed_lua", {})
	caster:AddNewModifier(caster, ability, "modifier_shapeshift_model_lua", {})
end

function ShapeshiftEnd( keys )
	local caster = keys.caster
	local ability = keys.ability

	caster:RemoveModifierByName('modifier_shapeshift_model_lua')
end
