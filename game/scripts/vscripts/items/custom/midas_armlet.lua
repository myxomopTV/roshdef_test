
LinkLuaModifier( "modifier_item_midas_armlet", "items/custom/midas_armlet", LUA_MODIFIER_MOTION_NONE )

item_midas_armlet = class({})

function item_midas_armlet:GetIntrinsicModifierName()
	return "modifier_item_midas_armlet"
end

modifier_item_midas_armlet = class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return true end,
	DeclareFunctions		= function(self) return 
		{
			MODIFIER_EVENT_ON_TAKEDAMAGE,
--			MODIFIER_EVENT_ON_DEATH,
			MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		} end,
})

function modifier_item_midas_armlet:OnTakeDamage(data)
    local parent = self:GetParent()
	local attacker = data.attacker
	local unit = data.unit
	local flDamage = data.damage

    if parent == attacker and unit:GetHealth() <= 0  then 
	    local ability = self:GetAbility()
		local trigger_chance = ability:GetSpecialValueFor("trigger_chance")
		local bonus_xp = ability:GetSpecialValueFor("bonus_xp")/100
		local bonus_gold = ability:GetSpecialValueFor("bonus_gold")/100
		if RollPercentage(trigger_chance) then
			local gold = unit:GetGoldBounty()*(bonus_gold+1)
			local xp = unit:GetDeathXP()*(bonus_xp+1)
			unit:SetMaximumGoldBounty(gold)
			unit:SetMinimumGoldBounty(gold)
			unit:SetDeathXP(xp)

--			parent:ModifyGold(gold, false, 0)
--			parent:AddExperience(xp, 0, true, true)

			parent:EmitSound("DOTA_Item.Hand_Of_Midas")
			local effect = "particles/econ/items/alchemist/alchemist_midas_knuckles/alch_knuckles_lasthit_coins.vpcf"
			local particle_fx = ParticleManager:CreateParticle(effect, PATTACH_ABSORIGIN_FOLLOW, unit)
			ParticleManager:SetParticleControl(particle_fx, 0, unit:GetAbsOrigin())
			ParticleManager:SetParticleControl(particle_fx, 1, unit:GetAbsOrigin())
			ParticleManager:ReleaseParticleIndex(particle_fx)
		end
--		local player = PlayerResource:GetPlayer(caster:GetPlayerID())
--		SendOverheadEventMessage( player, OVERHEAD_ALERT_GOLD, caster, gold, nil )
--		caster:ModifyGold(gold, false, 0)
   end
end

function modifier_item_midas_armlet:GetModifierAttackSpeedBonus_Constant()
	return self:GetAbility():GetSpecialValueFor("bonus_as")
end

item_midas_armlet_1 = class(item_midas_armlet)
item_midas_armlet_2 = class(item_midas_armlet)
item_midas_armlet_3 = class(item_midas_armlet)

