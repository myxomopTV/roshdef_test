LinkLuaModifier("modifier_spectre_soul_eater", "heroes/hero_spectre/soul_eater", LUA_MODIFIER_MOTION_NONE)

spectre_soul_eater = class({})

function spectre_soul_eater:GetIntrinsicModifierName()
	return "modifier_spectre_soul_eater"
end

--------------------------------------------------------
------------------------------------------------------------
modifier_spectre_soul_eater = class({
	IsHidden 				= function(self) return false end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	DeclareFunctions		= function(self) return 
		{MODIFIER_EVENT_ON_DEATH,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		} end,
})

function modifier_spectre_soul_eater:OnDeath(data)
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
function modifier_spectre_soul_eater:GetModifierBonusStats_Strength()
	local mult = 1
	if self:GetCaster():HasModifier("modifier_item_mystic_dagger") then
		mult = 2
	elseif self:GetCaster():HasModifier("modifier_item_mystic_dagger_upgrade") then
		mult = 10
	end	
	return self:GetAbility():GetSpecialValueFor("stat_per_kill")*self:GetStackCount()*mult
end

function modifier_spectre_soul_eater:GetModifierBonusStats_Agility()
	local mult = 1
	if self:GetCaster():HasModifier("modifier_item_mystic_dagger") then
		mult = 2
	elseif self:GetCaster():HasModifier("modifier_item_mystic_dagger_upgrade") then
		mult = 10
	end	
	return self:GetAbility():GetSpecialValueFor("stat_per_kill")*self:GetStackCount()*mult
end

function modifier_spectre_soul_eater:GetModifierBonusStats_Intellect()
	local mult = 1
	if self:GetCaster():HasModifier("modifier_item_mystic_dagger") then
		mult = 2
	elseif self:GetCaster():HasModifier("modifier_item_mystic_dagger_upgrade") then
		mult = 10
	end	
	return self:GetAbility():GetSpecialValueFor("stat_per_kill")*self:GetStackCount()*mult
end

