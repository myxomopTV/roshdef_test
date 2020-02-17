
function TemplePortalExitTouch( keys )
	local target = keys.activator
	local player = target:GetPlayerOwnerID()
	
	local point_name = "temple_portal_end"
--	local modifier = "modifier_item_chicken_game_ticket"
	local point =  Entities:FindByName( nil, point_name):GetAbsOrigin()
	
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

function TemplePortalTouch( keys )
	local target = keys.activator
	local player = target:GetPlayerOwnerID()
	
	local point_name = "temple_portal_point"
--	local modifier = "modifier_item_chicken_game_ticket"
	local point =  Entities:FindByName( nil, point_name):GetAbsOrigin()

	
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
