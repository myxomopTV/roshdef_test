
LinkLuaModifier( "modifier_aniki_", "heroes/hero_aniki/", LUA_MODIFIER_MOTION_NONE )

mark_strength = class({})

function mark_strength:GetIntrinsicModifierName()
	return "modifier_mark_strength"
end

modifier_mark_strength = class({
	IsHidden 				= function(self) return false end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return true end,
	DeclareFunctions		= function(self) return 
		{
		MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE,
		} end,
})

function modifier_mark_strength:OnCreated()
	if IsServer() then
		local ability = self:GetAbility()
		self.value_need = 1/ability:GetSpecialValueFor("str_mult")
		self.crit_chance = ability:GetSpecialValueFor("crit_chance")
		self:StartIntervalThink(1)
	end
end

function modifier_mark_strength:OnIntervalThink()
	local caster = self:GetCaster()
	local value = caster:GetStrength()
	local stack_count = math.floor(value/ self.value_need)

	self:SetStackCount(stack_count)
	
end


function modifier_mark_strength:GetModifierPreAttack_CriticalStrike()
	if RollPercentage( self.crit_chance) then
		return self:GetStackCount() + 100
	else
		return
	end
end
