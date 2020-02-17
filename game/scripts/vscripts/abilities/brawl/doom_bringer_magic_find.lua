doom_bringer_magic_find = class({})

function doom_bringer_magic_find:CastFilterResultTarget(hTarget)
	if hTarget:GetUnitName() ~= "npc_treasure_chest" then
		return UF_FAIL_CUSTOM
	end

	local nResult = UnitFilter(hTarget, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, self:GetCaster():GetTeamNumber())
	if nResult ~= UF_SUCCESS then
		return nResult
	end

	return UF_SUCCESS
end

function doom_bringer_magic_find:GetCustomCastErrorTarget(hTarget)
	if hTarget:GetUnitName() ~= "npc_treasure_chest" then
		return "#dota_hud_error_only_on_treasures"
	end

	return ""
end

function doom_bringer_magic_find:OnSpellStart()
	local goldBonus = self:GetSpecialValueFor("bonus_gold")
	local xpBonus = self:GetSpecialValueFor("bonus_xp")

	OnTreasureOpen(self:GetCaster(), self:GetCursorTarget())

	self:GetCaster():ModifyGold(goldBonus, false, DOTA_ModifyGold_CreepKill)
	self:GetCaster():AddExperience(xpBonus, DOTA_ModifyXP_CreepKill, false, true)
	SendOverheadEventMessage(nil, OVERHEAD_ALERT_GOLD, self:GetCaster(), goldBonus, nil)
end