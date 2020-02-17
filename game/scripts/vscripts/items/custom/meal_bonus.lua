
function SetMealBonus( keys )

	local ability = keys.ability
	local target = keys.target
	local meal_bonus = ability:GetSpecialValueFor( "heal" )/2
	
	if target:GetUnitName() == "npc_dota_roshan1" then
		local current_health = target:GetHealth() + meal_bonus
		local max_health = target:GetMaxHealth() + meal_bonus
		target:SetBaseMaxHealth(max_health)
		target:SetMaxHealth(max_health)
		target:SetHealth(current_health)
	end

	
end



