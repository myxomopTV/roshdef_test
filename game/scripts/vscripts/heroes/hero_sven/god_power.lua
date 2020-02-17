LinkLuaModifier("modifier_sven_god_power", "heroes/hero_sven/god_power", LUA_MODIFIER_MOTION_NONE)

sven_god_power = class({})

function sven_god_power:OnSpellStart()
	local caster = self:GetCaster()
	local buff_duration = self:GetSpecialValueFor("buff_duration")
	caster:AddNewModifier(caster, self, "modifier_sven_god_power", {duration = buff_duration})
	EmitSoundOn("sven_sven_ability_godstrength_02", caster)
end

modifier_sven_god_power = class({
	IsHidden 				= function(self) return false end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return true end,
--	GetAttributes 			= function(self) return MODIFIER_ATTRIBUTE_MULTIPLE end,
	DeclareFunctions		= function(self) return 
		{
			MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,
		} end,
})
function modifier_sven_god_power:CheckState()
	local states = {
		[MODIFIER_STATE_MAGIC_IMMUNE] = true,
	}
	return states
end

function modifier_sven_god_power:OnCreated()
	local caster = self:GetCaster()
	local ability = self:GetAbility()
	if caster:HasModifier("modifier_sven_thirsty_blade") then
		self.blade_modifier = caster:FindModifierByName("modifier_sven_thirsty_blade")
		local stack_count = self.blade_modifier:GetStackCount()
		self.stack_count_increase = stack_count * (ability:GetSpecialValueFor("blade_multiplier") - 1)
		self.blade_modifier:SetStackCount(stack_count+self.stack_count_increase)
	end
end

function modifier_sven_god_power:OnDestroy()
	local caster = self:GetCaster()
	local ability = self:GetAbility()
	if self.blade_modifier then
		local stack_count = self.blade_modifier:GetStackCount()
		self.blade_modifier:SetStackCount(stack_count-self.stack_count_increase)
	end
end
function modifier_sven_god_power:GetEffectName()
	return "particles/item/black_queen_cape/black_king_bar_avatar.vpcf"
end
function modifier_sven_god_power:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end
function modifier_sven_god_power:GetModifierBaseAttack_BonusDamage()
	return self:GetStackCount() or 0
end
