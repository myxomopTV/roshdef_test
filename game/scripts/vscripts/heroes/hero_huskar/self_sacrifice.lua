function SelfSacrificeDamage( keys )
    -- Variables
	local ability = keys.ability
	local caster = keys.caster
    local caster_health = caster:GetHealth()
    local health_cost = ability:GetLevelSpecialValueFor("health_cost_percent", (ability:GetLevel() - 1))

    local dmg_to_caster = caster_health * health_cost

    -- Compose the damage tables and apply them to the designated target
	
	local damage_table = {
							victim = caster,
							attacker = caster,
							damage = dmg_to_caster,
							damage_type = DAMAGE_TYPE_MAGICAL,
							damage_flags = DOTA_DAMAGE_FLAG_NON_LETHAL 
						}
    ApplyDamage(damage_table)
end