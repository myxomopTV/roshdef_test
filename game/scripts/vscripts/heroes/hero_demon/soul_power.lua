LinkLuaModifier("modifier_demon_soul_power", "heroes/hero_demon/soul_power", LUA_MODIFIER_MOTION_NONE)

demon_soul_power = class({})

function demon_soul_power:GetIntrinsicModifierName()
	return "modifier_demon_soul_power"
end

--------------------------------------------------------
------------------------------------------------------------
modifier_demon_soul_power = class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	DeclareFunctions		= function(self) return 
		{
			MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		} end,
})

function modifier_demon_soul_power:OnCreated()
	if IsServer() then
		self:StartIntervalThink(0.1)
	end
end

function modifier_demon_soul_power:OnIntervalThink()
	if IsServer() then
		local caster = self:GetCaster()
		local soul_modifier_count = caster:FindModifierByName("modifier_demon_soul_collector"):GetStackCount()
		self:SetStackCount(soul_modifier_count)

	end
end

function modifier_demon_soul_power:GetModifierPreAttack_BonusDamage()
	return self:GetAbility():GetSpecialValueFor("dmg_per_soul") * self:GetStackCount()
end


