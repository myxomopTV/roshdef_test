LinkLuaModifier("modifier_storm_wisdom_power", "heroes/hero_storm/wisdom_power", LUA_MODIFIER_MOTION_NONE)

storm_wisdom_power = class({})

function storm_wisdom_power:GetIntrinsicModifierName()
	return "modifier_storm_wisdom_power"
end

--------------------------------------------------------
------------------------------------------------------------
modifier_storm_wisdom_power = class({
	IsHidden 				= function(self) return false end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	DeclareFunctions		= function(self) return 
		{MODIFIER_EVENT_ON_DEATH,
--			MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
			MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
		} end,
})

function modifier_storm_wisdom_power:OnDeath(data)
	if IsServer() then
		local parent = self:GetParent()
		local killer = data.attacker
		local killed_unit = data.unit
		
		if killer == parent and killed_unit then
			self:IncrementStackCount()
			
			local effect = "particles/units/heroes/hero_pudge/pudge_fleshheap_count.vpcf"
			local pfx = ParticleManager:CreateParticle(effect, PATTACH_ABSORIGIN_FOLLOW, parent)
			ParticleManager:ReleaseParticleIndex(pfx)
		end
	end
end

function modifier_storm_wisdom_power:GetModifierBonusStats_Intellect()
	return self:GetAbility():GetSpecialValueFor("stat_per_kill")*self:GetStackCount()
end

function modifier_storm_wisdom_power:GetModifierConstantManaRegen()
	return self:GetAbility():GetSpecialValueFor("stat_per_kill")*self:GetStackCount()
end
