LinkLuaModifier("modifier_broodmother_spawn_spiderling", "heroes/hero_broodmother/spawn_spiderling", LUA_MODIFIER_MOTION_NONE)


broodmother_spawn_spiderling = class({})

function broodmother_spawn_spiderling:GetIntrinsicModifierName()
	return "modifier_broodmother_spawn_spiderling"
end


modifier_broodmother_spawn_spiderling = class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	DeclareFunctions		= function(self) return 
		{   MODIFIER_EVENT_ON_DEATH} end,
})

function modifier_broodmother_spawn_spiderling:OnDeath(data)
	if IsServer() then
		local parent = self:GetParent()
		local killer = data.attacker
		local killed_unit = data.unit
 
		if killer == parent and killed_unit:GetTeam() ~= killer:GetTeam() then
			if killer:IsRealHero() == false then
				killer = killer:GetPlayerOwner():GetAssignedHero()
			end
			local stack_count = 0
			if killer:HasModifier("modifier_broodmother_upgrade_spiderling") then
				stack_count = killer:FindModifierByName("modifier_broodmother_upgrade_spiderling"):GetStackCount()
			end

			EmitSoundOn("Hero_Broodmother.SpawnSpiderlingsImpact", killed_unit)			
			local effect = "particles/units/heroes/hero_broodmother/broodmother_spiderlings_spawn.vpcf"
			local pfx = ParticleManager:CreateParticle(effect, PATTACH_CUSTOMORIGIN, nil)
			ParticleManager:SetParticleControl(pfx, 0, killed_unit:GetAbsOrigin()) -- Origin
			ParticleManager:ReleaseParticleIndex(pfx)

			local ability = self:GetAbility()
			local spawn_duration = ability:GetSpecialValueFor("spawn_duration") 
			local base_hp = ability:GetSpecialValueFor("base_hp") 
			local base_armor = ability:GetSpecialValueFor("base_armor") 
			local base_dmg = ability:GetSpecialValueFor("base_dmg") 

			local upgrade_hp = ability:GetSpecialValueFor("upgrade_hp")*stack_count
			local upgrade_armor = ability:GetSpecialValueFor("upgrade_armor")*stack_count
			local upgrade_dmg = ability:GetSpecialValueFor("upgrade_dmg")*stack_count
			
			local player = killer:GetPlayerID()
			local fv = killed_unit:GetForwardVector()
			local point = killed_unit:GetAbsOrigin()
			local team = killer:GetTeam()

			local unit = CreateUnitByName( "npc_dota_broodmother_spiderling", point, true, killer, killer, team )
			unit:GetAbilityByIndex(0):SetLevel(1)
			unit:AddNewModifier( unit, ability, "modifier_phased", {duration = 0.1} )
			unit:AddNewModifier( unit, ability, "modifier_kill", {duration = spawn_duration} )

			unit:SetControllableByPlayer(player, false)
			unit:SetOwner(killer)
			unit:SetForwardVector(fv)
			
			unit:SetBaseDamageMin( base_dmg  + upgrade_dmg )
			unit:SetBaseDamageMax( base_dmg  + upgrade_dmg )				
			unit:SetPhysicalArmorBaseValue( base_armor  )
			unit:SetBaseMaxHealth( base_hp + upgrade_hp )
			unit:SetMaxHealth( base_hp + upgrade_hp )
			unit:SetHealth( base_hp + upgrade_hp )
			
		end
	end
end



