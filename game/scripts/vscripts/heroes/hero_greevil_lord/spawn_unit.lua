LinkLuaModifier("modifier_greevil_unit_upgrade", "heroes/hero_greevil_lord/upgrade_unit", LUA_MODIFIER_MOTION_NONE)

spawn_unit_weak = class({})
function spawn_unit_weak:GetGoldCost()	
	local gold_cost = self:GetSpecialValueFor("gold_cost") 
	
	return  gold_cost
end
function spawn_unit_weak:GetChannelTime()
	local spawn_time = self:GetSpecialValueFor("spawn_time") 
	
	return spawn_time
end
function spawn_unit_weak:OnChannelFinish( bInterrupted )	
	local hero = self:GetCaster():GetOwner()
	local gold = self:GetGoldCost(-1)
	print("gold cost = "..gold)
	if bInterrupted then
		hero:ModifyGold(gold, false, 0)
	else
		SpawnUnit(self, "npc_dota_greevil_lord_unit_weak")
	end
end

spawn_unit_medium = class({})
function spawn_unit_medium:GetGoldCost()	
	local gold_cost = self:GetSpecialValueFor("gold_cost") 
	
	return  gold_cost
end
function spawn_unit_medium:GetChannelTime()
	local spawn_time = self:GetSpecialValueFor("spawn_time") 
	
	return spawn_time
end
function spawn_unit_medium:OnChannelFinish( bInterrupted )	
	local hero = self:GetCaster():GetOwner()
	local gold = self:GetGoldCost(-1)
	print("gold cost = "..gold)
	if bInterrupted then
		hero:ModifyGold(gold, false, 0)
	else
		SpawnUnit(self, "npc_dota_greevil_lord_unit_medium")
	end
end

spawn_unit_strong = class({})
function spawn_unit_strong:GetGoldCost()	
	local gold_cost = self:GetSpecialValueFor("gold_cost") 
	
	return  gold_cost
end
function spawn_unit_strong:GetChannelTime()
	local spawn_time = self:GetSpecialValueFor("spawn_time") 
	
	return spawn_time
end
function spawn_unit_strong:OnChannelFinish( bInterrupted )	
	local hero = self:GetCaster():GetOwner()
	local gold = self:GetGoldCost(-1)
	print("gold cost = "..gold)
	if bInterrupted then
		hero:ModifyGold(gold, false, 0)
	else
		SpawnUnit(self, "npc_dota_greevil_lord_unit_strong")
	end
end

function SpawnUnit(ability, unit_name)
		local caster = ability:GetCaster()
		local point = caster:GetAbsOrigin()
		local player = caster:GetPlayerOwnerID() 
		local hero = PlayerResource:GetSelectedHeroEntity(player) or caster:GetOwner()

		local unit_name = unit_name
		local base_hp = ability:GetSpecialValueFor("base_hp")
		local base_dmg = ability:GetSpecialValueFor("base_dmg")
		local base_armor = ability:GetSpecialValueFor("base_armor")
		
		unit = CreateUnitByName(unit_name, point, true, caster, caster, caster:GetTeamNumber())
		unit:SetControllableByPlayer(player, true)
		unit:SetOwner(hero)

		local new_hp = base_hp 

		unit:SetBaseDamageMin(base_dmg )
		unit:SetBaseDamageMax(base_dmg )				
		unit:SetPhysicalArmorBaseValue(base_armor )
		unit:SetMaxHealth( new_hp )
		unit:SetBaseMaxHealth( new_hp )
		unit:SetHealth( new_hp )
		
		unit:AddNewModifier(unit, nil, "modifier_greevil_unit_upgrade", nil)
		unit:AddNewModifier(caster,ability,"modifier_phased",{duration = 0.1})	
end


