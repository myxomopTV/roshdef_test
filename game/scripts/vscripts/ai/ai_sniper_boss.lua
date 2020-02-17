
function Spawn( entityKeyValues )	-- вызывается когда юнит появляется
	if not IsServer() then		-- если сервер не отвечает
		return
	end

	if thisEntity == nil then	-- если данного юнита не существует
		return
	end

    local waypoint = Entities:FindByName( nil, "d_waypoint19") 		-- Записываем в переменную 'waypoint' координаты бокса d_waypoint19
 	if waypoint then thisEntity:SetInitialGoalEntity( waypoint ) end-- Посылаем моба на наш d_waypoint19, координаты которого мы записали в переменную 'waypoint'

	NoTargetAbility1 = thisEntity:FindAbilityByName( "gyrocopter_rocket_barrage" )
	NoTargetAbility2 = thisEntity:FindAbilityByName( "gyrocopter_flak_cannon" )
	TargetAbility1 = thisEntity:FindAbilityByName( "gyrocopter_homing_missile" )
	TargetAbility2 = thisEntity:FindAbilityByName( "sniper_assassinate" )

	thisEntity:SetContextThink( "BossThink", BossThink, 1 )	-- поведение юнита каждую секунду
end

function BossThink()
	if ( not thisEntity:IsAlive() ) then		--если юнит мертв
		return -1	
	end
	
	if GameRules:IsGamePaused() == true then	--если игра приостановлена
		return 1	
	end


	local enemies = FindUnitsInRadius( 
						thisEntity:GetTeamNumber(),	--команда юнита
						thisEntity:GetOrigin(),		--местоположение юнита
						nil,	--айди юнита (необязательно)
						750,	--радиус поиска
						DOTA_UNIT_TARGET_TEAM_ENEMY,	-- юнитов чьей команды ищем вражеской/дружественной
						DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	--юнитов какого типа ищем 
						DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NO_INVIS,	--поиск по флагам
						FIND_CLOSEST,	--сортировка от ближнего к дальнему или от дальнего к ближнему
						false )

	if #enemies > 0 	then	-- если количество найденных юнитов больше нуля
		
		if TargetAbility2 ~= nil and TargetAbility2:IsFullyCastable() then	--если абилка существует и её можно использовать
			for i=1, #enemies do
				local enemy = enemies[i]
				if enemy:IsRealHero() and enemy:GetHealth() < 1500  then 
					TargetAbilityCast2( enemy )
				end		
			end
		end
			
		if TargetAbility1 ~= nil and TargetAbility1:IsFullyCastable() then	--если абилка существует и её можно использовать
			TargetAbilityCast1( enemies[1])
		end
	
	
	
	
		if NoTargetAbility2 ~= nil and NoTargetAbility2:IsFullyCastable()  then	--если абилка существует и её можно использовать
			if thisEntity:GetHealthPercent() < 75 then 
				NoTargetAbilityCast2()
			end
		end
			
		if NoTargetAbility1 ~= nil and NoTargetAbility1:IsFullyCastable()  then	--если абилка существует и её можно использовать
			return NoTargetAbilityCast1()
		end





		if ItemAbility ~= nil and ItemAbility:IsFullyCastable()  then	--если предмет существует и её можно использовать
			if thisEntity:GetHealth() < ( thisEntity:GetMaxHealth() * 0.3 ) then 
				ItemAbilityCast()
			end
		end
		


	end
	
	return 0.5
	
end


function NoTargetAbilityCast1()
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),	--индекс кастера
		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,	-- тип приказа
		AbilityIndex = NoTargetAbility1:entindex(),	-- индекс способности
		Queue = false,
	})
	
	return 1
end

function NoTargetAbilityCast2()
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),	--индекс кастера
		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,	-- тип приказа
		AbilityIndex = NoTargetAbility2:entindex(), -- индекс способности
		Queue = false,
	})
	
	return 1
end



function TargetAbilityCast1( enemy )

	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),	--индекс кастера
		OrderType = DOTA_UNIT_ORDER_CAST_TARGET,	-- тип приказа
		AbilityIndex = TargetAbility1:entindex(), -- индекс способности
		TargetIndex = enemy:entindex(),
		Queue = false,
	})

	return 1
end

function TargetAbilityCast2( enemy )

	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),	--индекс кастера
		OrderType = DOTA_UNIT_ORDER_CAST_TARGET,	-- тип приказа
		AbilityIndex = TargetAbility2:entindex(), -- индекс способности
		TargetIndex = enemy:entindex(),
		Queue = false,
	})

	return 1
end

function ItemAbilityCast()
		ExecuteOrderFromTable({
			UnitIndex = thisEntity:entindex(),	--индекс кастера
			OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,	-- тип приказа
			AbilityIndex = ItemAbility:entindex(), -- индекс способности
			Queue = false,
		})
	return 1
end

