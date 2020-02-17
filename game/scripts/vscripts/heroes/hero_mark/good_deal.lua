mark_good_deal = class({})

function mark_good_deal:OnSpellStart()
	if IsServer() then
		local caster = self:GetCaster()
		local killed_unit = caster
		local summon_duration = self:GetSpecialValueFor("summon_duration") 	

		EmitGlobalSound("announcer_dlc_gaben_killing_spree_gaben_ann_kill_double_03")			

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


