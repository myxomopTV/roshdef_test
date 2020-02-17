LinkLuaModifier("modifier_zombie_king_flesh_golem_stacks", "heroes/hero_zombie_king/flesh_golem.lua", LUA_MODIFIER_MOTION_NONE)

function SpawnFleshGolem( keys )
	local caster = keys.caster
	local ability = keys.ability
	local params = ability:GetSpecialValueFor("params")/100

	local total_count = 0
	local total_hp = 100
	local base_dmg_min = 5
	local base_dmg_max = 10
	
	local allCreatures = Entities:FindAllByClassname('npc_dota_creature')
	for i = 1, #allCreatures do
		local creature = allCreatures[i]
		local team = creature:GetTeam()
		local name= creature:GetUnitName()
		
		
		if team == caster:GetTeam() and name == "npc_dota_zombie_king_spawn" then
			total_count = total_count + 1
			total_hp = total_hp + creature:GetMaxHealth()
			base_dmg_min = base_dmg_min + creature:GetBaseDamageMin()
			base_dmg_max = base_dmg_max + creature:GetBaseDamageMax()
			creature:ForceKill(false)
		end
	end
	print(total_count)
	print(total_hp)
	print(base_dmg_min)
	print(base_dmg_max)

	local player = caster:GetPlayerID()
	local team = caster:GetTeam()
	local point = caster:GetAbsOrigin()
	local fv = caster:GetForwardVector()
	
	local unit = CreateUnitByName( "npc_dota_zombie_king_butcher", point, true, caster, caster, team )
	
	unit:AddNewModifier( unit, ability, "modifier_phased", {} )

	unit:SetControllableByPlayer(player, false)
	unit:SetOwner(caster)
	unit:SetForwardVector(fv)
	
	unit:SetBaseDamageMin( base_dmg_min  * params )
	unit:SetBaseDamageMax( base_dmg_max  * params )				
--	unit:SetPhysicalArmorBaseValue( total_count * params )
	unit:SetBaseMaxHealth( total_hp * params )
	unit:SetMaxHealth( total_hp * params )
	unit:SetHealth( total_hp * params )
	
	local modifier = unit:AddNewModifier( caster, ability, "modifier_zombie_king_flesh_golem_stacks" , {} )

	modifier:SetStackCount(total_count)
	
end

-------------------------------------------
-------------------------------------------

modifier_zombie_king_flesh_golem_stacks = class({
	IsHidden 				= function(self) return false end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return true end,
	DeclareFunctions		= function(self) return 
		{   MODIFIER_PROPERTY_MODEL_SCALE
			} end,
})

function modifier_zombie_king_flesh_golem_stacks:GetModifierModelScale()
	local stack_count = self:GetStackCount()
	if stack_count > 200 then
		stack_count = 200
	end
	return self:GetAbility():GetSpecialValueFor("model_scale_stack")*stack_count
end

