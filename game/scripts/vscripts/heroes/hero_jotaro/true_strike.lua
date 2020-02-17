LinkLuaModifier("modifier_jotaro_true_strike", "heroes/hero_jotaro/true_strike", LUA_MODIFIER_MOTION_NONE)

if not jotaro_true_strike then
	jotaro_true_strike = class({})
end
if IsServer() then
function jotaro_true_strike:OnSpellStart()
	local caster = self:GetCaster()
	local duration = self:GetSpecialValueFor("duration")
	
	caster:AddNewModifier(caster, self, "modifier_jotaro_true_strike", {duration = duration})
end
end
if not modifier_jotaro_true_strike then
	modifier_jotaro_true_strike = class({})
end
if IsServer() then
	function modifier_jotaro_true_strike:DeclareFunctions()
		return {MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE}
	end
	function modifier_jotaro_true_strike:GetModifierPreAttack_CriticalStrike()
		local mult = 1
		local caster = self:GetCaster()
		if caster:HasModifier("modifier_item_special_jotaro") then
			mult = 2
		end
		return self:GetAbility():GetSpecialValueFor("crit")
	end
	function modifier_jotaro_true_strike:CheckState(self)
	    return {[MODIFIER_STATE_CANNOT_MISS] = true}
	end
end
function modifier_jotaro_true_strike:GetAttributes()
    return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE + MODIFIER_ATTRIBUTE_PERMANENT
end