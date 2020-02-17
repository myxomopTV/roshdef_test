LinkLuaModifier( "modifier_tangin_galop", "heroes/hero_tangin/galop", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
tangin_galop = class({})

function tangin_galop:OnSpellStart()
	if IsServer() then
		self.hHitEntities = {}
		self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_tangin_galop", { duration = self:GetSpecialValueFor( "duration" ) } )
	end
end

--------------------------------------------------------------------------------

--------------------------------------------------------------------------------

modifier_tangin_galop = class({})

--------------------------------------------------------------------------------

function modifier_tangin_galop:OnCreated( kv )
	self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
	self.stun_duration = self:GetAbility():GetSpecialValueFor( "stun_duration" )
	self.bonus_movespeed_pct = self:GetAbility():GetSpecialValueFor( "bonus_movespeed_pct" )
	self.hHitTargets = {}
	if IsServer() then
		self:StartIntervalThink( 0.05 )
		EmitSoundOn( "Hero_ChaosKnight.Phantasm", self:GetParent() )

		local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_centaur/centaur_stampede.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
		ParticleManager:SetParticleControlEnt( nFXIndex, 1, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetOrigin(), true )
		self:AddParticle( nFXIndex, false, false, -1, false, false  );

		local nFXIndexB = ParticleManager:CreateParticle( "particles/units/heroes/hero_centaur/centaur_stampede_cast.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
		ParticleManager:SetParticleControlEnt( nFXIndexB, 1, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetOrigin(), true )
		ParticleManager:ReleaseParticleIndex( nFXIndexB );
	end
end

--------------------------------------------------------------------------------

function modifier_tangin_galop:OnIntervalThink()
	if IsServer() then
		local enemies = FindUnitsInRadius( self:GetParent():GetTeamNumber(), self:GetParent():GetOrigin(), self:GetParent(), self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false )
		if #enemies > 0 then
			for _,enemy in pairs(enemies) do
				if enemy ~= nil and ( not enemy:IsMagicImmune() ) and ( not enemy:IsInvulnerable() ) and ( not self:HasHitTarget( enemy ) ) then
					self:AddHitTarget( enemy )
--					self:GetParent():AddNewModifier( self:GetCaster(), self:GetAbility(), "modifier_phantom_assassin_stiflingdagger_caster", {} )
					self:GetParent():PerformAttack( enemy, true, false, true, true, false, false, true)

						local mult = 1
						local caster = self:GetCaster()
						if caster:HasModifier("modifier_item_special_tangin") then
							if RollPercentage(10) then
								local ability = caster:FindAbilityByName("tangin_fire_breathe")
								caster:SetCursorPosition(enemy:GetAbsOrigin())
								ability:OnSpellStart()
							end
						elseif caster:HasModifier("modifier_item_special_tangin_upgrade") then
							local ability = caster:FindAbilityByName("tangin_fire_breathe")
							caster:SetCursorPosition(enemy:GetAbsOrigin())
							ability:OnSpellStart()
						end	

--					self:GetParent():RemoveModifierByName( "modifier_phantom_assassin_stiflingdagger_caster" )

					enemy:AddNewModifier( self:GetCaster(), self:GetAbility(), "modifier_stunned", { duration = self.stun_duration } )

--					EmitSoundOn( "Hero_tangin.galop", enemy )
				end
			end
		end
	end
end

function modifier_tangin_galop:GetEffectName()
	return "particles/units/heroes/hero_centaur/centaur_stampede_overhead.vpcf"
end

function modifier_tangin_galop:GetEffectAttachType()
    return PATTACH_OVERHEAD_FOLLOW
end

--------------------------------------------------------------------------------

function modifier_tangin_galop:DeclareFunctions()
	local funcs =
	{
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}
	return funcs
end

--------------------------------------------------------------------------------

function modifier_tangin_galop:GetModifierMoveSpeedBonus_Percentage( params )
	return self.bonus_movespeed_pct
end

--------------------------------------------------------------------------------

function modifier_tangin_galop:CheckState()
	local state =
	{
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
	}

	return state

end

--------------------------------------------------------------------------------

function modifier_tangin_galop:HasHitTarget( hTarget )
	for _, target in pairs( self.hHitTargets ) do
		if target == hTarget then
	    	return true
	    end
	end
	
	return false
end

--------------------------------------------------------------------------------

function modifier_tangin_galop:AddHitTarget( hTarget )
	table.insert( self.hHitTargets, hTarget )
end
