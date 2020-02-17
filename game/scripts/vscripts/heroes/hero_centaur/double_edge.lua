
function DoubleEdge( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local helix_modifier = keys.helix_modifier
	local radius = ability:GetSpecialValueFor("radius")
	local base_dmg = ability:GetSpecialValueFor("base_dmg")
	local str_dmg = ability:GetSpecialValueFor("str_dmg")/100
	local damage = caster:GetStrength() * str_dmg + base_dmg
	local current_mana  = caster:GetMana()
	local mana_required = ability:GetManaCost(-1)

	if target:IsBuilding() then
	return end
	
	if current_mana > mana_required then
	
		caster:SetMana(current_mana - mana_required)
		EmitSoundOn("Hero_Centaur.DoubleEdge",target)
		
		local effect = "particles/units/heroes/hero_centaur/centaur_double_edge.vpcf"
		local pfx = ParticleManager:CreateParticle(effect, PATTACH_ABSORIGIN_FOLLOW, target)
		ParticleManager:SetParticleControl(pfx, 0, target:GetAbsOrigin()) -- Origin
		ParticleManager:SetParticleControl(pfx, 1, target:GetAbsOrigin()) -- Destination
		ParticleManager:SetParticleControl(pfx, 5, target:GetAbsOrigin()) -- Hit Glow

		local enemies = FindUnitsInRadius(caster:GetTeam(), 
										target:GetAbsOrigin(), 
										nil, 
										radius, 
										DOTA_UNIT_TARGET_TEAM_ENEMY, 
										DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, 
										DOTA_UNIT_TARGET_FLAG_NONE, 
										FIND_ANY_ORDER, false)
		
		for i=1,#enemies do
			local enemy = enemies[i]
			DealDamage(caster, enemy, damage, DAMAGE_TYPE_PHYSICAL, nil, ability)
			
		end
	else
		ability:ToggleAbility()
	end
end