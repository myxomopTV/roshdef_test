LinkLuaModifier("modifier_geostrike_custom", "geostrike_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_geostrike_custom_debuff", "geostrike_custom", LUA_MODIFIER_MOTION_NONE)

------------------------------------------------------------
------------------------------------------------------------

geostrike_custom = class({})

function geostrike_custom:GetIntrinsicModifierName()
	return "modifier_geostrike_custom"
end

------------------------------------------------------------
------------------------------------------------------------
modifier_geostrike_custom = class({
	IsHidden 				= function(self) return true end,
	DeclareFunctions		= function(self) return 
		{MODIFIER_EVENT_ON_ATTACK_LANDED} end,
})

function modifier_geostrike_custom:OnAttackLanded(data)
	local ability = self:GetAbility()
	local duration = ability:GetSpecialValueFor("duration")
	local parent = self:GetParent()
	local attacker = data.attacker
	local target = data.target

	if parent == attacker and target and not target:IsBuilding() then
		local modifier = target:FindModifierByNameAndCaster("modifier_geostrike_custom_debuff", parent)
		if modifier then
			modifier:SetDuration(duration, true)
		else
			target:AddNewModifier(parent, ability, "modifier_geostrike_custom_debuff", {duration = duration})
		end
	end
	return 1
end

modifier_geostrike_custom_debuff = class({
	IsHidden 				= function(self) return false end,
	GetAttributes 			= function(self) return MODIFIER_ATTRIBUTE_MULTIPLE end,
	DeclareFunctions		= function(self) return 
	{MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE} end,
})

function modifier_geostrike_custom_debuff:GetEffectName()
	return "particles/units/heroes/hero_meepo/meepo_geostrike.vpcf"
end

function modifier_geostrike_custom_debuff:OnCreated()
	self:StartIntervalThink(1)
end

function modifier_geostrike_custom_debuff:OnIntervalThink()
	local parent = self:GetParent()
	local caster = self:GetCaster()
	local ability = self:GetAbility()
	local dps = ability:GetSpecialValueFor("dps")

    local dTable = {
        victim = parent,
        attacker = caster,
        damage = dps,
        damage_type = DAMAGE_TYPE_MAGICAL,
--        damage_flags = nil,
        ability = ability
    }
    ApplyDamage(dTable)		
end

function modifier_geostrike_custom_debuff:GetModifierMoveSpeedBonus_Percentage()
	return  self:GetAbility():GetSpecialValueFor("ms_slow")*(-1)
end