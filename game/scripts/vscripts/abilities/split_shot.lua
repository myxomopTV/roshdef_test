function SplitShot(data)

	local caster = data.caster
	local target = data.target
	local ability = data.ability
	local attack_range = caster:Script_GetAttackRange() + 100
	local arrow_count = ability:GetSpecialValueFor("arrow_count")

	local units = FindUnitsInRadius(caster:GetTeamNumber(), 
									caster:GetAbsOrigin(),
									nil,
									attack_range,
									DOTA_UNIT_TARGET_TEAM_ENEMY,
									DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP, 
									DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE,
									FIND_CLOSEST, 
									false) 
	
	if ability.split == nil then
		ability.split = true
	elseif ability.split == false then
		return
	end
	
	ability.split = false 
	if arrow_count > #units-1  then 
		arrow_count = #units-1
	end

	local index = 1
	local arrow_deal = 0
	
	while arrow_deal < arrow_count   do
		if units[index] == target then
			print("bingo!!!")
		else
			caster:PerformAttack(units[ index ], false, true, true, false, true, false, false)
			arrow_deal = arrow_deal + 1
		end	
		index = index + 1
	end
	
	ability.split = true
		
end