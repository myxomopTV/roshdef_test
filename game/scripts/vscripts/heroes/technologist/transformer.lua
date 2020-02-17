if customability_technologist_transformer == nil then
    customability_technologist_transformer = class({})
end


LinkLuaModifier( "modifier_technologist_energized", "heroes/technologist/modifiers/energy_system.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_technologist_energized_stack", "heroes/technologist/modifiers/energy_system.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_technologist_energized_failsafe", "heroes/technologist/modifiers/energy_system.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_technologist_transformer", "heroes/technologist/modifiers/transformer.lua", LUA_MODIFIER_MOTION_NONE )


function customability_technologist_transformer:OnUpgrade() 
	self.damagePerc = (1 + (self:GetLevel() * .3)) / 100
end

function customability_technologist_transformer:GetManaCost()
	return 1
end

function customability_technologist_transformer:GetAOERadius()
	return 200
end

function customability_technologist_transformer:GetChannelTime()
	return 5
end

function customability_technologist_transformer:OnSpellStart()
	local Caster = self:GetCaster()
	local Target = false
	if not self:GetCursorTargetingNothing() then
        Target = self:GetCursorTarget()
    end
    self.point = self:GetCursorPosition()

    local mod = Caster:FindModifierByName("modifier_technologist_energy")
    mod:ModifyStacks(-self:GetManaCost(-1))

    Caster:AddNewModifier(Caster, self, "modifier_technologist_energized_failsafe", {duration = 10})

    self.cc_interval = (self:GetChannelTime() / 100)
    self.cc_timer = 0
    self.energyBank = 1

    self.radius = self:GetAOERadius()

    StartSoundEvent("Hero_KeeperOfTheLight.Illuminate.Charge", Caster)

    self.chargeParticle = ParticleManager:CreateParticle("particles/technologist/transformer_charge.vpcf", PATTACH_ABSORIGIN_FOLLOW, Caster)
    ParticleManager:SetParticleControl(self.chargeParticle,1,Vector(self:GetChannelTime(),0,0))
end

function customability_technologist_transformer:OnChannelThink(flInterval)
	self.cc_timer = self.cc_timer + flInterval
	if self.cc_timer >= self.cc_interval then
	    self.cc_timer = self.cc_timer - self.cc_interval
	    self:CustomChannelThink()
	end
end

function customability_technologist_transformer:CustomChannelThink()
	local Caster = self:GetCaster()
	Caster:AddNewModifier(Caster, self, "modifier_technologist_energized_failsafe", {duration = 10})
	if Caster:GetMana() > 0 then
		local mod = Caster:FindModifierByName("modifier_technologist_energy")
	    mod:ModifyStacks(-1)
		self.energyBank = self.energyBank + 1
	else
		Caster:Stop()
	end
end

function customability_technologist_transformer:OnChannelFinish(bInterrupted)
	if not IsServer() then return end

	local Caster = self:GetCaster()
	local damage = (Caster:GetIntellect() * self.damagePerc) * self.energyBank

	--Fire laser
	ParticleManager:DestroyParticle(self.chargeParticle, true)

	StopSoundEvent("Hero_KeeperOfTheLight.Illuminate.Charge", Caster)
	EmitSoundOnLocationWithCaster(Caster:GetAbsOrigin(), "Hero_Tinker.Laser", Caster)

	local beamParticle = ParticleManager:CreateParticle("particles/technologist/transformer_beam.vpcf", PATTACH_ABSORIGIN_FOLLOW, Caster)
	ParticleManager:SetParticleControl(beamParticle,1,self.point)

	Timers:CreateTimer(.25, function()
		local explosionParticle = ParticleManager:CreateParticle("particles/technologist/transformer_explosion.vpcf", PATTACH_ABSORIGIN, Caster)
		ParticleManager:SetParticleControl(explosionParticle,0,self.point)

		local units = FindUnitsInRadius( Caster:GetTeamNumber(), self.point, nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		local index = 1
		if units[1] then
		   	for i=1,self.energyBank do
		    	if units[index] then
		    		units[index]:AddNewModifier(Caster, self, "modifier_technologist_energized", {})
		    		index = index + 1
		    	else
		    		units[1]:AddNewModifier(Caster, self, "modifier_technologist_energized", {})
		    		index = 2
		    	end
		    end
		else
			--add photosynthesis modifier
			local manaRegen = 4
			local duration = self.energyBank / manaRegen --50/3 --16.666
			local tickInterval = 1 / manaRegen --mana per second    --.333

			Caster:AddNewModifier(Caster, self, "modifier_technologist_transformer", {duration = duration, manaRegen = manaRegen, tickInterval = tickInterval})
		end
		for k,unit in pairs(units) do
		    DealDamage(Caster, unit, damage, DAMAGE_TYPE_MAGICAL, nil)
--		    PopupNumbersFilter("shock",unit, damage, Caster)
		end
	end)

	Timers:CreateTimer(.5, function()
		ParticleManager:DestroyParticle(beamParticle, false)
		--ParticleManager:SetParticleControlEnt(beamParticle,1,Target,PATTACH_POINT_FOLLOW,"attach_hitloc",Target:GetAbsOrigin(),true)
    end)
end