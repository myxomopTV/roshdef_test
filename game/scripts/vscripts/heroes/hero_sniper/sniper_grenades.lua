

function MakeCharges(keys)
    local caster = keys.caster
	local ability = keys.ability
	local max_count		 = ability:GetSpecialValueFor("max_count")
	local start_count	 = ability:GetSpecialValueFor("max_count")
	local replenish_time = ability:GetSpecialValueFor("replenish_time")
	
    caster:AddNewModifier(caster, ability, "modifier_charges", 
		{max_count = max_count,
		start_count = start_count, 
		replenish_time = replenish_time}
	)
end