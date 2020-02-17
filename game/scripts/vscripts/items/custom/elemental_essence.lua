LinkLuaModifier("modifier_veteran_grow_fire", "items/custom/elemental_essence.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_veteran_grow_water", "items/custom/elemental_essence.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_veteran_grow_air", "items/custom/elemental_essence.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_veteran_grow_earth", "items/custom/elemental_essence.lua", LUA_MODIFIER_MOTION_NONE)



function FireSetStacks( keys )

	local ability = keys.ability
	local caster = keys.caster
	local target = keys.target
	local stacks = ability:GetSpecialValueFor( "stacks" )
	local StackModifier = "modifier_veteran_grow_fire"
	local grow_ability = target:FindAbilityByName("veteran_grow_fire") 

		local currentStacks = target:GetModifierStackCount(StackModifier, nil)

		if currentStacks == 0 then
			target:AddNewModifier(caster, nil, StackModifier, {})
			target:SetModifierStackCount(StackModifier, nil, (currentStacks + stacks))
		else 
			target:SetModifierStackCount(StackModifier, nil, (currentStacks + stacks))
		end
	if grow_ability ~= nil then
		local stack_limit = grow_ability:GetSpecialValueFor( "stack_limit" )

		if currentStacks+stacks>=stack_limit then
			local point = target:GetAbsOrigin()
			local team = target:GetTeam()
			local player = target:GetPlayerOwnerID()
			local hero   = PlayerResource:GetSelectedHeroEntity(player)
			local name	= ""
			local child_fw = target:GetForwardVector()
	
			if 			target:GetUnitName() == "npc_dota_ogre_veteran" 	then name = "npc_dota_ogre_myth"
			elseif 		target:GetUnitName() == "npc_dota_dragon_veteran" then name = "npc_dota_dragon_myth" 
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

function WaterSetStacks( keys )

	local ability = keys.ability
	local caster = keys.caster
	local target = keys.target
	local stacks = ability:GetSpecialValueFor( "stacks" )
	local StackModifier = "modifier_veteran_grow_water"
	local grow_ability = target:FindAbilityByName("veteran_grow_water") 

		local currentStacks = target:GetModifierStackCount(StackModifier, nil)

		if currentStacks == 0 then
			target:AddNewModifier(caster, nil, StackModifier, {})
			target:SetModifierStackCount(StackModifier, nil, (currentStacks + stacks))
		else 
			target:SetModifierStackCount(StackModifier, nil, (currentStacks + stacks))
		end
	if grow_ability ~= nil then
		local stack_limit = grow_ability:GetSpecialValueFor( "stack_limit" )

		if currentStacks+stacks>=stack_limit then
			local point = target:GetAbsOrigin()
			local team = target:GetTeam()
			local player = target:GetPlayerOwnerID()
			local hero   = PlayerResource:GetSelectedHeroEntity(player)
			local name	= ""
			local child_fw = target:GetForwardVector()
	
			if 			target:GetUnitName() == "npc_dota_ursa_veteran" 	then name = "npc_dota_ursa_myth" 
			elseif 		target:GetUnitName() == "npc_dota_satyr_veteran" 	then name = "npc_dota_satyr_myth"
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

function AirSetStacks( keys )

	local ability = keys.ability
	local caster = keys.caster
	local target = keys.target
	local stacks = ability:GetSpecialValueFor( "stacks" )
	local StackModifier = "modifier_veteran_grow_air"
	local grow_ability = target:FindAbilityByName("veteran_grow_air") 

		local currentStacks = target:GetModifierStackCount(StackModifier, nil)

		if currentStacks == 0 then
			target:AddNewModifier(caster, nil, StackModifier, {})
			target:SetModifierStackCount(StackModifier, nil, (currentStacks + stacks))
		else 
			target:SetModifierStackCount(StackModifier, nil, (currentStacks + stacks))
		end
	if grow_ability ~= nil then
		local stack_limit = grow_ability:GetSpecialValueFor( "stack_limit" )

		if currentStacks+stacks>=stack_limit then
			local point = target:GetAbsOrigin()
			local team = target:GetTeam()
			local player = target:GetPlayerOwnerID()
			local hero   = PlayerResource:GetSelectedHeroEntity(player)
			local name	= ""
			local child_fw = target:GetForwardVector()
	
			if 			target:GetUnitName() == "npc_dota_wolf_veteran" 	then name = "npc_dota_wolf_myth"
			elseif 		target:GetUnitName() == "npc_dota_centaur_veteran"then name = "npc_dota_centaur_myth"
			elseif 		target:GetUnitName() == "npc_dota_lizard_veteran"then name = "npc_dota_lizard_myth"
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

function EarthSetStacks( keys )

	local ability = keys.ability
	local caster = keys.caster
	local target = keys.target
	local stacks = ability:GetSpecialValueFor( "stacks" )
	local StackModifier = "modifier_veteran_grow_earth"
	local grow_ability = target:FindAbilityByName("veteran_grow_earth") 

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
	
			if 			target:GetUnitName() == "npc_dota_troll_veteran" 	then name = "npc_dota_troll_myth" 
			elseif 		target:GetUnitName() == "npc_dota_kobold_veteran" then name = "npc_dota_kobold_myth"
			elseif 		target:GetUnitName() == "npc_dota_golem_veteran" 	then name = "npc_dota_golem_myth"
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
modifier_veteran_grow_earth = modifier_veteran_grow_earth or class({})
function modifier_veteran_grow_earth:IsDebuff() return false end
function modifier_veteran_grow_earth:IsBuff() return true end
function modifier_veteran_grow_earth:IsHidden() return false end
function modifier_veteran_grow_earth:IsPurgable() return false end
function modifier_veteran_grow_earth:IsStunDebuff() return false end
function modifier_veteran_grow_earth:RemoveOnDeath() return false end
-------------------------------------------
function modifier_veteran_grow_earth:GetTexture() 
return "item_earth_essence" 
end


function modifier_veteran_grow_earth:DeclareFunctions()
	local decFuns =
		{
			MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
		}
	return decFuns
end

function modifier_veteran_grow_earth:GetModifierIncomingDamage_Percentage()
	return -self:GetStackCount()*1
end

-------------------------------------------
modifier_veteran_grow_water = modifier_veteran_grow_water or class({})
function modifier_veteran_grow_water:IsDebuff() return false end
function modifier_veteran_grow_water:IsBuff() return true end
function modifier_veteran_grow_water:IsHidden() return false end
function modifier_veteran_grow_water:IsPurgable() return false end
function modifier_veteran_grow_water:IsStunDebuff() return false end
function modifier_veteran_grow_water:RemoveOnDeath() return false end
-------------------------------------------
function modifier_veteran_grow_water:GetTexture() 
return "item_water_essence" 
end


function modifier_veteran_grow_water:DeclareFunctions()
	local decFuns =
		{
			MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
		}
	return decFuns
end

function modifier_veteran_grow_water:OnCreated()
	self.value_bonus = ability:GetSpecialValueFor("bonus_value")
end

function modifier_veteran_grow_water:GetModifierSpellAmplify_Percentage()
	return self:GetStackCount()*1
end

-------------------------------------------
modifier_veteran_grow_air = modifier_veteran_grow_air or class({})
function modifier_veteran_grow_air:IsDebuff() return false end
function modifier_veteran_grow_air:IsBuff() return true end
function modifier_veteran_grow_air:IsHidden() return false end
function modifier_veteran_grow_air:IsPurgable() return false end
function modifier_veteran_grow_air:IsStunDebuff() return false end
function modifier_veteran_grow_air:RemoveOnDeath() return false end
-------------------------------------------
function modifier_veteran_grow_air:GetTexture() 
return "item_air_essence" 
end


function modifier_veteran_grow_air:DeclareFunctions()
	local decFuns =
		{
			MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
		}
	return decFuns
end

function modifier_veteran_grow_air:GetModifierMoveSpeedBonus_Constant()
	return self:GetStackCount()*2
end

-------------------------------------------
modifier_veteran_grow_fire = modifier_veteran_grow_fire or class({})
function modifier_veteran_grow_fire:IsDebuff() return false end
function modifier_veteran_grow_fire:IsBuff() return true end
function modifier_veteran_grow_fire:IsHidden() return false end
function modifier_veteran_grow_fire:IsPurgable() return false end
function modifier_veteran_grow_fire:IsStunDebuff() return false end
function modifier_veteran_grow_fire:RemoveOnDeath() return false end
-------------------------------------------
function modifier_veteran_grow_fire:GetTexture() 
return "item_fire_essence" 
end


function modifier_veteran_grow_fire:DeclareFunctions()
	local decFuns =
		{
			MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,
		}
	return decFuns
end

function modifier_veteran_grow_fire:GetModifierBaseDamageOutgoing_Percentage()
	return self:GetStackCount()*1
end

