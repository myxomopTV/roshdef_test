roshan_frostivus_passive_buffs = class({})

LinkLuaModifier("modifier_roshan", "abilities/roshan_frostivus_passive_buffs", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_roshan_intro", "abilities/roshan_frostivus_passive_buffs", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_roshan_bellyache", "abilities/roshan_frostivus_passive_buffs", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_roshan_casting", "abilities/roshan_frostivus_passive_buffs", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_roshan_truesight", "abilities/roshan_frostivus_passive_buffs", LUA_MODIFIER_MOTION_NONE)

function roshan_frostivus_passive_buffs:GetIntrinsicModifierName()
	return "modifier_roshan"
end

function roshan_frostivus_passive_buffs:OnProjectileHit_ExtraData(hTarget, vLocation, ExtraData)
	if hTarget ~= nil then
		local presentName = "npc_present_red"
		
		if ExtraData ~= nil and ExtraData.present_name ~= nil then
			presentName = ExtraData.present_name
		end

		local present = CreateUnitByName(presentName, vLocation, true, nil, nil, DOTA_TEAM_NEUTRALS)

		hTarget:Destroy()
	end
end

modifier_roshan = class({
	IsPurgable = function() return false end,
	IsHidden = function() return true end,
	IsAura = function() return true end,
	GetModifierAura = function() return "modifier_roshan_truesight" end,
	GetAuraSearchTeam = function() return DOTA_UNIT_TARGET_TEAM_ENEMY end,
	GetAuraSearchType = function() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end,
	GetAuraSearchFlags = function() return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES end,
	GetAuraRadius = function() return 3500 end,
})

function modifier_roshan:DeclareFunctions()
	return {MODIFIER_EVENT_ON_ABILITY_START, MODIFIER_EVENT_ON_TAKEDAMAGE, MODIFIER_PROPERTY_MIN_HEALTH, MODIFIER_PROPERTY_PROVIDES_FOW_POSITION}
end

function modifier_roshan:GetMinHealth()
	return 1
end

function modifier_roshan:GetModifierProvidesFOWVision()
	return 1
end

if IsServer() then
	function modifier_roshan:OnCreated()
		self:StartIntervalThink(0.1)

		local playersCount = GetPlayersCount()
		if IsInToolsMode() then
			playersCount = 1
		end

		local health = self:GetAbility():GetSpecialValueFor("hp_per_player") * playersCount

		self:GetParent():SetBaseMaxHealth(health)
		self:GetParent():SetMaxHealth(health)
		self:GetParent():SetHealth(health)
	end
	function modifier_roshan:OnIntervalThink()
		self:GetParent():Purge(false, true, false, true, false)
		GridNav:DestroyTreesAroundPoint(self:GetParent():GetOrigin(), 200, true)

		if self:GetParent():GetCurrentActiveAbility() or self:GetParent():IsChanneling() then
			self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_roshan_casting", {duration = 0.11})
		end
	end
	function modifier_roshan:OnAbilityStart(event)
		if event.unit == self:GetParent() then
			local ability = event.ability
			local castPoint = ability:GetCastPoint()
			if castPoint ~= nil then
				-- event.unit:AddNewModifier(event.unit, self:GetAbility(), "modifier_roshan_casting", {duration = castPoint})
			end
		end
	end
	function modifier_roshan:OnTakeDamage(event)
		if event.unit == self:GetParent() then
			if self:GetParent():GetHealth() <= event.damage then
				self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_roshan_bellyache", {duration = self:GetAbility():GetSpecialValueFor("bellyache_duration")})

				self:GetParent():SetContextThink("ThrowPresents", function()
					for i = 1, 4 do
						local dummyPos = self:GetParent():GetOrigin() + RandomVector(400)
						local dummy = CreateUnitByName("npc_dummy_unit", dummyPos, true, nil, nil, DOTA_TEAM_NEUTRALS)

						local presentName = "npc_present_red"
						if RollPercentage(30) then
							presentName = "npc_present_green"
						elseif RollPercentage(30) then
							presentName = "npc_present_blue"
						end

						local particle = "particles/generic_gameplay/red_present_proj.vpcf"

						if string.find(presentName, "red") then particle = "particles/generic_gameplay/red_present_proj.vpcf" end
						if string.find(presentName, "green") then particle = "particles/generic_gameplay/green_present_proj.vpcf" end
						if string.find(presentName, "blue") then particle = "particles/generic_gameplay/blue_present_proj.vpcf" end

						ProjectileManager:CreateTrackingProjectile({
							Target = dummy,
							Source = self:GetParent(),
							Ability = self:GetAbility(),
							EffectName = particle,
							bDodgeable = false,
							bProvidesVision = false,
							iMoveSpeed = 600,
							iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_1,
							ExtraData = {present_name = presentName}
						})
					end
				end, 2.0)
			end
		end
	end
end

modifier_roshan_intro = class({
	IsPurgable = function() return false end,
	IsHidden = function() return true end,
})

function modifier_roshan_intro:CheckState() 
	return {
		[MODIFIER_STATE_DISARMED] = true,
		[MODIFIER_STATE_SILENCED] = true,
		[MODIFIER_STATE_UNSELECTABLE] = true,
		[MODIFIER_STATE_BLIND] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_NOT_ON_MINIMAP] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_INVULNERABLE] = true
	}
end

function modifier_roshan_intro:DeclareFunctions()
	return {MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE, MODIFIER_PROPERTY_MOVESPEED_MAX, MODIFIER_PROPERTY_MOVESPEED_LIMIT}
end

function modifier_roshan_intro:GetModifierMoveSpeed_Absolute()
	return 400
end

function modifier_roshan_intro:GetModifierMoveSpeed_Max()
	return 400
end

function modifier_roshan_intro:GetModifierMoveSpeed_Limit()
	return 400
end

modifier_roshan_bellyache = class({
	IsPurgable = function() return false end,
})

function modifier_roshan_bellyache:CheckState() 
	return {
		[MODIFIER_STATE_DISARMED] = true,
		[MODIFIER_STATE_SILENCED] = true,
		[MODIFIER_STATE_STUNNED] = true,
		[MODIFIER_STATE_UNSELECTABLE] = true,
		[MODIFIER_STATE_BLIND] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_NOT_ON_MINIMAP] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_INVULNERABLE] = true
	}
end

function modifier_roshan_bellyache:DeclareFunctions()
	return {MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT, MODIFIER_PROPERTY_MANA_REGEN_CONSTANT}
end

function modifier_roshan_bellyache:GetModifierConstantHealthRegen()
	return 0
end

function modifier_roshan_bellyache:GetModifierConstantManaRegen()
	return -150
end

if IsServer() then
	function modifier_roshan_bellyache:OnCreated()
		self:GetParent():SetHealth(1)
		self:GetParent():SetMana(1)

		self:GetParent():StartGesture(ACT_DOTA_BELLYACHE_START)
		self:GetParent():SetContextThink("PlayLoopAnimation", function() self:GetParent():StartGesture(ACT_DOTA_BELLYACHE_LOOP) end, 2.2)
		self:StartIntervalThink(0.5)

		EmitSoundOn("RoshanFrost.Bellyache", self:GetParent())
	end
	function modifier_roshan_bellyache:OnDestroy()
		self:GetParent():RemoveGesture(ACT_DOTA_BELLYACHE_LOOP)
		self:GetParent():StartGesture(ACT_DOTA_BELLYACHE_END)

		for i = 0, self:GetParent():GetAbilityCount()-1 do
			local ability = self:GetParent():GetAbilityByIndex(i)
			if ability then
				ability:EndCooldown()
			end
		end

		local playersCount = GetPlayersCount()
		if IsInToolsMode() then
			playersCount = 1
		end

		local health = self:GetParent():GetMaxHealth() + (self:GetAbility():GetSpecialValueFor("hp_per_bellyache") * playersCount)

		self:GetParent():SetBaseMaxHealth(health)
		self:GetParent():SetMaxHealth(health)
		self:GetParent():SetHealth(health)

		self:GetParent():SetMana(self:GetParent():GetMaxMana())

		self:GetParent():AddNewModifier(nil, nil, "modifier_roshan_intro", {duration = -1})
		self:GetParent().AIState = "respawn"
	end
	function modifier_roshan_bellyache:OnIntervalThink()
		local healthRegen = (self:GetParent():GetMaxHealth() / self:GetDuration()) * 0.5
		local manaRegen = (self:GetParent():GetMaxMana() / self:GetDuration()) * 0.5
		self:GetParent():Heal(healthRegen, self:GetParent())
		self:GetParent():GiveMana(manaRegen)
	end
end

modifier_roshan_casting = class({
	IsPurgable = function() return false end,
	IsHidden = function() return true end,
})

function modifier_roshan_casting:CheckState() 
	return {
		-- [MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_MAGIC_IMMUNE] = true,
		-- [MODIFIER_STATE_ATTACK_IMMUNE] = true
	}
end

modifier_roshan_truesight = class({
	IsPurgable = function() return false end,
	IsHidden = function() return true end,
})

function modifier_roshan_truesight:CheckState() 
	return {
		[MODIFIER_STATE_INVISIBLE] = false
	}
end

function modifier_roshan_truesight:GetPriority()
	return MODIFIER_PRIORITY_ULTRA
end