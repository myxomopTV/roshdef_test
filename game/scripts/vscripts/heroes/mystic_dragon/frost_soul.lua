

function DamageApply( keys )
	local caster = keys.caster
	local ability = keys.ability
	local target = keys.target
	local target_max_hp = target:GetHealth() / 100
	local max_hp_dmg = ability:GetSpecialValueFor("max_hp_dmg")
	
	local damage = target_max_hp*max_hp_dmg

	DealDamage(caster, target, damage, DAMAGE_TYPE_PURE, DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION, ability)
end