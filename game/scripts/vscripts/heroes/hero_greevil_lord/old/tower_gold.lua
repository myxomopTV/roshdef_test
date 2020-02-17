tower_lvl = 0

function AbilityLevelUp (keys)
	local ability = keys.ability
	local required_lvl = ability:GetSpecialValueFor("required_lvl")
--	print("tower_lvl = "..tower_lvl)
--	print("required_lvl = "..required_lvl)
	Timers:CreateTimer(0.01,function()
		if tower_lvl >= required_lvl then
--			ability:SetLevel(1)
		else
--			ability:SetLevel(0)
		end	
	end)
end


function TowerLvlUp()
	tower_lvl = tower_lvl + 1
	print("tower_lvl = "..tower_lvl)
end

function CreateWorker(event)
	local caster = event.caster
	local point = caster:GetAbsOrigin()
	local player = caster:GetPlayerOwnerID()
	local hero = PlayerResource:GetSelectedHeroEntity(player)
	local ability = event.ability

	local unit_name = "npc_dota_greevil_worker"

	local unit = CreateUnitByName(unit_name, point, true, caster, caster, caster:GetTeamNumber())
	unit:AddNewModifier(caster, ability, "modifier_phased", {duration = 0.1})
	unit:SetControllableByPlayer(player, true)
	unit:SetOwner(hero)
	
	for i=0,9 do
		local ability = unit:GetAbilityByIndex(i)
		if ability then
			local required_lvl = ability:GetSpecialValueFor("required_lvl")
			if tower_lvl >= required_lvl then
				ability:SetLevel(1)
			else
				ability:SetLevel(0)
			end	
		end
	end

end
