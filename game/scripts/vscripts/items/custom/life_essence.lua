LinkLuaModifier("modifier_veteran_grow", "items/custom/life_essence.lua", LUA_MODIFIER_MOTION_NONE)



function SetStacks( keys )

	local ability = keys.ability
	local caster = keys.caster
	local target = keys.target
	local stacks = ability:GetSpecialValueFor( "stacks" )
	local StackModifier = "modifier_veteran_grow"
	local grow_ability = target:FindAbilityByName("adult_grow") 

	local currentStacks = target:GetModifierStackCount(StackModifier, nil)

	if currentStacks == 0 then
		target:AddNewModifier(caster, nil, StackModifier, {})
		target:SetModifierStackCount(StackModifier, nil, (currentStacks + stacks))
	else 
		target:SetModifierStackCount(StackModifier, nil, (currentStacks + stacks))
	end
	if grow_ability ~= nil then
		local stack_limit = grow_ability:GetSpecialValueFor( "stack_limit" )
	
		if currentStacks+stacks>=stack_limit   then
			local point = target:GetAbsOrigin()
			local team = target:GetTeam()
			local player = target:GetPlayerOwnerID()
			local hero   = PlayerResource:GetSelectedHeroEntity(player)
			local name	= ""
			local child_fw = target:GetForwardVector()
	
			if 			target:GetUnitName() == "npc_dota_troll_adult" 	then name = "npc_dota_troll_veteran" 
			elseif 		target:GetUnitName() == "npc_dota_ogre_adult" 	then name = "npc_dota_ogre_veteran"
			elseif 		target:GetUnitName() == "npc_dota_dragon_adult" then name = "npc_dota_dragon_veteran" 
			elseif 		target:GetUnitName() == "npc_dota_kobold_adult" then name = "npc_dota_kobold_veteran"
			elseif 		target:GetUnitName() == "npc_dota_wolf_adult" 	then name = "npc_dota_wolf_veteran"
			elseif 		target:GetUnitName() == "npc_dota_centaur_adult"then name = "npc_dota_centaur_veteran"
			elseif 		target:GetUnitName() == "npc_dota_golem_adult" 	then name = "npc_dota_golem_veteran"
			elseif 		target:GetUnitName() == "npc_dota_ursa_adult" 	then name = "npc_dota_ursa_veteran" 
			elseif 		target:GetUnitName() == "npc_dota_satyr_adult" 	then name = "npc_dota_satyr_veteran"
			elseif 		target:GetUnitName() == "npc_dota_lizard_adult" 	then name = "npc_dota_lizard_veteran"
			end
			target:ForceKill(true)
			target:AddNoDraw()
			local unit = CreateUnitByName( name, point, true, nil, nil, team )
			unit:SetOwner(hero)
			unit:SetControllableByPlayer(player, true)
			unit:SetForwardVector(child_fw)
			
		end
	end	
	
	target:AddNewModifier(target, nil, "modifier_phased", {duration = 0.01})
	target:SetHealth(target:GetHealth()+ability:GetSpecialValueFor("bonus_hp"))
end


--------------------------------------------------------------------------------
--------------------------------------------------------------------------------


-------------------------------------------
modifier_veteran_grow = modifier_veteran_grow or class({})
function modifier_veteran_grow:IsDebuff() return false end
function modifier_veteran_grow:IsBuff() return true end
function modifier_veteran_grow:IsHidden() return false end
function modifier_veteran_grow:IsPurgable() return false end
function modifier_veteran_grow:IsStunDebuff() return false end
function modifier_veteran_grow:RemoveOnDeath() return false end
-------------------------------------------
function modifier_veteran_grow:GetTexture() 
return "item_life_essence" 
end


function modifier_veteran_grow:DeclareFunctions()
	local decFuns =
		{
			MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,
--			MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
			MODIFIER_PROPERTY_EXTRA_HEALTH_BONUS
		}
	return decFuns
end

function modifier_veteran_grow:GetModifierBaseAttack_BonusDamage()
	return self:GetStackCount()*3
end

--function modifier_veteran_grow:GetModifierPhysicalArmorBonus()
--	return self:GetStackCount()*0.5
--end

function modifier_veteran_grow:GetModifierExtraHealthBonus()
	return self:GetStackCount()*50
end


