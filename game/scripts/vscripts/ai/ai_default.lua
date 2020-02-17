
function Spawn( entityKeyValues )
	if thisEntity:GetTeam() ~= DOTA_TEAM_GOODGUYS then
		local waypoint = Entities:FindByName( nil, "d_waypoint20") -- Записываем в переменную 'waypoint' координаты бокса d_waypoint19
		if waypoint then 
			waypoint = waypoint:GetAbsOrigin()
--			thisEntity:MoveToPositionAggressive( waypoint:GetAbsOrigin() )
--			thisEntity:SetInitialGoalEntity(waypoint)
			AttackMove ( thisEntity, waypoint )
		else
			print("waypoint dont exist !!!")
		end
	else
		print("entity = good guys")
	end
	
end


