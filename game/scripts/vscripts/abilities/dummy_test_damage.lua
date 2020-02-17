
function ShowDamageTaken( event )
	-- Variables
	local damage = math.floor(event.DamageTaken)
	local caster = event.caster

	caster:SetBaseMaxHealth(caster:GetMaxHealth() + damage)
	caster:SetHealth(caster:GetMaxHealth())
	if caster:GetMaxHealth() > 100000000   then
		if caster:GetMaxHealth() < 101000000 then 
			local point = caster:GetAbsOrigin()
			local newItem = CreateItem( "item_imba_spell_fencer", nil, nil )
			local drop = CreateItemOnPositionSync( point, newItem )
			caster:RemoveSelf()	
		end
		caster:ForceKill(false)
	end


end

function ClearDamageFilter( event )
	local caster = event.caster


	caster:SetMaxHealth(1)
	caster:SetBaseMaxHealth(1)
	caster:SetHealth(1)
end
