
-- Set the units looking at the same point of the caster
function SetUnitsMoveForward( event )
	local caster = event.caster
	local target = event.target


	local ability = event.ability
	local ability_level = ability:GetLevel() - 1
	local summon_ability1= target:FindAbilityByName("beastmaster_boar_crit")
		  summon_ability1:SetLevel(ability_level+1)
	local summon_ability2= target:FindAbilityByName("true_strike_datadriven")
		  if ability_level>4 then summon_ability2:SetLevel(1) 
		  else summon_ability2:SetLevel(0) end

	local armor_per_agility = ability:GetLevelSpecialValueFor("armor_per_agi", ability:GetLevel() - 1)
	local dmg_per_intellect = ability:GetLevelSpecialValueFor("dmg_per_int", ability:GetLevel() - 1)
	local hp_per_strenght = ability:GetLevelSpecialValueFor("hp_per_str", ability:GetLevel() - 1) 

	local strenght = caster:GetStrength()
	local agility = caster:GetAgility()
	local intellegence = caster:GetIntellect()

	local base_hp = ability:GetLevelSpecialValueFor("summon_hp", ability_level)
	local base_dmg = ability:GetLevelSpecialValueFor("summon_dmg", ability_level)
	local bat = ability:GetLevelSpecialValueFor("summon_bat", ability_level)
	local fv = caster:GetForwardVector()
	target:SetForwardVector(fv)
	
	target:SetBaseDamageMin(base_dmg + intellegence*dmg_per_intellect )
	target:SetBaseDamageMax(base_dmg + intellegence*dmg_per_intellect )				
	target:SetPhysicalArmorBaseValue( agility*armor_per_agility )
	target:SetBaseMaxHealth(base_hp+ strenght*hp_per_strenght )
	target:SetBaseAttackTime(bat)

--	target:SetHealth(target:GetMaxHealth())
--	unit:SetHealth(unit:GetMaxHealth())
end


