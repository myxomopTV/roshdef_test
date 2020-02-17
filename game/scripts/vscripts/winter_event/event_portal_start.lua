LinkLuaModifier("modifier_event_portal_start", "winter_event/event_portal_start", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_event_portal_start_hidden", "winter_event/event_portal_start", LUA_MODIFIER_MOTION_NONE)

event_portal_start = class({})

function event_portal_start:GetIntrinsicModifierName()
	return "modifier_event_portal_start"
end
--------------------------------------------------------
------------------------------------------------------------ sa

modifier_event_portal_start = class({
	IsHidden 				= function(self) return false end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return true end,
})

function modifier_event_portal_start:OnCreated()
	if IsServer() then
		local ability = self:GetAbility()

		local parent = self:GetParent()
		parent.event = true
		local point = parent:GetAbsOrigin()
--[[		local effect = "particles/econ/events/nexon_hero_compendium_2014/teleport_end_nexon_hero_cp_2014.vpcf"
--		local effect = "particles/econ/events/fall_major_2016/teleport_end_fm06_lvl2.vpcf"
		local pfx = ParticleManager:CreateParticle(effect, PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(pfx, 0, point)
		ParticleManager:SetParticleControl(pfx, 1, point)
		ParticleManager:SetParticleControl(pfx, 4, Vector(1,0,0))
		ParticleManager:SetParticleControl(pfx, 5, point)]]
--		ParticleManager:SetParticleControlEnt(pfx, 3, parent, PATTACH_CUSTOMORIGIN, "attach_hitloc", point, true)
--		self:AddParticle(pfx, true, false, 111, false, false)

		self:StartIntervalThink(0.1)		
	end
end

function modifier_event_portal_start:OnIntervalThink()
	local parent = self:GetParent()
	
	local heroes = FindUnitsInRadius(parent:GetTeamNumber(), 
									parent:GetAbsOrigin(),
									nil,
									100,
									DOTA_UNIT_TARGET_TEAM_BOTH,
									DOTA_UNIT_TARGET_HERO, 
									DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NO_INVIS,
									FIND_CLOSEST, 
									false)
	for i = 1, #heroes do
		local hero = heroes[1]

		if FrostEvent.available == false or not hero:IsRealHero() then
			return
		end

		if hero.event_valid == nil then 
			hero.event_valid = true
		end


		if hero.event_valid == true then 
			hero.event_valid = false
			local unit_name = ""
			local team = hero:GetTeam()
			local event_lvl = FrostEvent.event_level 
			if event_lvl == 1 then
				unit_name = "npc_dota_event_techies"
				if FrostEvent.event_init == false then
					FrostEvent.event_init = true
					FrostEvent:StartEvent_1()
				end
			elseif event_lvl == 2 then
				unit_name = "npc_dota_event_survior"
				if FrostEvent.event_init == false then
					FrostEvent.event_init = true
					FrostEvent:StartEvent_2()
				end
			elseif event_lvl == 3 then
				unit_name = "npc_dota_event_tuskar"
				if FrostEvent.event_init == false then
					FrostEvent.event_init = true
					FrostEvent:StartEvent_3()
				end
--[[				GiveGoldPlayers(2500)
				EmitGlobalSound("event_gift")
				FrostEvent.event_level = FrostEvent.event_level + 1
				FrostEvent.event_init   = false
				hero.event_valid = true
				return]]
			elseif event_lvl == 4 then
				unit_name = "npc_dota_event_penguin"
				if FrostEvent.event_init == false then
					FrostEvent.event_init = true
--					FrostEvent:StartEvent_2()
				end
			elseif event_lvl == 5 then
				unit_name = "npc_dota_event_penguin"
				if FrostEvent.event_init == false then
					FrostEvent.event_init = true
					FrostEvent:StartEvent_5()
				end
			else
				return
			end
			hero:AddNewModifier(hero, nil, "modifier_event_portal_start_hidden", nil)
			FrostEvent.players_ingame = FrostEvent.players_ingame + 1

			local points = Entities:FindAllByName("event_start_point_"..event_lvl)
			local point = points[RandomInt(1, #points)]:GetAbsOrigin()
			local event_avatar = CreateUnitByName(unit_name, point, true, hero, hero, team)
			local player = hero:GetPlayerID()
			event_avatar.avatar = true
			event_avatar.hero = hero
			event_avatar.player = hero:GetPlayerID()
			event_avatar:SetControllableByPlayer(event_avatar.player, true)
			PlayerResource:SetCameraTarget(event_avatar.player, event_avatar)
			PlayerResource:SetOverrideSelectionEntity(event_avatar.player, event_avatar)
--			table.insert(FrostEvent.event_avatars, event_avatar)
			FrostEvent.event_avatars[event_avatar:entindex()] = event_avatar
			if event_lvl == 5 then
				event_avatar:AddAbility("event_avatar_change"):SetLevel(1)
			end 
		end	
	end
end
function modifier_event_portal_start:GetEffectName()
	return "particles/econ/courier/courier_trail_winter_2012/courier_trail_winter_2012.vpcf"
end

modifier_event_portal_start_hidden = class({
	CheckState = function(self) return {
		[MODIFIER_STATE_STUNNED] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_NOT_ON_MINIMAP] = true,
		[MODIFIER_STATE_DISARMED] = true,
		[MODIFIER_STATE_BLIND] = true,
		[MODIFIER_STATE_OUT_OF_GAME] = true,
	}end,
	IsPurgable = function(self) return false end,
})