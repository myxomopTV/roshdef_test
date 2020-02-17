LinkLuaModifier("modifier_sven_god_strength", "heroes/hero_sven/god_strength", LUA_MODIFIER_MOTION_NONE)

sven_god_strength = class({})

function sven_god_strength:GetBehavior()
	if self:GetCaster():HasModifier("modifier_item_shattered_greatsword") then
		return DOTA_ABILITY_BEHAVIOR_PASSIVE
	else
		return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_IGNORE_BACKSWING
	end
end
function sven_god_strength:OnSpellStart()
	local caster = self:GetCaster()
	local buff_duration = self:GetSpecialValueFor("buff_duration")
	caster:AddNewModifier(caster, self, "modifier_sven_god_strength", {duration = buff_duration})

	EmitSoundOn("Hero_Sven.GodsStrength",caster)

	local effect = "particles/units/heroes/hero_sven/sven_spell_gods_strength.vpcf"
	local pfx = ParticleManager:CreateParticle(effect, PATTACH_ABSORIGIN_FOLLOW, caster)
	ParticleManager:ReleaseParticleIndex(pfx)

end

--function sven_god_strength:GetIntrinsicModifierName()
--	if self:GetCaster():HasModifier("modifier_sven_powerup") then
--		return "modifier_sven_god_strength"
--	end
--end
modifier_sven_god_strength = class({
	IsHidden 				= function(self) return false end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	DeclareFunctions		= function(self) return 
		{
			MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
			MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,
		} end,
})

function modifier_sven_god_strength:OnIntervalThink()
	local ability = self:GetAbility()
	if ability.passive_skill == false then
		self:Destroy()
	end
end
function modifier_sven_god_strength:GetPriority()
	return 50
end
function modifier_sven_god_strength:OnCreated()
	local caster = self:GetCaster()
	local ability = self:GetAbility()
	EmitSoundOn("Hero_Sven.GodsStrength",caster)

	local effect = "particles/units/heroes/hero_sven/sven_spell_gods_strength.vpcf"
	local pfx = ParticleManager:CreateParticle(effect, PATTACH_ABSORIGIN_FOLLOW, caster)
	ParticleManager:ReleaseParticleIndex(pfx)
	
end

function modifier_sven_god_strength:GetStatusEffectName()
	return "particles/status_fx/status_effect_gods_strength.vpcf"
end
function modifier_sven_god_strength:GetPriority()
	return 50
end
function modifier_sven_god_strength:GetModifierBonusStats_Strength()
	return self:GetAbility():GetSpecialValueFor("bonus_str")
end
function modifier_sven_god_strength:GetModifierBaseDamageOutgoing_Percentage()
	return self:GetAbility():GetSpecialValueFor("bonus_dmg")
end
