root_trap = class({})

LinkLuaModifier("modifier_root_trap_thinker", "abilities/traps/root_trap", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_root_trap_debuff", "abilities/traps/root_trap", LUA_MODIFIER_MOTION_NONE)

function root_trap:GetIntrinsicModifierName()
	return "modifier_root_trap_thinker"
end

modifier_root_trap_thinker = class({
	IsPurgable = function() return false end,
	IsHidden = function() return true end,
})

function modifier_root_trap_thinker:CheckState() 
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

if IsServer() then
	function modifier_root_trap_thinker:OnCreated(kv)
		self:StartIntervalThink(0.1)
	end

	function modifier_root_trap_thinker:OnIntervalThink()
		if not self:GetParent():HasModifier("modifier_trap_cooldown") then
			local heroes = FindUnitsInRadius(self:GetParent():GetTeamNumber(), self:GetParent():GetOrigin(), nil, 100, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
			if #heroes > 0 then
				if RollPercentage(25) then
					self:GetParent():SetContextThink("TrapActivate", function()
						local hitHeroes = FindUnitsInRadius(self:GetParent():GetTeamNumber(), self:GetParent():GetOrigin(), nil, 200, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
						for _,hitHero in pairs(hitHeroes) do
							self.trapDamageSource = self:GetParent()
							if hitHero.LastTimeDamageTakenByHero ~= nil and hitHero.LastTimeDamageTakenByHero + 2 >= GameRules:GetGameTime() and hitHero.LastTimeDamageSource then
								self.trapDamageSource = hitHero.LastTimeDamageSource
							end

							GridNav:DestroyTreesAroundPoint(hitHero:GetOrigin(), 150, true)
							for i = 1, 3 do
								local treant = CreateUnitByName("npc_treant", hitHero:GetOrigin() + RandomVector(150), true, self.trapDamageSource, self.trapDamageSource, self.trapDamageSource:GetTeamNumber())
								if treant ~= nil then
									treant:AddNewModifier(self.trapDamageSource, self:GetAbility(), "modifier_kill", {duration = 7.0})
									treant:SetForceAttackTarget(hitHero)
								end
							end

							ApplyDamage({
								victim = hitHero,
								attacker = self.trapDamageSource,
								damage = 100,
								damage_type = DAMAGE_TYPE_MAGICAL,
								ability = self:GetAbility()
							})

							hitHero:AddNewModifier(self.trapDamageSource, self:GetAbility(), "modifier_root_trap_debuff", {duration = 5.0})

							hitHero:EmitSound("RootTrap.Release")

							-- local splashFX = ParticleManager:CreateParticle("particles/ice_gaser_trap.vpcf", PATTACH_WORLDORIGIN, nil)
							-- ParticleManager:SetParticleControl(splashFX, 0, self:GetParent():GetOrigin())
							-- ParticleManager:ReleaseParticleIndex(splashFX)
						end
					end, 0.6)

					self:GetParent():StartGesture(ACT_DOTA_OVERRIDE_ABILITY_1)

					EmitSoundOnLocationWithCaster(self:GetParent():GetOrigin(), "RootTrap.Activate", self:GetParent())
				end

				local cooldownTime = 60.0

				self:GetParent():AddNewModifier(self:GetParent(), nil, "modifier_trap_cooldown", {duration = cooldownTime})
			end
		end
	end
end

modifier_root_trap_debuff = class({
	IsPurgable = function() return false end,
	GetEffectName = function() return "particles/traps/root_trap_root.vpcf" end,
	GetEffectAttachType = function() return PATTACH_ABSORIGIN_FOLLOW end,
})

function modifier_root_trap_debuff:CheckState() 
	return {
		[MODIFIER_STATE_ROOTED] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true
	}
end