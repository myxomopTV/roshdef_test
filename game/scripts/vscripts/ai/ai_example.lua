--LinkLuaModifier( "modifier_fow_vision", "modifiers/modifier_fow_vision", LUA_MODIFIER_MOTION_NONE )

function Spawn( entityKeyValues )
	if not IsServer() then
		return
	end

	if thisEntity == nil then
		return
	end

--	thisEntity:AddNewModifier( thisEntity, nil, "modifier_fow_vision", nil )

	SmashAbility = thisEntity:FindAbilityByName( "ogre_tank_boss_melee_smash" )
	JumpAbility = thisEntity:FindAbilityByName( "ogre_tank_boss_jump_smash" )
	VoidAbility = thisEntity:FindAbilityByName( "minimage_mana_void" )

	thisEntity:SetContextThink( "OgreTankThink", OgreTankThink, 1 )
end

function OgreTankThink()
	if ( not thisEntity:IsAlive() ) then
		return -1
	end
	
	if GameRules:IsGamePaused() == true then
		return 1
	end

	-- Increase acquisition range after the initial aggro

	local enemies = FindUnitsInRadius( 
									thisEntity:GetTeamNumber(),	--команда юнита
									thisEntity:GetOrigin(),		--местоположение юнита
									nil,	--айди юнита (необязательно)
									5000,	--радиус поиска
									DOTA_UNIT_TARGET_TEAM_ENEMY,	-- юнитов чьей команды ищем вражеской/дружественной
									DOTA_UNIT_TARGET_HERO,	--юнитов какого типа ищем 
									DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NO_INVIS,	--поиск по флагам
									FIND_CLOSEST,	--сортировка от ближнего к дальнему или от дальнего к ближнему
									false )

	if #enemies > 0 	then
		if JumpAbility ~= nil and JumpAbility:IsFullyCastable()  then
			return Jump()
		end



		if SmashAbility ~= nil and SmashAbility:IsFullyCastable() then
			return Smash( enemies[ 1 ] )
		end

		if VoidAbility ~= nil and VoidAbility:IsFullyCastable() then
			return Void( enemies[ 1 ] )
		end

		if thisEntity:GetHealth() < ( thisEntity:GetMaxHealth() * 0.3 ) then 
			UseMaskOfMadness()
		end

	end
		return 0.5
	
end


function Jump()
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
		AbilityIndex = JumpAbility:entindex(),
		Queue = false,
	})
	
	return 2.5
end


function Smash( enemy )
	if enemy == nil then
		return
	end

	if ( not thisEntity:HasModifier( "modifier_provide_vision" ) ) then
		--print( "If player can't see me, provide brief vision to his team as I start my Smash" )
		thisEntity:AddNewModifier( thisEntity, nil, "modifier_provide_vision", { duration = 1.5 } )
	end

	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
		AbilityIndex = SmashAbility:entindex(),
		Position = enemy:GetOrigin(),
		Queue = false,
	})

	return 3 
end

function Void( enemy )

	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
		AbilityIndex = VoidAbility:entindex(),
		TargetIndex = enemy:entindex(),
		Queue = false,
	})

	return 0.5
end

function UseMaskOfMadness()
	if thisEntity.hMaskOfMadnessAbility ~= nil and thisEntity.hMaskOfMadnessAbility:IsFullyCastable() then
		ExecuteOrderFromTable({
			UnitIndex = thisEntity:entindex(),
			OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
			AbilityIndex = thisEntity.hMaskOfMadnessAbility:entindex(),
			Queue = false,
		})
	end
end

