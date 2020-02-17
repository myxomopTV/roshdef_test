
event_avatar_change = class({})

function event_avatar_change:OnSpellStart()
		local caster = self:GetCaster()
		local unit_name = ""
		local team = caster:GetTeam()
		local event_lvl = FrostEvent.event_level 
		local caster_name = caster:GetUnitName()
		local caster_fw = caster:GetForwardVector()

		if caster_name == "npc_dota_event_techies" then
			unit_name = "npc_dota_event_tuskar"

		elseif caster_name == "npc_dota_event_survior" then
			unit_name = "npc_dota_event_tuskar"

		elseif caster_name == "npc_dota_event_tuskar" then
			unit_name = "npc_dota_event_penguin"

		elseif caster_name == "npc_dota_event_penguin" then
			unit_name = "npc_dota_event_techies"
		else
			return
		end

		local point = caster:GetAbsOrigin()
		local event_avatar = CreateUnitByName(unit_name, point, false, caster, caster, team)
		event_avatar:AddAbility("event_avatar_change"):SetLevel(1)
		event_avatar:SetForwardVector(caster_fw)
		event_avatar.avatar = true
		event_avatar.hero = caster.hero
		event_avatar.player = caster.player
		event_avatar:SetControllableByPlayer(event_avatar.player, true)
		PlayerResource:SetCameraTarget(event_avatar.player, event_avatar)
		PlayerResource:SetOverrideSelectionEntity(event_avatar.player, event_avatar)
		FrostEvent.event_avatars[event_avatar:entindex()] = event_avatar

		local old_avatar = FrostEvent.event_avatars[caster:entindex()]
		FrostEvent.event_avatars[caster:entindex()] = nil
		old_avatar.avatar = false
		old_avatar:AddNoDraw()
		old_avatar:ForceKill(false)
end
