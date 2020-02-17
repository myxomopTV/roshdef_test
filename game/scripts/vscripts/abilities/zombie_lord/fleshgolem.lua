LinkLuaModifier("modifier_zombie_lord_fleshgolem", "abilities/zombie_lord/fleshgolem", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_zombie_lord_fleshgolem_aura", "abilities/zombie_lord/fleshgolem", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_zombie_lord_fleshgolem_aura_debuff", "abilities/zombie_lord/fleshgolem", LUA_MODIFIER_MOTION_NONE)

if not zombie_lord_fleshgolem then zombie_lord_fleshgolem = class({}) end

function zombie_lord_fleshgolem:GetIntrinsicModifierName()
	return "modifier_zombie_lord_fleshgolem"
end

function zombie_lord_fleshgolem:GetCastRange()
	return self:GetSpecialValueFor("aura_radius")
end

modifier_zombie_lord_fleshgolem = class({
	IsHidden 	= function(self) return true end,
})
function modifier_zombie_lord_fleshgolem:OnCreated()
	self:StartIntervalThink(0.1)
end

function modifier_zombie_lord_fleshgolem:OnIntervalThink()
	local caster = self:GetCaster()
	local ability = self:GetAbility()
	local current_health_pct = caster:GetHealthPercent()
	local health_required = ability:GetSpecialValueFor("health_required_pct")
	local model = "models/items/undying/flesh_golem/frostivus_2018_undying_accursed_draugr_golem/frostivus_2018_undying_accursed_draugr_golem.vmdl"

	if current_health_pct > health_required or self.fleshgolem then
		return
	end
	self.fleshgolem = true
	caster:AddNewModifier(caster, ability, "modifier_zombie_lord_fleshgolem_aura", nil)
	
	caster:SetModel(model)
	caster:SetOriginalModel(model)
	caster:StartGesture(ACT_DOTA_SPAWN)
	EmitGlobalSound("undying_undying_big_zombie_lord_fleshgolem_04")
--	caster:AddNewModifier(caster,ability,"modifier_zombie_lord_fleshgolem_lord_zombie_lord_fleshgolem_form",nil)
	caster.hiddenWearables = {} -- Keep every wearable handle in a table to show them later
    local model = caster:FirstMoveChild()
    while model ~= nil do
        if model:GetClassname() == "dota_item_wearable" then
            model:AddEffects(EF_NODRAW) -- Set model hidden
            table.insert(caster.hiddenWearables, model)
        end
        model = model:NextMovePeer()
    end
end

modifier_zombie_lord_fleshgolem_aura = class({
	IsHidden 	= function(self) return true end,
	IsAura 		= function(self) return true end,
	IsPurgable  = function(self) return false end,
	GetAuraRadius 	= function(self) return self:GetAbility():GetSpecialValueFor("aura_radius") end,
	GetAuraSearchTeam = function(self) return DOTA_UNIT_TARGET_TEAM_ENEMY end,
	GetAuraSearchFlags = function(self) return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES end,
	GetAuraSearchType = function(self) return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end,
	GetModifierAura   = function(self) return "modifier_zombie_lord_fleshgolem_aura_debuff" end,
})

modifier_zombie_lord_fleshgolem_aura_debuff = class({
	IsHidded 	= function(self) return false end,
})

function modifier_zombie_lord_fleshgolem_aura_debuff:OnCreated()
	local interval = self:GetAbility():GetSpecialValueFor("tick_interval")
--	print(interval)
	self:StartIntervalThink(interval)
end

function modifier_zombie_lord_fleshgolem_aura_debuff:OnIntervalThink()
	local caster = self:GetCaster()
	local parent = self:GetParent()
	local ability = self:GetAbility()
	local dmg_pct = ability:GetSpecialValueFor("dmg_pct")
	local damage = parent:GetHealth()*dmg_pct/100
	
	DealDamage(caster, parent, damage, DAMAGE_TYPE_PURE, nil, ability)
end

-------------------------------------------------------------------------
-------------------------------------------------------------------------
modifier_zombie_lord_fleshgolem_lord_zombie_lord_fleshgolem_form = class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return true end,
	GetAttributes 			= function(self) return MODIFIER_ATTRIBUTE_MULTIPLE end,
	DeclareFunctions		= function(self) return 
		{   MODIFIER_PROPERTY_MODEL_CHANGE} end,
})
-------------------------------------------


function modifier_zombie_lord_fleshgolem_lord_zombie_lord_fleshgolem_form:GetModifierModelChange()
	return 	"models/items/undying/flesh_golem/frostivus_2018_undying_accursed_draugr_golem/frostivus_2018_undying_accursed_draugr_golem.vmdl"
end

