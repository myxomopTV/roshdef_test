LinkLuaModifier("modifier_upgrade_unit_health", "heroes/hero_greevil_lord/upgrade_unit", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_greevil_titan_egg", "heroes/hero_greevil_lord/summon_titan", LUA_MODIFIER_MOTION_NONE)

greevil_lord_summon_titan = class({})

function greevil_lord_summon_titan:OnSpellStart()
	local point = self:GetCursorPosition()
	
	local ability = self
	local caster = self:GetCaster()

	local player = caster:GetPlayerID()
	local level = ability:GetLevel()
	local unit_name = "npc_dota_greevil_lord_titan_egg"
		
	local base_hp = ability:GetSpecialValueFor("base_hp")
	local base_dmg = ability:GetSpecialValueFor("base_dmg")
	local base_armor = ability:GetSpecialValueFor("base_armor")
	local egg_duration = ability:GetSpecialValueFor("egg_duration") 
	
	
	local unit = CreateUnitByName(unit_name, point, true, caster, caster, caster:GetTeamNumber())
	unit:SetControllableByPlayer(player, true)
--	unit:AddNewModifier(caster,ability,"modifier_kill",{duration = egg_duration})
	unit:AddNewModifier(caster,ability,"modifier_phased",{duration = 0.01})
	unit:AddNewModifier(caster,ability,"modifier_greevil_titan_egg",nil)

end

modifier_greevil_titan_egg = class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return true end,
	DeclareFunctions		= function(self) return 
		{MODIFIER_PROPERTY_MODEL_SCALE} end,
})
function modifier_greevil_titan_egg:OnCreated()
	local ability = self:GetAbility()
	local interval_growth = ability:GetSpecialValueFor("interval_growth")
	self.model_growth = ability:GetSpecialValueFor("model_growth")
	self.max_grow = ability:GetSpecialValueFor("max_grow")

	self:StartIntervalThink(interval_growth)
end
function modifier_greevil_titan_egg:SpawnTitan()
	if IsServer() then
		local ability = self:GetAbility()
		local caster = self:GetCaster()
		print(caster:GetUnitName())
		
		local point = self:GetParent():GetAbsOrigin()
		local player = caster:GetPlayerID()
		local level = ability:GetLevel()
		local unit_name = "npc_dota_greevil_lord_titan"
			
		local base_hp = ability:GetSpecialValueFor("base_hp")
		local base_dmg = ability:GetSpecialValueFor("base_dmg")
		local base_armor = ability:GetSpecialValueFor("base_armor")
		local titan_duration = ability:GetSpecialValueFor("titan_duration") 	
		
		local unit = CreateUnitByName(unit_name, point, false, caster, caster, caster:GetTeamNumber())
		unit:SetControllableByPlayer(player, true)
		unit:AddNewModifier(caster,ability,"modifier_kill",{duration = titan_duration})
		unit:AddNewModifier(caster,ability,"modifier_phased",{duration = 0.01})
		unit:AddNewModifier(caster,ability,"modifier_greevil_unit_upgrade",nil)

		local new_hp = base_hp

		unit:SetBaseDamageMin(base_dmg )
		unit:SetBaseDamageMax(base_dmg  )				
		unit:SetPhysicalArmorBaseValue(base_armor )
		unit:SetMaxHealth( new_hp )
		unit:SetBaseMaxHealth( new_hp )
		unit:SetHealth( new_hp )
		
		EmitSoundOn("Hero_Phoenix.SuperNova.Explode",unit)
		local effect = "particles/units/heroes/hero_phoenix/phoenix_supernova_reborn.vpcf"
		local pfx = ParticleManager:CreateParticle(effect, PATTACH_ABSORIGIN_FOLLOW, unit)
--		local point = unit:GetAbsOrigin()
		ParticleManager:SetParticleControl(pfx, 0, unit:GetAbsOrigin()) -- Origin
		ParticleManager:SetParticleControl(pfx, 1, unit:GetAbsOrigin()) -- Destination
			

	end	
end
function modifier_greevil_titan_egg:OnIntervalThink()
	if self:GetStackCount() == self.max_grow then
		self:GetParent():SetOriginalModel("models/creeps/ice_boss/ice_boss_egg_dest.vmdl")
		self:GetParent():ForceKill(false)
		self:SpawnTitan()
	else
		self:IncrementStackCount()
	end
end	
function modifier_greevil_titan_egg:GetModifierModelScale()
	return self:GetStackCount()*self.model_growth
end
