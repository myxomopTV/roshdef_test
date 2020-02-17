
LinkLuaModifier( "modifier_aniki_powerfull", "heroes/hero_aniki/powerfull", LUA_MODIFIER_MOTION_NONE )

aniki_powerfull = class({})

function aniki_powerfull:GetIntrinsicModifierName()
	return "modifier_aniki_powerfull"
end

modifier_aniki_powerfull = class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return true end,
	DeclareFunctions		= function(self) return 
		{
			MODIFIER_PROPERTY_HEALTH_BONUS,
			MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		} end,
})

function modifier_aniki_powerfull:OnCreated()
	if IsServer() then
		self:StartIntervalThink(0.1)
	end
end

function modifier_aniki_powerfull:OnIntervalThink()
	local caster = self:GetCaster()
	local stack_count = caster:GetStrength()

	self:SetStackCount(stack_count)
	
end

function modifier_aniki_powerfull:GetModifierHealthBonus()
	return self:GetAbility():GetSpecialValueFor("str_health")*self:GetStackCount()
end

function modifier_aniki_powerfull:GetModifierConstantHealthRegen()
	return self:GetAbility():GetSpecialValueFor("str_regen")*self:GetStackCount()
end
