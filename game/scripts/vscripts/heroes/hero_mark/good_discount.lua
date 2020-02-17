mark_good_discount = class({})

function mark_good_discount:OnSpellStart()
	local caster = self:GetCaster()
	if caster:HasModifier("tome_strenght_modifier") == false then
		caster:AddNewModifier(caster,ability,"tome_strenght_modifier",nil)
		caster:SetModifierStackCount("tome_strenght_modifier", caster, 10)
	else
		caster:SetModifierStackCount("tome_strenght_modifier", caster, (caster:GetModifierStackCount("tome_strenght_modifier", caster) + 10))
	end
	 if caster:HasModifier("tome_agility_modifier") == false then
		caster:AddNewModifier(caster,ability,"tome_agility_modifier",nil)
		caster:SetModifierStackCount("tome_agility_modifier", caster, 10)
	else
		caster:SetModifierStackCount("tome_agility_modifier", caster, (caster:GetModifierStackCount("tome_agility_modifier", caster) + 10))
	end
   if caster:HasModifier("tome_intelect_modifier") == false then
		caster:AddNewModifier(caster,ability,"tome_intelect_modifier",nil)
		caster:SetModifierStackCount("tome_intelect_modifier", caster, 10)
	else
		caster:SetModifierStackCount("tome_intelect_modifier", caster, (caster:GetModifierStackCount("tome_intelect_modifier", caster) + 10))
	end
	
	if caster:HasScepter() and RollPercentage(2) then
		local killed_unit = caster
		local summon_duration = 90 	

		local suffix = RandomInt(1,52)
		if suffix < 10 then suffix = "0"..suffix end
		EmitGlobalSound("announcer_dlc_gaben_killing_spree/gaben_ann_kill_followup_"..suffix)			

		local player = caster:GetPlayerID()
		local fv = caster:GetForwardVector()
		local point = caster:GetAbsOrigin()
		local team = caster:GetTeam()

		local unit = CreateUnitByName( "Spectre_boss", point, true, caster, caster, team )
		unit:RemoveAbility("boss_respawn")
		unit:AddNewModifier( unit, ability, "modifier_phased", {duration = 0.1} )
		unit:AddNewModifier( unit, ability, "modifier_kill", {duration = summon_duration} )

		unit:SetControllableByPlayer(player, false)
		unit:SetOwner(caster)
		unit:SetForwardVector(fv)				
	end
end
