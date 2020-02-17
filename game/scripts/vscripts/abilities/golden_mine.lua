
function OnAttacked( event )
	local caster = event.caster
	local attacker = event.attacker
	local ability = event.ability
	
	if not attacker:IsRealHero() then
		return
	end
	
	ability.attacks_need = ability.attacks_need - 1
	if ability.attacks_need == 0 then
		caster:ForceKill(false)
	else
		caster:SetHealth(ability.attacks_need)
	end
	
end

function OnCreated( event )
	local caster = event.caster
	local ability = event.ability
	ability.attacks_need = ability:GetSpecialValueFor("attacks_need")
	caster:SetBaseMaxHealth(ability.attacks_need)
	caster:SetMaxHealth(ability.attacks_need)
	caster:SetHealth(ability.attacks_need)
end
