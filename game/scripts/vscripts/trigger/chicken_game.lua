
function ComeOut( keys )

	local target = keys.activator
	local player = target:GetPlayerOwnerID()
	
	local point_name = "roshan_team_start_point"
	local modifier = "modifier_item_chicken_game_ticket"
	local point =  Entities:FindByName( nil, point_name):GetAbsOrigin()


	if target:HasModifier(modifier) then
		return
	end
	
	FindClearSpaceForUnit(target, point, false)
	PlayerResource:SetCameraTarget(player, target)
	Timers:CreateTimer(0.1, function()
		PlayerResource:SetCameraTarget(player, nil) -- Чтобы камера разблочилась, т.к. она начинает следовать за игроком постоянно.
	end)	
end
