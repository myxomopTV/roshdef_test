
function OnAttackLanded(data)
	local target = data.target
	if target:IsMagicImmune() or target:IsBuilding() then
		return
	end
	
	local damage = 	RandomInt(data.ability:GetSpecialValueFor("damage_min"), data.ability:GetSpecialValueFor("damage_max"))
	local damage_table = {}

	damage_table.attacker = data.caster
	damage_table.victim = target
--	damage_table.damage_type = DAMAGE_TYPE_PURE
	damage_table.ability = data.ability
	damage_table.damage = damage
	damage_table.damage_type = DAMAGE_TYPE_MAGICAL -- Doesnt trigger abilities and items that get disabled by damage

	ApplyDamage(damage_table)
	PopupDamageOverTime(target, damage)
	
end
