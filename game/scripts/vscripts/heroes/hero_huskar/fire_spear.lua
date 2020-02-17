LinkLuaModifier("modifier_huskar_fire_spear", "heroes/hero_huskar/fire_spear", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_huskar_fire_spear_debuff", "heroes/hero_huskar/fire_spear", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_huskar_fire_spear_counter", "heroes/hero_huskar/fire_spear", LUA_MODIFIER_MOTION_NONE)

huskar_fire_spear = class({})

function huskar_fire_spear:GetIntrinsicModifierName()
	return "modifier_huskar_fire_spear"
end
--------------------------------------------------------
------------------------------------------------------------
modifier_huskar_fire_spear = class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	DeclareFunctions		= function(self) return 
		{
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		} end,
})
function modifier_huskar_fire_spear:OnCreated( )
	self:GetCaster():SetRangedProjectileName("particles/units/heroes/hero_huskar/huskar_burning_spear.vpcf")
end
function modifier_huskar_fire_spear:OnAttackLanded( params )
	if IsServer() then
		local caster = self:GetCaster()
		if params.attacker == caster and ( not caster:IsIllusion() ) then
			if self:GetParent():PassivesDisabled() then
				return 0
			end

			local target = params.target

			if target ~= nil and target:GetTeamNumber() ~= self:GetParent():GetTeamNumber() and not target:IsBuilding() and not target:IsMagicImmune() then
				local ability = self:GetAbility()

				local debuff_duration = ability:GetSpecialValueFor("fire_duration")
				local DebuffModifierCounter = "modifier_huskar_fire_spear_counter"
				local DebuffModifier = "modifier_huskar_fire_spear_debuff"
				local currentDebuffStacks = target:GetModifierStackCount(DebuffModifierCounter, ability)

				EmitSoundOn("Hero_Huskar.Burning_Spear",target)
				target:AddNewModifier( caster, ability, DebuffModifier , { Duration = debuff_duration } )
				target:AddNewModifier( caster, ability, DebuffModifierCounter , { Duration = debuff_duration } )

				target:SetModifierStackCount(DebuffModifierCounter, ability, (currentDebuffStacks + 1))

			end
		end
	end

	return 0
end


modifier_huskar_fire_spear_debuff = class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return true end,
	GetAttributes 			= function(self) return MODIFIER_ATTRIBUTE_MULTIPLE end,
})
-------------------------------------------

function modifier_huskar_fire_spear_debuff:OnDestroy(keys)
	local caster = self:GetCaster()
	local parent = self:GetParent()
	local modifier = "modifier_huskar_fire_spear_counter"

	if parent:HasModifier(modifier) then
		local previous_stack_count = parent:GetModifierStackCount(modifier, caster)
		if previous_stack_count > 1 then
			parent:SetModifierStackCount(modifier, caster, previous_stack_count - 1)
		else
			parent:RemoveModifierByName(modifier)
		end
	end
end

modifier_huskar_fire_spear_counter = class({
	IsHidden 				= function(self) return false end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return true end,
	IsBuff                  = function(self) return false end,
	RemoveOnDeath 			= function(self) return true end,

})

function modifier_huskar_fire_spear_counter:GetEffectName()
	return "particles/units/heroes/hero_huskar/huskar_burning_spear_debuff.vpcf"
end

function modifier_huskar_fire_spear_counter:OnCreated()
	self:StartIntervalThink(1)
end

function modifier_huskar_fire_spear_counter:OnIntervalThink()
	local caster = self:GetCaster()
	local parent = self:GetParent()
	local ability = self:GetAbility()
	local dmg_per_sec = ability:GetSpecialValueFor("dmg_per_sec")
	local total_dmg = dmg_per_sec*self:GetStackCount()
	
	DealDamage(caster, parent, total_dmg, DAMAGE_TYPE_MAGICAL, nil, ability)
end
