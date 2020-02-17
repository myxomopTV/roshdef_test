
function ForpostSpawnStart(keys)
	local caster = keys.caster
	local ability = keys.ability
	local roshan_point = Entities:FindByName( nil, "d_waypoint20"):GetAbsOrigin()
	
	if ability.wave_count == nil then
		ability.wave_count = 0
	else
		ability.wave_count = ability.wave_count + 1
	end

--[[	
	Timers:CreateTimer(1, function()
		print("game time = "..GameRules:GetDOTATime(false, true))
		return 1
	end)
]]	
	if GameRules:GetDOTATime(false, true) < 0 or GameRules.DIFFICULTY == 0 or GetMapName() == "roshdef_adventure" then 
		return 
	end
	
	local ranged_count = ability:GetSpecialValueFor("ranged_count")
	local ranged_hp_buff = ability:GetSpecialValueFor("ranged_hp_buff")*ability.wave_count
	local ranged_dmg_buff = ability:GetSpecialValueFor("ranged_dmg_buff")*ability.wave_count
	local ranged_armor_buff = ability:GetSpecialValueFor("ranged_armor_buff")*ability.wave_count
	local meele_count = ability:GetSpecialValueFor("meele_count")
	local meele_hp_buff = ability:GetSpecialValueFor("meele_hp_buff")*ability.wave_count
	local meele_dmg_buff = ability:GetSpecialValueFor("meele_dmg_buff")*ability.wave_count
	local meele_armor_buff = ability:GetSpecialValueFor("meele_armor_buff")*ability.wave_count
	local spawn_cooldown = ability:GetSpecialValueFor("spawn_cooldown")
	
	GameRules:SendCustomMessage("#Game_notification_forpost_spawn",0,0)
	for i=1,ranged_count do
		local vSpawnPos = caster:GetOrigin() + RandomVector( 125 )
		local name = "npc_dota_sniper_forpost_1"
		local unit = CreateUnitByName( name, vSpawnPos, true, nil, nil, caster:GetTeamNumber() )
		UnitUpgrade (unit, ranged_hp_buff, ranged_dmg_buff, ranged_armor_buff)
		unit:AddNewModifier( unit, ability, "modifier_phased", { duration = 0.1 } )
		AttackMove( unit, roshan_point )
	
	end
	for i=1,meele_count do
		local vSpawnPos = caster:GetOrigin() + RandomVector( 125 )
		local name = "npc_dota_dk_forpost_1"
		local unit = CreateUnitByName( name, vSpawnPos, true, nil, nil, caster:GetTeamNumber() )
		UnitUpgrade (unit, meele_hp_buff, meele_dmg_buff, meele_armor_buff)
		unit:AddNewModifier( unit, ability, "modifier_phased", { duration = 0.1 } )
		AttackMove( unit, roshan_point )
	
	end
	
	if ability.wave_count == 17 then
		local vSpawnPos = caster:GetOrigin() + RandomVector( 125 )
		local name = "npc_dota_forpost_boss_1"
		local unit = CreateUnitByName( name, vSpawnPos, true, nil, nil, caster:GetTeamNumber() )
		unit:AddNewModifier( unit, ability, "modifier_phased", { duration = 0.1 } )	
	end
	
end

function ForpostSpawnEnd (keys)
	local ability = keys.ability
	
	ability.trigger = nil

end

function UnitUpgrade (unit, hp, dmg, armor)
	local maxhp = unit:GetMaxHealth() + hp
	
	unit:SetBaseDamageMin(unit:GetBaseDamageMin() + dmg)
	unit:SetBaseDamageMax(unit:GetBaseDamageMax() + dmg)				
	unit:SetPhysicalArmorBaseValue(unit:GetPhysicalArmorBaseValue() + armor)
	unit:SetBaseMaxHealth(maxhp)
	unit:SetMaxHealth(maxhp)	
	unit:SetHealth(maxhp)

end

function AttackMove ( unit, point )
	print("that shit work !!!")
	Timers:CreateTimer(0.1, function()
		ExecuteOrderFromTable({
			UnitIndex = unit:entindex(),
			OrderType = DOTA_UNIT_ORDER_ATTACK_MOVE,
			Position = point,
			Queue = false,
		})
	end)
end