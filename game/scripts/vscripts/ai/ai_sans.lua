--LinkLuaModifier( "modifier_fow_vision", "modifiers/modifier_fow_vision", LUA_MODIFIER_MOTION_NONE )

function Spawn( entityKeyValues )
	if not IsServer() then
		return
	end

	if thisEntity == nil then
		return
	end

--	thisEntity:AddNewModifier( thisEntity, nil, "modifier_fow_vision", nil )

	MassTelekinesisAbility = thisEntity:FindAbilityByName( "sans_mass_telekinesis" )
	GreatTelekenesisAbility = thisEntity:FindAbilityByName( "aghs_greater_telekinesis" )
	GasterBlasterAbility = thisEntity:FindAbilityByName( "gaster_blaster_summon" )

	EmitGlobalSound("sans_speak")
	GameRules:SendCustomMessage("#Game_notification_sans_start_message",0,0)
	
	thisEntity:SetContextThink( "SanskThink", SanskThink, 1 )
end

function SanskThink()

	if GreatTelekenesisAbility ~= nil and GreatTelekenesisAbility:IsFullyCastable()  then
		GreatTelekenesis()
	end

	if ( not thisEntity:IsAlive() ) then
	return -1
	end
	
	if GameRules:IsGamePaused() == true then
		return 1
	end

	if thisEntity:HasModifier("modifier_sans_shield_counter") then

	-- Increase acquisition range after the initial aggro

	local enemies = FindUnitsInRadius( 
									thisEntity:GetTeamNumber(),
									thisEntity:GetOrigin(),
									nil,
									5000,
									DOTA_UNIT_TARGET_TEAM_ENEMY,
									DOTA_UNIT_TARGET_HERO ,
									DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NO_INVIS,
									FIND_CLOSEST,
									false )





	if MassTelekinesisAbility ~= nil and MassTelekinesisAbility:IsFullyCastable() then
		return Telekenesis( enemies[ 1 ] )
	end

	if GasterBlasterAbility ~= nil and GasterBlasterAbility:IsFullyCastable()  then
		SummonGasterBlaster()
	end

	
	return 0.5
	
	else
		EmitGlobalSound("sans_speak")
		GameRules:SendCustomMessage("#Game_notification_sans_end_message",0,0)
		thisEntity:RemoveModifierByName('modifier_backtrack_datadriven')
		thisEntity:AddNewModifier(thisEntity, nil, "modifier_invulnerable", {duration=5})
		thisEntity:AddNewModifier(thisEntity, nil, "modifier_tutorial_sleep", {})
		local allCreatures = Entities:FindAllByClassname('npc_dota_creature')
		for i = 1, #allCreatures do
			local creature = allCreatures[i]
			if creature:GetUnitName() == "npc_dota_gaster_blaster" then
				print("gaster_blaster_find")
				creature:ForceKill(false)
			end
		end
			return -1
	end
end


function SummonGasterBlaster()
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
		AbilityIndex = GasterBlasterAbility:entindex(),
		Queue = false,
	})
	
	return 2.5
end

function GreatTelekenesis()


	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
		AbilityIndex = GreatTelekenesisAbility:entindex(),
		Position = thisEntity:GetOrigin(),
		Queue = false,
	})

	return 3
	
end

function Telekenesis( enemy )
	if enemy == nil then
		return 1
	end

	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
		AbilityIndex = MassTelekinesisAbility:entindex(),
		Position = enemy:GetOrigin(),
		Queue = false,
	})

	return 3 
end


