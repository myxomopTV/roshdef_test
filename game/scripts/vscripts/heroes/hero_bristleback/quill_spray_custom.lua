
LinkLuaModifier( "modifier_bristleback_quill_spray_custom", "heroes/hero_bristleback/quill_spray_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bristleback_quill_spray_custom_buff", "heroes/hero_bristleback/quill_spray_custom", LUA_MODIFIER_MOTION_NONE )

bristleback_quill_spray_custom = class({})

function bristleback_quill_spray_custom:OnToggle()
	local caster = self:GetCaster()
	if self:GetToggleState() then
		caster:AddNewModifier( caster, self, "modifier_bristleback_quill_spray_custom_buff", nil )
	else
		caster:RemoveModifierByName("modifier_bristleback_quill_spray_custom_buff")
	end
end
function bristleback_quill_spray_custom:GetCastRange()
	return self:GetSpecialValueFor("radius")
end

function bristleback_quill_spray_custom:DoSpray()
	local ability = self
	local caster = self:GetCaster()
	local radius = self:GetSpecialValueFor("radius")
	local base_dmg = self:GetSpecialValueFor("base_dmg")
	local str_dmg = self:GetSpecialValueFor("str_dmg")*caster:GetStrength()/100
	local stack_dmg_pct = self:GetSpecialValueFor("stack_dmg_pct")/100
	local duration = self:GetSpecialValueFor("duration")
	local stack_dmg = 0
	
	local effect = "particles/units/heroes/hero_bristleback/bristleback_quill_spray.vpcf"
	local pfx = ParticleManager:CreateParticle(effect, PATTACH_ABSORIGIN_FOLLOW, caster)
	ParticleManager:SetParticleControl(pfx, 0, caster:GetAbsOrigin()) -- Origin
	ParticleManager:SetParticleControl(pfx, 2, Vector(radius,radius,radius)) -- Origin
	ParticleManager:ReleaseParticleIndex(pfx)

	EmitSoundOn( "Hero_Bristleback.QuillSpray.Cast", caster )

	local enemies = FindUnitsInRadius(caster:GetTeam(), 
									caster:GetAbsOrigin(), 
									nil, 
									radius, 
									DOTA_UNIT_TARGET_TEAM_ENEMY, 
									DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, 
									DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 
									FIND_ANY_ORDER, false)
	
	for i=1,#enemies do
		local enemy = enemies[i]
		if enemy:HasModifier("modifier_bristleback_quill_spray_custom") then
			local modifier = enemy:FindModifierByName("modifier_bristleback_quill_spray_custom")
			local stack_count = modifier:GetStackCount()
			stack_dmg = (base_dmg + str_dmg)*stack_dmg_pct*stack_count
		end
		local modifier = enemy:AddNewModifier(caster, self, "modifier_bristleback_quill_spray_custom", {duration = duration})
		modifier:IncrementStackCount()
		local damage = base_dmg + str_dmg + stack_dmg

		EmitSoundOn( "Hero_Bristleback.QuillSpray.Target", enemy )
		DealDamage(caster, enemy, damage, DAMAGE_TYPE_PHYSICAL, nil, ability)

		local effect = "particles/units/heroes/hero_bristleback/bristleback_quill_spray_impact.vpcf"
		local pfx = ParticleManager:CreateParticle(effect, PATTACH_ABSORIGIN_FOLLOW, enemy)
		ParticleManager:SetParticleControl(pfx, 0, enemy:GetAbsOrigin()) -- Origin
		ParticleManager:ReleaseParticleIndex(pfx)
			
	end

	if caster:HasModifier("modifier_bristleback_mega_quill_spray") and not caster:HasModifier("modifier_bristleback_mega_quill_spray_buff") then
		local modifier = caster:FindModifierByName("modifier_bristleback_mega_quill_spray")
		if modifier:GetStackCount() < 100 then
			modifier:IncrementStackCount()
		end
	end	
end

--------------------------------------------------------------------------------

modifier_bristleback_quill_spray_custom = class({
	IsHidden 				= function(self) return false end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return true end,
	IsBuff                  = function(self) return false end,
	RemoveOnDeath 			= function(self) return true end,
})

function modifier_bristleback_quill_spray_custom:OnCreated()
	local parent = self:GetParent()
	local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_bristleback/bristleback_quill_spray_hit_creep.vpcf", PATTACH_ABSORIGIN_FOLLOW, parent)

	ParticleManager:SetParticleControlEnt(particle, 1, parent, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", parent:GetAbsOrigin(), true)
	self:AddParticle(particle, false, false, -1, false, false)
end

modifier_bristleback_quill_spray_custom_buff = class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return true end,
})

function modifier_bristleback_quill_spray_custom_buff:OnCreated()
	if IsServer() then
		local ability = self:GetAbility()
		local interval = ability:GetSpecialValueFor("interval")
		self:StartIntervalThink(interval)
		ability:DoSpray()
	end
end

function modifier_bristleback_quill_spray_custom_buff:OnIntervalThink()
	local caster = self:GetCaster()
	local parent = self:GetParent()
	local ability = self:GetAbility()
	local current_mana  = caster:GetMana()
	local mana_required = ability:GetManaCost(-1)
	
	if current_mana > mana_required then
		caster:SetMana(caster:GetMana() - mana_required)
		ability:DoSpray()
	else
		ability:ToggleAbility()
	end
end
