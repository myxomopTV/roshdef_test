LinkLuaModifier("modifier_epic_tower_upgrade_as", "heroes/hero_epic_tower/upgrade_as", LUA_MODIFIER_MOTION_NONE)

epic_tower_upgrade_as = class({})

function epic_tower_upgrade_as:GetIntrinsicModifierName()
	return "modifier_epic_tower_upgrade_as"
end

function epic_tower_upgrade_as:OnSpellStart()
	local point = self:GetCursorPosition()
	local caster = self:GetCaster()

	local modifier = caster:AddNewModifier(caster, self, "modifier_epic_tower_upgrade_as", {})
	modifier:IncrementStackCount()

end	

modifier_epic_tower_upgrade_as = class ({
	IsHidden = function(self) return false end,	
	DeclareFunctions = function(self) return {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	}end,
})

function modifier_epic_tower_upgrade_as:GetModifierAttackSpeedBonus_Constant()
    if self:GetCaster():HasModifier("modifier_epic_tower_construct") then

		local caster = self:GetCaster()
		local upgrade_self = self:GetStackCount()
--		local upgrade_epic = caster:FindAbilityByName("epic_tower_construct_build"):GetLevel()-1
		local upgrade_value = self:GetAbility():GetSpecialValueFor("upgrade_value")
--		local epic_bonus = self:GetAbility():GetSpecialValueFor("epic_bonus")

		return upgrade_self *( upgrade_value )--+ upgrade_epic * epic_bonus)
	else
		return 0
	end
end



