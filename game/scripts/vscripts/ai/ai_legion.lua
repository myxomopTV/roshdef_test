
function Spawn( entityKeyValues )
	if not IsServer() then
		return
	end

	if thisEntity == nil then
		return
	end

	BuffAbility = thisEntity:FindAbilityByName( "legion_commander_press_the_attack" )
	DuelAbility = thisEntity:FindAbilityByName( "legion_commander_duel" )
	thisEntity:SetContextThink( "GuardianThink", GuardianThink, 1 )
end

function GuardianThink()
	if ( not thisEntity:IsAlive() ) then
		return -1
	end
	
	if GameRules:IsGamePaused() == true then
		return 1
	end

	if not thisEntity.bInitialized then
		thisEntity.vInitialSpawnPos = thisEntity:GetOrigin()
		thisEntity.fMaxDist = thisEntity:GetAcquisitionRange()
		thisEntity.bInitialized = true
		
	end

	local hp_pct = thisEntity:GetHealthPercent()
	local fDist = ( thisEntity:GetOrigin() - thisEntity.vInitialSpawnPos ):Length2D()
	if fDist > 1.5 * thisEntity.fMaxDist then
		RetreatHome()
		return 3
	end

	local enemies = FindUnitsInRadius( 
			thisEntity:GetTeamNumber(), 
			thisEntity.vInitialSpawnPos, 
			nil, 
			thisEntity.fMaxDist, 
			DOTA_UNIT_TARGET_TEAM_ENEMY, 
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 
			DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, 
			FIND_CLOSEST, 
			false )


			
	if #enemies == 0 then
		RetreatHome()
		return 1
	end

	if hp_pct < 90 and BuffAbility ~= nil and BuffAbility:IsFullyCastable() then
		return BuffCast( thisEntity )
	end
	
	if hp_pct < 85 and DuelAbility ~= nil and DuelAbility:IsCooldownReady()  then
		for j=1,#enemies do
			if enemies[j]:IsRealHero() then
				return DuelCast( enemies[j] )
			end			
		end		
	end
	
	AttackTarget(enemies[1])
print("flagpoint 111")


	
	return 0.5
end

function AttackTarget( enemy )
	if enemy == nil then
		return
	end
	

	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
--		OrderType = DOTA_UNIT_ORDER_ATTACK_MOVE,
--		OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
		OrderType = DOTA_UNIT_ORDER_ATTACK_TARGET,
		TargetIndex = enemy:entindex(),
--		Position = enemy:GetOrigin(),
--		Queue = false,
	})

	return 1.5
end

function BuffCast( friendly )
	--print( "ai_temple_guardian - Purification" )
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
		AbilityIndex = BuffAbility:entindex(),
		TargetIndex = friendly:entindex(),
		Queue = false,
	})
	return 0.5
end

function DuelCast( enemy )
	--print( "ai_temple_guardian - Smash" )
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
		AbilityIndex = DuelAbility:entindex(),
		TargetIndex = enemy:entindex(),
		Queue = false,
	})
	return 0.5
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

