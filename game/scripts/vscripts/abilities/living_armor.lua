LinkLuaModifier("modifier_living_armor", "abilities/living_armor", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_living_armor_buff", "abilities/living_armor", LUA_MODIFIER_MOTION_NONE)

living_armor = class({})

function living_armor:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	local ability = self
	local buff_duration = ability:GetSpecialValueFor("buff_duration")
	EmitSoundOn("Hero_Treant.LivingArmor.Cast", caster)
	
	local modifier = target:AddNewModifier(caster, ability, "modifier_living_armor_buff", {duration = buff_duration})

end

creature_living_armor = class(living_armor)
boss_living_armor = class(living_armor)

--------------------------------------------------------
------------------------------------------------------------
modifier_living_armor_buff = class({
	IsHidden 				= function(self) return false end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	DeclareFunctions		= function(self) return 
		{	MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
			--MODIFIER_PROPERTY_PHYSICAL_CONSTANT_BLOCK_SPECIAL,
			MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT} end,
})

function modifier_living_armor_buff:OnCreated()
	local parent = self:GetParent()
	local ability = self:GetAbility()
	self.buff_armor = ability:GetSpecialValueFor("buff_armor")
	self.buff_regen = ability:GetSpecialValueFor("buff_regen")

	local effect = "particles/units/heroes/hero_treant/treant_livingarmor.vpcf"
	local pfx = ParticleManager:CreateParticle(effect, PATTACH_POINT_FOLLOW, parent)
	ParticleManager:SetParticleControlEnt(pfx, 0, parent, PATTACH_POINT_FOLLOW, "attach_feet", parent:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(pfx, 1, parent, PATTACH_POINT_FOLLOW, "attach_feet", parent:GetAbsOrigin(), true)
--	ParticleManager:ReleaseParticleIndex(pfx)	
--	self:AddEffect(pfx)
	self:AddParticle(pfx, true, false, 100, true, false)
end

function modifier_living_armor_buff:GetModifierPhysical_ConstantBlockSpecial()
	return self:GetAbility():GetSpecialValueFor("buff_block")
end
function modifier_living_armor_buff:GetModifierPhysicalArmorBonus()
	return self.buff_armor
end
function modifier_living_armor_buff:GetModifierConstantHealthRegen()
	return self.buff_regen
end



