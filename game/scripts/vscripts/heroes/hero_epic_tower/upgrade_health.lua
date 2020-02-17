LinkLuaModifier("modifier_epic_tower_upgrade_health", "heroes/hero_epic_tower/upgrade_health", LUA_MODIFIER_MOTION_NONE)

epic_tower_upgrade_health = class({})

function epic_tower_upgrade_health:GetIntrinsicModifierName()
	return "modifier_epic_tower_upgrade_health"
end

function epic_tower_upgrade_health:OnSpellStart()
	local point = self:GetCursorPosition()
	local caster = self:GetCaster()

	local modifier = caster:AddNewModifier(caster, self, "modifier_epic_tower_upgrade_health", {})
	modifier:IncrementStackCount()
	caster:CalculateStatBonus()

end	

modifier_epic_tower_upgrade_health = class ({
	IsHidden = function(self) return false end,	
	DeclareFunctions = function(self) return {
		MODIFIER_PROPERTY_HEALTH_BONUS,
	}end,
})

function modifier_epic_tower_upgrade_health:GetModifierHealthBonus()
    if self:GetCaster():HasModifier("modifier_epic_tower_construct") then

		local caster = self:GetCaster()
		local upgrade_self = self:GetStackCount()
		local upgrade_epic = caster:FindAbilityByName("epic_tower_construct_build"):GetLevel()-1
		local upgrade_value = self:GetAbility():GetSpecialValueFor("upgrade_value")
		local epic_bonus = self:GetAbility():GetSpecialValueFor("epic_bonus")

		return upgrade_self *( upgrade_value + upgrade_epic * epic_bonus)
	else
		return 0
	end
end



