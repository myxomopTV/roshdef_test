LinkLuaModifier("modifier_quest_template", "abilities/quest/quest_template", LUA_MODIFIER_MOTION_NONE)

quest_template = class({})

function quest_template:GetIntrinsicModifierName()
	return "modifier_quest_template"
end
--------------------------------------------------------
------------------------------------------------------------

modifier_quest_template = class({
	IsHidden 				= function(self) return false end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return true end,
	GetAttributes 			= function(self) return MODIFIER_ATTRIBUTE_MULTIPLE end,
})

function modifier_quest_template:OnCreated()
	if IsServer() then
		local ability = self:GetAbility()
		self.value_required	= ability:GetSpecialValueFor("value_required")
		self.reward_exp 	= ability:GetSpecialValueFor("reward_exp")
		self.reward_gold 	= ability:GetSpecialValueFor("reward_gold")
--		self.value_required	= ability.value_required
--		self.reward_exp 	= ability.reward_exp
--		self.reward_gold 	= ability.reward_gold
		self.quest_item 	= ability.quest_item
		self.reward_item 	= ability.reward_item
		self.particle  		= ability.particle
		self.current_quest  = ability:GetName()
		self.next_quest  	= ability.next_quest
		self.reusable  		= ability.reusable

		if self.particle == 1 then
			local parent = self:GetParent()
			local effect = "particles/generic_gameplay/generic_has_quest.vpcf"
			local pfx = ParticleManager:CreateParticle(effect, PATTACH_OVERHEAD_FOLLOW, parent)
			self:AddParticle(pfx, true, false, 111, false, false)

		end
		print(self.value_required)
		print(self.reward_exp)
		print(self.reward_gold)
		print(self.quest_item)
		print(self.reward_item)
		print(self.particle)
		print(self.current_quest)
		print(self.next_quest)
		print(self.reusable)

		self:StartIntervalThink(0.1)		
	end
end

function modifier_quest_template:OnIntervalThink()
	local parent = self:GetParent()
	
	local heroes = FindUnitsInRadius(parent:GetTeamNumber(), 
									parent:GetAbsOrigin(),
									nil,
									350,
									DOTA_UNIT_TARGET_TEAM_BOTH,
									DOTA_UNIT_TARGET_HERO, 
									DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NO_INVIS,
									FIND_CLOSEST, 
									false)
	for i = 1, #heroes do
		local hero = heroes[1]
		for j = 0,9 do 
			local item = hero:GetItemInSlot(j)
			if item and item:GetName() == self.quest_item then
				local item_charges = item:GetCurrentCharges()
				if self.value_required < 2 or item_charges >= self.value_required then
					hero:RemoveItem( item )
					if self.reward_exp > 0 then
						hero:GiveExperiencePlayers( self.reward_exp )
					end
					if self.reward_gold > 0 then
						hero:GiveGoldPlayers( self.reward_gold )
					end
					EmitGlobalSound("gachi_oh_yeah")
					
					if self.reward_item then
						parent:DropQuestItem( hero, self.reward_item )
					end
					if self.reusable == 0 then
						if self.current_quest then
							parent:RemoveAbility(self.current_quest)
							self:Destroy()
						end
						if self.next_quest then
							parent:AddAbility(self.next_quest):SetLevel(1)
						end
					end
				end
			end
		end
	end
end

quest_test1 = class(quest_template)

function quest_test1:Spawn()
	self.quest_item 	= "item_clarity"	-- название предмета, который нужен для завершения задания
	self.reward_item 	= "item_enchanted_mango" -- название предмета, который получен за прохождение задания(опционально)
	self.particle 		= 1	-- нужен ли эффект над головой ? 1 - да, 0 - нет
	self.next_quest 	= "quest_test2" -- название следующего квеста (опционально)
	self.reusable 		= 0 -- данный квест можно выполнять много кратно. 0 - нет, 1 - да
end

quest_test2 = class(quest_template)

function quest_test2:Spawn()
	self.quest_item 	= "item_belt_of_strength"	-- название предмета, который нужен для завершения задания
	self.reward_item 	= "item_ogre_axe" -- название предмета, который получен за прохождение задания(опционально)
	self.particle 		= 0	-- нужен ли эффект над головой ? 1 - да, 0 - нет
	self.next_quest 	= nil -- название следующего квеста (опционально)
	self.reusable 		= 1 -- данный квест можно выполнять много кратно. 0 - нет, 1 - да
end
---------------------------------------------------------------
---------------------------------------------------------------

function OnQuestCreated(data)
	Timers:CreateTimer(0, function()
		local ability = data.ability
		local caster = data.caster

		ability.quest_item 		= data.quest_item or nil
		ability.reward_item 	= data.reward_item or nil
		ability.particle 		= data.particle or nil
		ability.next_quest 		= data.next_quest or nil
		ability.reusable 		= data.reusable or nil

		caster:AddNewModifier(caster, ability, "modifier_quest_template", nil)
	end)
end
---------------------------------------------------------------
---------------------------------------------------------------

function CDOTA_BaseNPC:DropQuestItem( target, item_name )
	local unit = self			
	local spawnPoint = unit:GetAbsOrigin()	
	local newItem = CreateItem( item_name, nil, nil )
	local drop = CreateItemOnPositionForLaunch( spawnPoint, newItem )
	local initialPoint = target:GetAbsOrigin() + RandomVector( RandomFloat( 50, 125 ) )

	newItem:LaunchLootInitialHeight( false, 0, 150, 0.75, initialPoint )
end

function CDOTA_BaseNPC:GiveGoldPlayers( gold )
	local team = self:GetTeam()
	for index=0 ,9 do
		if PlayerResource:HasSelectedHero(index) then
			local player = PlayerResource:GetPlayer(index)
			local hero = PlayerResource:GetSelectedHeroEntity(index)
			local hero_team = hero:GetTeam()
			if hero_team == team then
				hero:ModifyGold(gold, false, 0)
				SendOverheadEventMessage( player, OVERHEAD_ALERT_GOLD, hero, gold, nil )
			end
		end
	end
end

function CDOTA_BaseNPC:GiveExperiencePlayers( experience )
	local team = self:GetTeam()
	for index=0 ,9 do
		if PlayerResource:HasSelectedHero(index) then
			local player = PlayerResource:GetPlayer(index)
			local hero = PlayerResource:GetSelectedHeroEntity(index)
			local hero_team = hero:GetTeam()
			if hero_team == team then
				hero:AddExperience(experience, 0, false, true )
			end
		end
	end
end
