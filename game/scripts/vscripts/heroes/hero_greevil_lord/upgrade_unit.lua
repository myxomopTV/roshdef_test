LinkLuaModifier("modifier_upgrade_unit_attack", "heroes/hero_greevil_lord/upgrade_unit", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_upgrade_unit_speed", "heroes/hero_greevil_lord/upgrade_unit", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_upgrade_unit_body", "heroes/hero_greevil_lord/upgrade_unit", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_upgrade_unit_health", "heroes/hero_greevil_lord/upgrade_unit", LUA_MODIFIER_MOTION_NONE)

if IsServer() then
	CustomNetTables:SetTableValue("unit_upgrades", "upgrade_unit_attack", { value = 0})
	CustomNetTables:SetTableValue("unit_upgrades", "unit_attack_value", { value = 0})
	upgrade_unit_attack_check = false

	CustomNetTables:SetTableValue("unit_upgrades", "upgrade_unit_speed", { value = 0})
	CustomNetTables:SetTableValue("unit_upgrades", "unit_attack_speed_value", { value = 0})
	CustomNetTables:SetTableValue("unit_upgrades", "unit_move_speed_value", { value = 0})
	upgrade_unit_speed_check = false

	CustomNetTables:SetTableValue("unit_upgrades", "upgrade_unit_body", { value = 0})
	CustomNetTables:SetTableValue("unit_upgrades", "unit_armor_value", { value = 0})
	CustomNetTables:SetTableValue("unit_upgrades", "weak_unit_health_value", { value = 0})
	CustomNetTables:SetTableValue("unit_upgrades", "medium_unit_health_value", { value = 0})
	CustomNetTables:SetTableValue("unit_upgrades", "strong_unit_health_value", { value = 0})
	upgrade_unit_body_check = false

	CustomNetTables:SetTableValue("unit_upgrades", "upgrade_unit_health", { value = 0})
	CustomNetTables:SetTableValue("unit_upgrades", "unit_health_pct_value", { value = 0})
	upgrade_unit_health_check = false
	

end
greevil_units = {}

upgrade_unit_attack = class({})

function upgrade_unit_attack:OnSpellStart()
	local max_upgrade = self:GetSpecialValueFor("max_upgrade")
	local current_upgrade = tGetValue ("unit_upgrades", "upgrade_unit_attack")
	if current_upgrade >= max_upgrade then
		self:GetCaster():Stop()
		self:SetHidden(true)
	end
end	
function upgrade_unit_attack:GetGoldCost()	
	local gold_cost = self:GetSpecialValueFor("gold_cost") 
	local gold_cost_up = self:GetSpecialValueFor("gold_cost_up") * tGetValue ("unit_upgrades", "upgrade_unit_attack")

	return  gold_cost + gold_cost_up
end

function upgrade_unit_attack:GetChannelTime()
	local upgrade_time = self:GetSpecialValueFor("upgrade_time")
	local upgrade_time_up = self:GetSpecialValueFor("upgrade_time_up") * tGetValue ("unit_upgrades", "upgrade_unit_attack")

	return upgrade_time + upgrade_time_up
end

function upgrade_unit_attack:OnChannelFinish( bInterrupted )	
	local hero = self:GetCaster():GetOwner()
	local gold = self:GetGoldCost(-1)

	if upgrade_unit_attack_check == false then
		upgrade_unit_attack_check = true
		local upgrade_value = self:GetSpecialValueFor("upgrade_value")

		CustomNetTables:SetTableValue("unit_upgrades", "unit_attack_value", { value = upgrade_value})
		print(tGetValue("unit_upgrades", "unit_attack_value"))
	end
	if bInterrupted then
		hero:ModifyGold(gold, false, 0)
	else
		tIncreaseValue("unit_upgrades", "upgrade_unit_attack")
		UpdateUnitsStats(greevil_units)
		local modifier = self:GetCaster():FindModifierByName("modifier_upgrade_unit_attack")
		modifier:IncrementStackCount()
	end
end
function upgrade_unit_attack:GetIntrinsicModifierName()
	return "modifier_upgrade_unit_attack"
end
modifier_upgrade_unit_attack = class({
	IsHidden 				= function(self) return false end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return true end,
	OnCreated				= function(self)
		self:SetStackCount(tGetValue("unit_upgrades", "upgrade_unit_attack"))
	end,
})

upgrade_unit_speed = class({})

function upgrade_unit_speed:OnSpellStart()
	local max_upgrade = self:GetSpecialValueFor("max_upgrade")
	local current_upgrade = tGetValue ("unit_upgrades", "upgrade_unit_speed")
	if current_upgrade >= max_upgrade then
		self:GetCaster():Stop()
		self:SetHidden(true)
	end
end	
function upgrade_unit_speed:GetGoldCost()	
	local gold_cost = self:GetSpecialValueFor("gold_cost") 
	local gold_cost_up = self:GetSpecialValueFor("gold_cost_up") * tGetValue ("unit_upgrades", "upgrade_unit_speed")

	return  gold_cost + gold_cost_up
end

function upgrade_unit_speed:GetChannelTime()
	local upgrade_time = self:GetSpecialValueFor("upgrade_time")
	local upgrade_time_up = self:GetSpecialValueFor("upgrade_time_up") * tGetValue ("unit_upgrades", "upgrade_unit_speed")

	return upgrade_time + upgrade_time_up
end


function upgrade_unit_speed:OnChannelFinish( bInterrupted )	
	local hero = self:GetCaster():GetOwner()
	local gold = self:GetGoldCost(-1)

	if upgrade_unit_speed_check == false then
		upgrade_unit_speed_check = true
		local upgrade_value1 = self:GetSpecialValueFor("upgrade_value1")
		local upgrade_value2 = self:GetSpecialValueFor("upgrade_value2")

		CustomNetTables:SetTableValue("unit_upgrades", "unit_attack_speed_value", { value = upgrade_value1})
		CustomNetTables:SetTableValue("unit_upgrades", "unit_move_speed_value", { value = upgrade_value2})
		print(tGetValue("unit_upgrades", "unit_attack_speed_value"))
		print(tGetValue("unit_upgrades", "unit_move_speed_value"))
	end
	if bInterrupted then
		hero:ModifyGold(gold, false, 0)
	else
		tIncreaseValue("unit_upgrades", "upgrade_unit_speed")
		UpdateUnitsStats(greevil_units)
		local modifier = self:GetCaster():FindModifierByName("modifier_upgrade_unit_speed")
		modifier:IncrementStackCount()
	end
end
function upgrade_unit_speed:GetIntrinsicModifierName()
	return "modifier_upgrade_unit_speed"
end
modifier_upgrade_unit_speed = class({
	IsHidden 				= function(self) return false end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return true end,
	OnCreated				= function(self)
		self:SetStackCount(tGetValue("unit_upgrades", "upgrade_unit_speed"))
	end,
})
upgrade_unit_body = class({})

function upgrade_unit_body:OnSpellStart()
	local max_upgrade = self:GetSpecialValueFor("max_upgrade")
	local current_upgrade = tGetValue ("unit_upgrades", "upgrade_unit_body")
	if current_upgrade >= max_upgrade then
		self:GetCaster():Stop()
		self:SetHidden(true)
	end
end	
function upgrade_unit_body:GetGoldCost()	
	local gold_cost = self:GetSpecialValueFor("gold_cost") 
	local gold_cost_up = self:GetSpecialValueFor("gold_cost_up") * tGetValue ("unit_upgrades", "upgrade_unit_body")

	return  gold_cost + gold_cost_up
end

function upgrade_unit_body:GetChannelTime()
	local upgrade_time = self:GetSpecialValueFor("upgrade_time")
	local upgrade_time_up = self:GetSpecialValueFor("upgrade_time_up") * tGetValue ("unit_upgrades", "upgrade_unit_body")

	return upgrade_time + upgrade_time_up
end


function upgrade_unit_body:OnChannelFinish( bInterrupted )	
	local hero = self:GetCaster():GetOwner()
	local gold = self:GetGoldCost(-1)

	if upgrade_unit_body_check == false then
		upgrade_unit_body_check = true
		local upgrade_value0 = self:GetSpecialValueFor("upgrade_value0")
		local upgrade_value1 = self:GetSpecialValueFor("upgrade_value1")
		local upgrade_value2 = self:GetSpecialValueFor("upgrade_value2")
		local upgrade_value3 = self:GetSpecialValueFor("upgrade_value3")

		CustomNetTables:SetTableValue("unit_upgrades", "unit_armor_value", 			{ value = upgrade_value0})
		CustomNetTables:SetTableValue("unit_upgrades", "weak_unit_health_value", 	{ value = upgrade_value1})
		CustomNetTables:SetTableValue("unit_upgrades", "medium_unit_health_value", 	{ value = upgrade_value2})
		CustomNetTables:SetTableValue("unit_upgrades", "strong_unit_health_value", 	{ value = upgrade_value3})
		print(tGetValue("unit_upgrades", "unit_armor_value"))
		print(tGetValue("unit_upgrades", "weak_unit_health_value"))
		print(tGetValue("unit_upgrades", "medium_unit_health_value"))
		print(tGetValue("unit_upgrades", "strong_unit_health_value"))
	end
	if bInterrupted then
		hero:ModifyGold(gold, false, 0)
	else
		tIncreaseValue("unit_upgrades", "upgrade_unit_body")
		UpdateUnitsStats(greevil_units)
		local modifier = self:GetCaster():FindModifierByName("modifier_upgrade_unit_body")
		modifier:IncrementStackCount()
	end
end
function upgrade_unit_body:GetIntrinsicModifierName()
	return "modifier_upgrade_unit_body"
end
modifier_upgrade_unit_body = class({
	IsHidden 				= function(self) return false end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return true end,
	OnCreated				= function(self)
		self:SetStackCount(tGetValue("unit_upgrades", "upgrade_unit_body"))
	end,
})

upgrade_unit_health = class({})

function upgrade_unit_health:OnSpellStart()
	local max_upgrade = self:GetSpecialValueFor("max_upgrade")
	local current_upgrade = tGetValue ("unit_upgrades", "upgrade_unit_health")
	if current_upgrade >= max_upgrade then
		self:GetCaster():Stop()
		self:SetHidden(true)
	end
end	
function upgrade_unit_health:GetGoldCost()	
	local gold_cost = self:GetSpecialValueFor("gold_cost") 
	local gold_cost_up = self:GetSpecialValueFor("gold_cost_up") * tGetValue ("unit_upgrades", "upgrade_unit_health")

	return  gold_cost + gold_cost_up
end

function upgrade_unit_health:GetChannelTime()
	local upgrade_time = self:GetSpecialValueFor("upgrade_time")
	local upgrade_time_up = self:GetSpecialValueFor("upgrade_time_up") * tGetValue ("unit_upgrades", "upgrade_unit_health")

	return upgrade_time + upgrade_time_up
end

function upgrade_unit_health:OnChannelFinish( bInterrupted )	
	local hero = self:GetCaster():GetOwner()
	local gold = self:GetGoldCost(-1)

	if upgrade_unit_health_check == false then
		upgrade_unit_health_check = true
		local upgrade_value = self:GetSpecialValueFor("upgrade_value")

		CustomNetTables:SetTableValue("unit_upgrades", "unit_health_pct_value", { value = upgrade_value})
		print(tGetValue("unit_upgrades", "unit_health_pct_value"))
	end
	if bInterrupted then
		hero:ModifyGold(gold, false, 0)
	else
		tIncreaseValue("unit_upgrades", "upgrade_unit_health")
		UpdateUnitsStats(greevil_units)
		local modifier = self:GetCaster():FindModifierByName("modifier_upgrade_unit_health")
		modifier:IncrementStackCount()
	end
end
function upgrade_unit_health:GetIntrinsicModifierName()
	return "modifier_upgrade_unit_health"
end
modifier_upgrade_unit_health = class({
	IsHidden 				= function(self) return false end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return true end,
	OnCreated				= function(self)
		self:SetStackCount(tGetValue("unit_upgrades", "upgrade_unit_health"))
	end,
})

modifier_greevil_unit_upgrade = class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return true end,
	DeclareFunctions		= function(self) return 
		{	MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
			MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
			MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,
			MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
			MODIFIER_PROPERTY_EXTRA_HEALTH_BONUS,
			MODIFIER_PROPERTY_EXTRA_HEALTH_PERCENTAGE,
			} end,
})
function modifier_greevil_unit_upgrade:OnCreated()
	table.insert(greevil_units, self:GetParent())
end
function modifier_greevil_unit_upgrade:OnDestroy()
	local parent = self:GetParent()
	for i=1, #greevil_units do
		if greevil_units[i] == parent then
			table.remove(greevil_units, i)
		end			
	end		
end

function modifier_greevil_unit_upgrade:GetModifierAttackSpeedBonus_Constant()
	local upgrade_count = tGetValue ("unit_upgrades", "upgrade_unit_speed")
	local upgrade_value = tGetValue ("unit_upgrades", "unit_attack_speed_value")
	return  upgrade_count * upgrade_value
end
function modifier_greevil_unit_upgrade:GetModifierMoveSpeedBonus_Constant()
	local upgrade_count = tGetValue ("unit_upgrades", "upgrade_unit_speed")
	local upgrade_value = tGetValue ("unit_upgrades", "unit_move_speed_value")
	return  upgrade_count * upgrade_value
end
function modifier_greevil_unit_upgrade:GetModifierBaseAttack_BonusDamage()
	local upgrade_count = tGetValue ("unit_upgrades", "upgrade_unit_attack")
	local upgrade_value = tGetValue ("unit_upgrades", "unit_attack_value")
	return  upgrade_count * upgrade_value
end
function modifier_greevil_unit_upgrade:GetModifierPhysicalArmorBonus()
	local upgrade_count = tGetValue ("unit_upgrades", "upgrade_unit_body")
	local upgrade_value = tGetValue ("unit_upgrades", "unit_armor_value")
	return  upgrade_count * upgrade_value
end
function modifier_greevil_unit_upgrade:GetModifierExtraHealthBonus()
	local name = self:GetParent():GetUnitName()
	local upgrade_count = tGetValue ("unit_upgrades", "upgrade_unit_body")
	local upgrade_value
	if name == "npc_dota_greevil_lord_unit_strong" then
		upgrade_value = tGetValue ("unit_upgrades", "strong_unit_health_value")
	elseif name == "npc_dota_greevil_lord_unit_medium" then
		upgrade_value = tGetValue ("unit_upgrades", "medium_unit_health_value")
	elseif name == "npc_dota_greevil_lord_greevil_weak" then
		upgrade_value = tGetValue ("unit_upgrades", "weak_unit_health_value")
	else
		upgrade_value = tGetValue ("unit_upgrades", "weak_unit_health_value")
	end
	return upgrade_count * upgrade_value
end
function modifier_greevil_unit_upgrade:GetModifierExtraHealthPercentage()
	local upgrade_count = tGetValue ("unit_upgrades", "upgrade_unit_health")
	local upgrade_value = tGetValue ("unit_upgrades", "unit_health_pct_value")
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
	for i=1, #enum do
		local unit = enum[i]
		unit:AddNewModifier(unit, nil, "modifier_phased", {duration = 0.01})
	end
end
