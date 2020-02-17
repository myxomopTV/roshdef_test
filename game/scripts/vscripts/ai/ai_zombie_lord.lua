--LinkLuaModifier( "modifier_fow_vision", "modifiers/modifier_fow_vision", LUA_MODIFIER_MOTION_NONE )

function Spawn( entityKeyValues )
	if not IsServer() then
		return
	end

	if thisEntity == nil then
		return
	end

--	thisEntity:AddNewModifier( thisEntity, nil, "modifier_fow_vision", nil )

	NoTargetAbility1 = thisEntity:FindAbilityByName( "zombie_lord_decay" )

	thisEntity:SetContextThink( "ZombieLordThink", ZombieLordThink, 1 )
end

function ZombieLordThink()
	if ( not thisEntity:IsAlive() ) then
		return -1
	end
	
	if GameRules:IsGamePaused() == true then
		return 1
	end



	local enemies = FindUnitsInRadius( 
									thisEntity:GetTeamNumber(),
									thisEntity:GetOrigin(),
									nil,
									1000,
									DOTA_UNIT_TARGET_TEAM_ENEMY,
									DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
									DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NO_INVIS,
									FIND_CLOSEST,
									false )

	if #enemies > 0 then
		if NoTargetAbility1 ~= nil and NoTargetAbility1:IsFullyCastable() then
			return NoTargetAbility1Cast()
		end
	end	
	return 0.5
end


function NoTargetAbility1Cast()
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),	--индекс кастера
		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,	-- тип приказа
		AbilityIndex = NoTargetAbility1:entindex(), -- индекс способности
		Queue = false,
	})
	
	return 1
end

