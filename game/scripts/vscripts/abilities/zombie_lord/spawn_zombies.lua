function CheckZombieAura ( keys )
	local ability = keys.ability
	local caster = keys.caster
	local modifier_form = keys.modifier_form
	local modifier_thinker = keys.modifier_thinker
	local modifier_aura1 = keys.modifier_aura1
	local modifier_aura2 = keys.modifier_aura2

	if caster:HasModifier(modifier_form) then
		ability:ApplyDataDrivenModifier(caster, caster, modifier_aura2, nil)
		caster:RemoveModifierByName(modifier_thinker)
		caster:RemoveModifierByName(modifier_aura1)
	end
end

function SpawnZombie ( keys )
	local caster = keys.caster
	local targets = keys.target_entities
	local ability = keys.ability
	local unit_name = "npc_dota_zombie_lord_zombie"
	local team = caster:GetTeam()
	for _,target in pairs (targets) do
		local point = target:GetAbsOrigin()
		local unit = CreateUnitByName(unit_name, point, true, caster, caster, team)
--		unit:SetControllableByPlayer(caster:GetPlayerOwner(), true)	
	end

	
end