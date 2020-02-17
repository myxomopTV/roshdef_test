function BuffStackIncrement(params)
	local caster = params.caster
	local ability = params.ability
	local modifier_buff = params.modifier_buff
	local previous_stack_count = 0
		if caster:HasModifier(modifier_buff) then
			previous_stack_count = caster:GetModifierStackCount(modifier_buff, caster)
			
			--We have to remove and replace the modifier so the duration will refresh (so it will show the duration of the latest Essence Shift).
			caster:RemoveModifierByNameAndCaster(modifier_buff, caster)
		end
		ability:ApplyDataDrivenModifier(caster, caster, modifier_buff, nil)
		caster:SetModifierStackCount(modifier_buff, caster, previous_stack_count + 1)

end

function BuffStackOnDestroy(keys)
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local modifier = keys.modifier_buff

	if caster:HasModifier(modifier) then
		local previous_stack_count = caster:GetModifierStackCount(modifier, caster)
		if previous_stack_count > 1 then
			caster:SetModifierStackCount(modifier, caster, previous_stack_count - 1)
		else
			caster:RemoveModifierByNameAndCaster(modifier, caster)
		end
	end
end

function DebuffStackIncrement(params)
	local caster = params.caster
	local target = params.target
	local ability = params.ability
	local modifier = params.modifier_debuff
	local previous_stack_count = 0
	
		if target:HasModifier(modifier) then
			previous_stack_count = target:GetModifierStackCount(modifier, caster)
			
			--We have to remove and replace the modifier so the duration will refresh (so it will show the duration of the latest Essence Shift).
			target:RemoveModifierByNameAndCaster(modifier, caster)
		end
		ability:ApplyDataDrivenModifier(caster, target, modifier, nil)
		target:SetModifierStackCount(modifier, caster, previous_stack_count + 1)

end

function DebuffStackOnDestroy(keys)
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local modifier = keys.modifier_debuff

	if target:HasModifier(modifier) then
		local previous_stack_count = target:GetModifierStackCount(modifier, caster)
		if previous_stack_count > 1 then
			target:SetModifierStackCount(modifier, caster, previous_stack_count - 1)
		else
			target:RemoveModifierByNameAndCaster(modifier, caster)
		end
	end
end

function DamageApply( keys )
	local caster = keys.caster
	local ability = keys.ability
	local target = keys.target
	local target_max_hp = target:GetMaxHealth() / 100
	local aura_damage = ability:GetLevelSpecialValueFor("aura_damage", (ability:GetLevel() - 1))
	local aura_damage_interval = ability:GetLevelSpecialValueFor("aura_damage_interval", (ability:GetLevel() - 1))


	local damage_table = {}

	damage_table.attacker = caster
	damage_table.victim = caster
	damage_table.damage_type = DAMAGE_TYPE_PURE
	damage_table.ability = ability
	damage_table.damage = 1
	damage_table.damage_flags = DOTA_DAMAGE_FLAG_HPLOSS -- Doesnt trigger abilities and items that get disabled by damage

	ApplyDamage(damage_table)
end