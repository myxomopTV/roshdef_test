LinkLuaModifier("modifier_damage_heap_collector", "heroes/hero_renegade/infinite_damage", LUA_MODIFIER_MOTION_NONE)

--------------------------------------------------------
------------------------------------------------------------
modifier_damage_heap_collector = class({
	IsHidden 				= function(self) return false end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	DeclareFunctions		= function(self) return 
		{MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE} end,
})

function modifier_damage_heap_collector:GetModifierBaseAttack_BonusDamage()
	return self:GetStackCount()*self:GetAbility():GetSpecialValueFor("stack_bonus_dmg")
end

--------------------------------------------------------
------------------------------------------------------------

--Increases the stack count of Flesh Heap.
function StackCountIncrease( keys )
    local caster = keys.caster
    local ability = keys.ability
    local fleshHeapStackModifier = "modifier_damage_heap_collector"
    local currentStacks = caster:GetModifierStackCount(fleshHeapStackModifier, ability)

	caster:AddNewModifier(caster, ability, fleshHeapStackModifier, nil)
    caster:SetModifierStackCount(fleshHeapStackModifier, ability, (currentStacks + 1))
end

