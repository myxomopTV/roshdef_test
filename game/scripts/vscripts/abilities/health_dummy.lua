
function DummyDamage( event )
	local target = event.target
	local caster = event.caster
	local current_health = caster:GetHealth()
	if current_health < 1 then
		caster:Kill(nil, target)
	else
		caster:SetHealth(current_health - 1)
	end
end
