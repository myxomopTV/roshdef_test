LinkLuaModifier( "modifier_wisp_powerup_dmg_buff", "heroes/hero_wisp/powerup.lua", LUA_MODIFIER_MOTION_NONE )	-- Root debuff
LinkLuaModifier( "modifier_wisp_powerup_armor_buff", "heroes/hero_wisp/powerup.lua", LUA_MODIFIER_MOTION_NONE )	-- Root debuff
LinkLuaModifier( "modifier_wisp_powerup_hp_buff", "heroes/hero_wisp/powerup.lua", LUA_MODIFIER_MOTION_NONE )	-- Root debuff
LinkLuaModifier( "modifier_wisp_powerup_as_buff", "heroes/hero_wisp/powerup.lua", LUA_MODIFIER_MOTION_NONE )	-- Root debuff
LinkLuaModifier( "modifier_wisp_powerup_ms_buff", "heroes/hero_wisp/powerup.lua", LUA_MODIFIER_MOTION_NONE )	-- Root debuff

GameRules.HeroesFile = LoadKeyValues("scripts/npc/npc_units_custom.txt")

function infest_check_valid( keys )
    local caster = keys.caster
    local target = keys.target
	local ability = keys.ability
	
	local unit_lvl = target:GetLevel()
	local unit_lvl_required = ability:GetSpecialValueFor("lvl_required")
	
	print("unit lvl = "..unit_lvl.." required lvl = "..unit_lvl_required)
    print(target:GetUnitLabel())
    print(target:GetUnitName())

    --check for validity. theres a lot of exceptions, and i'd like a better way to do this.
    --unsure of the formatting as well as it's a long list.
    local enemyexceptionlist = {"spirit_bear", "visage_familiars"}
    local enemyisexception = false
    for _,item in pairs(enemyexceptionlist) do
        if item == target:GetUnitLabel() and target:GetTeamNumber() ~= caster:GetTeamNumber() then
            enemyisexception = true
          break
        end
    end

    if target:IsHero() and target:GetTeamNumber() ~= caster:GetTeamNumber() or caster == target or target:IsCourier() or target:IsBoss() or target:IsAncient() or enemyisexception then
--		print("Ты выбрал не ту дверь!")
-- 		DisplayError(0, "ERRRORRRRRRRRRRR")
--         caster:Hold()
    end
	
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
	
	local isBossMonster = GameRules.HeroesFile[target:GetUnitName()]["IsBossMonster"] or 0
	if isBossMonster == 1 then
		Containers:DisplayError(caster:GetPlayerID(), "wisp_infest_error_is_boss")
		caster:Hold()
	end

    if unit_lvl > unit_lvl_required or target:IsHero() or caster == target or target:IsCourier()  then
		Containers:DisplayError(caster:GetPlayerID(), "wisp_infest_error_need_lvl")
		caster:Hold()
    end
	
	
end

function infest_add_consume( keys )
    if not keys.caster:HasAbility("life_stealer_consume_datadriven") then
        keys.caster:AddAbility("life_stealer_consume_datadriven")
    end
end

function infest_start( keys )
    local target = keys.target
    local caster = keys.caster
    local ability = keys.ability
	local player = caster:GetPlayerID()
	local team = caster:GetTeam()
	
	local ability_dmg = caster:FindAbilityByName("wisp_powerup_dmg")
	local ability_armor = caster:FindAbilityByName("wisp_powerup_armor")
	local ability_hp = caster:FindAbilityByName("wisp_powerup_hp")
	local ability_as = caster:FindAbilityByName("wisp_powerup_as")
	local ability_ms = caster:FindAbilityByName("wisp_powerup_ms")
	
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
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_infest_hide", nil)
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
	ability:ApplyDataDrivenModifier(caster, unit, "modifier_infest_buff", nil)
	unit:AddNewModifier(caster,ability,"modifier_bloodseeker_thirst",nil)
	unit:AddNewModifier(caster,ability_dmg,"modifier_wisp_powerup_dmg_buff",nil)
	unit:AddNewModifier(caster,ability_armor,"modifier_wisp_powerup_armor_buff",nil)
	unit:AddNewModifier(caster,ability_hp,"modifier_wisp_powerup_hp_buff",nil)
	unit:AddNewModifier(caster,ability_as,"modifier_wisp_powerup_as_buff",nil)
	unit:AddNewModifier(caster,ability_ms,"modifier_wisp_powerup_ms_buff",nil)

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

	
    -- Strong Dispel
    local RemovePositiveBuffs = false
    local RemoveDebuffs = true
    local BuffsCreatedThisFrameOnly = false
    local RemoveStuns = true
    local RemoveExceptions = false
    caster:Purge( RemovePositiveBuffs, RemoveDebuffs, BuffsCreatedThisFrameOnly, RemoveStuns, RemoveExceptions)

    -- Hide the hero underground
    caster:SetAbsOrigin(caster.host:GetAbsOrigin() - Vector(0, 0, 322))
    caster:SwapAbilities("wisp_infest", "wisp_consume", false, true) 

 --[[   -- Remove the abilities.
    for i = 0, 4 do
        local ability_slot = caster:GetAbilityByIndex(i)
        if ability_slot ~= nil and ability_slot:GetAbilityName() ~= "life_stealer_infest_datadriven" and ability_slot:GetAbilityName() ~= "life_stealer_consume_datadriven" then
            print(ability_slot, ability_slot:GetAbilityName() )
            caster.removed_spells[i] = { ability_slot:GetAbilityName(), ability_slot:GetLevel() }

            print(caster.removed_spells[i][1], caster.removed_spells[i][2])
            caster:RemoveAbility(ability_slot:GetAbilityName())
        end
    end
]]    
	--Timers:CreateTimer(10, function() reset(keys) end)
end

function infest_move_unit( keys )
    local caster = keys.caster
    local ability = keys.ability
	local infest_ability = caster:FindAbilityByName("wisp_infest")
	local ability_bonus_cd = infest_ability:GetSpecialValueFor("bonus_cd")
    --Check if the host still exists
    if caster.host == nil or not caster.host:IsAlive() then -- CHANGE THIS PLEASE?
		caster:SetAbsOrigin(caster.host:GetAbsOrigin())
		caster:RemoveModifierByName("modifier_infest_hide")
		caster.host:RemoveModifierByName("modifier_infest_buff")
		caster:SwapAbilities("wisp_consume", "wisp_infest", false, true) 
	--[[
		--return the abilities
		for i = 0, 4 do
			if caster.removed_spells[i] ~= nil then
				print(caster.removed_spells[i][1], caster.removed_spells[i][2])
				caster:AddAbility(caster.removed_spells[i][1])
				caster:GetAbilityByIndex(i):SetLevel(caster.removed_spells[i][2])
			end
		end
	]]	
		-- if the unit is not a hero, the unit dies

	--    caster.host:Kill(ability, caster)
		if caster.host:HasModifier("modifier_special_effect_divine") then
			caster.host:AddNewModifier(caster,ability,"modifier_special_effect_divine",{duration = 0.1})
			caster:AddNewModifier(caster,ability,"modifier_special_effect_divine",nil)
		end
		if caster.host:HasModifier("modifier_special_effect_legendary") then
			caster.host:AddNewModifier(caster,ability,"modifier_special_effect_legendary",{duration = 0.1})
			caster:AddNewModifier(caster,ability,"modifier_special_effect_legendary",nil)
		end

		caster:Hold()	
		infest_ability:StartCooldown(ability_bonus_cd)
		
		else
        caster:SetAbsOrigin(caster.host:GetAbsOrigin() - Vector(0, 0, 322))
    end
end

function infest_consume(keys)
    print(keys.caster.host:GetUnitLabel())
    print(keys.caster.host:GetUnitName())
    local caster = keys.caster
    local ability = keys.ability
	
	caster.host:Kill(ability, caster)


end

function SetGoldMana(keys)
	local caster = keys.caster
	local player = caster:GetPlayerID()
	local gold = PlayerResource:GetGold(player)
	
	caster:SetMana(gold)
end

function SetModifiersCount(keys)
	local ability = keys.ability
	local caster = keys.caster
	local target = keys.target
	
	
	local stack_count_dmg = caster:GetModifierStackCount("wisp_powerup_dmg_counter", nil)
	local stack_count_hp = caster:GetModifierStackCount("wisp_powerup_hp_counter", nil)
	local stack_count_armor = caster:GetModifierStackCount("wisp_powerup_armor_counter", nil)
	local stack_count_as = caster:GetModifierStackCount("wisp_powerup_as_counter", nil)
	local stack_count_ms = caster:GetModifierStackCount("wisp_powerup_ms_counter", nil)

	local stack_count_hp_buff = target:GetModifierStackCount("modifier_wisp_powerup_hp_buff", nil)
	local ability_hp = caster:FindAbilityByName("wisp_powerup_hp"):GetSpecialValueFor("upgrade_value")
	local current_hp = target:GetHealth()
	local max_hp = target:GetMaxHealth()
	local hp_bonus = ability_hp * (stack_count_hp - stack_count_hp_buff)
	
	
	target:SetModifierStackCount("modifier_wisp_powerup_dmg_buff", caster, stack_count_dmg )
	target:SetModifierStackCount("modifier_wisp_powerup_hp_buff", caster, stack_count_hp )
	target:SetModifierStackCount("modifier_wisp_powerup_armor_buff", caster, stack_count_armor )
	target:SetModifierStackCount("modifier_wisp_powerup_as_buff", caster, stack_count_as )
	target:SetModifierStackCount("modifier_wisp_powerup_ms_buff", caster, stack_count_ms )
	
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

	if not target:HasModifier("modifier_granite_golem_hp_aura_bonus") and not target:HasModifier("modifier_power_up_buff") then
		target:SetBaseMaxHealth(max_hp + hp_bonus)
		target:SetMaxHealth(max_hp + hp_bonus)	
		target:SetHealth(current_hp + hp_bonus)	
	end
		
end

