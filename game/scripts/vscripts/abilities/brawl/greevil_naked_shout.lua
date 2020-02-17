greevil_naked_shout = class({})

LinkLuaModifier("modifier_greevil_naked_shout", "abilities/greevil_naked_shout", LUA_MODIFIER_MOTION_NONE)

function greevil_naked_shout:GetAbilityTextureName()
	return "greevil_naked_shout"
end

function greevil_naked_shout:GetCastAnimation()
	return ACT_DOTA_CAST_ABILITY_2
end

function greevil_naked_shout:OnSpellStart()
	self:GetCursorTarget():AddNewModifier(self:GetCaster(), self, "modifier_greevil_naked_shout", {duration = self:GetSpecialValueFor("duration")})

	EmitSoundOn("Greevil.Shout.Cast", self:GetCursorTarget())
end

modifier_greevil_naked_shout = class({
	IsPurgable = function() return false end,
})

function modifier_greevil_naked_shout:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_EVENT_ON_ABILITY_EXECUTED
	}
end

function modifier_greevil_naked_shout:GetModifierMoveSpeedBonus_Percentage()
	return -self:GetAbility():GetSpecialValueFor("slow")
end

if IsServer() then
	function modifier_greevil_naked_shout:OnCreated()
		local nFXIndex = ParticleManager:CreateParticle("particles/econ/items/silencer/silencer_ti6/silencer_last_word_status_ti6.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		ParticleManager:SetParticleControl(nFXIndex, 1, self:GetParent():GetOrigin())
		ParticleManager:SetParticleControl(nFXIndex, 3, self:GetParent():GetOrigin())
		self:AddParticle(nFXIndex, false, false, -1, false, false)

		self:StartIntervalThink(1.0)
		self:OnIntervalThink()
	end
	function modifier_greevil_naked_shout:OnIntervalThink()
		local damage = self:GetAbility():GetSpecialValueFor("damage")
		local gameTime = math.min(math.floor(GameRules:GetDOTATime(false, false)/60), GREEVIL_BUFF_TIME_LIMIT)
		damage = damage + self:GetAbility():GetSpecialValueFor("damage_per_minute") * gameTime
		ApplyDamage({
			victim = self:GetParent(),
			attacker = self:GetCaster(),
			damage = damage,
			damage_type = self:GetAbility():GetAbilityDamageType(),
			ability = self:GetAbility()
		})

		EmitSoundOn("Greevil.Shout.Tick", self:GetParent())
		
		local damagePFX = ParticleManager:CreateParticle("particles/econ/items/silencer/silencer_ti6/silencer_last_word_dmg_ti6.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		ParticleManager:SetParticleControl(damagePFX, 1, self:GetParent():GetOrigin())
		ParticleManager:SetParticleControl(damagePFX, 3, self:GetParent():GetOrigin())
		ParticleManager:ReleaseParticleIndex(damagePFX)
	end
	function modifier_greevil_naked_shout:OnAbilityExecuted(event)
		if event.unit == self:GetParent() then
			local cast_ability = event.ability
			if not cast_ability:IsItem() and not cast_ability:HasBehavior(DOTA_ABILITY_BEHAVIOR_AUTOCAST) and not cast_ability:HasBehavior(DOTA_ABILITY_BEHAVIOR_ATTACK) and not cast_ability:HasBehavior(DOTA_ABILITY_BEHAVIOR_TOGGLE) then
				self:Destroy()
			end
		end
	end
end