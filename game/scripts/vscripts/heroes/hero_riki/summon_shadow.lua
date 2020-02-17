

function ShadowSpawn( event )
	local caster = event.caster
	local unit = event.target
	local player = caster:GetPlayerID()
	local ability = event.ability
	local level = ability:GetLevel()
	local fv = caster:GetForwardVector()

unit:SetForwardVector(fv)

	local hp_per_agility = ability:GetLevelSpecialValueFor("hp_per_agility", ability:GetLevel() - 1)
	local armor_per_agility = ability:GetLevelSpecialValueFor("armor_per_agility", ability:GetLevel() - 1)
	local dmg_per_agility = ability:GetLevelSpecialValueFor("dmg_per_agility", ability:GetLevel() - 1) 
	
	-- Set the unit name, concatenated with the level number
	local apm = caster:GetAttacksPerSecond()
	local bat 
	if apm > 10 then bat = 0.1 else bat = 1/apm end
	local agility = caster:GetAgility()
	local new_hp = unit:GetMaxHealth()+ agility*hp_per_agility

		unit:SetBaseDamageMin(unit:GetBaseDamageMin() + agility*dmg_per_agility )
		unit:SetBaseDamageMax(unit:GetBaseDamageMax() + agility*dmg_per_agility )				
		unit:SetPhysicalArmorBaseValue(unit:GetPhysicalArmorBaseValue() + agility*armor_per_agility )
		unit:SetMaxHealth( new_hp )
		unit:SetBaseMaxHealth( new_hp )
		unit:SetHealth( new_hp )
		
		unit:SetBaseAttackTime(bat)

		-- Apply the synergy buff if the ability existt
		-- Learn its abilities: return lvl 2, entangle lvl 3, demolish lvl 4. By Index
end


