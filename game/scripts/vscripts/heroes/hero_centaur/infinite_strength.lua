LinkLuaModifier("modifier_strenght_heap_collector", "heroes/hero_centaur/infinite_strength", LUA_MODIFIER_MOTION_NONE)

--------------------------------------------------------
------------------------------------------------------------
modifier_strenght_heap_collector = class({
	IsHidden 				= function(self) return false end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	DeclareFunctions		= function(self) return 
		{MODIFIER_PROPERTY_STATS_STRENGTH_BONUS} end,
})

function modifier_strenght_heap_collector:GetModifierBonusStats_Strength()
	return self:GetStackCount()*self:GetAbility():GetSpecialValueFor("stack_bonus_str")
end

--Increases the stack count of Flesh Heap.
function StackCountIncrease( keys )
    local caster = keys.caster
    local ability = keys.ability
    local fleshHeapStackModifier = "modifier_strenght_heap_collector"
    local currentStacks = caster:GetModifierStackCount(fleshHeapStackModifier, ability)

 	local modifier = caster:AddNewModifier(caster, ability, fleshHeapStackModifier, nil)
    caster:SetModifierStackCount(fleshHeapStackModifier, caster, (currentStacks + 1))
end


