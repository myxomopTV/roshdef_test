
function Spawn( entityKeyValues )	-- вызывается когда юнит появляется
	if not IsServer() then		-- если сервер не отвечает
		return
	end

	if thisEntity == nil then	-- если данного юнита не существует
		return
	end

    local waypoint = Entities:FindByName( nil, "d_waypoint19") 		-- Записываем в переменную 'waypoint' координаты бокса d_waypoint19
 	if waypoint then thisEntity:SetInitialGoalEntity( waypoint ) end-- Посылаем моба на наш d_waypoint19, координаты которого мы записали в переменную 'waypoint'

	NoTargetAbility1 = thisEntity:FindAbilityByName( "necrolyte_boss_death_pulse" )
	NoTargetAbility2 = thisEntity:FindAbilityByName( "necrolyte_sadist" )
	TargetAbility = thisEntity:FindAbilityByName( "creature_reapers_scythe" )

	ItemAbility = FindItemAbility( thisEntity, "item_imba_shivas_guard" )

	thisEntity:SetContextThink( "NecroLordThink", NecroLordThink, 1 )	-- поведение юнита каждую секунду
end

function NecroLordThink()
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
						1250,	--радиус поиска
						DOTA_UNIT_TARGET_TEAM_ENEMY,	-- юнитов чьей команды ищем вражеской/дружественной
						DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	--юнитов какого типа ищем 
						DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NO_INVIS,	--поиск по флагам
						FIND_CLOSEST,	--сортировка от ближнего к дальнему или от дальнего к ближнему
						false )

	if #enemies > 0 	then	-- если количество найденных юнитов больше нуля
		
			
		if TargetAbility ~= nil and TargetAbility:IsFullyCastable() then	--если абилка существует и её можно использовать
			for i=1, #enemies do
				local enemy = enemies[i]
				if enemy:IsRealHero() and enemy:GetHealthPercent() < 35  then 
					TargetAbilityCast( enemy )
				end		
			end
		end
	
	
	
		if NoTargetAbility2 ~= nil and NoTargetAbility2:IsFullyCastable()  then	--если абилка существует и её можно использовать
			if thisEntity:GetHealth() < ( thisEntity:GetMaxHealth() * 0.3 ) then 
				NoTargetAbility2Cast()
			end
		end
			
		if NoTargetAbility1 ~= nil and NoTargetAbility1:IsFullyCastable()  then	--если абилка существует и её можно использовать
			return NoTargetAbility1Cast()
		end

		if ItemAbility ~= nil and ItemAbility:IsFullyCastable()  then	--если предмет существует и её можно использовать
			if thisEntity:GetHealth() < ( thisEntity:GetMaxHealth() * 0.3 ) then 
				ItemAbilityCast()
			end
		end
		


	end
	
	return 0.5
	
end


function NoTargetAbility1Cast()
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),	--индекс кастера
		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,	-- тип приказа
		AbilityIndex = NoTargetAbility1:entindex(),	-- индекс способности
		Queue = false,
	})
	
	return 1.5
end

function NoTargetAbility2Cast()
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),	--индекс кастера
		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,	-- тип приказа
		AbilityIndex = NoTargetAbility2:entindex(), -- индекс способности
		Queue = false,
	})
	
	return 1.5
end



function TargetAbilityCast( enemy )

	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),	--индекс кастера
		OrderType = DOTA_UNIT_ORDER_CAST_TARGET,	-- тип приказа
		AbilityIndex = TargetAbility:entindex(), -- индекс способности
		TargetIndex = enemy:entindex(),
		Queue = false,
	})

	return 1.5
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


function FindItemAbility( hCaster, szItemName )	--необходимая утилита , без нее не будет работать функция FindItemAbility
	for i = 0, 5 do
		local item = hCaster:GetItemInSlot( i )
		if item then
			if item:GetAbilityName() == szItemName then
				return item
			end
		end
	end
end
