function OnStartTouch( data )	
	local unit = data.activator
	local player = unit:GetPlayerOwnerID()
	
	local point = Entities:FindByName( nil, "roshan_team_start_point"):GetAbsOrigin()
	

	if unit.event or unit.avatar or unit:GetTeam() == DOTA_TEAM_NEUTRALS or unit:IsBuilding() then
		return
	end

	FindClearSpaceForUnit(unit, point, false)
	if unit:IsRealHero() then
		PlayerResource:SetCameraTarget(player, unit)
		Timers:CreateTimer(0.1, function()
			PlayerResource:SetCameraTarget(player, nil) 
		end)
	end
end

