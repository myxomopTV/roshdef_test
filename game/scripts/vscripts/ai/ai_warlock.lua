
function Spawn( entityKeyValues )
	if not IsServer() then
		return
	end

	if thisEntity == nil then
		return
	end

--	thisEntity:AddNewModifier( thisEntity, nil, "modifier_fow_vision", nil )

	UpHeavalAbility = thisEntity:FindAbilityByName( "imba_warlock_upheaval" )

	thisEntity:SetContextThink( "WarlockBossThink", WarlockBossThink, 1 )
end

function WarlockBossThink()
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
	
	local fDist = ( thisEntity:GetOrigin() - thisEntity.vInitialSpawnPos ):Length2D()
	local enemies = FindUnitsInRadius( 
									thisEntity:GetTeamNumber(),
									thisEntity:GetOrigin(),
									nil,
									750,
									DOTA_UNIT_TARGET_TEAM_ENEMY,
									DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
									DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NO_INVIS,
									FIND_CLOSEST,
									false )

	if #enemies > 0 then
		
		if thisEntity:GetHealth() < ( thisEntity:GetMaxHealth() * 0.9 ) then 
			if UpHeavalAbility ~= nil and UpHeavalAbility:IsFullyCastable() then
				return CastUpHeaval(enemies[1])
			end
		end
		
		thisEntity:MoveToPositionAggressive(enemies[1]:GetAbsOrigin())
	elseif (#enemies == 0 and fDist > 200 ) or fDist > thisEntity.fMaxDist then
		RetreatHome()
		return 2
	end	
	return 1
end


function CastUpHeaval( enemy )

	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
		Position = enemy:GetAbsOrigin(),
		AbilityIndex = UpHeavalAbility:entindex(),
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

