--[[Author: Pizzalol
	Date: 14.02.2016.
	Keeps track of the casters health]]
function CreateGoodCandy( keys )
	local caster = keys.caster
	caster:SetHealth(caster:GetHealth()-1)
	local ability = keys.ability
	local loot_duration = ability:GetSpecialValueFor("candy_duration")
	local spawnPoint = caster:GetAbsOrigin()
	
	local newItem = CreateItem( "item_good_candy", nil, nil )
	local drop = CreateItemOnPositionForLaunch( spawnPoint, newItem )
	local dropRadius = RandomFloat( 50, 100 )

	newItem:LaunchLootInitialHeight( false, 0, 150, 0.5, spawnPoint + RandomVector( dropRadius ) )
	newItem:SetContextThink( "KillLoot", function() return KillLoot( newItem, drop ) end, loot_duration )
	
end

function CreateBadCandy( keys )
	local caster = keys.caster
	caster:SetHealth(caster:GetHealth()-1)
	local ability = keys.ability
	local loot_duration = ability:GetSpecialValueFor("candy_duration")
	local spawnPoint = caster:GetAbsOrigin()
	
	local newItem = CreateItem( "item_bad_candy", nil, nil )
	local drop = CreateItemOnPositionForLaunch( spawnPoint, newItem )
	local dropRadius = RandomFloat( 50, 100 )

	newItem:LaunchLootInitialHeight( false, 0, 150, 0.5, spawnPoint + RandomVector( dropRadius ) )
	newItem:SetContextThink( "KillLoot", function() return KillLoot( newItem, drop ) end, loot_duration )
	
end

function KillLoot( item, drop )

	if drop:IsNull() then
		return
	end

	local nFXIndex = ParticleManager:CreateParticle( "particles/items2_fx/veil_of_discord.vpcf", PATTACH_CUSTOMORIGIN, drop )
	ParticleManager:SetParticleControl( nFXIndex, 0, drop:GetOrigin() )
	ParticleManager:SetParticleControl( nFXIndex, 1, Vector( 35, 35, 25 ) )
	ParticleManager:ReleaseParticleIndex( nFXIndex )
--	EmitGlobalSound("Item.PickUpWorld")

	UTIL_Remove( item )
	UTIL_Remove( drop )
end
