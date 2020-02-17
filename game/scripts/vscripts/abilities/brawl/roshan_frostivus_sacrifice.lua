roshan_frostivus_sacrifice = class({})

LinkLuaModifier("modifier_roshan_frostivus_sacrifice", "abilities/roshan_frostivus_sacrifice", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_roshan_frostivus_sacrifice_debuff", "abilities/roshan_frostivus_sacrifice", LUA_MODIFIER_MOTION_NONE)

function roshan_frostivus_sacrifice:GetAbilityTextureName()
	return "roshan_frostivus_sacrifice"
end

function roshan_frostivus_sacrifice:GetCastAnimation()
	return ACT_DOTA_CAST_ABILITY_4
end

function roshan_frostivus_sacrifice:OnAbilityPhaseStart()
	self:GetCaster():EmitSound("RoshanFrost.Scream")
	return true
end

function roshan_frostivus_sacrifice:OnAbilityPhaseInterrupted()
	self:GetCaster():StopSound("RoshanFrost.Scream")
end

function roshan_frostivus_sacrifice:OnSpellStart()
	self.aggroTarget = self:GetCursorTarget()

	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_roshan_frostivus_sacrifice", {duration = self:GetSpecialValueFor("duration")})
	self:GetCursorTarget():AddNewModifier(self:GetCaster(), self, "modifier_roshan_frostivus_sacrifice_debuff", {duration = self:GetSpecialValueFor("duration")})
end

modifier_roshan_frostivus_sacrifice = class({
	IsPurgable = function() return false end,
	-- GetStatusEffectName = function() return "particles/status_fx/status_effect_doom.vpcf" end,
	StatusEffectPriority = function() return 10 end,
})

function modifier_roshan_frostivus_sacrifice:CheckState()
	return {
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true
	}
end

function modifier_roshan_frostivus_sacrifice:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE,
		MODIFIER_PROPERTY_MOVESPEED_MAX,
		MODIFIER_PROPERTY_MOVESPEED_LIMIT,
		-- MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
		MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_EVENT_ON_ATTACK_LANDED
	}
end

function modifier_roshan_frostivus_sacrifice:GetModifierMoveSpeed_Absolute()
	return self:GetAbility():GetSpecialValueFor("movespeed")
end

function modifier_roshan_frostivus_sacrifice:GetModifierMoveSpeed_Max()
	return self:GetAbility():GetSpecialValueFor("movespeed")
end

function modifier_roshan_frostivus_sacrifice:GetModifierMoveSpeed_Limit()
	return self:GetAbility():GetSpecialValueFor("movespeed")
end

function modifier_roshan_frostivus_sacrifice:GetModifierHealthRegenPercentage()
	return self:GetAbility():GetSpecialValueFor("health_regen")
end

function modifier_roshan_frostivus_sacrifice:GetModifierAttackSpeedBonus_Constant()
	return self:GetAbility():GetSpecialValueFor("attack_speed")
end

function modifier_roshan_frostivus_sacrifice:GetActivityTranslationModifiers()
	return "injured"
end

if IsServer() then
	function modifier_roshan_frostivus_sacrifice:OnCreated()
		self:StartIntervalThink(0.1)
		self:OnIntervalThink()
		self:GetParent():SetRenderColor(255, 200, 200)
	end
	function modifier_roshan_frostivus_sacrifice:OnDestroy()
		self:GetParent():SetForceAttackTarget(nil)
		self:GetParent():SetRenderColor(255, 255, 255)
	end
	function modifier_roshan_frostivus_sacrifice:OnIntervalThink()
		if not self:GetAbility().aggroTarget then return end
		self:GetParent():SetForceAttackTarget(nil)
		if self:GetAbility().aggroTarget:IsAlive() then
			ExecuteOrderFromTable({
				UnitIndex = self:GetParent():entindex(),
				OrderType = DOTA_UNIT_ORDER_ATTACK_TARGET,
				TargetIndex = self:GetAbility().aggroTarget:entindex()
			})
			self:GetParent():SetForceAttackTarget(self:GetAbility().aggroTarget)
		else
			self:GetParent():Stop()
			self:Destroy()
		end
	end
	function modifier_roshan_frostivus_sacrifice:OnAttackLanded(event)
		if event.attacker == self:GetParent() then
			local heal = self:GetParent():GetMaxHealth() * (self:GetAbility():GetSpecialValueFor("health_regen") * 0.01)
			self:GetParent():Heal(heal, self:GetAbility())
		end
	end
end

modifier_roshan_frostivus_sacrifice_debuff = class({
	IsPurgable = function() return false end,
	GetEffectName = function() return "particles/generic_gameplay/roshan_frostivus/roshan_frostivus_sacrifice_enemy.vpcf" end,
	GetEffectAttachType = function() return PATTACH_OVERHEAD_FOLLOW end,
})