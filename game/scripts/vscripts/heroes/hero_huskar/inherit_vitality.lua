LinkLuaModifier("modifier_huskar_inherit_vitality_passive", "heroes/hero_huskar/inherit_vitality", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_huskar_inherit_vitality_buff", "heroes/hero_huskar/inherit_vitality", LUA_MODIFIER_MOTION_NONE)

huskar_inherit_vitality = class({})

function huskar_inherit_vitality:GetIntrinsicModifierName()
	return "modifier_huskar_inherit_vitality_passive"
end
function huskar_inherit_vitality:OnSpellStart()
	local caster = self:GetCaster()
	local buff_duration = self:GetSpecialValueFor("buff_duration")
	local modifier = caster:FindModifierByName("modifier_huskar_inherit_vitality_passive")
	local stack_count = modifier:GetStackCount()
	modifier:SetStackCount(0)
	
	EmitSoundOn("Hero_Huskar.Inner_Vitality",caster)
	local buff_modifier = caster:AddNewModifier( caster, self, "modifier_huskar_inherit_vitality_buff", {duration = buff_duration})
	buff_modifier:SetStackCount(stack_count)
end
--------------------------------------------------------
------------------------------------------------------------
modifier_huskar_inherit_vitality_passive = class({
	IsHidden 				= function(self) return false end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	DeclareFunctions		= function(self) return 
		{MODIFIER_EVENT_ON_DEATH,
		MODIFIER_PROPERTY_HEALTH_BONUS,
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		} end,
})

function modifier_huskar_inherit_vitality_passive:OnDeath(data)
	if IsServer() then
		local parent = self:GetParent()
		local killer = data.attacker
		local killed_unit = data.unit
		
		if killer == parent then
			self:IncrementStackCount()
			
			local effect = "particles/units/heroes/hero_pudge/pudge_fleshheap_count.vpcf"
			local pfx = ParticleManager:CreateParticle(effect, PATTACH_ABSORIGIN_FOLLOW, parent)
			ParticleManager:ReleaseParticleIndex(pfx)
		end
	end
end
function modifier_huskar_inherit_vitality_passive:GetModifierHealthBonus()
	return self:GetAbility():GetSpecialValueFor("bonus_health")
end

function modifier_huskar_inherit_vitality_passive:GetModifierConstantHealthRegen()
	return self:GetAbility():GetSpecialValueFor("bonus_regen")
end

modifier_huskar_inherit_vitality_buff = class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return true end,
	DeclareFunctions		= function(self) return 
		{
		MODIFIER_PROPERTY_HEALTH_BONUS,
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		} end,
})

function modifier_huskar_inherit_vitality_buff:GetEffectName()
	return "particles/units/heroes/hero_huskar/huskar_inner_vitality.vpcf"
end

function modifier_huskar_inherit_vitality_buff:GetModifierHealthBonus()
	return self:GetAbility():GetSpecialValueFor("bonus_health_stack")*self:GetStackCount()
end

function modifier_huskar_inherit_vitality_buff:GetModifierConstantHealthRegen()
	return self:GetAbility():GetSpecialValueFor("bonus_regen_stack")*self:GetStackCount()
end
