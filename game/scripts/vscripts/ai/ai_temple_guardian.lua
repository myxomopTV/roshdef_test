function Spawn( entityKeyValues )
	if not IsServer() then
		return
	end

	if thisEntity == nil then
		return
	end

	thisEntity.bIsEnraged = false

	HammerSmashAbility = thisEntity:FindAbilityByName( "temple_guardian_hammer_smash" )
	HammerThrowAbility = thisEntity:FindAbilityByName( "temple_guardian_hammer_throw" )
	PurificationAbility = thisEntity:FindAbilityByName( "temple_guardian_purification" )
	WrathAbility = thisEntity:FindAbilityByName( "temple_guardian_wrath" )

	RageHammerSmashAbility = thisEntity:FindAbilityByName( "temple_guardian_rage_hammer_smash" )
	RageHammerSmashAbility:SetHidden( false )

	thisEntity:SetContextThink( "TempleGuardianThink", TempleGuardianThink, 1 )
end

function TempleGuardianThink()

	if ( not thisEntity:IsAlive() ) then
		return -1
	end

	if GameRules:IsGamePaused() == true then
		return 1
	end

	if thisEntity:IsChanneling() == true then
		return 0.1
	end

	if not thisEntity.bInitialized then
		thisEntity.vInitialSpawnPos = thisEntity:GetOrigin()
		thisEntity.fMaxDist = thisEntity:GetAcquisitionRange()
		thisEntity.bInitialized = true
		
	end

	local hp_pct = thisEntity:GetHealthPercent()
	
	local fDist = ( thisEntity:GetOrigin() - thisEntity.vInitialSpawnPos ):Length2D()
	if fDist > thisEntity.fMaxDist then
		RetreatHome()
		return 3
	end
	
	local hEnemies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity.vInitialSpawnPos, nil, thisEntity.fMaxDist, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false )
	if #hEnemies == 0 then
		RetreatHome()
		return 1
	end

	if hp_pct < 35 then
		-- Our brother died, swap for enraged version of hammer smash
		thisEntity:SwapAbilities( "temple_guardian_hammer_smash", "temple_guardian_rage_hammer_smash", false, true )
		thisEntity.bIsEnraged = true
		thisEntity.fTimeEnrageStarted = GameRules:GetGameTime()
	end


	if hp_pct < 25 and WrathAbility ~= nil and WrathAbility:IsCooldownReady()  then
		return Wrath()
	end

	if hp_pct < 80 and HammerThrowAbility ~= nil and HammerThrowAbility:IsCooldownReady()  then
		local hLastEnemy = hEnemies[ #hEnemies ]
		if hLastEnemy ~= nil then
			local flDist = (hLastEnemy:GetOrigin() - thisEntity:GetOrigin()):Length2D()
			if flDist > 600 then
				return Throw( hLastEnemy )
			end
		end
	end

	if hp_pct < 50 and PurificationAbility ~= nil and PurificationAbility:IsFullyCastable() then
		return Purification( thisEntity )
	end

	if not thisEntity.bIsEnraged then
		if HammerSmashAbility ~= nil and HammerSmashAbility:IsCooldownReady() then
			return Smash( hEnemies[ 1 ] )
		end
	else
		if RageHammerSmashAbility ~= nil and RageHammerSmashAbility:IsFullyCastable() then
			return RageSmash( hEnemies[ 1 ] )
		end
	end

	return 0.5
end

function Wrath()
	--print( "ai_temple_guardian - Wrath" )
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
		AbilityIndex = WrathAbility:entindex(),
		Queue = false,
	})
	return 10
end

function Throw( enemy )
	--print( "ai_temple_guardian - Throw" )
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
		AbilityIndex = HammerThrowAbility:entindex(),
		Position = enemy:GetOrigin(),
		Queue = false,
	})
	return 2
end

function Purification( friendly )
	--print( "ai_temple_guardian - Purification" )
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
		AbilityIndex = PurificationAbility:entindex(),
		TargetIndex = friendly:entindex(),
		Queue = false,
	})
	return 1.3
end

function Smash( enemy )
	--print( "ai_temple_guardian - Smash" )
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
		AbilityIndex = HammerSmashAbility:entindex(),
		Position = enemy:GetOrigin(),
		Queue = false,
	})
	return 1.4
end

function RageSmash( enemy )
	--print( "ai_temple_guardian - RageSmash" )
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
		AbilityIndex = RageHammerSmashAbility:entindex(),
		Position = enemy:GetOrigin(),
		Queue = false,
	})
	return 1.1
end

function RetreatHome()
	--print( "OgreTankBoss - RetreatHome()" )
	thisEntity:SetAggroTarget(nil)
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
		Position = thisEntity.vInitialSpawnPos
	})
end


