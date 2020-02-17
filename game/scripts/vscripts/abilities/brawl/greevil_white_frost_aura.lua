greevil_white_frost_aura = class({})

LinkLuaModifier("modifier_greevil_white_frost_aura", "abilities/greevil_white_frost_aura", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_greevil_white_frost_aura_debuff", "abilities/greevil_white_frost_aura", LUA_MODIFIER_MOTION_NONE)

function greevil_white_frost_aura:GetAbilityTextureName()
	return "greevil_white_frost_aura"
end
function greevil_white_frost_aura:GetIntrinsicModifierName()
	return "modifier_greevil_white_frost_aura"
end

modifier_greevil_white_frost_aura = class({
	IsPurgable = function() return false end,
	IsHidden = function() return true end,
})
if IsServer() then
	function modifier_greevil_white_frost_aura:OnCreated()
		self:StartIntervalThink(self:GetAbility():GetSpecialValueFor("stack_interval"))
		self:OnIntervalThink()
	end
	function modifier_greevil_white_frost_aura:OnIntervalThink()
		local enemies = FindUnitsInRadius(self:GetParent():GetTeamNumber(), self:GetParent():GetOrigin(), nil, self:GetAbility():GetSpecialValueFor("radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
		for _,enemy in pairs(enemies) do
			local debuffModifier = enemy:FindModifierByName("modifier_greevil_white_frost_aura_debuff")
			if debuffModifier ~= nil then
				enemy:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_greevil_white_frost_aura_debuff", {})
				if debuffModifier:GetStackCount() < self:GetAbility():GetSpecialValueFor("max_stacks") then
					debuffModifier:SetStackCount(debuffModifier:GetStackCount() + 1)
				else
					debuffModifier:SetStackCount(self:GetAbility():GetSpecialValueFor("max_stacks"))
				end
				debuffModifier:SetDuration(self:GetAbility():GetSpecialValueFor("stack_interval") + 1, false)
			else
				enemy:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_greevil_white_frost_aura_debuff", {})
				debuffModifier = enemy:FindModifierByName("modifier_greevil_white_frost_aura_debuff")
				debuffModifier:SetStackCount(1)
				debuffModifier:SetDuration(self:GetAbility():GetSpecialValueFor("stack_interval") + 1, false)
			end
		end
	end
end

modifier_greevil_white_frost_aura_debuff = class({
	IsPurgable = function() return false end,
})

function modifier_greevil_white_frost_aura_debuff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_TURN_RATE_PERCENTAGE,
		MODIFIER_PROPERTY_DISABLE_HEALING,
	}
end

function modifier_greevil_white_frost_aura_debuff:GetModifierMoveSpeedBonus_Percentage()
	return -10 * self:GetStackCount()
end
function modifier_greevil_white_frost_aura_debuff:GetModifierAttackSpeedBonus_Constant()
	return -10 * self:GetStackCount()
end
function modifier_greevil_white_frost_aura_debuff:GetModifierTurnRate_Percentage()
	return -10 * self:GetStackCount()
end
function modifier_greevil_white_frost_aura_debuff:GetDisableHealing()
	return 1
end