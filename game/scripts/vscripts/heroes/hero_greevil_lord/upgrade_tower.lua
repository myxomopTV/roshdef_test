LinkLuaModifier("modifier_greevil_tower_upgrade", "heroes/hero_greevil_lord/upgrade_tower", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_upgrade_tower_health", "heroes/hero_greevil_lord/upgrade_tower", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_upgrade_tower_armor", "heroes/hero_greevil_lord/upgrade_tower", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_upgrade_tower_attack", "heroes/hero_greevil_lord/upgrade_tower", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_upgrade_tower_speed", "heroes/hero_greevil_lord/upgrade_tower", LUA_MODIFIER_MOTION_NONE)

if IsServer() then
	CustomNetTables:SetTableValue("tower_upgrades", "upgrade_tower_health", { value = 0})
	CustomNetTables:SetTableValue("tower_upgrades", "tower_health_value", { value = 0})
	upgrade_tower_health_check = false

	CustomNetTables:SetTableValue("tower_upgrades", "upgrade_tower_armor", { value = 0})
	CustomNetTables:SetTableValue("tower_upgrades", "tower_armor_value", { value = 0})
	upgrade_tower_armor_check = false

	CustomNetTables:SetTableValue("tower_upgrades", "upgrade_tower_attack", { value = 0})
	CustomNetTables:SetTableValue("tower_upgrades", "tower_attack_value", { value = 0})
	upgrade_tower_attack_check = false

	CustomNetTables:SetTableValue("tower_upgrades", "upgrade_tower_speed", { value = 0})
	CustomNetTables:SetTableValue("tower_upgrades", "tower_speed_value", { value = 0})
	upgrade_tower_speed_check = false
	
end
greevil_towers = {}

upgrade_tower_health = class({})

function upgrade_tower_health:OnSpellStart()
	local max_upgrade = self:GetSpecialValueFor("max_upgrade")
	local current_upgrade = tGetValue ("tower_upgrades", "upgrade_tower_health")
	if current_upgrade >= max_upgrade then
		self:GetCaster():Stop()
		self:SetHidden(true)
	end
end	
function upgrade_tower_health:GetGoldCost()	
	local gold_cost = self:GetSpecialValueFor("gold_cost") 
	local gold_cost_up = self:GetSpecialValueFor("gold_cost_up") * tGetValue ("tower_upgrades", "upgrade_tower_health")

	return  gold_cost + gold_cost_up
end

function upgrade_tower_health:GetChannelTime()
	local upgrade_time = self:GetSpecialValueFor("upgrade_time")
	local upgrade_time_up = self:GetSpecialValueFor("upgrade_time_up") * tGetValue ("tower_upgrades", "upgrade_tower_health")

	return upgrade_time + upgrade_time_up
end

function upgrade_tower_health:OnChannelFinish( bInterrupted )	
	local hero = self:GetCaster():GetOwner()
	local gold = self:GetGoldCost(-1)

	if upgrade_tower_health_check == false then
		upgrade_tower_health_check = true
		local upgrade_value = self:GetSpecialValueFor("upgrade_value")

		CustomNetTables:SetTableValue("tower_upgrades", "tower_health_value", { value = upgrade_value})
		print(tGetValue("tower_upgrades", "tower_health_value"))
	end
	if bInterrupted then
		hero:ModifyGold(gold, false, 0)
	else
		tIncreaseValue("tower_upgrades", "upgrade_tower_health")
		UpdateUnitsStats(greevil_towers)
		local modifier = self:GetCaster():FindModifierByName("modifier_upgrade_tower_health")
		modifier:IncrementStackCount()
	end
end
function upgrade_tower_health:GetIntrinsicModifierName()
	return "modifier_upgrade_tower_health"
end
modifier_upgrade_tower_health = class({
	IsHidden 				= function(self) return false end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return true end,
	OnCreated				= function(self)
		self:SetStackCount(tGetValue("tower_upgrades", "upgrade_tower_health"))
	end,
})

upgrade_tower_armor = class({})

function upgrade_tower_armor:OnSpellStart()
	local max_upgrade = self:GetSpecialValueFor("max_upgrade")
	local current_upgrade = tGetValue ("tower_upgrades", "upgrade_tower_armor")
	if current_upgrade >= max_upgrade then
		self:GetCaster():Stop()
		self:SetHidden(true)
	end
end	
function upgrade_tower_armor:GetGoldCost()	
	local gold_cost = self:GetSpecialValueFor("gold_cost") 
	local gold_cost_up = self:GetSpecialValueFor("gold_cost_up") * tGetValue ("tower_upgrades", "upgrade_tower_armor")

	return  gold_cost + gold_cost_up
end

function upgrade_tower_armor:GetChannelTime()
	local upgrade_time = self:GetSpecialValueFor("upgrade_time")
	local upgrade_time_up = self:GetSpecialValueFor("upgrade_time_up") * tGetValue ("tower_upgrades", "upgrade_tower_armor")

	return upgrade_time + upgrade_time_up
end

function upgrade_tower_armor:OnChannelFinish( bInterrupted )	
	local hero = self:GetCaster():GetOwner()
	local gold = self:GetGoldCost(-1)

	if upgrade_tower_armor_check == false then
		upgrade_tower_armor_check = true
		local upgrade_value = self:GetSpecialValueFor("upgrade_value")

		CustomNetTables:SetTableValue("tower_upgrades", "tower_armor_value", { value = upgrade_value})
		print(tGetValue("tower_upgrades", "tower_armor_value"))
	end
	if bInterrupted then
		hero:ModifyGold(gold, false, 0)
	else
		tIncreaseValue("tower_upgrades", "upgrade_tower_armor")
		UpdateUnitsStats(greevil_towers)
		local modifier = self:GetCaster():FindModifierByName("modifier_upgrade_tower_armor")
		modifier:IncrementStackCount()
	end
end
function upgrade_tower_armor:GetIntrinsicModifierName()
	return "modifier_upgrade_tower_armor"
end
modifier_upgrade_tower_armor = class({
	IsHidden 				= function(self) return false end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return true end,
	OnCreated				= function(self)
		self:SetStackCount(tGetValue("tower_upgrades", "upgrade_tower_armor"))
	end,
})

upgrade_tower_attack = class({})

function upgrade_tower_attack:OnSpellStart()
	local max_upgrade = self:GetSpecialValueFor("max_upgrade")
	local current_upgrade = tGetValue ("tower_upgrades", "upgrade_tower_attack")
	if current_upgrade >= max_upgrade then
		self:GetCaster():Stop()
		self:SetHidden(true)
	end
end	
function upgrade_tower_attack:GetGoldCost()	
	local gold_cost = self:GetSpecialValueFor("gold_cost") 
	local gold_cost_up = self:GetSpecialValueFor("gold_cost_up") * tGetValue ("tower_upgrades", "upgrade_tower_attack")

	return  gold_cost + gold_cost_up
end

function upgrade_tower_attack:GetChannelTime()
	local upgrade_time = self:GetSpecialValueFor("upgrade_time")
	local upgrade_time_up = self:GetSpecialValueFor("upgrade_time_up") * tGetValue ("tower_upgrades", "upgrade_tower_attack")

	return upgrade_time + upgrade_time_up
end

function upgrade_tower_attack:OnChannelFinish( bInterrupted )	
	local hero = self:GetCaster():GetOwner()
	local gold = self:GetGoldCost(-1)

	if upgrade_tower_attack_check == false then
		upgrade_tower_attack_check = true
		local upgrade_value = self:GetSpecialValueFor("upgrade_value")

		CustomNetTables:SetTableValue("tower_upgrades", "tower_attack_value", { value = upgrade_value})
		print(tGetValue("tower_upgrades", "tower_attack_value"))
	end
	if bInterrupted then
		hero:ModifyGold(gold, false, 0)
	else
		tIncreaseValue("tower_upgrades", "upgrade_tower_attack")
		UpdateUnitsStats(greevil_towers)
		local modifier = self:GetCaster():FindModifierByName("modifier_upgrade_tower_attack")
		modifier:IncrementStackCount()
	end
end
function upgrade_tower_attack:GetIntrinsicModifierName()
	return "modifier_upgrade_tower_attack"
end
modifier_upgrade_tower_attack = class({
	IsHidden 				= function(self) return false end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return true end,
	OnCreated				= function(self)
		self:SetStackCount(tGetValue("tower_upgrades", "upgrade_tower_attack"))
	end,
})

upgrade_tower_speed = class({})

function upgrade_tower_speed:OnSpellStart()
	local max_upgrade = self:GetSpecialValueFor("max_upgrade")
	local current_upgrade = tGetValue ("tower_upgrades", "upgrade_tower_speed")
	if current_upgrade >= max_upgrade then
		self:GetCaster():Stop()
		self:SetHidden(true)
	end
end	
function upgrade_tower_speed:GetGoldCost()	
	local gold_cost = self:GetSpecialValueFor("gold_cost") 
	local gold_cost_up = self:GetSpecialValueFor("gold_cost_up") * tGetValue ("tower_upgrades", "upgrade_tower_speed")

	return  gold_cost + gold_cost_up
end

function upgrade_tower_speed:GetChannelTime()
	local upgrade_time = self:GetSpecialValueFor("upgrade_time")
	local upgrade_time_up = self:GetSpecialValueFor("upgrade_time_up") * tGetValue ("tower_upgrades", "upgrade_tower_speed")

	return upgrade_time + upgrade_time_up
end

function upgrade_tower_speed:OnChannelFinish( bInterrupted )	
	local hero = self:GetCaster():GetOwner()
	local gold = self:GetGoldCost(-1)

	if upgrade_tower_speed_check == false then
		upgrade_tower_speed_check = true
		local upgrade_value = self:GetSpecialValueFor("upgrade_value")

		CustomNetTables:SetTableValue("tower_upgrades", "tower_speed_value", { value = upgrade_value})
		print(tGetValue("tower_upgrades", "tower_speed_value"))
	end
	if bInterrupted then
		hero:ModifyGold(gold, false, 0)
	else
		tIncreaseValue("tower_upgrades", "upgrade_tower_speed")
		UpdateUnitsStats(greevil_towers)
		local modifier = self:GetCaster():FindModifierByName("modifier_upgrade_tower_speed")
		modifier:IncrementStackCount()
	end
end
function upgrade_tower_speed:GetIntrinsicModifierName()
	return "modifier_upgrade_tower_speed"
end
modifier_upgrade_tower_speed = class({
	IsHidden 				= function(self) return false end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return true end,
	OnCreated				= function(self)
		self:SetStackCount(tGetValue("tower_upgrades", "upgrade_tower_speed"))
	end,
})

greevil_tower_passive = class({})
function greevil_tower_passive:GetIntrinsicModifierName()
	return "modifier_greevil_tower_upgrade"
end

modifier_greevil_tower_upgrade = class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return true end,
	DeclareFunctions		= function(self) return 
		{				
			MODIFIER_PROPERTY_EXTRA_HEALTH_PERCENTAGE,
			MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
			MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,
			MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
			} end,
})
function modifier_greevil_tower_upgrade:OnCreated()
	table.insert(greevil_towers, self:GetParent())
	print("table inserted !")
end
function modifier_greevil_tower_upgrade:OnDestroy()
	local parent = self:GetParent()
	for i=1, #greevil_towers do
		if greevil_towers[i] == parent then
			table.remove(greevil_towers, i)
		end			
	end		
end

function modifier_greevil_tower_upgrade:GetModifierExtraHealthPercentage()
	local upgrade_count = tGetValue ("tower_upgrades", "upgrade_tower_health")
	local upgrade_value = tGetValue ("tower_upgrades", "tower_health_value")
	return  upgrade_count * upgrade_value
end
function modifier_greevil_tower_upgrade:GetModifierPhysicalArmorBonus()
	local upgrade_count = tGetValue ("tower_upgrades", "upgrade_tower_armor")
	local upgrade_value = tGetValue ("tower_upgrades", "tower_armor_value")
	return  upgrade_count * upgrade_value
end
function modifier_greevil_tower_upgrade:GetModifierBaseAttack_BonusDamage()
	local upgrade_count = tGetValue ("tower_upgrades", "upgrade_tower_attack")
	local upgrade_value = tGetValue ("tower_upgrades", "tower_attack_value")
	return  upgrade_count * upgrade_value
end
function modifier_greevil_tower_upgrade:GetModifierAttackSpeedBonus_Constant()
	local upgrade_count = tGetValue ("tower_upgrades", "upgrade_tower_speed")
	local upgrade_value = tGetValue ("tower_upgrades", "tower_speed_value")
	return  upgrade_count * upgrade_value
end

function tIncreaseValue(ttable, unit )
	local current_value = CustomNetTables:GetTableValue(ttable, unit).value
	CustomNetTables:SetTableValue(ttable, unit, { value = current_value + 1})
end

function tGetValue (ttable, unit)
	return CustomNetTables:GetTableValue(ttable, unit).value
end

function UpdateUnitsStats( enum )
	local length = #enum
	print("length = "..length)
	for i=length, 1, -1 do
		local unit = enum[i]		
		if unit:IsNull() then
			print("element null"..i)
			table.remove(enum, i)
		else
			print(unit:GetUnitName())
			unit:AddNewModifier(unit, nil, "modifier_phased", {duration = 0.01})
		end		
	end
end
