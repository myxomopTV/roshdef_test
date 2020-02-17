
-------------------------------------------
--			  Fire Spirits
-------------------------------------------
LinkLuaModifier("modifier_imba_phoenix_fire_spirits_count", "heroes/hero_phoenix/fire_spirits", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_phoenix_launch_fire_spirit", "heroes/hero_phoenix/fire_spirits", LUA_MODIFIER_MOTION_NONE)





phoenix_fire_spirits_custom = phoenix_fire_spirits_custom or class({})


function phoenix_fire_spirits_custom:IsHiddenWhenStolen() 	return false end
function phoenix_fire_spirits_custom:IsRefreshable() 			return true  end
function phoenix_fire_spirits_custom:IsStealable() 			return true  end
function phoenix_fire_spirits_custom:IsNetherWardStealable() 	return false end


function phoenix_fire_spirits_custom:GetCastRange() 	return self:GetSpecialValueFor("trigger_radius") end


function phoenix_fire_spirits_custom:GetIntrinsicModifierName()
	return "modifier_imba_phoenix_launch_fire_spirit"
end

function phoenix_fire_spirits_custom:OnCreated()
	if not IsServer() then
		return
	end

		-- Swap sub ability
end

function phoenix_fire_spirits_custom:GetCastAnimation()
	return ACT_DOTA_CAST_ABILITY_2
end

function phoenix_fire_spirits_custom:OnProjectileThink( vLocation )
	if not IsServer() then
		return
	end
	local caster = self:GetCaster()
	local ability = self
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(),
                              vLocation,
                              nil,
                              20,
                              DOTA_UNIT_TARGET_TEAM_BOTH,
                              DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
                              DOTA_UNIT_TARGET_FLAG_NONE,
                              FIND_ANY_ORDER,
                              false)
	for _, enemy in pairs(enemies) do
		if enemy:GetTeamNumber() ~= caster:GetTeamNumber() then
			enemy:AddNewModifier(caster, ability, "modifier_imba_phoenix_fire_spirits_debuff", { duration = ability:GetSpecialValueFor("duration") } )
		else
--			enemy:AddNewModifier(caster, ability, "modifier_imba_phoenix_burning_wings_ally_buff", {duration = 0.2})
		end
	end
end

function phoenix_fire_spirits_custom:OnProjectileHit( hTarget, vLocation)
	if not IsServer() then
		return
	end
	local caster = self:GetCaster()
	local location = vLocation
	if hTarget then
		location = hTarget:GetAbsOrigin() 
	end
	-- Particles and sound
	local DummyUnit = CreateUnitByName("npc_dota_thinker",location,false,caster,caster:GetOwner(),caster:GetTeamNumber())
	DummyUnit:AddNewModifier(caster, ability, "modifier_kill", {duration = 0.04})
	local pfx_explosion = ParticleManager:CreateParticle("particles/units/heroes/hero_phoenix/phoenix_fire_spirit_ground.vpcf", PATTACH_WORLDORIGIN, nil)
	ParticleManager:SetParticleControl(pfx_explosion, 0, location)
	ParticleManager:ReleaseParticleIndex(pfx_explosion)

	EmitSoundOn("Hero_Phoenix.ProjectileImpact", DummyUnit)
	EmitSoundOn("Hero_Phoenix.FireSpirits.Target", DummyUnit)

	-- Vision
	AddFOWViewer(caster:GetTeamNumber(), DummyUnit:GetAbsOrigin(), 175, 1, true)

	local units = FindUnitsInRadius(caster:GetTeamNumber(),
	                                location,
	                                nil,
	                                self:GetSpecialValueFor("radius"),
	                                DOTA_UNIT_TARGET_TEAM_BOTH,
	                                DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
	                                DOTA_UNIT_TARGET_FLAG_NONE,
	                                FIND_ANY_ORDER,
	                                false)
	for _,unit in pairs(units) do
		if unit ~= caster then
			if unit:GetTeamNumber() ~= caster:GetTeamNumber() then
				unit:AddNewModifier(caster, self, "modifier_imba_phoenix_fire_spirits_debuff", {duration = self:GetSpecialValueFor("duration")} )
			else
				--unit:AddNewModifier(caster, self, "modifier_imba_phoenix_fire_spirits_buff", {duration = self:GetSpecialValueFor("duration")} )
			end
		end
	end
	return true
end

pocket_phoenix_fire_spirits = class(phoenix_fire_spirits_custom)

modifier_imba_phoenix_fire_spirits_count = modifier_imba_phoenix_fire_spirits_count or class({})

function modifier_imba_phoenix_fire_spirits_count:IsDebuff()			return false end
function modifier_imba_phoenix_fire_spirits_count:IsHidden() 			return false end
function modifier_imba_phoenix_fire_spirits_count:IsPurgable() 			return false end
function modifier_imba_phoenix_fire_spirits_count:IsPurgeException() 	return false end
function modifier_imba_phoenix_fire_spirits_count:IsStunDebuff() 		return false end
function modifier_imba_phoenix_fire_spirits_count:RemoveOnDeath() 		return true  end

function modifier_imba_phoenix_fire_spirits_count:GetTexture()
	return "phoenix_fire_spirits"
end

function modifier_imba_phoenix_fire_spirits_count:OnCreated()
	if not IsServer() then
		return
	end
	self:StartIntervalThink(1.0)
end

function modifier_imba_phoenix_fire_spirits_count:OnIntervalThink()
	if not IsServer() then
		return
	end
	local caster = self:GetCaster()
	local ability = caster:FindAbilityByName("imba_phoenix_launch_fire_spirit")
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(),
                              caster:GetAbsOrigin(),
                              nil,
                              192,
                              DOTA_UNIT_TARGET_TEAM_ENEMY,
                              DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
                              DOTA_UNIT_TARGET_FLAG_NONE,
                              FIND_ANY_ORDER,
                              false)
	for _, enemy in pairs(enemies) do
		enemy:AddNewModifier(caster, ability, "modifier_imba_phoenix_fire_spirits_debuff", { duration = ability:GetSpecialValueFor("duration") } )
	end
end

function modifier_imba_phoenix_fire_spirits_count:OnDestroy()
	if not IsServer() then
		return
	end
	local caster = self:GetCaster()
	local pfx = caster.fire_spirits_pfx
	if pfx then
		ParticleManager:DestroyParticle( pfx, false )
		ParticleManager:ReleaseParticleIndex( pfx )
	end
	local main_ability_name	= "imba_phoenix_fire_spirits"
	local sub_ability_name	= "imba_phoenix_launch_fire_spirit"
	if caster then
		caster:SwapAbilities( main_ability_name, sub_ability_name, true, false )
	end
end

-------------------------------------------
--			  Fire Spirits : Launch
-------------------------------------------

LinkLuaModifier("modifier_imba_phoenix_fire_spirits_debuff", "heroes/hero_phoenix/fire_spirits", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_phoenix_fire_spirits_buff", "heroes/hero_phoenix/fire_spirits", LUA_MODIFIER_MOTION_NONE)

modifier_imba_phoenix_launch_fire_spirit = modifier_imba_phoenix_launch_fire_spirit or class({})

function modifier_imba_phoenix_launch_fire_spirit:OnCreated()

	self:StartIntervalThink(0.25)
end
function modifier_imba_phoenix_launch_fire_spirit:OnIntervalThink()
	if not IsServer() then
		return
	end
	local caster		= self:GetCaster()
	local ability		= self:GetAbility()
--	local modifierName	= self
	local debuffModifier = "modifier_imba_phoenix_fire_spirits_debuff"
--	local iModifier 	= caster:FindModifierByName(modifierName)
	local trigger_radius= self:GetAbility():GetSpecialValueFor("trigger_radius")

	if not ability:IsCooldownReady() or not caster:IsAlive() then
		return
	end
	
	if caster.fire_spirits_pfx == nil then
		caster:StartGesture(ACT_DOTA_CAST_ABILITY_2)
		EmitSoundOn("Hero_Phoenix.FireSpirits.Cast", caster)

		local particleName = "particles/units/heroes/hero_phoenix/phoenix_fire_spirits.vpcf"
		local pfx = ParticleManager:CreateParticle( particleName, PATTACH_ABSORIGIN_FOLLOW, caster )
		ParticleManager:SetParticleControl( pfx, 1, Vector( 1, 0, 0 ) )
		ParticleManager:SetParticleControl( pfx, 9, Vector( 1, 0, 0 ) )

		caster.fire_spirits_pfx			= pfx
	end
	

	local enemies = FindUnitsInRadius(caster:GetTeamNumber(),
                              caster:GetAbsOrigin(),
                              nil,
                              trigger_radius,
                              DOTA_UNIT_TARGET_TEAM_ENEMY,
                              DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
                              DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE,
                              FIND_ANY_ORDER,
                              false)
--	if 	#enemies > 0 then					  
		local index = 1
		for i=1,#enemies do
			if enemies[index]:HasModifier(debuffModifier) then
				
				table.remove( enemies, index )
			else
				index = index +1
			end
		end
--	end
	
	if #enemies > 0 then
		
		 
		local enemy = enemies[math.random(#enemies)]
		local point = enemy:GetAbsOrigin()
		
		caster:StartGesture(ACT_DOTA_OVERRIDE_ABILITY_2)
		EmitSoundOn("Hero_Phoenix.FireSpirits.Launch", caster)

		-- Update spirits count
--		iModifier:DecrementStackCount()
--		local currentStack = iModifier:GetStackCount()

		-- Update the particle FX
		ParticleManager:DestroyParticle(caster.fire_spirits_pfx, true)
		caster.fire_spirits_pfx = nil
--		local pfx = caster.fire_spirits_pfx
--		ParticleManager:SetParticleControl( pfx, 1, Vector( 0, 0, 0 ) )
--		ParticleManager:SetParticleControl( pfx, 1, Vector( 0, 0, 0 ) )
--[[	for i=1, caster.fire_spirits_numSpirits do
			local radius = 0
			if i <= currentStack then
				radius = 1
			end
			ParticleManager:SetParticleControl( pfx, 8+i, Vector( radius, 0, 0 ) )
		end
]]	--		
--		ParticleManager:SetParticleControl( pfx, 9, Vector( 0, 0, 0 ) )
		

		-- Projectile
		local direction = (point - caster:GetAbsOrigin()):Normalized()
--		local DummyUnit = CreateUnitByName("npc_dummy_unit",point,false,caster,caster:GetOwner(),caster:GetTeamNumber())
--		DummyUnit:AddNewModifier(caster, ability, "modifier_kill", {duration = 0.04})
--		local cast_target = DummyUnit

		local info = 
		{
			Target = enemy,
			Source = caster,
			Ability = ability,	
			EffectName = "particles/hero/phoenix/phoenix_fire_spirit_launch.vpcf",
			iMoveSpeed = self:GetSpecialValueFor("spirit_speed"),
			vSourceLoc = direction,							-- Optional (HOW)
			bDrawsOnMinimap = false,						-- Optional
			bDodgeable = false,								-- Optional
			bIsAttack = false,								-- Optional
			bVisibleToEnemies = true,						-- Optional
			bReplaceExisting = false,						-- Optional
			flExpireTime = GameRules:GetGameTime() + 10,	-- Optional but recommended
			bProvidesVision = false,						-- Optional
			iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_HITLOCATION
		}
		ProjectileManager:CreateTrackingProjectile(info)

		-- Remove the stack modifier if all the spirits has been launched.
--		if iModifier:GetStackCount() < 1 then
--			iModifier:Destroy()
		ability:UseResources(false,false,true)
--		end
--		Timers:CreateTimer(ability:GetCooldown(ability:GetLevel()),function() ability:OnCreated() end)

	end
end


function modifier_imba_phoenix_launch_fire_spirit:GetCastAnimation()
	return ACT_DOTA_OVERRIDE_ABILITY_2
end



modifier_imba_phoenix_fire_spirits_debuff = modifier_imba_phoenix_fire_spirits_debuff or class({})

function modifier_imba_phoenix_fire_spirits_debuff:IsDebuff()			return true  end
function modifier_imba_phoenix_fire_spirits_debuff:IsHidden() 			return false end
function modifier_imba_phoenix_fire_spirits_debuff:IsPurgable() 		return true  end
function modifier_imba_phoenix_fire_spirits_debuff:IsPurgeException() 	return true  end
function modifier_imba_phoenix_fire_spirits_debuff:IsStunDebuff() 		return false end
function modifier_imba_phoenix_fire_spirits_debuff:RemoveOnDeath() 		return true  end

function modifier_imba_phoenix_fire_spirits_debuff:DeclareFunctions()
    local decFuns =
    {
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
    }
    return decFuns
end

function modifier_imba_phoenix_fire_spirits_debuff:GetTexture()
	return "phoenix_fire_spirits"
end

function modifier_imba_phoenix_fire_spirits_debuff:GetEffectName() return "particles/units/heroes/hero_phoenix/phoenix_fire_spirit_burn.vpcf" end
function modifier_imba_phoenix_fire_spirits_debuff:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
function modifier_imba_phoenix_fire_spirits_debuff:GetModifierAttackSpeedBonus_Constant()
	if self:GetCaster():GetTeamNumber() == self:GetParent():GetTeamNumber() then
		return 0 
	else
		return self:GetStackCount() * self:GetAbility():GetSpecialValueFor("attackspeed_slow") * (-1)
	end
end

function modifier_imba_phoenix_fire_spirits_debuff:OnCreated()
	if not IsServer() then
		return
	end
	local ability = self:GetAbility()
	if self:GetStackCount() <= 1 then
		self:SetStackCount(1)
	end
	local tick = ability:GetSpecialValueFor("tick_interval")
	self:StartIntervalThink( tick )
end

function modifier_imba_phoenix_fire_spirits_debuff:OnRefresh()
	if not IsServer() then
		return
	end
	local ability = self:GetAbility()
	local caster = self:GetCaster()
	if self:GetStackCount() <= 1 then
		self:SetStackCount(1)
	end
	if caster:HasTalent("special_bonus_imba_phoenix_3") and self:GetStackCount() < caster:FindTalentValue("special_bonus_imba_phoenix_3","max_stacks") then
		self:IncrementStackCount()
	end
end

function modifier_imba_phoenix_fire_spirits_debuff:OnIntervalThink()
	if not IsServer() then
		return
	end
	if not self:GetParent():IsAlive() then
		return
	end
	local caster = self:GetCaster()
	local ability = self:GetAbility()
	local tick = ability:GetSpecialValueFor("tick_interval")
	local dmg = ability:GetSpecialValueFor("damage_per_second") * ( tick / 1.0 )
	local damageTable = {
       	victim = self:GetParent(),
       	attacker = caster,
       	damage = dmg * self:GetStackCount(),
       	damage_type = DAMAGE_TYPE_MAGICAL,
       	ability = self:GetAbility(),
    	}
    ApplyDamage(damageTable)
end
