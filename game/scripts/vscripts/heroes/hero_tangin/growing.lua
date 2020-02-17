LinkLuaModifier("modifier_tangin_growing", "heroes/hero_tangin/growing", LUA_MODIFIER_MOTION_NONE)

tangin_growing = class({})

function tangin_growing:GetIntrinsicModifierName()
	return "modifier_tangin_growing"
end
--------------------------------------------------------
------------------------------------------------------------
modifier_tangin_growing = class({
	IsHidden 				= function(self) return false end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	DeclareFunctions		= function(self) return 
		{
			MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
			MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
			MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
			MODIFIER_PROPERTY_MODEL_SCALE,
			MODIFIER_EVENT_ON_DEATH,
		} end,
})

function modifier_tangin_growing:GetModifierBonusStats_Strength()
	local mult = 1
	local caster = self:GetCaster()
	if caster:HasModifier("modifier_tangin_sleep") then
		mult = 5
	end
	if caster:HasModifier("modifier_item_special_tangin") or caster:HasModifier("modifier_item_special_tangin_upgrade")then
		mult = mult*2
	end
	return self:GetAbility():GetSpecialValueFor("bonus_str")*mult
end

function modifier_tangin_growing:GetModifierAttackSpeedBonus_Constant()
	local mult = 1
	local caster = self:GetCaster()
	if caster:HasModifier("modifier_tangin_sleep") then
		mult = 5
	end
	if caster:HasModifier("modifier_item_special_tangin") or caster:HasModifier("modifier_item_special_tangin_upgrade")then
		mult = mult*2
	end
	return self:GetAbility():GetSpecialValueFor("bonus_as")*mult
end

function modifier_tangin_growing:GetModifierMoveSpeedBonus_Constant()
	local mult = 1
	local caster = self:GetCaster()
	if caster:HasModifier("modifier_tangin_sleep") then
		mult = 5
	end
	if caster:HasModifier("modifier_item_special_tangin") or caster:HasModifier("modifier_item_special_tangin_upgrade")then
		mult = mult*2
	end
	return self:GetAbility():GetSpecialValueFor("bonus_ms")*mult
end

function modifier_tangin_growing:GetModifierModelScale()
	local mult = 1
	if self:GetCaster():HasModifier("modifier_tangin_sleep") then
		mult = 2
	end
	return self:GetAbility():GetSpecialValueFor("bonus_scale")*mult
end

function modifier_tangin_growing:OnDeath(data)
	if IsServer() then
		local parent = self:GetParent()
		local killer = data.attacker
		local killed_unit = data.unit
		
		if killer == parent and killed_unit:GetTeam() ~= killer:GetTeam() then
			local ability = self:GetAbility()
			local current_level = ability:GetLevel()
			local kill_required = ability:GetLevelSpecialValueFor("kill_required", current_level)
			self:IncrementStackCount()
			
			if self:GetStackCount() == kill_required then
				ability:SetLevel(current_level+1)
			end
			local effect = "particles/units/heroes/hero_pudge/pudge_fleshheap_count.vpcf"
			local pfx = ParticleManager:CreateParticle(effect, PATTACH_ABSORIGIN_FOLLOW, parent)
			ParticleManager:ReleaseParticleIndex(pfx)

		end
	end
end
