bear_trap = class({})

LinkLuaModifier("modifier_bear_trap_thinker", "abilities/traps/bear_trap", LUA_MODIFIER_MOTION_NONE)

function bear_trap:GetIntrinsicModifierName()
	return "modifier_bear_trap_thinker"
end

modifier_bear_trap_thinker = class({
	IsPurgable = function() return false end,
	IsHidden = function() return true end,
})

function modifier_bear_trap_thinker:CheckState() 
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
	function modifier_bear_trap_thinker:OnCreated(kv)
		self:StartIntervalThink(0.1)
		self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_invisible", {})
	end

	function modifier_bear_trap_thinker:OnIntervalThink()
		if not self:GetParent():HasModifier("modifier_trap_cooldown") then
			local heroes = FindUnitsInRadius(self:GetParent():GetTeamNumber(), self:GetParent():GetOrigin(), nil, 100, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
			if #heroes > 0 then
				if RollPercentage(25) then
					self:GetParent():SetContextThink("TrapActivate", function()
						local hitHeroes = FindUnitsInRadius(self:GetParent():GetTeamNumber(), self:GetParent():GetOrigin(), nil, 100, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
						for _,hitHero in pairs(hitHeroes) do
							self.trapDamageSource = self:GetParent()
							if hitHero.LastTimeDamageTakenByHero ~= nil and hitHero.LastTimeDamageTakenByHero + 2 >= GameRules:GetGameTime() and hitHero.LastTimeDamageSource then
								self.trapDamageSource = hitHero.LastTimeDamageSource
							end

							ApplyDamage({
								victim = hitHero,
								attacker = self.trapDamageSource,
								damage = 150,
								damage_type = DAMAGE_TYPE_PHYSICAL,
								ability = self:GetAbility()
							})

							hitHero:EmitSound("BearTrap.Release")

							-- local splashFX = ParticleManager:CreateParticle("particles/ice_gaser_trap.vpcf", PATTACH_WORLDORIGIN, nil)
							-- ParticleManager:SetParticleControl(splashFX, 0, self:GetParent():GetOrigin())
							-- ParticleManager:ReleaseParticleIndex(splashFX)
							hitHero:AddNewModifier(self.trapDamageSource, self:GetAbility(), "modifier_bloodseeker_rupture", {duration = 3.0})
							hitHero:AddNewModifier(self.trapDamageSource, self:GetAbility(), "modifier_sange_and_yasha_buff", {duration = 3.0})
						end
					end, 0.5)

					self:GetParent():StartGesture(ACT_DOTA_OVERRIDE_ABILITY_1)

					self:GetParent():RemoveModifierByName("modifier_invisible")

					EmitSoundOnLocationWithCaster(self:GetParent():GetOrigin(), "BearTrap.Activate", self:GetParent())
				end

				local cooldownTime = 15.0

				self:GetParent():AddNewModifier(self:GetParent(), nil, "modifier_trap_cooldown", {duration = cooldownTime})
			end
		end
	end
end