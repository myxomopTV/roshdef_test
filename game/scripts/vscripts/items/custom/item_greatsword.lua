LinkLuaModifier( "modifier_item_greatsword", "items/custom/item_greatsword.lua", LUA_MODIFIER_MOTION_NONE )			-- Owner's bonus attributes, stackable
LinkLuaModifier( "modifier_item_shattered_greatsword", "items/custom/item_greatsword.lua", LUA_MODIFIER_MOTION_NONE )	-- On-damage slow applier

item_greatsword = class({})

function item_greatsword:GetIntrinsicModifierName()
	return "modifier_item_greatsword"
end

modifier_item_greatsword = class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	DeclareFunctions		= function(self) return 
		{
			MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
			MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
			MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
			MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		} end,
})

function modifier_item_greatsword:GetModifierBonusStats_Strength()
	return self:GetAbility():GetSpecialValueFor("rapier_str") end

function modifier_item_greatsword:GetModifierBonusStats_Agility()
	return self:GetAbility():GetSpecialValueFor("rapier_agi") end

function modifier_item_greatsword:GetModifierBonusStats_Intellect()
	return self:GetAbility():GetSpecialValueFor("rapier_int") end
	
function modifier_item_greatsword:GetModifierPreAttack_BonusDamage()
	return self:GetAbility():GetSpecialValueFor("rapier_dmg")
end

item_shattered_greatsword = class({})


function item_shattered_greatsword:GetIntrinsicModifierName()
	return "modifier_item_shattered_greatsword"
end

modifier_item_shattered_greatsword = class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	DeclareFunctions		= function(self) return 
		{
			MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
			MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
			MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
			MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		} end,
})

function modifier_item_shattered_greatsword:OnCreated()
	local caster = self:GetCaster()
	if caster:GetUnitName() == "npc_dota_hero_sven" then
		local ability = caster:FindAbilityByName("sven_god_strength")
		local modifier = caster:AddNewModifier(caster, ability, "modifier_sven_god_strength", nil)	
	end		
end

function modifier_item_shattered_greatsword:OnDestroy()
	local caster = self:GetCaster()
	caster:RemoveModifierByName("modifier_sven_god_strength")			
end

function modifier_item_shattered_greatsword:GetModifierBonusStats_Strength()
	return self:GetAbility():GetSpecialValueFor("rapier_str") end

function modifier_item_shattered_greatsword:GetModifierBonusStats_Agility()
	return self:GetAbility():GetSpecialValueFor("rapier_agi") end

function modifier_item_shattered_greatsword:GetModifierBonusStats_Intellect()
	return self:GetAbility():GetSpecialValueFor("rapier_int") end
	
function modifier_item_shattered_greatsword:GetModifierPreAttack_BonusDamage()
	return self:GetAbility():GetSpecialValueFor("rapier_dmg")
end

