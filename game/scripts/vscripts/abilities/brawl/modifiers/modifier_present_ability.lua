modifier_present_ability = class({
	IsPurgable = function() return false end,
	IsHidden = function() return true end,
	GetEffectName = function() return "particles/generic_gameplay/present_ambient.vpcf" end,
	GetEffectAttachType = function() return PATTACH_ABSORIGIN_FOLLOW end,
})

function modifier_present_ability:CheckState()
	local state = {
		[MODIFIER_STATE_NOT_ON_MINIMAP] = false,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_MAGIC_IMMUNE] = true,
		[MODIFIER_STATE_LOW_ATTACK_PRIORITY] = true,
		[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = false,
		[MODIFIER_STATE_STUNNED] = true
	}
	if self:GetParent().presentTarget ~= nil then
		state[MODIFIER_STATE_NOT_ON_MINIMAP] = true
		state[MODIFIER_STATE_NO_HEALTH_BAR] = false
		state[MODIFIER_STATE_MAGIC_IMMUNE] = false
		state[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true
	end
	return state
end

function modifier_present_ability:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_DISABLE_HEALING,
		MODIFIER_PROPERTY_MIN_HEALTH,
		MODIFIER_PROPERTY_PROVIDES_FOW_POSITION,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_MAGICAL,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PURE
	}
end

function modifier_present_ability:GetDisableHealing()
	return 1
end

function modifier_present_ability:GetMinHealth()
	return 1
end

function modifier_present_ability:GetModifierProvidesFOWVision()
	return self:GetParent().presentTarget == nil and 1 or 0
end

function modifier_present_ability:GetAbsoluteNoDamagePhysical()
	return self:GetParent().presentTarget == nil and 1 or 0
end

function modifier_present_ability:GetAbsoluteNoDamageMagical()
	return self:GetParent().presentTarget == nil and 1 or 0
end

function modifier_present_ability:GetAbsoluteNoDamagePure()
	return self:GetParent().presentTarget == nil and 1 or 0
end

if IsServer() then
	function modifier_present_ability:OnCreated()
		self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_disable_aggro", {})
	end
	function modifier_present_ability:OnRefresh()
		self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_disable_aggro", {})
	end
end