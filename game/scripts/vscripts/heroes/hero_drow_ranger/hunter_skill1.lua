LinkLuaModifier("modifier_drow_ranger_hunter_skill", "heroes/hero_drow_ranger/hunter_skill", LUA_MODIFIER_MOTION_NONE)

--------------------------------------------------------
------------------------------------------------------------
modifier_drow_ranger_hunter_skill = class({
	IsHidden 				= function(self) return false end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	DeclareFunctions		= function(self) return 
		{MODIFIER_PROPERTY_STATS_AGILITY_BONUS} end,
})

function modifier_drow_ranger_hunter_skill:GetModifierBonusStats_Agility()
	return self:GetStackCount()*self:GetAbility():GetSpecialValueFor("agility_bonus")
end

------------------------------------------------------------
------------------------------------------------------------
--Increases the stack count of Flesh Heap.
function StackCountIncrease( keys )
    local caster = keys.caster
	local target = keys.target
    local ability = keys.ability
    local modifier = keys.buff_modifier
	local hits_required = ability:GetSpecialValueFor("hits_required")
	
	if target:GetUnitName() == "npc_dota_damage_tester" then
		return
	end
	
	if ability.hits == nil then 
		ability.hits = 0 
	else
		ability.hits = ability.hits + 1
	end
	
	if ability.hits == hits_required then
		ability.hits = 0
		caster:AddNewModifier(caster, ability, modifier, nil)
		local currentStacks = caster:GetModifierStackCount(modifier, ability)	
		caster:SetModifierStackCount(modifier, ability, (currentStacks + 1))
	end
--	print("modifier="..modifier)
--    modifier:IncrementStackCount()
end

