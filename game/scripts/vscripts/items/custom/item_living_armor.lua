LinkLuaModifier("modifier_item_living_armor", "items/custom/item_living_armor", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_living_armor_buff", "items/custom/item_living_armor", LUA_MODIFIER_MOTION_NONE)

item_living_armor = class({})

function item_living_armor:OnSpellStart()
	local caster = self:GetCaster()
	local ability = self
	local buff_duration = ability:GetSpecialValueFor("buff_duration")
	EmitSoundOn("Hero_Treant.LivingArmor.Cast", caster)
	
	local modifier = caster:AddNewModifier(caster, ability, "modifier_item_living_armor_buff", {duration = buff_duration})

end

function item_living_armor:GetIntrinsicModifierName()
	return "modifier_item_living_armor"
end
--------------------------------------------------------
------------------------------------------------------------
modifier_item_living_armor = class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	DeclareFunctions		= function(self) return 
		{MODIFIER_PROPERTY_HEALTH_BONUS,
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		} end,
})

function modifier_item_living_armor:GetModifierHealthBonus()
	return self:GetAbility():GetSpecialValueFor("bonus_health")
end

function modifier_item_living_armor:GetModifierConstantHealthRegen()
	return self:GetAbility():GetSpecialValueFor("bonus_regen")
end
function modifier_item_living_armor:GetModifierPhysicalArmorBonus()
	return self:GetAbility():GetSpecialValueFor("bonus_armor")
end
--------------------------------------------------------
------------------------------------------------------------
modifier_item_living_armor_buff = class({
	IsHidden 				= function(self) return false end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	DeclareFunctions		= function(self) return 
		{MODIFIER_PROPERTY_PHYSICAL_CONSTANT_BLOCK_SPECIAL,
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT} end,
})

function modifier_item_living_armor_buff:OnCreated()
	local caster = self:GetCaster()
	local effect = "particles/units/heroes/hero_treant/treant_livingarmor.vpcf"
	local pfx = ParticleManager:CreateParticle(effect, PATTACH_POINT_FOLLOW, caster)
	ParticleManager:SetParticleControlEnt(pfx, 0, caster, PATTACH_POINT_FOLLOW, "attach_feet", caster:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(pfx, 1, caster, PATTACH_POINT_FOLLOW, "attach_feet", caster:GetAbsOrigin(), true)
--	ParticleManager:ReleaseParticleIndex(pfx)	
--	self:AddEffect(pfx)
	self:AddParticle(pfx, true, false, 100, true, false)
end

function modifier_item_living_armor_buff:GetModifierPhysical_ConstantBlockSpecial()
	return self:GetAbility():GetSpecialValueFor("buff_block")
end

function modifier_item_living_armor_buff:GetModifierConstantHealthRegen()
	return self:GetAbility():GetSpecialValueFor("buff_regen")
end

