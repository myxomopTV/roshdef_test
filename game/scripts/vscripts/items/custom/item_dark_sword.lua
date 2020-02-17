LinkLuaModifier("modifier_item_dark_sword", "items/custom/item_dark_sword", LUA_MODIFIER_MOTION_NONE)


item_dark_sword = class({})

function item_dark_sword:OnSpellStart()
	local caster = self:GetCaster()

	caster:AddNewModifier(caster, self, "modifier_item_dark_sword", {})
	caster:RemoveItem(self)
end

modifier_item_dark_sword = class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	DeclareFunctions		= function(self) return 
		{   MODIFIER_EVENT_ON_DEATH,
			MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE
		} end,
})

function modifier_item_dark_sword:OnCreated()
	local ability = self:GetAbility()
	self.bonus_dmg = ability:GetSpecialValueFor("bonus_dmg")
	self.trigger_chance = ability:GetSpecialValueFor("trigger_chance")
	self.shadow_duration = ability:GetSpecialValueFor("shadow_duration")
	self.shadow_params = ability:GetSpecialValueFor("shadow_params")/100

end

function modifier_item_dark_sword:GetEffectName()
	return "particles/units/heroes/hero_dark_willow/dark_willow_bramble_swirl_dark.vpcf"
end

function modifier_item_dark_sword:GetModifierPreAttack_BonusDamage()
	return self.bonus_dmg
end

function modifier_item_dark_sword:OnDeath(data)
	if IsServer() then
		local parent = self:GetParent()
		local killer = data.attacker
		local killed_unit = data.unit
		
		if killer == parent and killed_unit:GetTeam() ~= killer:GetTeam() and killed_unit:IsCreature() and not killed_unit.boss and RollPercentage(self.trigger_chance)  then
			print(killer:GetUnitName())
			print(killed_unit:GetUnitName())
			if killer:IsRealHero() == false then
				killer = killer:GetPlayerOwner():GetAssignedHero()
			end
			
			local params = self.shadow_params
			local base_hp = killed_unit:GetMaxHealth()
			local base_armor = killed_unit:GetPhysicalArmorBaseValue()
			local base_dmg_min = killed_unit:GetBaseDamageMin()
			local base_dmg_max = killed_unit:GetBaseDamageMax()
			local unit_name = killed_unit:GetUnitName()
			
			local player = killer:GetPlayerID()
			local fv = killed_unit:GetForwardVector()
			local point = killed_unit:GetAbsOrigin()
			local team = killer:GetTeam()

			local unit = CreateUnitByName( unit_name, point, true, killer, killer, team )
			
			local modifier = unit:AddNewModifier( unit, nil, "modifier_kill", {duration = self.shadow_duration} )
			unit:SetRenderColor(0 , 0 , 0 )

			local effect = "particles/units/heroes/hero_dark_willow/dark_willow_bramble_swirl_dark.vpcf"
			local particle_fx = ParticleManager:CreateParticle(effect, PATTACH_ABSORIGIN_FOLLOW, unit)
			ParticleManager:SetParticleControlEnt(particle_fx, 0, unit, PATTACH_POINT_FOLLOW, "attach_feet", unit:GetAbsOrigin(), true)
			ParticleManager:SetParticleControlEnt(particle_fx, 1, unit, PATTACH_POINT_FOLLOW, "attach_feet", unit:GetAbsOrigin(), true)
			modifier:AddParticle(particle_fx, true, false, 100, false, false)

			unit:SetControllableByPlayer(player, false)
			unit:SetOwner(killer)
			unit:SetForwardVector(fv)
			
			unit:SetBaseDamageMin( base_dmg_min  * params )
			unit:SetBaseDamageMax( base_dmg_max  * params )				
			unit:SetPhysicalArmorBaseValue( base_armor * params )
			unit:SetBaseMaxHealth( base_hp * params )
			unit:SetMaxHealth( base_hp * params )
			unit:SetHealth( base_hp * params )	

			if unit:FindAbilityByName("respawn") then
				unit:RemoveAbility("respawn")
			end
			if unit:FindAbilityByName("respawn_strong") then
				unit:RemoveAbility("respawn_strong")
			end
			if unit:FindAbilityByName("boss_respawn") then
				unit:RemoveAbility("boss_respawn")
			end
					
		end
	end
end



