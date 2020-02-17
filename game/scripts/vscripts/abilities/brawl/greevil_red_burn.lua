greevil_red_burn = class({})

LinkLuaModifier("modifier_greevil_red_burn", "abilities/greevil_red_burn", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_greevil_red_burn_debuff", "abilities/greevil_red_burn", LUA_MODIFIER_MOTION_NONE)

function greevil_red_burn:GetAbilityTextureName()
	return "greevil_red_burn"
end
function greevil_red_burn:GetIntrinsicModifierName()
	return "modifier_greevil_red_burn"
end

modifier_greevil_red_burn = class({
	IsPurgable = function() return false end,
})

if IsServer() then
	function modifier_greevil_red_burn:OnCreated()
		self:StartIntervalThink(0.25)
		self.firePoints = {}
		self.removePoints = false
		Timers:CreateTimer(2.0, function()
			self.removePoints = true
		end)
	end
	function modifier_greevil_red_burn:OnIntervalThink()
		if not self:GetParent():IsAlive() then return end
		
		if not self.firePoints then self.firePoints = {} end
		if self.removePoints then
			table.remove(self.firePoints, #self.firePoints)
		end
		table.insert(self.firePoints, 1, self:GetParent():GetOrigin())
		-- DebugDrawCircle(self:GetParent():GetOrigin(), Vector(255, 0, 0), 0, self:GetAbility():GetSpecialValueFor("radius"), true, 2.0)
		local firePFX = ParticleManager:CreateParticle("particles/greevils/greevil_red/greevil_red_burn.vpcf", PATTACH_WORLDORIGIN, nil)
		ParticleManager:SetParticleControl(firePFX, 0, self:GetParent():GetOrigin())
		Timers:CreateTimer(1.8, function()
			ParticleManager:DestroyParticle(firePFX, false)
			ParticleManager:ReleaseParticleIndex(firePFX)
		end)
		for i = 1, #self.firePoints do
			local point = self.firePoints[i]
			local enemies = FindUnitsInRadius(self:GetParent():GetTeamNumber(), point, nil, self:GetAbility():GetSpecialValueFor("radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
			for _,enemy in pairs(enemies) do
				enemy:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_greevil_red_burn_debuff", {duration = 1.0})
			end
			-- DebugDrawCircle(point, Vector(255, 0, 0), 0, self:GetAbility():GetSpecialValueFor("radius"), true, 0.25)
		end
	end
	function modifier_greevil_red_burn:DeclareFunctions()
		return {MODIFIER_EVENT_ON_DEATH}
	end
	function modifier_greevil_red_burn:OnDeath(event)
		if event.unit == self:GetParent() then
			self.firePoints = {}
			self:StartIntervalThink(-1)
		end
	end
end

modifier_greevil_red_burn_debuff = class({
	IsPurgable = function() return false end,
	GetEffectName = function() return "particles/units/heroes/hero_huskar/huskar_burning_spear_debuff.vpcf" end,
	GetEffectAttachType = function() return PATTACH_ABSORIGIN_FOLLOW end,
})

if IsServer() then
	function modifier_greevil_red_burn_debuff:OnCreated()
		self:StartIntervalThink(0.25)
	end
	function modifier_greevil_red_burn_debuff:OnIntervalThink()
		if self ~= nil then
			local damage = self:GetAbility():GetSpecialValueFor("damage")
			local gameTime = math.min(math.floor(GameRules:GetDOTATime(false, false)/60), GREEVIL_BUFF_TIME_LIMIT)
			damage = (damage + self:GetAbility():GetSpecialValueFor("damage_per_minute") * gameTime) * 0.25
			ApplyDamage({
				victim = self:GetParent(),
				attacker = self:GetCaster(),
				damage = damage,
				damage_type = self:GetAbility():GetAbilityDamageType(),
				ability = self:GetAbility()
			})
		end
	end
end