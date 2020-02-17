LinkLuaModifier("modifier_monkey_king_wukongs_command_custom_effect", "heroes/hero_monkey_king/wukongs_command_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_monkey_king_wukongs_command_custom", "heroes/hero_monkey_king/wukongs_command_custom", LUA_MODIFIER_MOTION_NONE)

monkey_king_wukongs_command_custom = class({})

function monkey_king_wukongs_command_custom:OnAbilityPhaseStart()
	EmitSoundOn("Hero_MonkeyKing.FurArmy.Channel", self:GetCaster())
    return true
end

function monkey_king_wukongs_command_custom:OnAbilityPhaseInterrupted()
	StopSoundOn("Hero_MonkeyKing.FurArmy.Channel", self:GetCaster())
end

function monkey_king_wukongs_command_custom:OnSpellStart()

    local caster = self:GetCaster()
    local ability = self
 	local unit_name = "npc_dota_monkey_king_warrior"
	local hero_damage = caster:GetAverageTrueAttackDamage(caster)

	local spawn_duration = ability:GetSpecialValueFor("spawn_duration")
	local unit_count = ability:GetSpecialValueFor("unit_count")
	caster:AddNewModifier(caster, ability, "modifier_monkey_king_wukongs_command_custom", {duration = spawn_duration})

	EmitSoundOn("Hero_MonkeyKing.FurArmy", caster)
	for i=1,unit_count do
--		Timers:CreateTimer(0.25*i, function ()
			local point = caster:GetAbsOrigin() + RandomVector(ability:GetSpecialValueFor("spawn_radius"))
			local unit = CreateUnitByName(unit_name, point, true, caster, caster, caster:GetTeamNumber())			
			unit:SetBaseDamageMin(hero_damage)
			unit:SetBaseDamageMax(hero_damage)
			unit:AddNewModifier(caster,ability,"modifier_monkey_king_wukongs_command_custom_effect", nil)
			unit:AddNewModifier(caster,ability,"modifier_phased",{duration = 0.1})
			unit:AddNewModifier(caster,ability,"modifier_kill",{duration = spawn_duration})
--		end)
	end
end

------------------------------------------------------------
------------------------------------------------------------
modifier_monkey_king_wukongs_command_custom = class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return true end,
 
})

function modifier_monkey_king_wukongs_command_custom:OnDestroy()
	local caster = self:GetCaster()
	StopSoundOn("Hero_MonkeyKing.FurArmy",caster)	

end

modifier_monkey_king_wukongs_command_custom_effect = class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return true end,
 
})

function modifier_monkey_king_wukongs_command_custom_effect:StatusEffectPriority()
	return 100
end

function modifier_monkey_king_wukongs_command_custom_effect:GetStatusEffectName()
	return "particles/status_fx/status_effect_monkey_king_fur_army.vpcf"
end
