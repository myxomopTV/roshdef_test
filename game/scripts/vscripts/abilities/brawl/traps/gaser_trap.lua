gaser_trap = class({})

LinkLuaModifier("modifier_gaser_trap_thinker", "abilities/traps/gaser_trap", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_gaser_trap_debuff", "abilities/traps/gaser_trap", LUA_MODIFIER_MOTION_VERTICAL)

function gaser_trap:GetIntrinsicModifierName()
	return "modifier_gaser_trap_thinker"
end

modifier_gaser_trap_thinker = class({
	IsPurgable = function() return false end,
	IsHidden = function() return true end,
})

function modifier_gaser_trap_thinker:CheckState() 
	return {
		[MODIFIER_STATE_UNSELECTABLE] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_NOT_ON_MINIMAP] = true,
		[MODIFIER_STATE_PROVIDES_VISION] = false,
		[MODIFIER_STATE_ROOTED] = true,
		[MODIFIER_STATE_DISARMED] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_LOW_ATTACK_PRIORITY] = true,
		[MODIFIER_STATE_BLOCK_DISABLED] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_OUT_OF_GAME] = true,
		[MODIFIER_STATE_BLIND] = true
	}
end

function modifier_gaser_trap_thinker:DeclareFunctions()
	return {MODIFIER_PROPERTY_PROVIDES_FOW_POSITION}
end

function modifier_gaser_trap_thinker:GetModifierProvidesFOWVision()
	return 1
end

if IsServer() then
	function modifier_gaser_trap_thinker:OnCreated(kv)
		self:GetParent():SetRenderColor(100, 105, 115)

		self:StartIntervalThink(0.1)
	end

	function modifier_gaser_trap_thinker:OnIntervalThink()
		if not self:GetParent():HasModifier("modifier_trap_cooldown") then
			local heroes = FindUnitsInRadius(self:GetParent():GetTeamNumber(), self:GetParent():GetOrigin(), nil, 100, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
			if #heroes > 0 then
				if self:GetParent().PermanentTrap or RollPercentage(25) then
					self:GetParent():SetContextThink("TrapActivate", function()
						local hitHeroes = FindUnitsInRadius(self:GetParent():GetTeamNumber(), self:GetParent():GetOrigin(), nil, 150, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
						for _,hitHero in pairs(hitHeroes) do
							self.trapDamageSource = self:GetParent()
							if hitHero.LastTimeDamageTakenByHero ~= nil and hitHero.LastTimeDamageTakenByHero + 2 >= GameRules:GetGameTime() and hitHero.LastTimeDamageSource then
								self.trapDamageSource = hitHero.LastTimeDamageSource
							end
							-- hitHero:AddNewModifier(self.trapDamageSource, self:GetAbility(), "modifier_knockback", {
							-- 	should_stun = 1,
							-- 	knockback_duration = 1.6,
							-- 	duration = 1.6,
							-- 	knockback_distance = 0,
							-- 	knockback_height = 400,
							-- 	center_x = hitHero:GetOrigin().x,
							-- 	center_y = hitHero:GetOrigin().y,
							-- 	center_z = hitHero:GetOrigin().z
							-- })
							hitHero:AddNewModifier(self.trapDamageSource, self:GetAbility(), "modifier_gaser_trap_debuff", {duration = 1.6})
						end

						local splashFX = ParticleManager:CreateParticle("particles/ice_gaser_trap.vpcf", PATTACH_WORLDORIGIN, nil)
						ParticleManager:SetParticleControl(splashFX, 0, self:GetParent():GetOrigin())
						ParticleManager:ReleaseParticleIndex(splashFX)

						EmitSoundOnLocationWithCaster(self:GetParent():GetOrigin(), "IceGaserTrap.Release", self:GetParent())
					end, 0.25)

					EmitSoundOnLocationWithCaster(self:GetParent():GetOrigin(), "IceGaserTrap.Activate", self:GetParent())
				end

				local cooldownTime = 15.0
				if self:GetParent().PermanentTrap then
					cooldownTime = 30.0
				end

				self:GetParent():AddNewModifier(self:GetParent(), nil, "modifier_trap_cooldown", {duration = cooldownTime})
			end
		end

		if GameRules:State_Get() == DOTA_GAMERULES_STATE_PRE_GAME and not self.nFXIndex then
			self.nFXIndex = ParticleManager:CreateParticle("particles/ice_gaser_trap_ambient.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
			ParticleManager:SetParticleControl(self.nFXIndex, 0, self:GetParent():GetOrigin())
			ParticleManager:ReleaseParticleIndex(self.nFXIndex)
		end
	end
end

modifier_gaser_trap_debuff = class({
	IsPurgable = function() return false end,
	IsStunDebuff = function() return true end,
	RemoveOnDeath = function() return false end,
})

function modifier_gaser_trap_debuff:DeclareFunctions()
	return {MODIFIER_PROPERTY_OVERRIDE_ANIMATION}
end

function modifier_gaser_trap_debuff:CheckState()
	return {[MODIFIER_STATE_STUNNED] = true}
end

function modifier_gaser_trap_debuff:GetOverrideAnimation()
	return ACT_DOTA_FLAIL
end

function modifier_gaser_trap_debuff:GetPriority()
	return MODIFIER_PRIORITY_ULTRA
end

function modifier_gaser_trap_debuff:GetTexture()
	return "modifier_gaser_trap_debuff"
end

if IsServer() then
	function modifier_gaser_trap_debuff:OnCreated()
		if self:ApplyVerticalMotionController() == false then 
			self:Destroy()
			return
		end

		self.height = 400
		self.divider = 5
		self.duration = self:GetDuration()
		self.flyTime = 0
		self.currentHeight = 0

		self.ticksCount = 10
		self.tickInterval = self.duration / self.ticksCount
		self.damagePerTick = 200 / self.ticksCount
		self.currentTicksCount = 0

		self:StartIntervalThink(self.tickInterval)
		self:OnIntervalThink()
	end

	function modifier_gaser_trap_debuff:OnDestroy()
		self:GetParent():RemoveHorizontalMotionController(self)
		self:GetParent():RemoveVerticalMotionController(self)
		--self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_stunned", {duration = 0.75})
		FindClearSpaceForUnit(self:GetParent(), self:GetParent():GetOrigin(), true)
		self:GetParent():FadeGesture(ACT_DOTA_FLAIL)
	end

	function modifier_gaser_trap_debuff:OnIntervalThink()
		if self.currentTicksCount < self.ticksCount then
			ApplyDamage({
				victim = self:GetParent(),
				attacker = self:GetCaster(),
				damage = self.damagePerTick,
				damage_type = DAMAGE_TYPE_MAGICAL,
				ability = self:GetAbility()
			})
			self.currentTicksCount = self.currentTicksCount + 1
		end
	end

	function modifier_gaser_trap_debuff:UpdateVerticalMotion(me, dt)
		-- if self.flyTime < self.duration then
		-- 	if self.flyTime <= self.duration / 2 then
		-- 		if self.currentHeight < 400 then
		-- 			self.currentHeight = 400 * self.flyTime / self.duration * 2
		-- 		else
		-- 			self.currentHeight = 400
		-- 		end
		-- 	else
		-- 		if self.currentHeight > 0 then
		-- 			self.currentHeight = 400 * (1 - (self.flyTime * 1.25) / self.duration) * 2
		-- 		else
		-- 			self.currentHeight = 0
		-- 			self:Destroy()
		-- 			return
		-- 		end
		-- 	end
		-- 	me:SetOrigin(GetGroundPosition(me:GetOrigin(), me) + Vector(0,0,self.currentHeight))
		-- 	me:StartGesture(ACT_DOTA_FLAIL)
		-- end

		if self.currentHeight < 400 and self.flyTime < 0.2 then
			self.currentHeight = self.currentHeight + (400 / self.divider)
			self.divider = self.divider + 2
		end

		if self.currentHeight > 400 and self.flyTime < 0.2 then
			self.currentHeight = 400
			self.flyTime = self.flyTime + dt
		end

		if self.currentHeight >= 400 and self.flyTime < 0.2 then
			self.flyTime = self.flyTime + dt
		end

		if self.flyTime >= 0.2 then
			self.currentHeight = self.currentHeight - (400 / self.divider)
			self.divider = self.divider - 2
			self.flyTime = self.flyTime + dt
		end

		if self.currentHeight <= 0 or self.flyTime >= 0.7 then
			self.currentHeight = 0
		end

		me:SetOrigin(GetGroundPosition(me:GetOrigin(), me) + Vector(0,0,self.currentHeight))
		self:GetParent():StartGesture(ACT_DOTA_FLAIL)
	end

	function modifier_gaser_trap_debuff:OnVerticalMotionInterrupted()
		self:Destroy()
	end
end