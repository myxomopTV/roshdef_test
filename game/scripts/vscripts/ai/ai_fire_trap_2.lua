function Spawn()
	if not IsServer() then
		return
	end

	if thisEntity == nil then
		return
	end

	local npc = thisEntity
	local start_timer = 0.75
	local interval = 2.25

	local npc_name = npc:GetName()
	local target_name = npc_name.."_target"
	npc.target = Entities:FindByName(nil, target_name)
	if npc.target then
		print(target_name) 
	end

	Timers:CreateTimer(start_timer,function()
		local fireTrap = npc:FindAbilityByName("breathe_fire_alt")
		npc:CastAbilityOnPosition(npc.target:GetOrigin(), fireTrap, -1 )
		return interval
	
	end)
end


