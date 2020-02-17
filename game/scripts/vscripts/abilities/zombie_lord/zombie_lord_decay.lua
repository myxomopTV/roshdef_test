LinkLuaModifier("modifier_zombie_lord_decay_buff_counter", "abilities/zombie_lord/zombie_lord_decay.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_zombie_lord_decay_buff", "abilities/zombie_lord/zombie_lord_decay.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_zombie_lord_decay_debuff_counter", "abilities/zombie_lord/zombie_lord_decay.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_zombie_lord_decay_debuff", "abilities/zombie_lord/zombie_lord_decay.lua", LUA_MODIFIER_MOTION_NONE)
if not zombie_lord_decay then zombie_lord_decay = class({}) end

function zombie_lord_decay:OnSpellStart ()
	local ability = self
	local caster = self:GetCaster()
	local point = caster:GetAbsOrigin()
	local radius = ability:GetSpecialValueFor("radius")
	local damage = ability:GetSpecialValueFor("damage")
	local buff_duration = ability:GetSpecialValueFor("buff_duration")
	
	local effect = "particles/econ/items/undying/undying_pale_augur/undying_pale_augur_decay.vpcf"
	local pfx = ParticleManager:CreateParticle(effect, PATTACH_WORLDORIGIN, caster)
	ParticleManager:SetParticleControl(pfx, 0, point)
	ParticleManager:SetParticleControl(pfx, 1, Vector(radius, radius, radius))
	ParticleManager:ReleaseParticleIndex(pfx)
	caster:EmitSound("Hero_Undying.Decay.Cast.PaleAugur")
	local enemies = caster:FindEnemyUnitsInRadius(point, radius, nil)

	for _,enemy in pairs(enemies) do
		DealDamage(caster, enemy, damage, DAMAGE_TYPE_MAGICAL, nil, ability)
		if enemy:IsRealHero() then
				local target_abs = enemy:GetAbsOrigin()
--[[
				local effect = "particles/units/heroes/hero_undying/undying_decay_strength_xfer.vpcf"
				local pid = ParticleManager:CreateParticle(effect, PATTACH_ABSORIGIN_FOLLOW, caster)
--				local pid = ParticleManager:CreateParticle("particles/units/heroes/hero_undying/undying_decay_strength_xfer.vpcf", PATTACH_ABSORIGIN_FOLLOW, enemy)
				ParticleManager:SetParticleControl(pid, 0, caster:GetAbsOrigin())	
				ParticleManager:SetParticleControl(pid, 1, target_abs)	
				ParticleManager:SetParticleControl(pid, 2, target_abs)
				]]

				local buff_duration = ability:GetSpecialValueFor( "buff_duration" )
				local BuffModifierCounter = "modifier_zombie_lord_decay_buff_counter"
				local BuffModifier = "modifier_zombie_lord_decay_buff"
				local DebuffModifierCounter = "modifier_zombie_lord_decay_debuff_counter"
				local DebuffModifier = "modifier_zombie_lord_decay_debuff"
				local currentBuffStacks = caster:GetModifierStackCount(BuffModifierCounter, ability)
				local currentDebuffStacks = enemy:GetModifierStackCount(DebuffModifierCounter, ability)

				caster:AddNewModifier( caster, ability, BuffModifier , { Duration = buff_duration } )
				caster:AddNewModifier( caster, ability, BuffModifierCounter , { Duration = buff_duration } )
				enemy:AddNewModifier( caster, ability, DebuffModifier , { Duration = buff_duration } )
				enemy:AddNewModifier( caster, ability, DebuffModifierCounter , { Duration = buff_duration } )

				caster:SetModifierStackCount(BuffModifierCounter, ability, (currentBuffStacks + 1))
				enemy:SetModifierStackCount(DebuffModifierCounter, ability, (currentDebuffStacks + 1))
		end
	end	
end

modifier_zombie_lord_decay_debuff = class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return true end,
	IsBuff                  = function(self) return false end,
	RemoveOnDeath 			= function(self) return true end,
	GetAttributes 			= function(self) return MODIFIER_ATTRIBUTE_MULTIPLE end,
	DeclareFunctions		= function(self) return 
		{--	MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
			MODIFIER_PROPERTY_STATS_STRENGTH_BONUS} end,
})
-------------------------------------------

function modifier_zombie_lord_decay_debuff:OnDestroy(keys)
	local caster = self:GetCaster()
	local target = self:GetParent()
	local modifier = "modifier_zombie_lord_decay_debuff_counter"

	if target:HasModifier(modifier) then
		local previous_stack_count = target:GetModifierStackCount(modifier, nil)
		if previous_stack_count > 1 then
			target:SetModifierStackCount(modifier, caster, previous_stack_count - 1)
		else
			target:RemoveModifierByName(modifier)
		end
	end
end


function modifier_zombie_lord_decay_debuff:GetModifierBonusStats_Strength()
	return (-1)*self:GetAbility():GetSpecialValueFor("str_steal")
end

modifier_zombie_lord_decay_buff = class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return true end,
	GetAttributes 			= function(self) return MODIFIER_ATTRIBUTE_MULTIPLE end,
	DeclareFunctions		= function(self) return 
		{   MODIFIER_PROPERTY_EXTRA_HEALTH_PERCENTAGE,
			MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,
			MODIFIER_PROPERTY_MODEL_SCALE} end,
})
-------------------------------------------

function modifier_zombie_lord_decay_buff:OnDestroy(keys)
	local caster = self:GetCaster()
	local target = self:GetParent()
	local modifier = "modifier_zombie_lord_decay_buff_counter"

	if caster:HasModifier(modifier) then
		local previous_stack_count = caster:GetModifierStackCount(modifier, caster)
		if previous_stack_count > 1 then
			caster:SetModifierStackCount(modifier, caster, previous_stack_count - 1)
		else
			caster:RemoveModifierByName(modifier)
		end
	end
end


function modifier_zombie_lord_decay_buff:GetModifierExtraHealthPercentage()
	return self:GetAbility():GetSpecialValueFor("hp_scale")
end

function modifier_zombie_lord_decay_buff:GetModifierModelScale()
	return self:GetAbility():GetSpecialValueFor("model_scale")
end
function modifier_zombie_lord_decay_buff:GetModifierBaseDamageOutgoing_Percentage()
	return self:GetAbility():GetSpecialValueFor("dmg_scale")
end

modifier_zombie_lord_decay_buff_counter = class({
	IsHidden 				= function(self) return false end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return true end,

})

modifier_zombie_lord_decay_debuff_counter = class({
	IsHidden 				= function(self) return false end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return true end,
	IsBuff                  = function(self) return false end,
	RemoveOnDeath 			= function(self) return true end,

})

