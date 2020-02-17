LinkLuaModifier("modifier_zombie_king_decay_buff_counter", "heroes/hero_zombie_king/decay.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_zombie_king_decay_buff", "heroes/hero_zombie_king/decay.lua", LUA_MODIFIER_MOTION_NONE)

function DecayRelease ( keys )
	local ability = keys.ability
	local caster = keys.caster
	local targets = keys.target_entities
	local damage = ability:GetSpecialValueFor("damage")
	local buff_duration = ability:GetSpecialValueFor("buff_duration")
	
	for _,target in pairs(targets) do
		DealDamage(caster, target, damage, DAMAGE_TYPE_MAGICAL, nil, ability)
		if target then
				local target_abs = target:GetAbsOrigin()

				local buff_duration = ability:GetSpecialValueFor( "buff_duration" )
				local BuffModifierCounter = "modifier_zombie_king_decay_buff_counter"
				local BuffModifier = "modifier_zombie_king_decay_buff"
				local currentBuffStacks = caster:GetModifierStackCount(BuffModifierCounter, ability)

				caster:AddNewModifier( caster, ability, BuffModifier , { Duration = buff_duration } )
				caster:AddNewModifier( caster, ability, BuffModifierCounter , { Duration = buff_duration } )

				caster:SetModifierStackCount(BuffModifierCounter, ability, (currentBuffStacks + 1))
		end
	end

	
end



modifier_zombie_king_decay_buff = class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return true end,
	GetAttributes 			= function(self) return MODIFIER_ATTRIBUTE_MULTIPLE end,
	DeclareFunctions		= function(self) return 
		{   MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
			--MODIFIER_PROPERTY_MODEL_SCALE
			} end,
})
-------------------------------------------

function modifier_zombie_king_decay_buff:OnDestroy(keys)
	local caster = self:GetCaster()
	local target = self:GetParent()
	local modifier = "modifier_zombie_king_decay_buff_counter"

	if caster:HasModifier(modifier) then
		local previous_stack_count = caster:GetModifierStackCount(modifier, caster)
		if previous_stack_count > 1 then
			caster:SetModifierStackCount(modifier, caster, previous_stack_count - 1)
		else
			caster:RemoveModifierByName(modifier)
		end
	end
end

function modifier_zombie_king_decay_buff:GetModifierModelScale()
	return self:GetAbility():GetSpecialValueFor("model_scale")
end

function modifier_zombie_king_decay_buff:GetModifierBonusStats_Strength()
	return self:GetAbility():GetSpecialValueFor("str_steal")
end

modifier_zombie_king_decay_buff_counter = class({
	IsHidden 				= function(self) return false end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return true end,

})


