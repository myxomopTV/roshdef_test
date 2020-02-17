--LinkLuaModifier( "modifier_fow_vision", "modifiers/modifier_fow_vision", LUA_MODIFIER_MOTION_NONE )

function Spawn( entityKeyValues )
	if not IsServer() then
		return
	end

	if thisEntity == nil then
		return
	end

--	thisEntity:AddNewModifier( thisEntity, nil, "modifier_fow_vision", nil )

	RuptureAbility = thisEntity:FindAbilityByName( "rupture_custom" )

	thisEntity:SetContextThink( "SeekerThink", SeekerThink, 1 )
end

function SeekerThink()
	if ( not thisEntity:IsAlive() ) then
		return -1
	end
	
	if GameRules:IsGamePaused() == true then
		return 1
	end

	-- Increase acquisition range after the initial aggro

	local enemies = FindUnitsInRadius( 
									thisEntity:GetTeamNumber(),
									thisEntity:GetOrigin(),
									nil,
									600,
									DOTA_UNIT_TARGET_TEAM_ENEMY,
									DOTA_UNIT_TARGET_HERO,
									DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NO_INVIS,
									FIND_CLOSEST,
									false )


	if #enemies > 0 and RuptureAbility ~= nil and RuptureAbility:IsFullyCastable()  then
		return Rupture()
	end




	
	return 0.5
end


function Rupture()
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
		AbilityIndex = RuptureAbility:entindex(),
		Queue = false,
	})
	
	return 5
end




