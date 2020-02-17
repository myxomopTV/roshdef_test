LinkLuaModifier("modifier_zombie_king_zombie_spawn", "heroes/hero_zombie_king/zombie_spawn", LUA_MODIFIER_MOTION_NONE)


zombie_king_zombie_spawn = class({})

function zombie_king_zombie_spawn:GetIntrinsicModifierName()
	return "modifier_zombie_king_zombie_spawn"
end


modifier_zombie_king_zombie_spawn = class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return true end,
	GetAttributes 			= function(self) return MODIFIER_ATTRIBUTE_MULTIPLE end,
	DeclareFunctions		= function(self) return 
		{   MODIFIER_EVENT_ON_DEATH} end,
})

function modifier_zombie_king_zombie_spawn:OnDeath(data)
	if IsServer() then
		local parent = self:GetParent()
		local killer = data.attacker
		local killed_unit = data.unit
		
		if killer == parent and killed_unit:GetTeam() ~= killer:GetTeam() then
			print("GGG")
			print(killer:GetUnitName())
			print(killed_unit:GetUnitName())
			if killer:IsRealHero() == false then
				killer = killer:GetPlayerOwner():GetAssignedHero()
			end
			
			local ability = self:GetAbility()
			local params = ability:GetSpecialValueFor("params")/100
			local base_hp = killed_unit:GetMaxHealth()
			local base_armor = killed_unit:GetPhysicalArmorBaseValue()
			local base_dmg_min = killed_unit:GetBaseDamageMin()
			local base_dmg_max = killed_unit:GetBaseDamageMax()
			
			local player = killer:GetPlayerID()
			local fv = killed_unit:GetForwardVector()
			local point = killed_unit:GetAbsOrigin()
			local team = killer:GetTeam()

			local unit = CreateUnitByName( "npc_dota_zombie_king_spawn", point, true, killer, killer, team )
			
			unit:AddNewModifier( unit, ability, "modifier_phased", {} )

			unit:SetControllableByPlayer(player, false)
			unit:SetOwner(killer)
			unit:SetForwardVector(fv)
			
			unit:SetBaseDamageMin( base_dmg_min  * params )
			unit:SetBaseDamageMax( base_dmg_max  * params )				
			unit:SetPhysicalArmorBaseValue( base_armor * params )
			unit:SetBaseMaxHealth( base_hp * params )
			unit:SetMaxHealth( base_hp * params )
			unit:SetHealth( base_hp * params )			
		end
	end
end



