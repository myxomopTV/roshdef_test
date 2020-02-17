
LinkLuaModifier( "modifier_roshan_inherit_buff_datadriven_crit_buff", "heroes/hero_roshan/roshan_inherit_buff.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_roshan_inherit_buff_datadriven", "heroes/hero_roshan/roshan_inherit_buff.lua", LUA_MODIFIER_MOTION_NONE )

--Increases the stack count of Flesh Heap.
function DamageTargets( keys )
    local caster = keys.caster
	local target = keys.target
    local ability_index = keys.ability
	local damage = 	ability_index:GetSpecialValueFor( "damage" )
	local damage_per_stack = ability_index:GetSpecialValueFor( "damage_per_stack" )
    local StackModifier = "modifier_roshan_inherit_buff_datadriven"
    local currentStacks = keys.caster:GetModifierStackCount(StackModifier, ability_index)
	local ability_damage = damage + damage_per_stack*currentStacks
	
	ApplyDamage({attacker = caster, victim = target, ability = ability_index, damage = ability_damage, damage_type = DAMAGE_TYPE_MAGICAL})

	local damage_table = {}

	damage_table.attacker = caster
	damage_table.victim = target
	damage_table.damage_type = DAMAGE_TYPE_MAGICAL
	damage_table.ability = ability_index
	damage_table.damage = ability_damage

--	ApplyDamage(damage_table)
end
