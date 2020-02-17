
function WarriorAttack(keys)
	local ability = keys.ability
	local target = keys.target
	local caster = keys.caster
	local owner = caster:GetOwner()
	
	if owner and not target:IsBuilding() then
		local damage = ability:GetSpecialValueFor("str_dmg") * owner:GetAverageTrueAttackDamage(owner)/100
		DealDamage(owner, target, damage, DAMAGE_TYPE_PHYSICAL, DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION, ability)
	
	end
end

