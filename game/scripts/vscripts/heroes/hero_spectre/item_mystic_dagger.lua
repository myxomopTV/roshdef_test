LinkLuaModifier("modifier_item_mystic_dagger", "heroes/hero_spectre/item_mystic_dagger", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_mystic_dagger_upgrade", "heroes/hero_spectre/item_mystic_dagger", LUA_MODIFIER_MOTION_NONE)

item_mystic_dagger = class({})

function item_mystic_dagger:GetIntrinsicModifierName()
	return "modifier_item_mystic_dagger"
end

modifier_item_mystic_dagger = class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	DeclareFunctions		= function(self) return 
		{MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		} end,
})

function modifier_item_mystic_dagger:OnCreated()
	if not IsServer() then
		return
	end
	local caster = self:GetCaster()
	if self.item == nil and caster:GetUnitName()=="npc_dota_hero_spectre" then
		local model = "models/items/spectre/immortal_shoulders/immortal_shoulders.vmdl"
		self.item = SpawnEntityFromTableSynchronous("prop_dynamic", {model = model})
		Timers:CreateTimer(0.01,function () self.item:FollowEntity(caster, true) end)
	end
end

function modifier_item_mystic_dagger:OnDestroy()
	if self.item then
		self.item:RemoveSelf()
		self.item = nil
	end
end

function modifier_item_mystic_dagger:GetModifierPreAttack_BonusDamage()
	return self:GetAbility():GetSpecialValueFor("bonus_dmg")
end

function modifier_item_mystic_dagger:GetModifierBonusStats_Strength()
	return self:GetAbility():GetSpecialValueFor("bonus_str")
end

function modifier_item_mystic_dagger:GetModifierBonusStats_Agility()
	return self:GetAbility():GetSpecialValueFor("bonus_agi")
end

function modifier_item_mystic_dagger:GetModifierBonusStats_Intellect()
	return self:GetAbility():GetSpecialValueFor("bonus_int")
end


item_mystic_dagger_upgrade = class({})

function item_mystic_dagger_upgrade:GetIntrinsicModifierName()
	return "modifier_item_mystic_dagger_upgrade"
end

modifier_item_mystic_dagger_upgrade = class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	DeclareFunctions		= function(self) return 
		{MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		} end,
})
function modifier_item_mystic_dagger_upgrade:OnCreated()
	if not IsServer() then
		return
	end
	local caster = self:GetCaster()

	if self.item == nil and caster:GetUnitName()=="npc_dota_hero_spectre" then
		local model = "models/items/spectre/immortal_shoulders/immortal_shoulders.vmdl"
		self.item = SpawnEntityFromTableSynchronous("prop_dynamic", {model = model})
--		caster:AddNewModifier(caster, nil, "modifier_spectre_spectral_dagger_path_phased", nil)
		Timers:CreateTimer(0.01,function () self.item:FollowEntity(caster, true) end)

		local particle_name = "particles/econ/items/spectre/spectre_transversant_soul/spectre_ti7_golden_transversant_ambient.vpcf"
		local _particle = ParticleManager:CreateParticle( particle_name, PATTACH_ABSORIGIN_FOLLOW, self.item )

		ParticleManager:SetParticleControlEnt( _particle, 0, self.item, PATTACH_POINT_FOLLOW, "attach_hitloc", self.item:GetOrigin(), true )
		ParticleManager:SetParticleControlEnt( _particle, 1, self.item, PATTACH_POINT_FOLLOW, "attach_hitloc", self.item:GetOrigin(), true )
	end
end

function modifier_item_mystic_dagger_upgrade:OnDestroy()
	local caster = self:GetCaster()
	if self.item then
		self.item:RemoveSelf()
		self.item = nil
--		caster:RemoveModifierByName("modifier_spectre_spectral_dagger_path_phased")
	end
end

function modifier_item_mystic_dagger_upgrade:GetModifierPreAttack_BonusDamage()
	return self:GetAbility():GetSpecialValueFor("bonus_dmg")
end

function modifier_item_mystic_dagger_upgrade:GetModifierBonusStats_Strength()
	return self:GetAbility():GetSpecialValueFor("bonus_str")
end

function modifier_item_mystic_dagger_upgrade:GetModifierBonusStats_Agility()
	return self:GetAbility():GetSpecialValueFor("bonus_agi")
end

function modifier_item_mystic_dagger_upgrade:GetModifierBonusStats_Intellect()
	return self:GetAbility():GetSpecialValueFor("bonus_int")
end

function modifier_item_mystic_dagger_upgrade:GetEffectName()
	return 0--"particles/econ/items/spectre/spectre_transversant_soul/spectre_ti7_golden_transversant_ambient.vpcf"
end
