fountain_heal_frost = class({})

LinkLuaModifier("modifier_fountain_heal_frost", "abilities/fountain_heal_frost", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_fountain_heal_frost_effect", "abilities/fountain_heal_frost", LUA_MODIFIER_MOTION_NONE)

function fountain_heal_frost:GetAbilityTextureName()
	return "fountain_heal"
end
function fountain_heal_frost:GetIntrinsicModifierName()
	return "modifier_fountain_heal_frost"
end

modifier_fountain_heal_frost = class({
	IsPurgable = function() return false end,
	IsAura = function() return true end,
	GetModifierAura = function() return "modifier_fountain_heal_frost_effect" end,
	GetAuraSearchTeam = function() return DOTA_UNIT_TARGET_TEAM_BOTH end,
	GetAuraSearchType = function() return DOTA_UNIT_TARGET_HERO end,
	GetAuraSearchFlags = function() return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES end,
	GetAuraRadius = function() return 400 end,
	GetAuraDuration = function() return 0.2 end,
})

function modifier_fountain_heal_frost:CheckState() 
	return {
		[MODIFIER_STATE_UNSELECTABLE] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_OUT_OF_GAME] = true,
		[MODIFIER_STATE_FLYING] = true
	}
end

function modifier_fountain_heal_frost:DeclareFunctions()
	return {MODIFIER_PROPERTY_PROVIDES_FOW_POSITION}
end

function modifier_fountain_heal_frost:GetModifierProvidesFOWVision()
	return 1
end

function modifier_fountain_heal_frost:GetAuraEntityReject(hEntity)
	if IsServer() then
		if hEntity.LastTimeDamageTaken ~= nil and hEntity.LastTimeDamageTaken + 3 >= GameRules:GetGameTime() or hEntity:IsGreevil() then
			return true
		end
	end
	return false
end

modifier_fountain_heal_frost_effect = class({
	IsPurgable = function() return false end,
	IsDebuff = function() return false end,
	IsHidden = function() return false end,
})

function modifier_fountain_heal_frost_effect:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
		MODIFIER_PROPERTY_MANA_REGEN_TOTAL_PERCENTAGE,
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
		MODIFIER_PROPERTY_TOOLTIP
	}
end
function modifier_fountain_heal_frost_effect:GetModifierHealthRegenPercentage() return 20 end
function modifier_fountain_heal_frost_effect:GetModifierTotalPercentageManaRegen() return 20 end
function modifier_fountain_heal_frost_effect:GetModifierConstantManaRegen() return 30 end
function modifier_fountain_heal_frost_effect:OnTooltip() return 10 end
if IsServer() then
	function modifier_fountain_heal_frost_effect:OnCreated(kv)
		local nFXIndex = ParticleManager:CreateParticle("particles/generic_gameplay/fountain_regen_frost.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		ParticleManager:SetParticleControl(nFXIndex, 1, self:GetCaster():GetOrigin())
		self:AddParticle(nFXIndex, false, false, -1, false, false)
	end
end