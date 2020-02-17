LinkLuaModifier('green_dragon_armor_destroy_modidifer','heroes/mystic_dragon/fury_swipes.lua',LUA_MODIFIER_MOTION_NONE)

function fury_swipes_attack( keys )
	-- Variables
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local modifierName = "green_dragon_armor_destroy_modidifer"
	local damageType = ability:GetAbilityDamageType()
	local exceptionName = "put_your_exception_unit_here"
	
	-- Necessary value from KV
	local duration = ability:GetLevelSpecialValueFor( "bonus_reset_time", ability:GetLevel() - 1 )

	if target:GetName() == exceptionName then	-- Put exception here
		duration = ability:GetLevelSpecialValueFor( "bonus_reset_time_roshan", ability:GetLevel() - 1 )
	end
	
	-- Check if unit already have stack
	if target:HasModifier( modifierName ) then
		local current_stack = target:GetModifierStackCount( modifierName, ability )
		
		target:AddNewModifier(target, ability, modifierName, {Duration = duration})

		target:SetModifierStackCount( modifierName, ability, current_stack + 1 )
	else
		target:AddNewModifier(target, ability, modifierName, {Duration = duration})

		target:SetModifierStackCount( modifierName, ability, 1 )
		
		-- Deal damage

	end
end

if green_dragon_armor_destroy_modidifer == nil then
    green_dragon_armor_destroy_modidifer = class({})
end


function green_dragon_armor_destroy_modidifer:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	}

	return funcs
end

function green_dragon_armor_destroy_modidifer:GetModifierPhysicalArmorBonus()
	return -self:GetAbility():GetSpecialValueFor("agi_mult") 
end

function green_dragon_armor_destroy_modidifer:OnCreated()
	if IsServer() then
--		self.nFXIndex = ParticleManager:CreateParticle("particles/units/heroes/hero_lycan/lycan_shapeshift_buff.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
--		self:AddParticle(self.nFXIndex, false, false, -1, false, false)
	end
end