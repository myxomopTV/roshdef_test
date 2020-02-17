greevil_naked_spell_echo = class({})

LinkLuaModifier("modifier_greevil_naked_spell_echo", "abilities/greevil_naked_spell_echo", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_greevil_naked_spell_echo_aura", "abilities/greevil_naked_spell_echo", LUA_MODIFIER_MOTION_NONE)

function greevil_naked_spell_echo:GetAbilityTextureName()
	return "greevil_naked_spell_echo"
end
function greevil_naked_spell_echo:GetIntrinsicModifierName()
	return "modifier_greevil_naked_spell_echo"
end

modifier_greevil_naked_spell_echo = class({
	IsPurgable = function() return false end,
	IsAura = function() return true end,
	GetModifierAura = function() return "modifier_greevil_naked_spell_echo_aura" end,
	GetAuraSearchTeam = function() return DOTA_UNIT_TARGET_TEAM_ENEMY end,
	GetAuraSearchType = function() return DOTA_UNIT_TARGET_HERO end,
	GetAuraSearchFlags = function() return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES end,
})
function modifier_greevil_naked_spell_echo:GetAuraRadius()
	return self:GetAbility():GetSpecialValueFor("radius")
end

modifier_greevil_naked_spell_echo_aura = class({
	IsPurgable = function() return false end,
	IsHidden = function() return true end,
	GetAttributes = function() return MODIFIER_ATTRIBUTE_MULTIPLE end,
})

function modifier_greevil_naked_spell_echo_aura:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ABILITY_EXECUTED
	}
end

function modifier_greevil_naked_spell_echo_aura:OnAbilityExecuted(event)
	if event.unit == self:GetParent() then
		local cast_ability = event.ability
		local target = event.unit
		local unit = self:GetCaster()
		if not target:IsHero() or cast_ability:GetAbilityType() == 1 or cast_ability:IsChanneling() then
			return
		end
		local forbidden_abilities = {
			"ancient_apparition_ice_blast",
			"clinkz_wind_walk",
			"doom_bringer_magic_find",
			"furion_teleportation",
			"furion_wrath_of_nature",
			"life_stealer_infest",
			"life_stealer_assimilate",
			"life_stealer_assimilate_eject",
			"storm_spirit_static_remnant",
			"shadow_demon_disruption",
			"shadow_demon_shadow_poison",
			"shadow_demon_demonic_purge",
			"phantom_lancer_doppelwalk",
			"chaos_knight_phantasm",
			"wisp_relocate",
			"templar_assassin_meld",
			"templar_assassin_psionic_trap",
			"naga_siren_mirror_image",
			"ember_spirit_activate_fire_remnant",
			"legion_commander_duel",
			"phoenix_fire_spirits",
			"terrorblade_conjure_image",
			"beastmaster_call_of_the_wild",
			"beastmaster_call_of_the_wild_boar",
			"lone_druid_spirit_bear",
			"earth_spirit_rolling_boulder",
			"earth_spirit_stone_caller",
			"dark_seer_ion_shell",
			"bounty_hunter_wind_walk",
			"mirana_invis",
			"morphling_replicate",
			"morphling_morph_replicate",
			"morphling_hybrid",
			"leshrac_pulse_nova",
			"spirit_breaker_charge_of_darkness",
			"shredder_chakram",
			"shredder_chakram_2",
			"spectre_haunt",
			"viper_poison_attack",
			"arc_warden_tempest_double",
			"sandking_sand_storm",
			"broodmother_spin_web",
			"weaver_shukuchi",
			"weaver_time_lapse",
			"treant_eyes_in_the_forest",
			"treant_living_armor",
			"enchantress_impetus",
			"chen_holy_persuasion",
			"undying_decay",
			"undying_tombstone",
			"tusk_walrus_kick",
			"tusk_walrus_punch",
			"elder_titan_echo_stomp_spirit",
			"visage_soul_assumption",
			"earth_spirit_geomagnetic_grip",
			"keeper_of_the_light_recall",
			"monkey_king_mischief",
			"monkey_king_tree_dance",
			"monkey_king_primal_spring",
			"monkey_king_wukongs_command",
			"zuus_cloud",
			"pangolier_swashbuckle",
			"dark_willow_shadow_realm",
			"item_invis_sword",
			"item_glimmer_cape",
			"item_silver_edge",
			"item_shadow_amulet",
			"item_hand_of_midas",
		}
		for _,forbidden_ability in pairs(forbidden_abilities) do
			if cast_ability:GetAbilityName() == forbidden_ability then
				return
			end
		end
		if string.find(cast_ability:GetAbilityName(), "invoker") or string.find(cast_ability:GetAbilityName(), "rune") then
			return
		end
		local skill = unit:FindAbilityByName(cast_ability:GetAbilityName())
		if skill == nil then
			skill = unit:AddAbility(cast_ability:GetAbilityName())
		end
		if skill ~= nil then
			skill:SetStolen(true)
			skill:SetHidden(true)
			skill:SetLevel(cast_ability:GetLevel())
			if cast_ability:HasBehavior(DOTA_ABILITY_BEHAVIOR_UNIT_TARGET) then
				if cast_ability:HasTargetTeam(DOTA_UNIT_TARGET_TEAM_ENEMY) then
					if target and type(target) == "table" then
						unit:SetCursorCastTarget(target)
					end
				elseif cast_ability:HasTargetTeam(DOTA_UNIT_TARGET_TEAM_FRIENDLY) then
					unit:SetCursorCastTarget(unit)
				elseif cast_ability:HasTargetTeam(DOTA_UNIT_TARGET_TEAM_BOTH) then
					if RollPercentage(50) then
						if target and type(target) == "table" then
							unit:SetCursorCastTarget(target)
						end
					else
						unit:SetCursorCastTarget(unit)
					end
				else
					if target and type(target) == "table" then
						unit:SetCursorCastTarget(target)
					end
				end
			elseif cast_ability:HasBehavior(DOTA_ABILITY_BEHAVIOR_POINT) then
				if target then
					unit:SetCursorPosition(target:GetOrigin())
				end
			end
			skill:OnSpellStart()

			unit:StartGesture(ACT_DOTA_CAST_ABILITY_1)

			EmitSoundOn("Greevil.SpellEcho.Reflect", unit)

			local reflectPFX = ParticleManager:CreateParticle("particles/greevils/greevil_naked/greevil_naked_reflect.vpcf", PATTACH_POINT_FOLLOW, unit)
			ParticleManager:SetParticleControlEnt(reflectPFX, 0, unit, PATTACH_POINT_FOLLOW, "attach_hitloc", unit:GetOrigin(), true)
			ParticleManager:ReleaseParticleIndex(reflectPFX)
		end
	end
end