LinkLuaModifier("modifier_demon_corrosive_aura", "heroes/hero_demon/corrosive_aura", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_demon_corrosive_aura_debuff", "heroes/hero_demon/corrosive_aura", LUA_MODIFIER_MOTION_NONE)

demon_corrosive_aura = class({})

function demon_corrosive_aura:GetIntrinsicModifierName()
	return "modifier_demon_corrosive_aura"
end

modifier_demon_corrosive_aura = class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	IsAura 					= function(self) return true end,
	GetAuraSearchTeam 		= function(self) return DOTA_UNIT_TARGET_TEAM_ENEMY end,
	GetAuraSearchType 		= function(self) return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end,
	GetAuraSearchFlags 		= function(self) return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES end,
	GetAuraRadius 			= function(self) return self:GetAbility():GetSpecialValueFor("aura_radius") end,
	GetModifierAura 		= function(self) return "modifier_demon_corrosive_aura_debuff" end,
})


modifier_demon_corrosive_aura_debuff = class({
    IsHidden                = function(self) return false end,
    IsPurgable              = function(self) return false end,
    IsDebuff                = function(self) return true end,
    IsBuff                  = function(self) return false end,
    RemoveOnDeath           = function(self) return false end,
    DeclareFunctions        = function(self) return 
        {
            MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
        } end,

})


function modifier_demon_corrosive_aura_debuff:OnCreated()
	if IsServer() then
		self:StartIntervalThink(0.1)
	end
end

function modifier_demon_corrosive_aura_debuff:OnIntervalThink()
	if IsServer() then
		local caster = self:GetCaster()
		local soul_modifier_count = caster:FindModifierByName("modifier_demon_soul_collector"):GetStackCount()
		local soul_debuff_armor = self:GetAbility():GetSpecialValueFor("armor_per_soul") * soul_modifier_count
	    local debuff_armor = self:GetAbility():GetSpecialValueFor("debuff_armor") + soul_debuff_armor
	 	self:SetStackCount(debuff_armor)

	end
end

function modifier_demon_corrosive_aura_debuff:GetModifierPhysicalArmorBonus()

	return self:GetStackCount() * (-1)   
end



