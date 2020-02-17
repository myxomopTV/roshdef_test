
-- Set the units looking at the same point of the caster
function SetUnitsMoveForward( event )
	local caster = event.caster
	local target = event.target
	local fv = caster:GetForwardVector()

target:SetForwardVector(fv)

	local ability = event.ability
	local armor_per_agility = ability:GetLevelSpecialValueFor("armor_per_agi", ability:GetLevel() - 1)
	local dmg_per_intellect = ability:GetLevelSpecialValueFor("dmg_per_int", ability:GetLevel() - 1)
	local hp_per_strenght = ability:GetLevelSpecialValueFor("hp_per_str", ability:GetLevel() - 1) 

	local strenght = caster:GetStrength()
	local agility = caster:GetAgility()
	local intellegence = caster:GetIntellect()

	target:SetBaseDamageMin(target:GetBaseDamageMin() + intellegence*dmg_per_intellect )
	target:SetBaseDamageMax(target:GetBaseDamageMax() + intellegence*dmg_per_intellect )				
	target:SetPhysicalArmorBaseValue(target:GetPhysicalArmorBaseValue() + agility*armor_per_agility )
	target:SetBaseMaxHealth(target:GetMaxHealth()+ strenght*hp_per_strenght )
--	target:SetHealth(target:GetMaxHealth())
--	unit:SetHealth(unit:GetMaxHealth())
	end


