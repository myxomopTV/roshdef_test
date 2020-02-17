LinkLuaModifier( "modifier_jacob_powerup_dmg_buff", "heroes/hero_jacob/powerup.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_jacob_powerup_armor_buff", "heroes/hero_jacob/powerup.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_jacob_powerup_hp_buff", "heroes/hero_jacob/powerup.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_jacob_powerup_as_buff", "heroes/hero_jacob/powerup.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_jacob_powerup_ms_buff", "heroes/hero_jacob/powerup.lua", LUA_MODIFIER_MOTION_NONE )

LinkLuaModifier( "modifier_jacob_infest_passive", "heroes/hero_jacob/infest", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_jacob_infest_hidden", "heroes/hero_jacob/infest", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier( "modifier_jacob_infest_host", "heroes/hero_jacob/infest", LUA_MODIFIER_MOTION_NONE )

jacob_consume = class({})

function jacob_consume:OnSpellStart()
	local caster = self:GetCaster()
	caster.host:ForceKill(false)
	
end

jacob_infest = class({})

function jacob_infest:OnAbilityPhaseStart()
    local caster = self:GetCaster()
    local target = self:GetCursorTarget()
	local ability = self
	
	local unit_lvl = target:GetLevel()
	local unit_lvl_required = ability:GetSpecialValueFor("lvl_required")
	
	print("unit lvl = "..unit_lvl.." required lvl = "..unit_lvl_required)
    print(target:GetUnitLabel())
    print(target:GetUnitName())
	
	if target:IsHero() then
		print("is hero = true")
	else
		print("is hero = false")	
	end
	
	if target:IsBoss() then
		print("is boss = true")
	else
		print("is boss = false")	
	end
	
	if target:IsAncient() then
		print("is ancient = true")
	else
		print("is ancient = false")	
	end
	
	if target.boss then
		Containers:DisplayError(caster:GetPlayerID(), "jacob_infest_error_is_boss")
		return false
	end

    if unit_lvl > unit_lvl_required or target:IsHero() or caster == target or target:IsCourier()  then
		Containers:DisplayError(caster:GetPlayerID(), "jacob_infest_error_need_lvl")
--		caster:Hold()
		return false
    end
	
	return true
		
end

function jacob_infest:OnSpellStart( keys )
    local target = self:GetCursorTarget()
    local caster = self:GetCaster()
    local ability = self
	local player = caster:GetPlayerID()
	local team = caster:GetTeam()
	
	local ability_dmg = caster:FindAbilityByName("jacob_powerup_dmg")
	local ability_armor = caster:FindAbilityByName("jacob_powerup_armor")
	local ability_hp = caster:FindAbilityByName("jacob_powerup_hp")
	local ability_as = caster:FindAbilityByName("jacob_powerup_as")
	local ability_ms = caster:FindAbilityByName("jacob_powerup_ms")
	
	local target_name = target:GetUnitName()
	local target_fw = target:GetForwardVector()	
	local target_origin = target:GetAbsOrigin()
	local target_health = target:GetHealth()
	local target_maxhealth = target:GetMaxHealth()
	local target_armor = target:GetPhysicalArmorBaseValue()
	local target_min_dmg = target:GetBaseDamageMin()
	local target_max_dmg = target:GetBaseDamageMax()
	

	target:AddNoDraw()
	target:ForceKill(false)
	local unit = CreateUnitByName( target_name, target_origin, true, nil, nil, team )
	caster:AddNewModifier(caster, ability, "modifier_jacob_infest_hidden", nil)
    caster.host = unit
	PlayerResource:SetOverrideSelectionEntity(player, unit) 
	Timers:CreateTimer(0.1,function()  
		PlayerResource:SetOverrideSelectionEntity(player, nil) 
	end) 
	if caster:HasModifier("modifier_special_effect_divine") then
		caster:AddNewModifier(caster,ability,"modifier_special_effect_divine",{duration = 0.1})
		unit:AddNewModifier(caster,ability,"modifier_special_effect_divine",nil)
	end
	if caster:HasModifier("modifier_special_effect_legendary") then
		caster:AddNewModifier(caster,ability,"modifier_special_effect_legendary",{duration = 0.1})
		unit:AddNewModifier(caster,ability,"modifier_special_effect_legendary",nil)
	end
	
	unit:SetForwardVector(target_fw)
	unit:SetControllableByPlayer(player, false)
	unit:SetOwner(caster)
	unit:SetBaseDamageMin(target_min_dmg)
	unit:SetBaseDamageMax(target_max_dmg)				
	unit:SetPhysicalArmorBaseValue(target_armor)
	unit:SetBaseMaxHealth(target_maxhealth)
	unit:SetMaxHealth(target_maxhealth)	
	unit:SetHealth(target_health)
	unit:AddNewModifier(caster, ability, "modifier_jacob_infest_host", nil)
	unit:AddNewModifier(caster,ability,"modifier_bloodseeker_thirst",nil)
	unit:AddNewModifier(caster,ability_dmg,"modifier_jacob_powerup_dmg_buff",nil)
	unit:AddNewModifier(caster,ability_armor,"modifier_jacob_powerup_armor_buff",nil)
	unit:AddNewModifier(caster,ability_hp,"modifier_jacob_powerup_hp_buff",nil)
	unit:AddNewModifier(caster,ability_as,"modifier_jacob_powerup_as_buff",nil)
	unit:AddNewModifier(caster,ability_ms,"modifier_jacob_powerup_ms_buff",nil)

	unit:AddAbility("wisp_critical_strike")
	unit:AddAbility("wisp_bonus_regen")
	unit:AddAbility("wisp_light_armor")
	unit:AddAbility("wisp_light_strike")
	unit:AddAbility("wisp_bonus_ms")

	if unit:FindAbilityByName("respawn") then
		unit:RemoveAbility("respawn")
	end
	if unit:FindAbilityByName("respawn_strong") then
		unit:RemoveAbility("respawn_strong")
	end
	if unit:FindAbilityByName("boss_respawn") then
		unit:RemoveAbility("boss_respawn")
	end

	caster:AddNoDraw()
	EmitSoundOn("Hero_LifeStealer.Infest",unit)
--	local effect = "particles/units/heroes/hero_life_stealer/life_stealer_infest_emerge_clean_mid.vpcf"
	local effect = "particles/test_particle/jacob_infest_cast_blood01.vpcf"
	local pfx = ParticleManager:CreateParticle(effect, PATTACH_ABSORIGIN_FOLLOW, unit)
	ParticleManager:ReleaseParticleIndex(pfx)

	caster:SwapAbilities("jacob_infest", "jacob_consume", false, true) 

end

function jacob_infest:GetIntrinsicModifierName()
	return "modifier_jacob_infest_passive"
end

modifier_jacob_infest_passive = class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	CheckState		= function(self) return 
		{
		[MODIFIER_STATE_DISARMED] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_MUTED] = true,
		} end,
})
function modifier_jacob_infest_passive:CheckState()
	local state =
	{
		[MODIFIER_STATE_DISARMED] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
--		[MODIFIER_STATE_MUTED] = true,
	}
	return state
end
function modifier_jacob_infest_passive:OnCreated()
	self:StartIntervalThink(0.03)
end

function modifier_jacob_infest_passive:OnIntervalThink()
	local caster = self:GetCaster()
	local player = caster:GetPlayerID()
	local gold = PlayerResource:GetGold(player)
	if IsValidEntity(caster.host) and caster.host:IsAlive() then
		caster:SetAbsOrigin(caster.host:GetAbsOrigin())
	end
	caster:SetMana(gold)
end

modifier_jacob_infest_hidden = class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	CheckState		= function(self) return 
		{
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_ROOTED] = true,
		[MODIFIER_STATE_NOT_ON_MINIMAP] = true,
		[MODIFIER_STATE_UNSELECTABLE] = true,
		[MODIFIER_STATE_OUT_OF_GAME] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		} end,
})

modifier_jacob_infest_host = class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	DeclareFunctions		= function(self) return 
		{
		MODIFIER_EVENT_ON_DEATH,
		} end,
})

function modifier_jacob_infest_host:GetEffectName()
--	return "particles/units/heroes/hero_life_stealer/life_stealer_infested_unit.vpcf"
	return "particles/test_particle/jacob_infested_unit_icon.vpcf"
end
function modifier_jacob_infest_host:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end
function modifier_jacob_infest_host:OnDeath(data)
    local caster = self:GetCaster()
	local parent = self:GetParent()
	local unit = data.unit
    local ability = self:GetAbility()
	local ability_bonus_cd = ability:GetSpecialValueFor("bonus_cd")

    if parent == unit  then 
		caster:SetAbsOrigin(parent:GetAbsOrigin())
		caster:RemoveNoDraw()
		caster:RemoveModifierByName("modifier_jacob_infest_hidden")
		parent:RemoveModifierByName("modifier_jacob_infest_host")
		caster:SwapAbilities("jacob_consume", "jacob_infest", false, true) 
		if parent:HasModifier("modifier_special_effect_divine") then
			parent:AddNewModifier(caster,ability,"modifier_special_effect_divine",{duration = 0.1})
			caster:AddNewModifier(caster,ability,"modifier_special_effect_divine",nil)
		end
		if parent:HasModifier("modifier_special_effect_legendary") then
			parent:AddNewModifier(caster,ability,"modifier_special_effect_legendary",{duration = 0.1})
			caster:AddNewModifier(caster,ability,"modifier_special_effect_legendary",nil)
		end
		EmitSoundOn("Hero_LifeStealer.consume",caster)
		local effect = "particles/test_particle/jacob_infest_emerge_clean_blood01.vpcf"
		local pfx = ParticleManager:CreateParticle(effect, PATTACH_ABSORIGIN_FOLLOW, unit)
		ParticleManager:ReleaseParticleIndex(pfx)

		caster:Hold()	
		ability:StartCooldown(ability_bonus_cd)
		
		else
        caster:SetAbsOrigin(caster.host:GetAbsOrigin() - Vector(0, 0, 322))
    end
end

function modifier_jacob_infest_host:OnCreated()
	local ability = self:GetAbility()
	local caster = self:GetCaster()
	local target = self:GetParent()
	print(ability:GetName())
	print(caster:GetUnitName())
	self:StartIntervalThink(0.1)
	
end

function modifier_jacob_infest_host:OnIntervalThink()
	local ability = self:GetAbility()
	local caster = self:GetCaster()
	local target = self:GetParent()
	local special_bonus = 0

	if target.init == nil then
		target:AddNewModifier(caster, nil, "modifier_phased", {duration = 0.1})
		target.init = true
	end

	if caster:HasModifier("modifier_item_special_jacob") then
		special_bonus = 5
	elseif caster:HasModifier("modifier_item_special_jacob_upgrade") then
		special_bonus = 50
	end

	local stack_count_dmg = caster:GetModifierStackCount("jacob_powerup_dmg_counter", nil) + special_bonus
	local stack_count_hp = caster:GetModifierStackCount("jacob_powerup_hp_counter", nil) + special_bonus
	local stack_count_armor = caster:GetModifierStackCount("jacob_powerup_armor_counter", nil) + special_bonus
	local stack_count_as = caster:GetModifierStackCount("jacob_powerup_as_counter", nil) + special_bonus
	local stack_count_ms = caster:GetModifierStackCount("jacob_powerup_ms_counter", nil) + special_bonus
	local stack_count_hp_buff = target:GetModifierStackCount("modifier_jacob_powerup_hp_buff", nil)
	local ability_hp = caster:FindAbilityByName("jacob_powerup_hp"):GetSpecialValueFor("upgrade_value")

	if stack_count_hp - stack_count_hp_buff > 0 then
		target.init = nil
	end
	
	target:SetModifierStackCount("modifier_jacob_powerup_dmg_buff", caster, stack_count_dmg )
	target:SetModifierStackCount("modifier_jacob_powerup_hp_buff", caster, stack_count_hp )
	target:SetModifierStackCount("modifier_jacob_powerup_armor_buff", caster, stack_count_armor )
	target:SetModifierStackCount("modifier_jacob_powerup_as_buff", caster, stack_count_as )
	target:SetModifierStackCount("modifier_jacob_powerup_ms_buff", caster, stack_count_ms )
	
	local ability_dmg = target:FindAbilityByName("wisp_critical_strike")
	local ability_hp = target:FindAbilityByName("wisp_bonus_regen")
	local ability_armor = target:FindAbilityByName("wisp_light_armor")
	local ability_as = target:FindAbilityByName("wisp_light_strike")
	local ability_ms = target:FindAbilityByName("wisp_bonus_ms")

	local ability_level_dmg = math.floor(stack_count_dmg/10)
	local ability_level_hp = math.floor(stack_count_hp/10)
	local ability_level_armor = math.floor(stack_count_armor/10)
	local ability_level_as = math.floor(stack_count_as/10)
	local ability_level_ms = math.floor(stack_count_ms/10)

	local current_ability_level_dmg = ability_dmg:GetLevel()
	local current_ability_level_hp = ability_hp:GetLevel()
	local current_ability_level_armor = ability_armor:GetLevel()
	local current_ability_level_as = ability_as:GetLevel()
	local current_ability_level_ms = ability_ms:GetLevel()
	 
	if current_ability_level_dmg < ability_level_dmg then
		ability_dmg:SetLevel(ability_level_dmg)
	end	
	if current_ability_level_hp < ability_level_hp then
		ability_hp:SetLevel(ability_level_hp)
	end	
	if current_ability_level_armor < ability_level_armor then
		ability_armor:SetLevel(ability_level_armor)
	end	
	if current_ability_level_as < ability_level_as then
		ability_as:SetLevel(ability_level_as)
	end	
	if current_ability_level_ms < ability_level_ms then
		ability_ms:SetLevel(ability_level_ms)
	end	
--[[
	if not target:HasModifier("modifier_granite_golem_hp_aura_bonus") and not target:HasModifier("modifier_power_up_buff") then
		target:SetBaseMaxHealth(max_hp + hp_bonus)
		target:SetMaxHealth(max_hp + hp_bonus)	
		target:SetHealth(current_hp + hp_bonus)	
	end
]]		
end

