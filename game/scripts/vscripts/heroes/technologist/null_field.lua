if customability_technologist_null_field == nil then
    customability_technologist_null_field = class({})
end


LinkLuaModifier( "modifier_technologist_energized", "heroes/technologist/modifiers/energy_system.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_technologist_energized_stack", "heroes/technologist/modifiers/energy_system.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_technologist_energized_failsafe", "heroes/technologist/modifiers/energy_system.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_technologist_null_field", "heroes/technologist/modifiers/null_field.lua", LUA_MODIFIER_MOTION_NONE )


function customability_technologist_null_field:OnUpgrade() 
	self.damagePerc = (5 + (self:GetLevel() * .83)) / 100
end

function customability_technologist_null_field:GetManaCost()
	return 30
end

function customability_technologist_null_field:GetAOERadius()
	return 200
end

function customability_technologist_null_field:OnSpellStart()
	local Caster = self:GetCaster()
	local Target = false
	if not self:GetCursorTargetingNothing() then
        Target = self:GetCursorTarget()
    end
    self.point = self:GetCursorPosition()

    local mod = Caster:FindModifierByName("modifier_technologist_energy")
    mod:ModifyStacks(-self:GetManaCost(-1))

    Caster:AddNewModifier(Caster, self, "modifier_technologist_energized_failsafe", {duration = 10})

    self.radius = self:GetAOERadius()
    local duration = 6

    EmitSoundOnLocationWithCaster(Caster:GetAbsOrigin(), "Hero_Disruptor.KineticField", Caster)

    self.nullField = ParticleManager:CreateParticle("particles/technologist/null_field.vpcf", PATTACH_ABSORIGIN, Caster)
    ParticleManager:SetParticleControl(self.nullField,0,self.point)

    local expireTime = GameRules:GetGameTime() + duration

    Timers:CreateTimer({callback = function()
			local damage = Caster:GetIntellect() * self.damagePerc

			local units = FindUnitsInRadius( Caster:GetTeamNumber(), self.point, nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
			for key,unit in pairs(units) do
			   	DealDamage(Caster, unit, damage, DAMAGE_TYPE_MAGICAL, nil, self)
 --       		PopupNumbersFilter("shock",unit, damage, Caster)

        		local mod = unit:FindModifierByName("modifier_technologist_energized_stack")
        		if mod then
        			mod:Destroy()
        		end
			end

			if expireTime < GameRules:GetGameTime() then
				return false
			end
			
			return .5
		end
	})

    Timers:CreateTimer({callback = function()
			local units = FindUnitsInRadius( Caster:GetTeamNumber(), self.point, nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
			for key,unit in pairs(units) do
			   	unit:AddNewModifier( Caster, ability, "modifier_technologist_null_field", {duration = .5} )
			end

			if expireTime < GameRules:GetGameTime() then
				ParticleManager:DestroyParticle(self.nullField, false)

				local mod = Caster:FindModifierByName("modifier_technologist_energy")
			    mod:ModifyStacks(self:GetManaCost(-1))
			    PopupNumbersFilter("energy",  Caster, self:GetManaCost(-1), Caster )
				return false
			end
			
			return .1
		end
	})
end