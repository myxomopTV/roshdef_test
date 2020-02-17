LinkLuaModifier("modifier_greevil_lord_craft_master", "heroes/hero_greevil_lord/craft_master", LUA_MODIFIER_MOTION_NONE)
greevil_workers ={}

greevil_lord_craft_master = class({})

function greevil_lord_craft_master:GetIntrinsicModifierName()
	return "modifier_greevil_lord_craft_master"
end
function greevil_lord_craft_master:OnUpgrade()
	for i=#greevil_workers, 1, -1 do
		local unit = greevil_workers[i]
		if IsValidEntity(unit) then
			UpdateCraft(unit, self)
		else
			table.remove(greevil_workers,i)
		end
	end
end

modifier_greevil_lord_craft_master = class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	DeclareFunctions		= function(self) return 
		{MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE} end,
})
function modifier_greevil_lord_craft_master:GetModifierPercentageCooldown()
	return self:GetAbility():GetSpecialValueFor("cd_reduce")
end


function CreateWorker(event)
	local caster = event.caster
	local point = caster:GetAbsOrigin()
	local player = caster:GetPlayerOwnerID()
	local hero = PlayerResource:GetSelectedHeroEntity(player)
	local ability = event.ability
	local craft_ability = caster:FindAbilityByName("greevil_lord_craft_master")

	local unit_name = "npc_dota_greevil_worker"

	local unit = CreateUnitByName(unit_name, point, true, caster, caster, caster:GetTeamNumber())
	unit:AddNewModifier(caster, ability, "modifier_phased", {duration = 0.1})
	unit:SetControllableByPlayer(player, true)
	unit:SetOwner(hero)

	table.insert(greevil_workers, unit)
	UpdateCraft(unit, craft_ability)
	EmitSoundOn("opyat_rabota",caster)
end

function UpdateCraft(unit, craft_ability)
	local craft_lvl = craft_ability:GetLevel()
	
	for i=0,9 do
		local ability = unit:GetAbilityByIndex(i)
		if ability then
			local required_lvl = ability:GetLevelSpecialValueFor("required_lvl", 1)
			print("required_lvl = "..required_lvl)
			if craft_lvl >= required_lvl then
				ability:SetLevel(1)
			else
				ability:SetLevel(0)
			end	
		end
	end
end