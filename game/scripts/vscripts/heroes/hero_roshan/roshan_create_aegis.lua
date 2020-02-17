
function DropItemWithTimer( keys )
	local caster = keys.caster
	local item_name = keys.item_name
	local spawnPoint = caster:GetAbsOrigin()	
	local newItem = CreateItem( item_name, nil, nil )
	local drop = CreateItemOnPositionForLaunch( spawnPoint, newItem )
	local dropRadius = RandomFloat( 50, 100 )

	newItem:LaunchLootInitialHeight( false, 0, 150, 0.5, spawnPoint + RandomVector( dropRadius ) )
end


