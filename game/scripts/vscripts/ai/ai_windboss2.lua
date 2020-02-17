
function Spawn( entityKeyValues )
	if not IsServer() then
		return
	end

	if thisEntity == nil then
		return
	end

--	thisEntity:AddNewModifier( thisEntity, nil, "modifier_fow_vision", nil )

	BoltAbility = thisEntity:FindAbilityByName( "zuus_lightning_bolt" )
	ThunderAbility = thisEntity:FindAbilityByName( "zuus_thundergods_wrath" )

	thisEntity:SetContextThink( "WindsBoss2Think", WindsBoss2Think, 1 )
end

function WindsBoss2Think()
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
	if fDist > thisEntity.fMaxDist then
		RetreatHome()
		return 3
	end

	-- Increase acquisition range after the initial aggro

	local enemies = FindUnitsInRadius( 
									thisEntity:GetTeamNumber(),
									thisEntity:GetOrigin(),
									nil,
									750,
									DOTA_UNIT_TARGET_TEAM_ENEMY,
									DOTA_UNIT_TARGET_HERO ,
									DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NO_INVIS,
									FIND_CLOSEST,
									false )

if #enemies > 0 then

	if BoltAbility ~= nil and BoltAbility:IsFullyCastable()  then
		return Bolt(enemies[1])
	end





	if thisEntity:GetHealth() < ( thisEntity:GetMaxHealth() * 0.6 ) then 
		if ThunderAbility ~= nil and ThunderAbility:IsFullyCastable() then
			return Thunder()
		end
	end
else
	RetreatHome()
end	
	return 1
end


function Bolt( enemy )

	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
		AbilityIndex = BoltAbility:entindex(),
		TargetIndex = enemy:entindex(),
		Queue = false,
	})

	return 0.5
end


function Thunder()
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
		AbilityIndex = ThunderAbility:entindex(),
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

