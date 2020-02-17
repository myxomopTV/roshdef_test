
function Spawn( entityKeyValues )
	if not IsServer() then
		return
	end

	if thisEntity == nil then
		return
	end

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

	-- Are we too far from our initial spawn position?
	local fDist = ( thisEntity:GetOrigin() - thisEntity.vInitialSpawnPos ):Length2D()
	if fDist > thisEntity.fMaxDist then
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
	else
	
	local unitCount = 0
	local enemiesCount = #enemies
	local index = 1
	while unitCount <= enemiesCount do
		local enemy = enemies[index]
		
		if enemy and enemy:GetTeam() == DOTA_TEAM_NEUTRALS then
			table.remove( enemies, i )
			else 
			index = index + 1
		end
		
		unitCount = unitCount + 1
	end
--		thisEntity:SetAggroTarget(enemies[1])
		AttackTarget(enemies[1])
print("flagpoint 111")
	end

	
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

function RetreatHome()
	--print( "OgreTankBoss - RetreatHome()" )
	thisEntity:SetAggroTarget(nil)
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
		Position = thisEntity.vInitialSpawnPos
	})
end

