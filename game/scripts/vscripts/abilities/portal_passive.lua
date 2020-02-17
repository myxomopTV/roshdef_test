
function PortalCheck( keys )	
	local target = keys.target
	local player = target:GetPlayerOwnerID()
	
	local point
	

	if target:HasModifier("modifier_item_chicken_game_ticket") then
		point = Entities:FindByName( nil, "chicken_game_point"):GetAbsOrigin()
	end
	
	if not point then
		return
	end
--	target:SetAbsOrigin( point )
	FindClearSpaceForUnit(target, point, false)
	PlayerResource:SetCameraTarget(player, target)
	Timers:CreateTimer(0.1, function()
		PlayerResource:SetCameraTarget(player, nil) -- Чтобы камера разблочилась, т.к. она начинает следовать за игроком постоянно.
	end)
end

function PortalToPoint( keys )

	local target = keys.target
	local player = target:GetPlayerOwnerID()
	
	local point_name = keys.point_name
	local point =  Entities:FindByName( nil, point_name):GetAbsOrigin()

	
	FindClearSpaceForUnit(target, point, false)
	PlayerResource:SetCameraTarget(player, target)
	Timers:CreateTimer(0.1, function()
		PlayerResource:SetCameraTarget(player, nil) -- Чтобы камера разблочилась, т.к. она начинает следовать за игроком постоянно.
	end)	
end


function CheckModifier( keys )

	local target = keys.target
	local player = target:GetPlayerOwnerID()
	
	local point_name = keys.point_name
	local modifier = keys.modifier
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
