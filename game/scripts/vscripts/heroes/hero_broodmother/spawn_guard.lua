LinkLuaModifier("modifier_broodmother_spawn_guard", "heroes/hero_broodmother/spawn_guard", LUA_MODIFIER_MOTION_NONE)


broodmother_spawn_guard = class({})

function broodmother_spawn_guard:OnSpellStart()
	if IsServer() then
		local caster = self:GetCaster()
		local killed_unit = caster
		local egg_duration = self:GetSpecialValueFor("egg_duration") 	

		EmitSoundOn("Hero_Broodmother.SpawnSpiderlingsImpact", killed_unit)			

		local point = caster:GetAbsOrigin()
		local team = caster:GetTeam()

		local unit = CreateUnitByName( "npc_dota_broodmother_guard_cocoon", point, true, caster, caster, team )
		unit:GetAbilityByIndex(0):SetLevel(1)
		unit:AddNewModifier( unit, ability, "modifier_phased", {duration = 0.1} )
		unit:AddNewModifier( unit, self, "modifier_broodmother_spawn_guard", {duration = egg_duration} )

	end
end

modifier_broodmother_spawn_guard = class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return true end,
	DeclareFunctions		= function(self) return 
		{   MODIFIER_PROPERTY_MODEL_SCALE} end,
})

function modifier_broodmother_spawn_guard:OnCreated()
	self:StartIntervalThink(1)
end

function modifier_broodmother_spawn_guard:OnIntervalThink()
	self:IncrementStackCount()
end

function modifier_broodmother_spawn_guard:GetModifierModelScale()
	local max_scale = self:GetAbility():GetSpecialValueFor("max_scale")
	local egg_duration = self:GetAbility():GetSpecialValueFor("egg_duration")
	return self:GetStackCount()*max_scale/egg_duration
end

function modifier_broodmother_spawn_guard:OnDestroy()
	if IsServer() then
		local parent = self:GetParent()
		local caster = self:GetCaster()
		local ability = self:GetAbility()
		
		if not parent:IsAlive() then
			parent:AddNoDraw()			
			return
		end
		
		if caster:IsRealHero() == false then
			caster = caster:GetPlayerOwner():GetAssignedHero()
		end
		local stack_count = 0
		if caster:HasModifier("modifier_broodmother_upgrade_spiderling") then
			stack_count = caster:FindModifierByName("modifier_broodmother_upgrade_spiderling"):GetStackCount()
		end
		
		EmitSoundOn("Hero_Broodmother.SpawnSpiderlings",parent)

		parent:AddNoDraw()
		parent:ForceKill(false)	
		local effect = "particles/units/heroes/hero_broodmother/broodmother_spiderlings_spawn.vpcf"
		local pfx = ParticleManager:CreateParticle(effect, PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(pfx, 0, parent:GetAbsOrigin()) -- Origin
		ParticleManager:ReleaseParticleIndex(pfx)

		local base_hp = ability:GetSpecialValueFor("base_hp") 
		local base_armor = ability:GetSpecialValueFor("base_armor") 
		local base_dmg = ability:GetSpecialValueFor("base_dmg") 

		local upgrade_hp = ability:GetSpecialValueFor("upgrade_hp")*stack_count
		local upgrade_armor = ability:GetSpecialValueFor("upgrade_armor")*stack_count
		local upgrade_dmg = ability:GetSpecialValueFor("upgrade_dmg")*stack_count
		
		local player = caster:GetPlayerID()
		local fv = parent:GetForwardVector()
		local point = parent:GetAbsOrigin()
		local team = caster:GetTeam()

		local unit = CreateUnitByName( "npc_dota_broodmother_spiderite", point, true, caster, caster, team )
		unit:GetAbilityByIndex(0):SetLevel(1)
		unit:AddNewModifier( unit, ability, "modifier_phased", {duration = 0.1} )

		unit:SetControllableByPlayer(player, false)
		unit:SetOwner(caster)
		unit:SetForwardVector(fv)
		
		unit:SetBaseDamageMin( base_dmg  + upgrade_dmg )
		unit:SetBaseDamageMax( base_dmg  + upgrade_dmg )				
		unit:SetPhysicalArmorBaseValue( base_armor  )
		unit:SetBaseMaxHealth( base_hp + upgrade_hp )
		unit:SetMaxHealth( base_hp + upgrade_hp )
		unit:SetHealth( base_hp + upgrade_hp )		

	end
end



