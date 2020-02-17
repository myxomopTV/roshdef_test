LinkLuaModifier("modifier_item_demon_horns", "heroes/hero_demon/item_demon_horns", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_demon_horns_upgrade", "heroes/hero_demon/item_demon_horns", LUA_MODIFIER_MOTION_NONE)

item_demon_horns = class({})

function item_demon_horns:GetIntrinsicModifierName()
	return "modifier_item_demon_horns"
end

modifier_item_demon_horns = class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	CheckState		= function(self) return 
		{
--			[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,          
		} end,
	DeclareFunctions		= function(self) return 
		{MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		} end,
})

function modifier_item_demon_horns:OnCreated()
	if not IsServer() then
		return
	end
	local caster = self:GetCaster()
--[[
	if self.model == nil and caster:GetUnitName()=="npc_dota_hero_terrorblade" then
		self.model = "models/heroes/terrorblade/terrorblade_arcana.vmdl"
		caster:SetModel(self.model)
		caster:SetOriginalModel(self.model)
		Timers:CreateTimer(0.01,function () self.item:FollowEntity(caster, true) end)
	end
]]
end

function modifier_item_demon_horns:OnDestroy()
	local caster = self:GetCaster()
	if self.model then
		local model = "models/heroes/terrorblade/terrorblade.vmdl"
		caster:SetModel(model)
		caster:SetOriginalModel(model)
		self.model = nil
	end
end

function modifier_item_demon_horns:GetModifierPreAttack_BonusDamage()
	return self:GetAbility():GetSpecialValueFor("bonus_dmg")
end

function modifier_item_demon_horns:GetModifierBonusStats_Strength()
	return self:GetAbility():GetSpecialValueFor("bonus_str")
end

function modifier_item_demon_horns:GetModifierBonusStats_Agility()
	return self:GetAbility():GetSpecialValueFor("bonus_agi")
end

function modifier_item_demon_horns:GetModifierBonusStats_Intellect()
	return self:GetAbility():GetSpecialValueFor("bonus_int")
end


item_demon_horns_upgrade = class({})

function item_demon_horns_upgrade:GetIntrinsicModifierName()
	return "modifier_item_demon_horns_upgrade"
end

modifier_item_demon_horns_upgrade = class({
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

function modifier_item_demon_horns_upgrade:OnCreated()
	if not IsServer() then
		return
	end
	self:StartIntervalThink(0.1)
--[[
	local caster = self:GetCaster()
	if self.model == nil and caster:GetUnitName()=="npc_dota_hero_terrorblade" then
		self.model = "models/heroes/terrorblade/terrorblade_arcana.vmdl"
		caster:SetModel(self.model)
		caster:SetOriginalModel(self.model)
		Timers:CreateTimer(0.01,function () self.item:FollowEntity(caster, true) end)
	end
]]
end

function modifier_item_demon_horns_upgrade:OnIntervalThink()
	if IsServer() then
		local caster = self:GetCaster()
		local stats = caster:GetStrength() + caster:GetAgility() + caster:GetIntellect()
		self:SetStackCount(stats)

	end
end
function modifier_item_demon_horns_upgrade:OnDestroy()
	local caster = self:GetCaster()
	if self.model then
		local model = "models/heroes/terrorblade/terrorblade.vmdl"
		caster:SetModel(model)
		caster:SetOriginalModel(model)
		self.model = nil
	end
end

function modifier_item_demon_horns_upgrade:GetModifierPreAttack_BonusDamage()
	local bonus_dmg = self:GetAbility():GetSpecialValueFor("bonus_dmg")
	if self:GetCaster():GetUnitName()=="npc_dota_hero_terrorblade" then
		bonus_dmg = bonus_dmg + self:GetStackCount()
	end	
	return bonus_dmg
end

function modifier_item_demon_horns_upgrade:GetModifierBonusStats_Strength()
	return self:GetAbility():GetSpecialValueFor("bonus_str")
end

function modifier_item_demon_horns_upgrade:GetModifierBonusStats_Agility()
	return self:GetAbility():GetSpecialValueFor("bonus_agi")
end

function modifier_item_demon_horns_upgrade:GetModifierBonusStats_Intellect()
	return self:GetAbility():GetSpecialValueFor("bonus_int")
end

function modifier_item_demon_horns_upgrade:GetEffectName()
	if self:GetCaster():GetUnitName()=="npc_dota_hero_terrorblade" then
		return "particles/econ/items/terrorblade/terrorblade_horns_arcana/terrorblade_ambient_body_arcana_horns.vpcf"
	else
		return
	end	
end
