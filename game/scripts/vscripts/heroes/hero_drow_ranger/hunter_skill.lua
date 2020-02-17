LinkLuaModifier("modifier_drow_ranger_hunter_skill", "heroes/hero_drow_ranger/hunter_skill", LUA_MODIFIER_MOTION_NONE)

if not drow_ranger_hunter_skill then
	drow_ranger_hunter_skill = class({})
end
if IsServer() then
	function drow_ranger_hunter_skill:OnSpellStart()
		local caster = self:GetCaster()
		local duration = self:GetSpecialValueFor("duration")
		
		caster:AddNewModifier(caster, self, "modifier_drow_ranger_hunter_skill", {duration = duration})
	end
end

if not modifier_drow_ranger_hunter_skill then
	modifier_drow_ranger_hunter_skill = class({})
end

if IsServer() then
	function modifier_drow_ranger_hunter_skill:DeclareFunctions()
		return {MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE}
	end
	function modifier_drow_ranger_hunter_skill:GetModifierPreAttack_CriticalStrike()
		local mult = 1
		local caster = self:GetCaster()
		if caster:HasModifier("modifier_item_special_jotaro") then
			mult = 2
		end
		return self:GetAbility():GetSpecialValueFor("crit_mult")
	end
	function modifier_drow_ranger_hunter_skill:CheckState(self)
	    return {[MODIFIER_STATE_CANNOT_MISS] = true}
	end
end
function modifier_drow_ranger_hunter_skill:GetAttributes()
    return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE + MODIFIER_ATTRIBUTE_PERMANENT
end