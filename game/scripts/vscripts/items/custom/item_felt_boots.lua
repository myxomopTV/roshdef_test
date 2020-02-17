
LinkLuaModifier( "modifier_item_felt_boots", "items/custom/item_felt_boots", LUA_MODIFIER_MOTION_NONE )

item_felt_boots = class({})

function item_felt_boots:GetIntrinsicModifierName()
	return "modifier_item_felt_boots"
end

modifier_item_felt_boots = class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return true end,
	DeclareFunctions		= function(self) return 
		{
			MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
			MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
			MODIFIER_PROPERTY_HEALTH_BONUS,
		} end,
})

function modifier_item_felt_boots:OnCreated()
	Timers:CreateTimer(0, function()
		local caster =  self:GetCaster()
		local item_level = self:GetAbility():GetLevel()
		local penguin_ability = caster:AddAbility("penguin_sledding_ride")
		penguin_ability:SetLevel(item_level)
	end)
end

function modifier_item_felt_boots:OnDestroy()
	local caster = self:GetCaster()
	caster:RemoveAbility("penguin_sledding_ride")
	if IsValidEntity(caster.penguin) and caster.penguin:IsAlive() then
		caster.penguin:ForceKill(false)
	end
end

function modifier_item_felt_boots:GetModifierMoveSpeedBonus_Percentage()
	return self:GetAbility():GetSpecialValueFor("decrease_ms")*(-1)
end

function modifier_item_felt_boots:GetModifierPhysicalArmorBonus()
	return self:GetAbility():GetSpecialValueFor("bonus_armor")
end

function modifier_item_felt_boots:GetModifierHealthBonus()
	return self:GetAbility():GetSpecialValueFor("bonus_health")
end

item_felt_boots_1 = class(item_felt_boots)
item_felt_boots_2 = class(item_felt_boots)
item_felt_boots_3 = class(item_felt_boots)
item_felt_boots_4 = class(item_felt_boots)

