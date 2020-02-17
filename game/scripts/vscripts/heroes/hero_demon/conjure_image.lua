LinkLuaModifier("modifier_demon_conjure_image", "heroes/hero_demon/conjure_image", LUA_MODIFIER_MOTION_NONE)

demon_conjure_image = class({})

function demon_conjure_image:OnSpellStart()
	local caster = self:GetCaster()
	local ability = self

	EmitSoundOn("Hero_Terrorblade.ConjureImage", caster)			

	local caster = self:GetCaster()
	local soul_modifier_count = caster:FindModifierByName("modifier_demon_soul_collector"):GetStackCount()
	local soul_duration = ability:GetSpecialValueFor("duration_per_soul") * soul_modifier_count
	local spawn_duration = ability:GetSpecialValueFor("duration") + soul_duration 
	local base_hp = caster:GetMaxHealth() * ability:GetSpecialValueFor("base_hp_pct") /100 
	local base_armor = ability:GetSpecialValueFor("base_armor") 
	local base_dmg = caster:GetAverageTrueAttackDamage(caster) * ability:GetSpecialValueFor("base_dmg_pct") /100
	
	local player = caster:GetPlayerID()
	local fv = caster:GetForwardVector()
	local point = caster:GetAbsOrigin()
	local team = caster:GetTeam()

	local unit = CreateUnitByName( "npc_dota_demon_conjure_image", point, true, caster, caster, team )
	local power_strike_ability_level = caster:FindAbilityByName("demon_power_strike"):GetLevel()
	unit:FindAbilityByName("demon_power_strike"):SetLevel(power_strike_ability_level)

	unit:AddNewModifier( unit, ability, "modifier_phased", {duration = 0.1} )
	unit:AddNewModifier( unit, ability, "modifier_demon_conjure_image", nil )
	unit:AddNewModifier( unit, ability, "modifier_kill", {duration = spawn_duration} )
	local collector_modifier = unit:AddNewModifier( unit, ability, "modifier_demon_soul_collector", nil )
	collector_modifier:SetStackCount(soul_modifier_count)


	unit:SetControllableByPlayer(player, false)
	unit:SetOwner(caster)
	unit:SetForwardVector(fv)
	
	unit:SetBaseDamageMin( base_dmg)
	unit:SetBaseDamageMax( base_dmg)				
	unit:SetPhysicalArmorBaseValue( base_armor  )
	unit:SetBaseMaxHealth( base_hp  )
	unit:SetMaxHealth( base_hp )
	unit:SetHealth( base_hp  )

	local effect = "particles/units/heroes/hero_terrorblade/terrorblade_mirror_image.vpcf"
	local pfx = ParticleManager:CreateParticle(effect, PATTACH_ABSORIGIN_FOLLOW, unit)
	ParticleManager:SetParticleControl(pfx, 0, caster:GetAbsOrigin()) -- Origin
	Timers:CreateTimer(1,function()
		ParticleManager:DestroyParticle(pfx, true)
		ParticleManager:ReleaseParticleIndex(pfx)
	end)

end

--------------------------------------------------------
------------------------------------------------------------
modifier_demon_conjure_image = class({
	IsHidden 				= function(self) return false end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
})

function modifier_demon_conjure_image:StatusEffectPriority()
	return 100
end

function modifier_demon_conjure_image:GetStatusEffectName()
	return "particles/status_fx/status_effect_terrorblade_reflection.vpcf"
end


