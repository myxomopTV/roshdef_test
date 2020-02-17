LinkLuaModifier("modifier_sven_thirsty_blade", "heroes/hero_sven/thirsty_blade", LUA_MODIFIER_MOTION_NONE)

sven_thirsty_blade = class({})

function sven_thirsty_blade:GetAbilityTextureName()
	local caster = self:GetCaster()
	if caster:HasModifier("modifier_sven_god_strength") or caster:HasModifier("modifier_sven_powerup") then
		return "sven/thirsty_blade_red"
	else
		return "sven/thirsty_blade_blue"
	end
end
function sven_thirsty_blade:GetIntrinsicModifierName()
	return "modifier_sven_thirsty_blade"
end
--------------------------------------------------------
------------------------------------------------------------
modifier_sven_thirsty_blade = class({
	IsHidden 				= function(self) return false end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	DeclareFunctions		= function(self) return 
		{MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_EVENT_ON_DEATH,
		} end,
})

function modifier_sven_thirsty_blade:GetModifierBaseAttack_BonusDamage()
	return self:GetStackCount()*self:GetAbility():GetSpecialValueFor("stack_bonus_dmg")
end

function modifier_sven_thirsty_blade:OnAttackLanded( params )
	if IsServer() then
		if params.attacker == self:GetParent() and ( not self:GetParent():IsIllusion() ) then
			if self:GetParent():PassivesDisabled() then
				return 0
			end

			local target = params.target
			if target ~= nil and target:GetTeamNumber() ~= self:GetParent():GetTeamNumber() then
				local cleave_damage = params.damage * self:GetAbility():GetSpecialValueFor("cleave_damage_pct") / 100.0
				local cleave_radius = self:GetAbility():GetSpecialValueFor("cleave_radius")
				local effect = ""
					if self:GetParent():HasModifier("modifier_sven_god_strength") or self:GetParent():HasModifier("modifier_sven_powerup") then
					effect_name = "particles/econ/items/sven/sven_ti7_sword/sven_ti7_sword_spell_great_cleave_gods_strength_crit.vpcf"
				else
					effect_name = "particles/econ/items/sven/sven_ti7_sword/sven_ti7_sword_spell_great_cleave_crit.vpcf"
				end
				DoCleaveAttack( self:GetParent(), target, self:GetAbility(), cleave_damage, cleave_radius, cleave_radius, cleave_radius, effect_name )
			end
		end
	end

	return 0
end

function modifier_sven_thirsty_blade:OnDeath(data)
	if IsServer() then
		local parent = self:GetParent()
		local killer = data.attacker
		local killed_unit = data.unit
		
		if killer == parent then
			self:IncrementStackCount()
			
			local effect = "particles/units/heroes/hero_pudge/pudge_fleshheap_count.vpcf"
			local pfx = ParticleManager:CreateParticle(effect, PATTACH_ABSORIGIN_FOLLOW, parent)
			ParticleManager:ReleaseParticleIndex(pfx)
		end
	end
end
