
LinkLuaModifier( "modifier_aniki_absorption_shield", "heroes/hero_aniki/absorption_shield", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_aniki_absorption_shield_buff", "heroes/hero_aniki/absorption_shield", LUA_MODIFIER_MOTION_NONE )

aniki_absorption_shield = class({})

function aniki_absorption_shield:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	local duration = self:GetSpecialValueFor("duration")

	target:AddNewModifier(caster, self, "modifier_aniki_absorption_shield", {duration = duration})
end

modifier_aniki_absorption_shield = class({
	IsHidden 				= function(self) return false end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return true end,
	DeclareFunctions		= function(self) return 
		{
			MODIFIER_EVENT_ON_TAKEDAMAGE,
		} end,
})

function modifier_aniki_absorption_shield:GetEffectName()
	return "particles/units/heroes/hero_abaddon/abaddon_borrowed_time.vpcf"
end

function modifier_aniki_absorption_shield:OnCreated()
	if IsServer() then
		local parent = self:GetParent()
		parent.old_health = parent:GetHealth()
		parent.total_damage = 0

		self:StartIntervalThink(1)
		parent:EmitSound("gachi_fisting_300")
	end
end

function modifier_aniki_absorption_shield:OnDestroy()
	if IsServer() then
		local parent = self:GetParent()
		local caster = self:GetCaster()
		local ability = self:GetAbility()
		local shield_duration = ability:GetSpecialValueFor("shield_duration")

		parent:AddNewModifier(caster, ability, "modifier_aniki_absorption_shield_buff", {duration = shield_duration})
	end
end

function modifier_aniki_absorption_shield:OnIntervalThink()
	local parent = self:GetParent()
	parent.old_health = parent:GetHealth()
	
end

function modifier_aniki_absorption_shield:OnTakeDamage( params )
    if IsServer() then
        local parent = self:GetParent()
        local Target = params.unit
        local Attacker = params.attacker
        local Ability = params.inflictor
        local flDamage = params.damage
--        local lifesteal_pct = self:GetAbility():GetSpecialValueFor("lifesteal_pct")
        
        if Target ~= nil and Target == parent  then
        	if flDamage <= 1000 and RollPercentage(100) then
        		parent:EmitSound("gachi_cry")
        	elseif flDamage > 1000 and RollPercentage(100) then
        		parent:EmitSound("gachi_wellcry")
        	end

--            local heal =  flDamage * lifesteal_pct / 100 
--            parent:Heal( heal, self:GetAbility() )
--            local nFXIndex = ParticleManager:CreateParticle( "particles/generic_gameplay/generic_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, parent )
--            ParticleManager:ReleaseParticleIndex( nFXIndex )
			parent.total_damage = parent.total_damage + flDamage
			parent:SetHealth(parent.old_health)
        end
    end
    return 0
end

modifier_aniki_absorption_shield_buff = class({
	IsHidden 				= function(self) return false end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return true end,
	DeclareFunctions		= function(self) return 
		{
			MODIFIER_EVENT_ON_TAKEDAMAGE,
		} end,
})


function modifier_aniki_absorption_shield_buff:OnCreated()
	if IsServer() then
		local parent = self:GetParent()
		local ability = self:GetAbility()
		local dmg_convert = ability:GetSpecialValueFor("dmg_convert")/100

		parent.absorption_shield = parent.total_damage*dmg_convert
		parent.old_health = parent:GetHealth()
		parent.total_damage = 0

		local particle = "particles/econ/items/abaddon/abaddon_alliance/abaddon_aphotic_shield_alliance.vpcf"
		local particle_fx = ParticleManager:CreateParticle(particle, PATTACH_ABSORIGIN_FOLLOW, parent)
		ParticleManager:SetParticleControl(particle_fx, 0, parent:GetAbsOrigin())
		ParticleManager:SetParticleControl(particle_fx, 1, Vector(150, 1, 150))
		self:AddParticle(particle_fx, true, false, 100, false, false)

		self:StartIntervalThink(1)
		parent:EmitSound("gachi_slaves_get")
	end
end

function modifier_aniki_absorption_shield_buff:OnIntervalThink()
	local parent = self:GetParent()
	parent.old_health = parent:GetHealth()
	
end

function modifier_aniki_absorption_shield_buff:OnTakeDamage( params )
    if IsServer() then
        local parent = self:GetParent()
        local Target = params.unit
        local Attacker = params.attacker
        local Ability = params.inflictor
        local flDamage = params.damage
        local shield_remaining = parent.absorption_shield
        print("shield_remaining = "..shield_remaining)
        
        if Target ~= nil and Target == parent  then
			if flDamage > shield_remaining then
				local newHealth = parent.old_health - flDamage + shield_remaining
				parent:SetHealth(newHealth)
			else
				local newHealth = parent.old_health			
				parent:SetHealth(newHealth)
			end
			-- Reduce the shield remaining and remove
			parent.absorption_shield = parent.absorption_shield - flDamage
			if parent.absorption_shield <= 0 then
				parent.absorption_shield = nil
				self:Destroy()
			end
        end
    end
    return 0
end