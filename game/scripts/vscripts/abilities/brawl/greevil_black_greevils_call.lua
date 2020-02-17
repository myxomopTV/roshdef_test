greevil_black_greevils_call = class({})

LinkLuaModifier("modifier_greevil_black_greevils_call", "abilities/greevil_black_greevils_call", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_greevil_black_greevils_call_debuff", "abilities/greevil_black_greevils_call", LUA_MODIFIER_MOTION_NONE)

function greevil_black_greevils_call:GetAbilityTextureName()
	return "greevil_black_greevils_call"
end

function greevil_black_greevils_call:GetCastAnimation()
	return ACT_DOTA_CAST_ABILITY_2
end

function greevil_black_greevils_call:OnAbilityPhaseStart()
	self:GetCaster():EmitSound("Greevil.GreevilsCall.Start")
	return true
end

function greevil_black_greevils_call:OnAbilityPhaseInterrupted()
	self:GetCaster():StopSound("Greevil.GreevilsCall.Start")
end

function greevil_black_greevils_call:OnSpellStart()
	local radius = self:GetSpecialValueFor("radius")
	local duration = self:GetSpecialValueFor("duration")
	local hpRegen = 0

	local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetCaster():GetOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
	for _,enemy in pairs(enemies) do
		if not enemy:IsPresent() then
			enemy:AddNewModifier(self:GetCaster(), self, "modifier_greevil_black_greevils_call_debuff", {duration = duration})
			hpRegen = hpRegen + self:GetSpecialValueFor("hp_regen")
		end
	end

	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_greevil_black_greevils_call", {duration = duration, hpRegen = hpRegen})

	local castPFX = ParticleManager:CreateParticle("particles/greevils/greevil_black/greevil_black_greevils_call.vpcf", PATTACH_ABSORIGIN, self:GetCaster())
	ParticleManager:SetParticleControlEnt(castPFX, 1, self:GetCaster(), PATTACH_POINT, "attach_mouth", self:GetCaster():GetOrigin(), true)
	ParticleManager:SetParticleControl(castPFX, 2, Vector(radius, 0, 0))
	ParticleManager:SetParticleControl(castPFX, 3, self:GetCaster():GetOrigin())
	ParticleManager:ReleaseParticleIndex(castPFX)

	self:GetCaster():EmitSound("Greevil.GreevilsCall.Cast")
end

modifier_greevil_black_greevils_call_debuff = class({
	IsPurgable = function() return false end,
	GetStatusEffectName = function() return "particles/status_fx/status_effect_beserkers_call.vpcf" end,
	StatusEffectPriority = function() return 10 end,
})

if IsServer() then
	function modifier_greevil_black_greevils_call_debuff:OnCreated()
		self:StartIntervalThink(0.1)
		self:OnIntervalThink()
	end
	function modifier_greevil_black_greevils_call_debuff:OnDestroy()
		self:GetParent():SetForceAttackTarget(nil)
	end
	function modifier_greevil_black_greevils_call_debuff:OnIntervalThink()
		self:GetParent():SetForceAttackTarget(nil)
		if self:GetCaster():IsAlive() then
			ExecuteOrderFromTable({
				UnitIndex = self:GetParent():entindex(),
				OrderType = DOTA_UNIT_ORDER_ATTACK_TARGET,
				TargetIndex = self:GetCaster():entindex()
			})
			self:GetParent():SetForceAttackTarget(self:GetCaster())
		else
			self:GetParent():Stop()
			self:Destroy()
		end
	end
end

modifier_greevil_black_greevils_call = class({
	IsPurgable = function() return false end,
})

function modifier_greevil_black_greevils_call:OnCreated(params)
	self.hpRegen = params.hpRegen or 0
end

function modifier_greevil_black_greevils_call:DeclareFunctions()
	return {MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT}
end

function modifier_greevil_black_greevils_call:GetModifierConstantHealthRegen()
	return self.hpRegen
end