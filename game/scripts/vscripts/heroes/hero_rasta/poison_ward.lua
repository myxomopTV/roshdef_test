LinkLuaModifier("modifier_rasta_poison_ward", "heroes/hero_rasta/poison_ward", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_rasta_poison_ward_debuff", "heroes/hero_rasta/poison_ward", LUA_MODIFIER_MOTION_NONE)

rasta_poison_ward = class({})


function rasta_poison_ward:OnSpellStart( )
	local caster = self:GetCaster()
	local ability = self

	local ward_duration = self:GetSpecialValueFor("ward_duration")
	local ward_count = self:GetSpecialValueFor("ward_count")
	local ward_damage = self:GetSpecialValueFor("ward_damage")
	local ward_health = self:GetSpecialValueFor("ward_health")
	local int_dmg = self:GetSpecialValueFor("int_dmg")*caster:GetIntellect()/100
	local point = self:GetCursorPosition()
	local fv = caster:GetForwardVector()
	local team = caster:GetTeam()
	local player = caster:GetPlayerID()

	for i=1, ward_count do
		local unit = CreateUnitByName( "npc_dota_rasta_poison_ward", point, true, caster, caster, team )

		unit:SetControllableByPlayer(player, false)
		unit:SetOwner(caster)
		unit:SetForwardVector(fv)	
		unit:SetBaseDamageMin(ward_damage + int_dmg)
		unit:SetBaseDamageMax(ward_damage + int_dmg)
		
		unit:SetBaseMaxHealth(ward_health)
		unit:SetMaxHealth(ward_health)
		unit:SetHealth(ward_health)				
	--	unit:SetBaseAttackTime(bat)
		unit:AddNewModifier(caster, ability, "modifier_rasta_poison_ward", nil)
		unit:AddNewModifier(caster, ability, "modifier_kill", {duration = ward_duration})
	end
	--	unit:SetHealth(unit:GetMaxHealth())
--	unit:SetHealth(unit:GetMaxHealth())
end

modifier_rasta_poison_ward = class({
	IsHidden = function(self) return true end,
	CheckState = function(self) return {
--		[MODIFIER_STATE_INVULNERABLE] = true,
--		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
--		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
--		[MODIFIER_STATE_DISARMED] = true,
	}end,
	DeclareFunctions = function(self) return {
		MODIFIER_EVENT_ON_ATTACK_LANDED
	}end,
})

function modifier_rasta_poison_ward:OnAttackLanded(data)
	local attacker = data.attacker
	local target = data.target
	local parent = self:GetParent()

	if attacker == parent and target then
		local ability = self:GetAbility()
		local debuff_duration = ability:GetSpecialValueFor("debuff_duration")

		target:AddNewModifier(parent, ability, "modifier_rasta_poison_ward_debuff", {duration = debuff_duration})
	end
end

modifier_rasta_poison_ward_debuff = class({
	DeclareFunctions = function(self) return {
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
	}end,
})

function modifier_rasta_poison_ward_debuff:GetModifierPhysicalArmorBonus()
	return self:GetAbility():GetSpecialValueFor("debuff_armor")*(-1)
end

function modifier_rasta_poison_ward_debuff:GetEffectName()
	return "particles/units/heroes/hero_venomancer/venomancer_gale_poison_debuff.vpcf"
end