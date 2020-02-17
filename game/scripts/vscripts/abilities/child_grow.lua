function ChildCreated(params)
	local caster = params.caster
	local ability = params.ability
	caster:AddNewModifier( caster, nil, "modifier_kill", { duration = 10 } )
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_child_grow_aura", { duration = 10})
	
end

function ChildControl(params)
	local caster = params.caster
	local target = params.target
	local player = target:GetPlayerOwnerID()
	local caster_name = caster:GetUnitName()
	local target_name = target:GetUnitName()
	local name1 = ""
	local name2 = ""
	
	if 			caster_name == "npc_dota_troll_child" then name1 = "npc_dota_hero_troll_warlord" name2 = "npc_dota_hero_huskar"
	elseif 		caster_name == "npc_dota_ogre_child" then name1 = "npc_dota_hero_ogre_magi"
	elseif 		caster_name == "npc_dota_dragon_child" then name1 = "npc_dota_hero_winter_wyvern" name2 = "npc_dota_hero_jakiro"
	elseif 		caster_name == "npc_dota_kobold_child" then name1 = "npc_dota_hero_meepo"
	elseif 		caster_name == "npc_dota_wolf_child" then name1 = "npc_dota_hero_lycan"
	elseif 		caster_name == "npc_dota_centaur_child" then name1 = "npc_dota_hero_centaur" name2 = "npc_dota_hero_leshrac" 
	elseif 		caster_name == "npc_dota_golem_child" then name1 = "npc_dota_hero_tiny"
	elseif 		caster_name == "npc_dota_ursa_child" then name1 = "npc_dota_hero_ursa" name2 = "npc_dota_hero_lone_druid"
	elseif 		caster_name == "npc_dota_satyr_child" then name1 = "npc_dota_hero_riki"
	elseif 		caster_name == "npc_dota_lizard_child" then name1 = "npc_dota_hero_disruptor"
	end
	
	if target_name == name1 or target_name == name2 then
		caster:SetOwner(target)
		caster:SetControllableByPlayer(player, true)
		caster:RemoveModifierByName("modifier_child_grow_aura")
		caster:AddNewModifier( caster, nil, "modifier_kill", { duration = 900 } )
	end
end
