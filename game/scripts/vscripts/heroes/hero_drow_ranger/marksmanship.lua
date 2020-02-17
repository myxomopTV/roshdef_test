LinkLuaModifier("modifier_drow_ranger_marksmanship_custom", "heroes/hero_drow_ranger/marksmanship", LUA_MODIFIER_MOTION_NONE)

drow_ranger_marksmanship_custom = class({})

function drow_ranger_marksmanship_custom:GetIntrinsicModifierName()
	return "modifier_drow_ranger_marksmanship_custom"
end

--------------------------------------------------------
------------------------------------------------------------
modifier_drow_ranger_marksmanship_custom = class({
	IsHidden 				= function(self) return false end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	DeclareFunctions		= function(self) return 
		{MODIFIER_EVENT_ON_DEATH,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		} end,
})

function modifier_drow_ranger_marksmanship_custom:OnDeath(data)
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
function modifier_drow_ranger_marksmanship_custom:GetModifierBonusStats_Agility()
	return self:GetAbility():GetSpecialValueFor("stat_per_kill")*self:GetStackCount()
end

