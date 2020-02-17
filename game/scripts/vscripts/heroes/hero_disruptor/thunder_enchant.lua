LinkLuaModifier("modifier_disruptor_thunder_enchant", "heroes/hero_disruptor/thunder_enchant", LUA_MODIFIER_MOTION_NONE)

disruptor_thunder_enchant = class({})

function disruptor_thunder_enchant:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	local buff_duration = self:GetSpecialValueFor("buff_duration")

	target:AddNewModifier(caster, self, "modifier_disruptor_thunder_enchant", {duration = buff_duration})
	
end
--------------------------------------------------------
------------------------------------------------------------
modifier_disruptor_thunder_enchant = class({
	IsHidden 				= function(self) return false end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	DeclareFunctions		= function(self) return 
		{
			MODIFIER_EVENT_ON_ATTACK_LANDED,
		} end,
})

function modifier_disruptor_thunder_enchant:GetEffectName() 	
	return "particles/units/heroes/hero_disruptor/disruptor_thunder_strike_buff.vpcf"
end

function modifier_disruptor_thunder_enchant:GetEffectAttachType()	
	return PATTACH_OVERHEAD_FOLLOW 
end

function modifier_disruptor_thunder_enchant:OnAttackLanded( params )
	if IsServer() then
		if params.attacker == self:GetParent() and ( not self:GetParent():IsIllusion() ) then

			local target = params.target
			if target ~= nil and target:GetTeamNumber() ~= self:GetParent():GetTeamNumber() and not target:IsBuilding() then
					local radius = self:GetAbility():GetSpecialValueFor("radius")
					local strike_dmg = self:GetAbility():GetSpecialValueFor("strike_dmg")
					local parent = self:GetParent()
					local parent_point = parent:GetAbsOrigin()
					local ability = self:GetAbility()

					local sound_impact = "Hero_Disruptor.ThunderStrike.Target"
					local strike_particle = "particles/units/heroes/hero_disruptor/disruptor_thunder_strike_bolt.vpcf"
					local aoe_particle = "particles/units/heroes/hero_disruptor/disruptor_thunder_strike_aoe.vpcf"
--					local stormbearer_buff = "modifier_imba_stormbearer"
					
					-- Play strike sound
					EmitSoundOn(sound_impact, target)
		
					-- Add bolt particle
					self.strike_particle_fx = ParticleManager:CreateParticle(strike_particle, PATTACH_ABSORIGIN, target)
					ParticleManager:SetParticleControl(self.strike_particle_fx, 0, Vector(parent_point.x, parent_point.y, parent_point.z + 300))
					ParticleManager:SetParticleControl(self.strike_particle_fx, 1, target:GetAbsOrigin())
					ParticleManager:SetParticleControl(self.strike_particle_fx, 2, target:GetAbsOrigin())
					
					-- Add Aoe particle
					self.aoe_particle_fx = ParticleManager:CreateParticle(aoe_particle, PATTACH_ABSORIGIN, target)
					ParticleManager:SetParticleControl(self.aoe_particle_fx, 0, target:GetAbsOrigin())
						
					local enemies = FindUnitsInRadius(parent:GetTeamNumber(),
													  target:GetAbsOrigin(),
													  nil,
													  radius,
													  DOTA_UNIT_TARGET_TEAM_ENEMY,
													  DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
													  DOTA_UNIT_TARGET_FLAG_NONE,
													  FIND_ANY_ORDER,
													  false)
														  
					for _,enemy in pairs(enemies) do
						-- Deal damage to appropriate enemies			
						if not enemy:IsMagicImmune() and not enemy:IsInvulnerable() then
										
							DealDamage(parent, enemy, strike_dmg, DAMAGE_TYPE_MAGICAL, nil, ability)
						end
					end
			end
		end
	end

	return 0
end

