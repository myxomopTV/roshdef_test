function DebuffTarget(params)
	local caster = params.caster
	local target = params.target
	local ability = params.ability
	local modifier_buff = params.modifier_buff
	local modifier_debuff = params.modifier_debuff

	if caster:HasModifier(modifier_buff) then			
			ability:ApplyDataDrivenModifier(caster, target, modifier_debuff, nil)
--			EmitSoundOn("hero_bloodseeker.rupture",target)
	end

end


