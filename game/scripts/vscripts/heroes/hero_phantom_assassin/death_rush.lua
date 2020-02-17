
function DeathRushInterval( event )
	local caster = event.caster	
	caster:SetHealth(1)

end

function DeathRushEnd( event )
	local caster = event.caster
	caster:ForceKill(true)
	
end