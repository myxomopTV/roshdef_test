--LinkLuaModifier( "modifier_fow_vision", "modifiers/modifier_fow_vision", LUA_MODIFIER_MOTION_NONE )

function Spawn( entityKeyValues )
	if not IsServer() then
		return
	end

	if thisEntity == nil then
		return
	end

--	thisEntity:AddNewModifier( thisEntity, nil, "modifier_fow_vision", nil )

	FleshGolemAbility = thisEntity:FindAbilityByName( "plague_wagon_fleshgolem" )
	SpeedAbility = thisEntity:FindAbilityByName( "plague_wagon_speed" )

	thisEntity:SetContextThink( "PlagueWagonThink", PlagueWagonThink, 1 )
end

function PlagueWagonThink()
	if ( not thisEntity:IsAlive() ) then
		return -1
	end
	
	if GameRules:IsGamePaused() == true then
		return 1
	end

	local hp_pct = thisEntity:GetHealthPercent()
	local roshan = Entities:FindByName( nil, "roshan")
	if roshan then
		AttackTarget( thisEntity, roshan )	
	end
	
	
	local enemies = FindUnitsInRadius( 
									thisEntity:GetTeamNumber(),
									thisEntity:GetOrigin(),
									nil,
									800,
									DOTA_UNIT_TARGET_TEAM_ENEMY,
									DOTA_UNIT_TARGET_HERO,
									DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NO_INVIS,
									FIND_CLOSEST,
									false )


	if #enemies > 0 and FleshGolemAbility ~= nil and FleshGolemAbility:IsFullyCastable()  then
		return CastFleshGolem()
	end

	if hp_pct <= 10 and SpeedAbility ~= nil and SpeedAbility:IsFullyCastable()  then
		return CastSpeed()
	end
	
	return 1
end


function CastFleshGolem()
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
		AbilityIndex = FleshGolemAbility:entindex(),
		Queue = false,
	})
	
	return 1
end

function CastSpeed()
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
		AbilityIndex = SpeedAbility:entindex(),
		Queue = false,
	})
	
	return 1
end

function AttackTarget( unit, enemy )

	ExecuteOrderFromTable({
		UnitIndex = unit:entindex(),	--индекс кастера
		OrderType = DOTA_UNIT_ORDER_ATTACK_TARGET,	-- тип приказа
		TargetIndex = enemy:entindex(),
		Queue = false,
	})

end




