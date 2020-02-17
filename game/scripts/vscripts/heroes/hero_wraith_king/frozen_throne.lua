LinkLuaModifier("modifier_wraith_king_frozen_throne", "heroes/hero_wraith_king/frozen_throne", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_wraith_king_ice_skeleton", "heroes/hero_wraith_king/frozen_throne", LUA_MODIFIER_MOTION_NONE)

wraith_king_frozen_throne = class({})

function wraith_king_frozen_throne:GetIntrinsicModifierName()
	return "modifier_wraith_king_frozen_throne"
end


modifier_wraith_king_frozen_throne = class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	DeclareFunctions		= function(self) return 
		{   MODIFIER_EVENT_ON_DEATH} end,
})
function modifier_wraith_king_frozen_throne:OnCreated(data)
	Timers:CreateTimer(0.1, function()
		local ability = self:GetAbility()
		local caster = ability:GetCaster()
		local caster_fw = caster:GetForwardVector()
			
		local unit_name = "npc_dota_wraith_king_prop"
		local point = caster:GetAbsOrigin()-caster_fw*50
		local team = caster:GetTeam()

		caster.unit = CreateUnitByName( unit_name, point, false, caster, caster, team )
		caster.unit:SetForwardVector(caster_fw)
		caster.unit:AddNewModifier( caster, ability, "modifier_wraith_king_ice_skeleton", nil )
	end)
--			caster.unit:AddNewModifier( caster, ability, "modifier_wraith_king_ice_skeleton", {duration = 4} )
--			caster.unit:StartGestureWithPlaybackRate( ACT_DOTA_SPAWN, 2 )

end
function modifier_wraith_king_frozen_throne:OnDeath(data)
	if IsServer() then
		local parent = self:GetParent()
		local killer = data.attacker
		local killed_unit = data.unit
 
		if killed_unit == parent then
		
			local ability = self:GetAbility()
			local caster = self:GetCaster()
			local spawn_duration = ability:GetSpecialValueFor("spawn_duration")

			killed_unit:AddNoDraw()
			EmitSoundOn("Hero_Ancient_Apparition.IceBlast.Target",killed_unit)			
			local effect = "particles/econ/items/crystal_maiden/crystal_maiden_cowl_of_ice/maiden_crystal_nova_cowlofice.vpcf"
			local pfx = ParticleManager:CreateParticle(effect, PATTACH_CUSTOMORIGIN, nil)
			ParticleManager:SetParticleControl(pfx, 0, parent:GetAbsOrigin()) -- Origin
			ParticleManager:ReleaseParticleIndex(pfx)

			local modifier = caster.unit:AddNewModifier( caster, ability, "modifier_wraith_king_ice_skeleton", {duration = spawn_duration} )
			modifier:StartIntervalThink(0.5)
			modifier.kill_timer = 0
			caster.unit:StartGestureWithPlaybackRate( ACT_DOTA_SPAWN, 8/spawn_duration )

			EmitSoundOn("wk_reincarnate",killed_unit)--global sound wk spawn
		end
	end
end

modifier_wraith_king_ice_skeleton = class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	DeclareFunctions		= function(self) return 
		{   MODIFIER_PROPERTY_OVERRIDE_ANIMATION} end,
	CheckState		= function(self) return 
		{   
			[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
			[MODIFIER_STATE_NO_HEALTH_BAR] = true,
			[MODIFIER_STATE_UNSELECTABLE] = true,
			[MODIFIER_STATE_STUNNED] = true,
			[MODIFIER_STATE_INVULNERABLE] = true,
			[MODIFIER_STATE_NOT_ON_MINIMAP] = true,
		} 
	end,

})
function modifier_wraith_king_ice_skeleton:GetOverrideAnimation( params )
        return ACT_DOTA_IDLE
end
function modifier_wraith_king_ice_skeleton:GetEffectName()
	return "particles/units/heroes/hero_skeletonking/wraith_king_ambient.vpcf"
end
function modifier_wraith_king_ice_skeleton:OnDestroy(data)
	if IsServer() then
		local parent = self:GetParent()
		local fw = parent:GetForwardVector()
		local point = parent:GetAbsOrigin() + fw*900		
		local team = parent:GetTeam()
		local unit_name = "npc_dota_wraith_king_boss"
	-- Эффект взрыва на герое + звук
		parent:ForceKill(false)
		parent:AddNoDraw()
--		EmitGlobalSound("skeleton_king_wraith_respawn_06")
		EmitGlobalSound("skeleton_king_wraith_fastres_03")
--		EmitSoundOn("Hero_Broodmother.SpawnSpiderlingsImpact", parent)			

		local unit = CreateUnitByName( unit_name, point, false, nil, nil, team )
		unit:SetForwardVector(fw)
		unit:AddNewModifier( parent, nil, "modifier_phased", {duration = 0.1} )
--		AttackMove(unit,final_poi)
	
	end
end
function modifier_wraith_king_ice_skeleton:OnIntervalThink()
	if IsServer() then
		self.kill_timer = self.kill_timer + 0.5
		local ability = self:GetAbility()
		local caster = self:GetCaster()
		local parent = self:GetParent()
		local spawn_duration = ability:GetSpecialValueFor("spawn_duration")
		local fw = parent:GetForwardVector() * self.kill_timer/spawn_duration 
		
		local point = parent:GetAbsOrigin() + fw*900 + Vector(0,0,450)		
		EmitSoundOn("Hero_Pugna.NetherWard.Attack.Wight", caster)			
		
		local effect = "particles/econ/items/pugna/pugna_ward_ti5/pugna_ward_attack_medium_ti_5.vpcf"
		local pfx = ParticleManager:CreateParticle(effect, PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(pfx, 0, caster:GetAbsOrigin()) -- Origin
		ParticleManager:SetParticleControl(pfx, 1, point) -- Origin
		ParticleManager:ReleaseParticleIndex(pfx)			
	
	end
end
