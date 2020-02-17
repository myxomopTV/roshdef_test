
function Spawn( entityKeyValues )
	print("vse ok1 !")
	if not IsServer() then
		return
	end

	if thisEntity == nil then
		return
	end
	print("vse ok2 !")

--	thisEntity:AddNewModifier( thisEntity, nil, "modifier_fow_vision", nil )

	RemnantAbility = thisEntity:FindAbilityByName( "storm_spirit_static_remnant" )
	VortexAbility = thisEntity:FindAbilityByName( "storm_spirit_electric_vortex" )

	thisEntity:SetContextThink( "WindsBoss3Think", WindsBoss3Think, 1 )
end

function WindsBoss3Think()
	if ( not thisEntity:IsAlive() ) then
		return -1
	end
	print("vse ok3 !")
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
									thisEntity,
									750,
									DOTA_UNIT_TARGET_TEAM_ENEMY,
									DOTA_UNIT_TARGET_HERO,
									DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NO_INVIS,
									FIND_CLOSEST,
									false )
	print("enemies ="..#enemies)
if #enemies > 0 then
	print("vse ok4 !")
	
	if RemnantAbility ~= nil and RemnantAbility:IsFullyCastable()  then
		print("vse ok5 !")
		return Remnant()
	end



	if thisEntity:GetHealth() < ( thisEntity:GetMaxHealth() * 0.6 ) then 
		if VortexAbility ~= nil and VortexAbility:IsFullyCastable() then
			print("vse ok6 !")
			return Vortex()
		end
	end
else
	RetreatHome()

end	
	return 1
end


function Remnant()
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
		AbilityIndex = RemnantAbility:entindex(),
		Queue = false,
	})
	
	return 0.5
end


function Vortex()
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
		AbilityIndex = VortexAbility:entindex(),
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

