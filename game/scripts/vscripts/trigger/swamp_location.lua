GameRules.swamp_active = false

function ComeOut( keys )
	local target = keys.activator
	local player = target:GetPlayerOwnerID()
	
	local point_name = "dire_forest_point_"..RandomInt(1, 2)
--	local modifier = "modifier_item_chicken_game_ticket"
	local point =  Entities:FindByName( nil, point_name):GetAbsOrigin()


	if GameRules.swamp_active then
		return
	end
	 
	FindClearSpaceForUnit(target, point, false)
	target:Stop()
	if not target:IsRealHero() then
		return
	end
	
	PlayerResource:SetCameraTarget(player, target)
	Timers:CreateTimer(0.1, function()
		PlayerResource:SetCameraTarget(player, nil) -- Чтобы камера разблочилась, т.к. она начинает следовать за игроком постоянно.
	end)	
end
