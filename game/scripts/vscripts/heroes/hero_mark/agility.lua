
LinkLuaModifier( "modifier_mark_agility", "heroes/hero_mark/agility.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_mark_agility_buff", "heroes/hero_mark/agility.lua", LUA_MODIFIER_MOTION_NONE )

mark_agility = class({})

function mark_agility:OnSpellStart()
	local caster = self:GetCaster()
	local duration = self:GetSpecialValueFor("duration")
	local stack_count = caster:FindModifierByName("modifier_mark_agility"):GetStackCount()
	
	local modifier = caster:AddNewModifier(caster, self, "modifier_mark_agility_buff", {duration = duration})	
	modifier:SetStackCount(stack_count)
end

function mark_agility:GetIntrinsicModifierName()
	return "modifier_mark_agility"
end
--------------------------------------------------------------------------------

modifier_mark_agility = class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return true end,
	DeclareFunctions		= function(self) return 
		{
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
		} end,
})

function modifier_mark_agility:OnCreated()
	if IsServer() then
		local ability = self:GetAbility()
		self.value_need = 1/ability:GetSpecialValueFor("agi_ms")
		self:StartIntervalThink(1)
	end
end

function modifier_mark_agility:OnIntervalThink()
	local caster = self:GetCaster()
	local value = caster:GetAgility()
	local stack_count = math.floor(value/ self.value_need)

	self:SetStackCount(stack_count)
	
end

function modifier_mark_agility:GetModifierMoveSpeedBonus_Constant()
	return self:GetStackCount()
end


modifier_mark_agility_buff = class({
	IsHidden 				= function(self) return false end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return true end,
	DeclareFunctions		= function(self) return 
		{
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		} end,
	CheckState 		= function(self) return 
		{[MODIFIER_STATE_NO_UNIT_COLLISION] = true} end,
})

function modifier_mark_agility_buff:GetEffect()
	return "particles/units/heroes/hero_pugna/pugna_ward_orientedrunes.vpcf"
end

function modifier_mark_agility_buff:GetModifierAttackSpeedBonus_Constant()
	return self:GetStackCount() + self:GetAbility():GetSpecialValueFor("base_as")
end
