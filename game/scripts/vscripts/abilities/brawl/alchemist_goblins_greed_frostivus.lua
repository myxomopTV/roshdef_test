alchemist_goblins_greed_frostivus = class({})

LinkLuaModifier("modifier_alchemist_goblins_greed_frostivus", "abilities/alchemist_goblins_greed_frostivus", LUA_MODIFIER_MOTION_NONE)

function alchemist_goblins_greed_frostivus:GetIntrinsicModifierName()
	return "modifier_alchemist_goblins_greed_frostivus"
end

function alchemist_goblins_greed_frostivus:OnPresentDelivered()
	local goblins_greed_modifier = self:GetCaster():FindModifierByName("modifier_alchemist_goblins_greed_frostivus")
	if goblins_greed_modifier then
		local bonusGold = goblins_greed_modifier:GetStackCount()
		self:GetCaster():ModifyGold(bonusGold, true, DOTA_ModifyGold_Unspecified)

		local goldPFX = ParticleManager:CreateParticleForPlayer("particles/units/heroes/hero_alchemist/alchemist_lasthit_coins.vpcf", PATTACH_ABSORIGIN, self:GetCaster(), self:GetCaster():GetPlayerOwner())
		ParticleManager:SetParticleControl(goldPFX, 0, self:GetCaster():GetOrigin())
		ParticleManager:SetParticleControl(goldPFX, 1, self:GetCaster():GetOrigin())
		ParticleManager:ReleaseParticleIndex(goldPFX)

		local msgPFX = ParticleManager:CreateParticleForPlayer("particles/units/heroes/hero_alchemist/alchemist_lasthit_msg_gold.vpcf", PATTACH_ABSORIGIN, self:GetCaster(), self:GetCaster():GetPlayerOwner())
		ParticleManager:SetParticleControl(msgPFX, 1, Vector(0, bonusGold, 0))
		ParticleManager:SetParticleControl(msgPFX, 2, Vector(2.0, string.len(bonusGold) + 1, 0))
		ParticleManager:SetParticleControl(msgPFX, 3, Vector(255, 200, 33))
		ParticleManager:ReleaseParticleIndex(msgPFX)

		if goblins_greed_modifier:GetStackCount() < self:GetSpecialValueFor("bonus_gold_cap") then
			goblins_greed_modifier:SetStackCount(goblins_greed_modifier:GetStackCount() + self:GetSpecialValueFor("bonus_bonus_gold"))
		else
			goblins_greed_modifier:SetStackCount(self:GetSpecialValueFor("bonus_gold_cap"))
		end

		goblins_greed_modifier:StartIntervalThink(self:GetSpecialValueFor("duration"))
	end
end

modifier_alchemist_goblins_greed_frostivus = class({
	IsPurgable = function() return false end,
})

if IsServer() then
	function modifier_alchemist_goblins_greed_frostivus:OnCreated()
		self:SetStackCount(self:GetAbility():GetSpecialValueFor("bonus_gold"))
		self:StartIntervalThink(self:GetAbility():GetSpecialValueFor("duration"))
	end
	function modifier_alchemist_goblins_greed_frostivus:OnIntervalThink()
		self:SetStackCount(self:GetAbility():GetSpecialValueFor("bonus_gold"))
	end
end