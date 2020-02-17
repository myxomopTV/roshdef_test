LinkLuaModifier("modifier_junior_grow", "items/custom/meat.lua", LUA_MODIFIER_MOTION_NONE)



function SetStacks( keys )

	local ability = keys.ability
	local caster = keys.caster
	local target = keys.target
	local stacks = ability:GetSpecialValueFor( "stacks" )
	local StackModifier = "modifier_junior_grow"
	local grow_ability = target:FindAbilityByName("junior_grow") 

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
			local name
			local child_fw = target:GetForwardVector()
	
			if 			target:GetUnitName() == "npc_dota_troll_junior" 	then name = "npc_dota_troll_adult" 
			elseif 		target:GetUnitName() == "npc_dota_ogre_junior" 	then name = "npc_dota_ogre_adult"
			elseif 		target:GetUnitName() == "npc_dota_dragon_junior" then name = "npc_dota_dragon_adult" 
			elseif 		target:GetUnitName() == "npc_dota_kobold_junior" then name = "npc_dota_kobold_adult"
			elseif 		target:GetUnitName() == "npc_dota_wolf_junior" 	then name = "npc_dota_wolf_adult"
			elseif 		target:GetUnitName() == "npc_dota_centaur_junior"then name = "npc_dota_centaur_adult"
			elseif 		target:GetUnitName() == "npc_dota_golem_junior" 	then name = "npc_dota_golem_adult"
			elseif 		target:GetUnitName() == "npc_dota_ursa_junior" 	then name = "npc_dota_ursa_adult" 
			elseif 		target:GetUnitName() == "npc_dota_satyr_junior" 	then name = "npc_dota_satyr_adult"
			elseif 		target:GetUnitName() == "npc_dota_lizard_junior" 	then name = "npc_dota_lizard_adult"
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
modifier_junior_grow = modifier_junior_grow or class({})
function modifier_junior_grow:IsDebuff() return false end
function modifier_junior_grow:IsBuff() return true end
function modifier_junior_grow:IsHidden() return false end
function modifier_junior_grow:IsPurgable() return false end
function modifier_junior_grow:IsStunDebuff() return false end
function modifier_junior_grow:RemoveOnDeath() return true end
-------------------------------------------
function modifier_junior_grow:GetTextureName() 
return "child/junior_grow" 
end

