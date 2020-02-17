LinkLuaModifier("modifier_item_special_antares", "heroes/hero_antares/item_special_antares", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_special_antares_upgrade_1", "heroes/hero_antares/item_special_antares", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_special_antares_upgrade_2", "heroes/hero_antares/item_special_antares", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_special_antares_upgrade_3", "heroes/hero_antares/item_special_antares", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_special_antares_upgrade_4", "heroes/hero_antares/item_special_antares", LUA_MODIFIER_MOTION_NONE)

item_special_antares = class({})

function item_special_antares:GetIntrinsicModifierName()
	return "modifier_item_special_antares"
end

modifier_item_special_antares = class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	DeclareFunctions		= function(self) return 
		{MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		} end,
})

function modifier_item_special_antares:OnCreated()
	if IsServer() then
		local caster = self:GetCaster()
		if caster:GetUnitName() == "npc_dota_hero_dragon_knight" then
			local ability = caster:FindAbilityByName("antares_dragon_form")
			local modifier = caster:AddNewModifier(caster, ability, "modifier_antares_dragon_form", nil)
		end		
	end		
end

function modifier_item_special_antares:OnDestroy()
	local caster = self:GetCaster()
	caster:RemoveModifierByName("modifier_antares_dragon_form")			
end

function modifier_item_special_antares:GetModifierPreAttack_BonusDamage()
	return self:GetAbility():GetSpecialValueFor("bonus_dmg")
end

function modifier_item_special_antares:GetModifierBonusStats_Strength()
	return self:GetAbility():GetSpecialValueFor("bonus_str")
end

function modifier_item_special_antares:GetModifierBonusStats_Agility()
	return self:GetAbility():GetSpecialValueFor("bonus_agi")
end

function modifier_item_special_antares:GetModifierBonusStats_Intellect()
	return self:GetAbility():GetSpecialValueFor("bonus_int")
end

function modifier_item_special_antares:GetEffectName()
	if self:GetCaster():GetUnitName()=="npc_dota_hero_dragon_knight" then
		return "particles/econ/courier/courier_babyroshan_ti9/courier_babyroshan_ti9_ambient.vpcf"
	else
		return
	end	
end

item_special_antares_upgrade_1 = class({})

function item_special_antares_upgrade_1:GetIntrinsicModifierName()
	return "modifier_item_special_antares_upgrade_1"
end

modifier_item_special_antares_upgrade_1 = class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	DeclareFunctions		= function(self) return 
		{MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		} end,
})

function modifier_item_special_antares_upgrade_1:OnCreated()
	if IsServer() then
		local caster = self:GetCaster()
		if caster:GetUnitName() == "npc_dota_hero_dragon_knight" then
			local ability = caster:FindAbilityByName("antares_dragon_form")
			local modifier = caster:AddNewModifier(caster, ability, "modifier_antares_dragon_form", nil)	
		end		
	end		
end

function modifier_item_special_antares_upgrade_1:OnDestroy()
	local caster = self:GetCaster()
	caster:RemoveModifierByName("modifier_antares_dragon_form")			
end

function modifier_item_special_antares_upgrade_1:GetModifierPreAttack_BonusDamage()
	return self:GetAbility():GetSpecialValueFor("bonus_dmg")
end

function modifier_item_special_antares_upgrade_1:GetModifierBonusStats_Strength()
	return self:GetAbility():GetSpecialValueFor("bonus_str")
end

function modifier_item_special_antares_upgrade_1:GetModifierBonusStats_Agility()
	return self:GetAbility():GetSpecialValueFor("bonus_agi")
end

function modifier_item_special_antares_upgrade_1:GetModifierBonusStats_Intellect()
	return self:GetAbility():GetSpecialValueFor("bonus_int")
end

function modifier_item_special_antares_upgrade_1:GetEffectName()
	if self:GetCaster():GetUnitName()=="npc_dota_hero_dragon_knight" then
		return "particles/econ/courier/courier_babyroshan_ti9/courier_babyroshan_ti9_ambient.vpcf"
	else
		return
	end	
end

item_special_antares_upgrade_2 = class({})

function item_special_antares_upgrade_2:GetIntrinsicModifierName()
	return "modifier_item_special_antares_upgrade_2"
end

modifier_item_special_antares_upgrade_2 = class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	DeclareFunctions		= function(self) return 
		{MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		} end,
})

function modifier_item_special_antares_upgrade_2:OnCreated()
	if IsServer() then
		local caster = self:GetCaster()
		if caster:GetUnitName() == "npc_dota_hero_dragon_knight" then
			local ability = caster:FindAbilityByName("antares_dragon_form")
			local modifier = caster:AddNewModifier(caster, ability, "modifier_antares_dragon_form", nil)	
		end		
	end		
end

function modifier_item_special_antares_upgrade_2:OnDestroy()
	local caster = self:GetCaster()
	caster:RemoveModifierByName("modifier_antares_dragon_form")			
end

function modifier_item_special_antares_upgrade_2:GetModifierPreAttack_BonusDamage()
	return self:GetAbility():GetSpecialValueFor("bonus_dmg")
end

function modifier_item_special_antares_upgrade_2:GetModifierBonusStats_Strength()
	return self:GetAbility():GetSpecialValueFor("bonus_str")
end

function modifier_item_special_antares_upgrade_2:GetModifierBonusStats_Agility()
	return self:GetAbility():GetSpecialValueFor("bonus_agi")
end

function modifier_item_special_antares_upgrade_2:GetModifierBonusStats_Intellect()
	return self:GetAbility():GetSpecialValueFor("bonus_int")
end

function modifier_item_special_antares_upgrade_2:GetEffectName()
	if self:GetCaster():GetUnitName()=="npc_dota_hero_dragon_knight" then
		return "particles/econ/courier/courier_babyroshan_ti9/courier_babyroshan_ti9_ambient.vpcf"
	else
		return
	end	
end

item_special_antares_upgrade_3 = class({})

function item_special_antares_upgrade_3:GetIntrinsicModifierName()
	return "modifier_item_special_antares_upgrade_3"
end

modifier_item_special_antares_upgrade_3 = class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	DeclareFunctions		= function(self) return 
		{MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		} end,
})

function modifier_item_special_antares_upgrade_3:OnCreated()
	if IsServer() then
		local caster = self:GetCaster()
		if caster:GetUnitName() == "npc_dota_hero_dragon_knight" then
			local ability = caster:FindAbilityByName("antares_dragon_form")
			local modifier = caster:AddNewModifier(caster, ability, "modifier_antares_dragon_form", nil)	
		end		
	end		
end

function modifier_item_special_antares_upgrade_3:OnDestroy()
	local caster = self:GetCaster()
	caster:RemoveModifierByName("modifier_antares_dragon_form")			
end

function modifier_item_special_antares_upgrade_3:GetModifierPreAttack_BonusDamage()
	return self:GetAbility():GetSpecialValueFor("bonus_dmg")
end

function modifier_item_special_antares_upgrade_3:GetModifierBonusStats_Strength()
	return self:GetAbility():GetSpecialValueFor("bonus_str")
end

function modifier_item_special_antares_upgrade_3:GetModifierBonusStats_Agility()
	return self:GetAbility():GetSpecialValueFor("bonus_agi")
end

function modifier_item_special_antares_upgrade_3:GetModifierBonusStats_Intellect()
	return self:GetAbility():GetSpecialValueFor("bonus_int")
end

function modifier_item_special_antares_upgrade_3:GetEffectName()
	if self:GetCaster():GetUnitName()=="npc_dota_hero_dragon_knight" then
		return "particles/econ/courier/courier_babyroshan_ti9/courier_babyroshan_ti9_ambient.vpcf"
	else
		return
	end	
end

item_special_antares_upgrade_4 = class({})

function item_special_antares_upgrade_4:GetIntrinsicModifierName()
	return "modifier_item_special_antares_upgrade_4"
end

modifier_item_special_antares_upgrade_4 = class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	DeclareFunctions		= function(self) return 
		{MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		} end,
})

function modifier_item_special_antares_upgrade_4:OnCreated()
	if IsServer() then
		local caster = self:GetCaster()
		if caster:GetUnitName() == "npc_dota_hero_dragon_knight" then
			local ability = caster:FindAbilityByName("antares_dragon_form")
			local modifier = caster:AddNewModifier(caster, ability, "modifier_antares_dragon_form", nil)	
		end		
	end
end

function modifier_item_special_antares_upgrade_4:OnDestroy()
	local caster = self:GetCaster()
	caster:RemoveModifierByName("modifier_antares_dragon_form")			
end

function modifier_item_special_antares_upgrade_4:GetModifierPreAttack_BonusDamage()
	return self:GetAbility():GetSpecialValueFor("bonus_dmg")
end

function modifier_item_special_antares_upgrade_4:GetModifierBonusStats_Strength()
	return self:GetAbility():GetSpecialValueFor("bonus_str")
end

function modifier_item_special_antares_upgrade_4:GetModifierBonusStats_Agility()
	return self:GetAbility():GetSpecialValueFor("bonus_agi")
end

function modifier_item_special_antares_upgrade_4:GetModifierBonusStats_Intellect()
	return self:GetAbility():GetSpecialValueFor("bonus_int")
end

function modifier_item_special_antares_upgrade_4:GetEffectName()
	if self:GetCaster():GetUnitName()=="npc_dota_hero_dragon_knight" then
		return "particles/econ/courier/courier_babyroshan_ti9/courier_babyroshan_ti9_ambient.vpcf"
	else
		return
	end	
end
