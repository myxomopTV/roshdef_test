LinkLuaModifier("modifier_power_up_buff", "heroes/hero_aibolit/power_up.lua", LUA_MODIFIER_MOTION_NONE)



function SetStacks( keys )

	local ability = keys.ability
	local caster = keys.caster
	local target = keys.target
	local buff_duration = ability:GetSpecialValueFor( "buff_duration" )
	local StackModifier = "modifier_power_up_buff"
    local currentStacks = target:GetModifierStackCount(StackModifier, ability)

	local caster_owner = caster:GetPlayerOwner() 
	local target_owner = target:GetPlayerOwner() 

	-- If they are the same then apply the modifier
	if caster_owner == target_owner and caster ~= target then
		target:AddNewModifier(caster, ability, StackModifier, {})
		target:SetModifierStackCount(StackModifier, ability, (currentStacks + 1))
	else
		target:AddNewModifier(caster, ability, StackModifier, {Duration = buff_duration})
		target:SetModifierStackCount(StackModifier, ability, (1))
		target:AddNewModifier(caster, ability, "modifier_phased", {Duration = 0.01})
--		target:SetModifierStackCount(StackModifier, ability, (currentStacks + 1))

	end
	
--	if currentStacks<=19 then
--				caster:SetModifierStackCount(StackModifier, ability, (currentStacks + 1))
--		else	caster:SetModifierStackCount(StackModifier, ability, (20))
--	end
	
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------


-------------------------------------------
modifier_power_up_buff = modifier_power_up_buff or class({})
function modifier_power_up_buff:IsDebuff() return false end
function modifier_power_up_buff:IsBuff() return true end
function modifier_power_up_buff:IsHidden() return false end
function modifier_power_up_buff:IsPurgable() return false end
function modifier_power_up_buff:IsStunDebuff() return false end
function modifier_power_up_buff:RemoveOnDeath() return true end
-------------------------------------------


function modifier_power_up_buff:DeclareFunctions()
	local decFuns =
		{
			MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,
			MODIFIER_PROPERTY_EXTRA_HEALTH_PERCENTAGE
		}
	return decFuns
end

function modifier_power_up_buff:GetModifierBaseDamageOutgoing_Percentage()
	return self:GetStackCount()*self:GetAbility():GetSpecialValueFor("bonus_dmg")
end

function modifier_power_up_buff:GetModifierExtraHealthPercentage()
	return self:GetStackCount()*self:GetAbility():GetSpecialValueFor("bonus_hp")
end

