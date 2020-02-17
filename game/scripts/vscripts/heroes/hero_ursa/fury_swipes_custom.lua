LinkLuaModifier("modifier_ursa_fury_swipes_custom", "heroes/hero_ursa/fury_swipes_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ursa_fury_swipes_custom_debuff", "heroes/hero_ursa/fury_swipes_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ursa_fury_swipes_custom_buff", "heroes/hero_ursa/fury_swipes_custom", LUA_MODIFIER_MOTION_NONE)

ursa_fury_swipes_custom = class({})

function ursa_fury_swipes_custom:GetIntrinsicModifierName()
	return "modifier_ursa_fury_swipes_custom"
end
--------------------------------------------------------
------------------------------------------------------------
modifier_ursa_fury_swipes_custom = class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	DeclareFunctions		= function(self) return 
		{
		MODIFIER_EVENT_ON_ATTACK,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
--		MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_PHYSICAL,
		} end,
})

function modifier_ursa_fury_swipes_custom:OnAttack( params )
	if IsServer() then
		local caster = self:GetCaster()
		if params.attacker == caster and ( not caster:IsIllusion() ) then
			if self:GetParent():PassivesDisabled() then
				return 0
			end

			local target = params.target

			if target ~= nil and target:GetTeamNumber() ~= self:GetParent():GetTeamNumber() and not target:IsBuilding() and not target:IsMagicImmune() then
				local parent = self:GetParent()
				local ability = self:GetAbility()
				local stack_duration = ability:GetSpecialValueFor("stack_duration")
				local StackModifier = "modifier_ursa_fury_swipes_custom_debuff"
				local BuffStackModifier = "modifier_ursa_fury_swipes_custom_buff"
				local currentDebuffStacks = target:GetModifierStackCount(StackModifier, ability)

				target:AddNewModifier( caster, ability, StackModifier , { Duration = stack_duration } )
				target:SetModifierStackCount(StackModifier, ability, (currentDebuffStacks + 1))

				caster:AddNewModifier( caster, ability, BuffStackModifier , nil )
				caster:SetModifierStackCount(BuffStackModifier, ability, (currentDebuffStacks + 1))
			end
		end
	end
end
function modifier_ursa_fury_swipes_custom:OnAttackLanded( params )
	if IsServer() then
		local caster = self:GetCaster()
		if params.attacker == caster and ( not caster:IsIllusion() ) then
			if self:GetParent():PassivesDisabled() then
				return 0
			end

			local target = params.target

			if target ~= nil and target:GetTeamNumber() ~= self:GetParent():GetTeamNumber() and not target:IsBuilding() and not target:IsMagicImmune() then
				caster:RemoveModifierByName("modifier_ursa_fury_swipes_custom_buff")
			end
		end
	end

	return 0
end


modifier_ursa_fury_swipes_custom_buff = class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return true end,
	DeclareFunctions		= function(self) return 
		{
		MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_PHYSICAL,
		} end,
})
function modifier_ursa_fury_swipes_custom_buff:GetModifierProcAttack_BonusDamage_Physical()
	local caster = self:GetCaster()
	local ability = self:GetAbility()
	local stack_damage = ability:GetSpecialValueFor("stack_damage")
	
	local ult_ability = caster:FindAbilityByName("ursa_enrage_custom")
	local dmg_multiplier = ult_ability:GetSpecialValueFor("dmg_multiplier")

	local total_dmg = stack_damage*self:GetStackCount()
	if caster:HasModifier("modifier_ursa_enrage_custom") then
		total_dmg = total_dmg * dmg_multiplier
	end
	return total_dmg
end

modifier_ursa_fury_swipes_custom_debuff = class({
	IsHidden 				= function(self) return false end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return true end,
	IsBuff                  = function(self) return false end,
	RemoveOnDeath 			= function(self) return true end,
})
-------------------------------------------

function modifier_ursa_fury_swipes_custom_debuff:GetEffectName()
	return "particles/units/heroes/hero_ursa/ursa_fury_swipes_debuff.vpcf"
end

function modifier_ursa_fury_swipes_custom_debuff:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end


