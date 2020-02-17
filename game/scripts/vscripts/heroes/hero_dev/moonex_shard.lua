--[My First Lua Expirience]
function AddStack(keys)
	local caster = keys.caster
	local ability = keys.ability
	local modifier = "modifier_moon_shard_consumed"
	local dur = inf
	if caster:HasModifier( modifier ) then
		local current_stack = caster:GetModifierStackCount( modifier, ability )
		ability:ApplyDataDrivenModifier( caster, caster, modifier, { Duration = dur })
		caster:SetModifierStackCount( modifier, ability, current_stack + 1 )
	else
		ability:ApplyDataDrivenModifier( caster, caster, modifier, { Duration = dur })
		caster:SetModifierStackCount( modifier, ability, 1 )
	end
end