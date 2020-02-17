LinkLuaModifier("modifier_child_grow", "items/custom/banana.lua", LUA_MODIFIER_MOTION_NONE)



function SetStacks( keys )

	local ability = keys.ability
	local caster = keys.caster
	local target = keys.target
	local stacks = ability:GetSpecialValueFor( "stacks" )
	local StackModifier = "modifier_child_grow"
	local grow_ability = target:FindAbilityByName("child_grow") 

	if grow_ability ~= nil then	
		local stack_limit = grow_ability:GetSpecialValueFor( "stack_limit" )
		local currentStacks = target:GetModifierStackCount(StackModifier, grow_ability)

		if currentStacks == 0 then
			target:AddNewModifier(caster, grow_ability, StackModifier, {})
			target:SetModifierStackCount(StackModifier, grow_ability, (currentStacks + stacks))
		else 
			target:SetModifierStackCount(StackModifier, grow_ability, (currentStacks + stacks))
		end

		if currentStacks+stacks>=stack_limit then
			local point = target:GetAbsOrigin()
			local team = target:GetTeam()
			local player = target:GetPlayerOwnerID()
			local hero   = PlayerResource:GetSelectedHeroEntity(player)
			local name	= ""
			local child_fw = target:GetForwardVector()
	
			if 			target:GetUnitName() == "npc_dota_troll_child" 	then name = "npc_dota_troll_junior" 
			elseif 		target:GetUnitName() == "npc_dota_ogre_child" 	then name = "npc_dota_ogre_junior"
			elseif 		target:GetUnitName() == "npc_dota_dragon_child" then name = "npc_dota_dragon_junior" 
			elseif 		target:GetUnitName() == "npc_dota_kobold_child" then name = "npc_dota_kobold_junior"
			elseif 		target:GetUnitName() == "npc_dota_wolf_child" 	then name = "npc_dota_wolf_junior"
			elseif 		target:GetUnitName() == "npc_dota_centaur_child"then name = "npc_dota_centaur_junior"
			elseif 		target:GetUnitName() == "npc_dota_golem_child" 	then name = "npc_dota_golem_junior"
			elseif 		target:GetUnitName() == "npc_dota_ursa_child" 	then name = "npc_dota_ursa_junior" 
			elseif 		target:GetUnitName() == "npc_dota_satyr_child" 	then name = "npc_dota_satyr_junior"
			elseif 		target:GetUnitName() == "npc_dota_lizard_child" 	then name = "npc_dota_lizard_junior"
			end
			target:ForceKill(true)
			target:AddNoDraw()
			local unit = CreateUnitByName( name, point, true, nil, nil, team )
				unit:SetOwner(hero)
				unit:SetControllableByPlayer(player, true)
				unit:SetForwardVector(child_fw)

		end
	end	
	

	
end


--------------------------------------------------------------------------------
--------------------------------------------------------------------------------


-------------------------------------------
modifier_child_grow = modifier_child_grow or class({})
function modifier_child_grow:IsDebuff() return false end
function modifier_child_grow:IsBuff() return true end
function modifier_child_grow:IsHidden() return false end
function modifier_child_grow:IsPurgable() return false end
function modifier_child_grow:IsStunDebuff() return false end
function modifier_child_grow:RemoveOnDeath() return true end
-------------------------------------------
function modifier_child_grow:GetTextureName() 
return "child/child_grow" 
end


