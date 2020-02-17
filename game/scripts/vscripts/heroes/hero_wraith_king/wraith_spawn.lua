LinkLuaModifier("modifier_wraith_king_wraith_spawn", "heroes/hero_wraith_king/wraith_spawn", LUA_MODIFIER_MOTION_NONE)

wraith_king_wraith_spawn = class({})

function wraith_king_wraith_spawn:GetIntrinsicModifierName()
	return "modifier_wraith_king_wraith_spawn"
end


modifier_wraith_king_wraith_spawn = class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	DeclareFunctions		= function(self) return 
		{   MODIFIER_EVENT_ON_DEATH} end,
})
function modifier_wraith_king_wraith_spawn:GetEffectName()
	return "particles/units/heroes/hero_skeletonking/wraith_king_ambient.vpcf"
end
function modifier_wraith_king_wraith_spawn:OnCreated(data)
	if IsServer() then

		local caster = self:GetCaster()
		local ability = self:GetAbility()
		local radius = ability:GetSpecialValueFor("radius")
		local damage = ability:GetSpecialValueFor("damage")
		local stun_duration = ability:GetSpecialValueFor("stun_duration")
		local blast_dot_duration = ability:GetSpecialValueFor("blast_dot_duration")
--[[
		local effect = "particles/econ/items/pugna/pugna_ti9_immortal/pugna_ti9_immortal_netherblast_pre_ring.vpcf"
		local pfx = ParticleManager:CreateParticle(effect, PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(pfx, 0, caster:GetAbsOrigin()) -- Origin
		ParticleManager:SetParticleControl(pfx, 1, Vector(500, 1, 1)) -- Origin
		ParticleManager:ReleaseParticleIndex(pfx)
]]		
		Timers:CreateTimer(1,function()
			local effect = "particles/econ/items/pugna/pugna_ti9_immortal/pugna_ti9_immortal_netherblast.vpcf"
			local pfx = ParticleManager:CreateParticle(effect, PATTACH_CUSTOMORIGIN, nil)
			ParticleManager:SetParticleControl(pfx, 0, caster:GetAbsOrigin()) -- Origin
			ParticleManager:SetParticleControl(pfx, 1, Vector(radius/2, radius, radius)) -- Origin
			ParticleManager:ReleaseParticleIndex(pfx)
			EmitSoundOn("Hero_SkeletonKing.Hellfire_Blast", caster)			
			
			local enemies = FindUnitsInRadius(caster:GetTeam(), 
											caster:GetAbsOrigin(), 
											nil, 
											radius, 
											DOTA_UNIT_TARGET_TEAM_ENEMY, 
											DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, 
											DOTA_UNIT_TARGET_FLAG_NONE, 
											FIND_ANY_ORDER, false)
			
			for i=1,#enemies do
				local enemy = enemies[i]
				DealDamage(caster, enemy, damage, DAMAGE_TYPE_MAGICAL, nil, ability)
				enemy:AddNewModifier(caster, ability, "modifier_stunned", {duration = stun_duration})
				enemy:AddNewModifier(caster, ability, "modifier_skeleton_king_hellfire_blast", {duration = blast_dot_duration})
				EmitSoundOn("Hero_SkeletonKing.Hellfire_Blast",enemy)
				
					
			end
		end)
	end
end

function modifier_wraith_king_wraith_spawn:OnDeath(data)
	if IsServer() then
		local parent = self:GetParent()
		local killer = data.attacker
		local killed_unit = data.unit
 
		if killed_unit == parent then
		
			local ability = self:GetAbility()
			local caster = self:GetCaster()
			EmitGlobalSound("skeleton_king_wraith_death_long_13")			
			
		end
	end
end
--[[
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

		local point = parent:GetAbsOrigin() + parent:GetForwardVector()*500
		local team = parent:GetTeam()
		local unit_name = "npc_dota_wraith_king_boss"
	-- Эффект взрыва на герое + звук
		EmitSoundOn("Hero_Broodmother.SpawnSpiderlingsImpact", parent)			
		local effect = "particles/units/heroes/hero_broodmother/broodmother_spiderlings_spawn.vpcf"
		local pfx = ParticleManager:CreateParticle(effect, PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(pfx, 0, parent:GetAbsOrigin()) -- Origin
		ParticleManager:ReleaseParticleIndex(pfx)

		local unit = CreateUnitByName( unit_name, point, true, nil, nil, team )
		unit:AddNewModifier( parent, nil, "modifier_phased", {duration = 0.1} )
--		AttackMove(unit,final_poi)
	
	end
end
]]
