LinkLuaModifier("modifier_quest_banana", "abilities/quest/banana", LUA_MODIFIER_MOTION_NONE)

quest_banana = class({})

function quest_banana:GetIntrinsicModifierName()
	return "modifier_quest_banana"
end
--------------------------------------------------------
------------------------------------------------------------

modifier_quest_banana = class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
})
function modifier_quest_banana:OnCreated()
	if IsServer() then
		self:StartIntervalThink(0.1)
	end
end
function modifier_quest_banana:OnIntervalThink()
	local ability = self:GetAbility()
	local caster = self:GetCaster()
	local value_required = ability:GetSpecialValueFor("value_required")
	local reward_exp = ability:GetSpecialValueFor("reward_exp")
	local reward_gold = ability:GetSpecialValueFor("reward_gold")
	local quest_item = "item_banana"
	local reward_item = "item_reward_banana"
	
	local heroes = FindUnitsInRadius(caster:GetTeamNumber(), 
									caster:GetAbsOrigin(),
									nil,
									350,
									DOTA_UNIT_TARGET_TEAM_FRIENDLY,
									DOTA_UNIT_TARGET_HERO, 
									DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NO_INVIS,
									FIND_CLOSEST, 
									false)
	for i = 1, #heroes do
		local hero = heroes[1]
		for j = 0,8 do 
			local item = hero:GetItemInSlot(j)
			if item and item:GetName() == quest_item then
				local item_charges = item:GetCurrentCharges()
				if item_charges >= value_required then
					hero:RemoveItem( item )
					GiveExperiencePlayers( reward_exp )
					GiveGoldPlayers( reward_gold )
					EmitGlobalSound("gachi_oh_yeah")
					
					caster:DropQuestItem( hero, reward_item )					
					caster:RemoveAbility(ability:GetName())
					caster:AddAbility("quest_fish"):SetLevel(1)

				end
			end
		end
	end
end

function modifier_quest_banana:GetEffectName()
	return "particles/generic_gameplay/generic_has_quest.vpcf"
end

function modifier_quest_banana:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end
