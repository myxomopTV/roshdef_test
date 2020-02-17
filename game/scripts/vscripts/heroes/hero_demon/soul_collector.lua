LinkLuaModifier("modifier_demon_soul_collector", "heroes/hero_demon/soul_collector", LUA_MODIFIER_MOTION_NONE)

demon_soul_collector = class({})

function demon_soul_collector:GetIntrinsicModifierName()
	return "modifier_demon_soul_collector"
end

--------------------------------------------------------
------------------------------------------------------------
modifier_demon_soul_collector = class({
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

function modifier_demon_soul_collector:OnDeath(data)
	if IsServer() then
		local parent = self:GetParent()
		local killer = data.attacker
		local killed_unit = data.unit
		
		if killer == parent and killed_unit:GetTeam() ~= killer:GetTeam() then
			if killer:IsRealHero() == false then
				killer = killer:GetPlayerOwner():GetAssignedHero()
			end
			killer:FindModifierByName("modifier_demon_soul_collector"):IncrementStackCount()

			
			local effect = "particles/units/heroes/hero_pudge/pudge_fleshheap_count.vpcf"
			local pfx = ParticleManager:CreateParticle(effect, PATTACH_ABSORIGIN_FOLLOW, killer)
			ParticleManager:ReleaseParticleIndex(pfx)
		end
	end
end
function modifier_demon_soul_collector:GetModifierBonusStats_Strength()
	local mult = 1
	if self:GetCaster():HasModifier("modifier_item_mystic_dagger_upgrade") then
		mult = 3
	end	
	return self:GetAbility():GetSpecialValueFor("stat_per_kill")*self:GetStackCount()*mult
end


