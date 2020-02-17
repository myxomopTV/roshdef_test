function OnStartTouch(data)
	local triggerName = thisEntity:GetName()
	local ent_index = thisEntity:entindex()
	local unit_name = unit:GetUnitName()
	local team = unit:GetTeam()
	local unit = data.activator

	if not thisEntity:IsTouching(unit) or team == DOTA_TEAM_NEUTRALS or unit:IsRealHero() then
		return
	end

	if unit.trigger_touch == nil then
		unit.trigger_touch = {}
		unit.trigger_count = 0
	end

	if unit.trigger_touch[ent_index] == nil then
		unit.trigger_touch[ent_index] = true
		unit.trigger_count = unit.trigger_count + 1
	end
	print("trigger_count = "..unit.trigger_count)

end

function OnEndTouch(data)
	local triggerName = thisEntity:GetName()
	local ent_index = thisEntity:entindex()
	local unit_name = unit:GetUnitName()
	local team = unit:GetTeam()
	local unit = data.activator

	if team == DOTA_TEAM_NEUTRALS or unit:IsRealHero() then
		return
	end	

	if unit.trigger_touch[ent_index] and not thisEntity:IsTouching(unit)  then
		unit.trigger_touch[ent_index] = nil
		unit.trigger_count = unit.trigger_count - 1
		print("trigger_count = "..unit.trigger_count)
		if unit.trigger_count == 0 and not unit.toss then
			unit:ForceKill(false)
		end
	end
	if not thisEntity:IsTouching(unit) then
		return
	end
	
end