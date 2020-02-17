
DONATE_SET_ROSHAN = {
	players = {
--		1002691281,
	},
}

DONATE_ITEMS = {
	heroes = {
		{
			name = "item_broodmother_essence",
			can_be_bought = true,
			free_available = true,
			count = 1,
			sets = {
				DONATE_SET_ROSHAN,
			},
		},
	},
	artifacts = {
		{
			name = "item_ventors_gamble",
			can_be_bought = true,
			free_available = true,
			count = 1,
			sets ={
				DONATE_SET_ROSHAN,
			},
		},
		{
			name = "item_bonus_effect_green",
			can_be_bought = true,
			free_available = true,
			count = 1,
			sets ={
				DONATE_SET_ROSHAN,
			},
		},
		{
			name = "item_bonus_effect_blue",
			can_be_bought = true,
			free_available = true,
			count = 1,
			sets ={
				DONATE_SET_ROSHAN,
			},
		},
		{
			name = "item_bonus_effect_pink",
			can_be_bought = true,
			free_available = true,
			count = 1,
			sets ={
				DONATE_SET_ROSHAN,
			},
		},
		{
			name = "item_bonus_tier_legendary",
			can_be_bought = true,
			free_available = true,
			count = 1,
			sets ={
				DONATE_SET_ROSHAN,
			},
		},
		{
			name = "item_bonus_tier_divine",
			can_be_bought = true,
			free_available = true,
			count = 1,
			sets ={
				DONATE_SET_ROSHAN,
			},
		},
	},
}

Donate = Donate or class({})

function Donate:OnGameRulesStateChange()
	if GameRules:State_Get() == DOTA_GAMERULES_STATE_CUSTOM_GAME_SETUP then
		self.players = {}
		for p = 0, PlayerResource:GetPlayerCount() - 1 do
			self.players[p] = {}
			local acc_id = PlayerResource:GetSteamAccountID( p )
			local player = self.players[p]

			if acc_id then
				for list, items in pairs( DONATE_ITEMS ) do
					for _, item in pairs( items ) do
						local item_info = {
							name = item.name,
							sets = {}
						}
						local player_has = item.free_available or nil
						for _, set in pairs( item.sets ) do
							for _, id in pairs( set.players or {} ) do
								if id == acc_id then
									player_has = true
								end
							end
							if set.name and set.can_be_bought then
								local set_info = {
									name = set.name,
									can_be_bought = set.can_be_bought,
									prices = set.prices
								}
								table.insert( item_info.sets, set_info )
							end
						end

						if item.can_be_bought or player_has then
							player[list] = player[list] or {}

							if player_has then
								item_info.count = item.count
							else
								item_info.count = -1
							end
							table.insert( player[list], item_info )
						end
					end
				end
			end
			self:UpdateNetTables( p )
		end
	end
end

function Donate:UpdateNetTables( pId )
	CustomNetTables:SetTableValue( "donate", tostring( pId ), self.players[pId] )
end

function Donate:PlayerTake( info )
	local use = CustomNetTables:GetTableValue( "donate", 'GLOBAL')
	use = use and use.use_donate == 0
	if use then return end

	local self = Donate

	local player_data = self.players[info.id]
	if not player_data then return end

	local player = PlayerResource:GetPlayer( info.id )

	if player and player:GetAssignedHero() then
		for _, l in pairs( player_data ) do
			for _, i in pairs( l ) do
				if i.name == info.itemname and i.count > 0 then
					local hero = player:GetAssignedHero()
					for ii = 0, 8 do
						if not hero:GetItemInSlot( ii ) then
							player:GetAssignedHero():AddItemByName( i.name )
							i.count = i.count - 1
							self:UpdateNetTables( info.id )
							return
						end
					end
				end
			end
		end
	end
end

function addItemByEnum(players_enum,item_name,steamID,npc)
	for _,enum in pairs(players_enum) do
		addItemBySteamID(enum,item_name,steamID,npc)
	end
end

function addItemBySteamID(enum,item_name,steamID,npc)
	for _,ID in pairs(enum) do
		if steamID == ID then
			Timers:CreateTimer(1,function() npc:AddItemByName(item_name) end)
		end
	end
end

function addModifierBySteamID(enum,modifier_name,steamID,npc)
	for _,ID in pairs(enum) do
		if steamID == ID then
			Timers:CreateTimer(1,function() npc:AddNewModifier( npc, nil, modifier_name, nil) end)
		end
	end
end

function Donate:DonateStateUpdate(data)
	local amount = 0
	for i = 0, DOTA_MAX_PLAYERS - 1 do
		if PlayerResource:IsValidPlayer(i) then
			amount = amount + 1
			if amount > 1 then
				return
			end
		end
	end
	local use = CustomNetTables:GetTableValue( "donate", 'GLOBAL')
	use = use and use.use_donate == 1
	CustomNetTables:SetTableValue( "donate", 'GLOBAL', {
		use_donate = not use,
	} )
end

-- Кто так писал? УЖАС
ListenToGameEvent( "game_rules_state_change", Dynamic_Wrap( Donate, "OnGameRulesStateChange" ), Donate )
CustomGameEventManager:RegisterListener( "donate_player_take", Dynamic_Wrap( Donate, "PlayerTake" ) )

--	Update Donate State
CustomGameEventManager:RegisterListener( "donate_state_update", Dynamic_Wrap( Donate, "DonateStateUpdate" ) )
