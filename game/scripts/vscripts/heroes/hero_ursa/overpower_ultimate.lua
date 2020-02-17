function BuffStackIncrement(params)
	local caster = params.caster
	local ability = params.ability
	local modifier_buff = params.modifier_buff
	local previous_stack_count = 0

		if caster:HasModifier(modifier_buff) then
			previous_stack_count = caster:GetModifierStackCount(modifier_buff, caster)
			caster:SetModifierStackCount(modifier_buff, caster, previous_stack_count + 1)
		end

end



