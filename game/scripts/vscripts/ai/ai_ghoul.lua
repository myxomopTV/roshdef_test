
function Spawn( entityKeyValues )
	local waypoint = Entities:FindByName( nil, "patrol_1_1") 
	if waypoint then 
--		waypoint = waypoint:GetAbsOrigin()
--			thisEntity:MoveToPositionAggressive( waypoint:GetAbsOrigin() )
--			thisEntity:SetInitialGoalEntity(waypoint)
--		AttackMove ( thisEntity, waypoint )
	else
		print("waypoint dont exist !!!")
	end
	local ent = Entities:FindByTarget(nil, waypoint:GetName())
	local ents = Entities:FindAllByTarget(waypoint:GetName())
	print("next_corner = "..waypoint.next_corner:GetName())
	for _,value in pairs(ents) do
		print(value:GetName())
	end
	PathGraph:DrawPaths(waypoint, nil, Vector(1,1,1))
	
	thisEntity:SetInitialWaypoint("patrol_3_1")
end


