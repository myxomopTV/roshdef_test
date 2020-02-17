
modifier_stone_gaze_debuff = class({
	IsHidden 				= function(self) return false end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return true end,
	IsBuff                  = function(self) return false end,
	RemoveOnDeath 			= function(self) return true end,
--	GetAttributes 			= function(self) return MODIFIER_ATTRIBUTE_MULTIPLE end,
	DeclareFunctions		= function(self) return 
		{MODIFIER_PROPERTY_INCOMING_PHYSICAL_DAMAGE_PERCENTAGE} end,
})

function modifier_stone_gaze_debuff:OnCreated(data)
	self.bonus_physical_damage = self:GetAbility():GetSpecialValueFor( "bonus_physical_damage" )
end

function modifier_stone_gaze_debuff:GetStatusEffectName()
	return "particles/status_fx/status_effect_medusa_stone_gaze.vpcf"
end

function modifier_stone_gaze_debuff:StatusEffectPriority()
	return 100
end

function modifier_stone_gaze_debuff:GetModifierIncomingPhysicalDamage_Percentage()
	return self.bonus_physical_damage
end

-- Declare modifier states
function modifier_stone_gaze_debuff:CheckState()
	local states = {
--		[MODIFIER_STATE_DISARMED] = true,
		[MODIFIER_STATE_STUNNED] = true,
--		[MODIFIER_STATE_ROOTED] = true,
		[MODIFIER_STATE_FROZEN] = true,
	}
	return states
end

