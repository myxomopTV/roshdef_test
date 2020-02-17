
---------------------------------
-- 		   Return 		       --
---------------------------------

storegga_golem_spawn = class({})
LinkLuaModifier("modifier_storegga_golem_spawn", "abilities/storegga_golem_spawn", LUA_MODIFIER_MOTION_NONE)


function storegga_golem_spawn:GetIntrinsicModifierName()
	return "modifier_storegga_golem_spawn"
end

-----------------------------------------------
-----------------------------------------------

modifier_storegga_golem_spawn = class({})

------------------------------------------------------------------------------

function modifier_storegga_golem_spawn:IsHidden() 
	return true
end

--------------------------------------------------------------------------------

function modifier_storegga_golem_spawn:IsPurgable()
	return false
end

----------------------------------------

function modifier_storegga_golem_spawn:OnCreated( kv )
	self.summon_duration = self:GetAbility():GetSpecialValueFor( "summon_duration" )
	self.summon_chance = self:GetAbility():GetSpecialValueFor( "summon_chance" )
end

----------------------------------------

function modifier_storegga_golem_spawn:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_EVENT_ON_TAKEDAMAGE,
	}
	return funcs
end

----------------------------------------

function modifier_storegga_golem_spawn:OnTakeDamage( params )
	if IsServer() then
		if params.unit == self:GetParent() then
			if params.damage > 25 and RollPercentage( self.summon_chance ) then
				local vSpawnPos = self:GetParent():GetOrigin() + RandomVector( 75 )
				local nFXCastIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_alchemist/alchemist_acid_spray_cast.vpcf", PATTACH_CUSTOMORIGIN, self:GetParent() )
				ParticleManager:SetParticleControlEnt( nFXCastIndex, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetParent():GetAbsOrigin(), true )
				ParticleManager:SetParticleControl( nFXCastIndex, 1, vSpawnPos )
				ParticleManager:ReleaseParticleIndex( nFXCastIndex )

				local hAmoeba = CreateUnitByName( "npc_dota_creature_little_storegga", vSpawnPos, true, self:GetParent(), self:GetParent(), self:GetParent():GetTeamNumber() )
				if hAmoeba ~= nil then
					local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_batrider/batrider_stickynapalm_impact.vpcf", PATTACH_CUSTOMORIGIN, nil )
					ParticleManager:SetParticleControl( nFXIndex, 0, vSpawnPos )
					ParticleManager:SetParticleControl( nFXIndex, 1, Vector( 150, 150, 150 ) )
					ParticleManager:SetParticleControlEnt( nFXIndex, 2, hAmoeba, PATTACH_POINT_FOLLOW, "attach_hitloc", hAmoeba:GetOrigin(), true )
					ParticleManager:ReleaseParticleIndex( nFXIndex )
				end
				hAmoeba:AddNewModifier( self:GetParent(), self, "modifier_kill", { duration = self.summon_duration } )
			end	
		end
	end
	return 0
end


----------------------------------------

