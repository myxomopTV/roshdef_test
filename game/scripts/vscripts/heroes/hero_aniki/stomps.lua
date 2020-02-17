
LinkLuaModifier( "modifier_aniki_stomps", "heroes/hero_aniki/stomps", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_aniki_stomps_debuff", "heroes/hero_aniki/stomps", LUA_MODIFIER_MOTION_NONE )

aniki_stomps = class({})

function aniki_stomps:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	local duration = self:GetSpecialValueFor("duration")

	caster:AddNewModifier(caster, self, "modifier_aniki_stomps", {duration = duration})
end

modifier_aniki_stomps = class({
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

function modifier_aniki_stomps:OnCreated()
	if IsServer() then
		local ability = self:GetAbility()
		local interval = ability:GetSpecialValueFor("interval")
		self:OnIntervalThink()

		self:StartIntervalThink(interval)
	end
end

function modifier_aniki_stomps:OnDestroy()
	if IsServer() then
		local parent = self:GetParent()
		local caster = self:GetCaster()
		local ability = self:GetAbility()

	end
end

function modifier_aniki_stomps:OnIntervalThink()
	local caster = self:GetCaster()
	local position = caster:GetAbsOrigin()
	local ability = self:GetAbility()
	local radius = ability:GetSpecialValueFor("radius")
	local health_damage = ability:GetSpecialValueFor("health_damage")*caster:GetMaxHealth()/100
	local damage = ability:GetSpecialValueFor("base_damage") + health_damage
	local debuff_duration = ability:GetSpecialValueFor("debuff_duration")

	caster:EmitSound("n_creep_Spawnlord.Stomp")
	caster:StartGestureWithPlaybackRate(ACT_DOTA_CAST_ABILITY_1, 2)
	local particle = "particles/neutral_fx/neutral_prowler_shaman_stomp.vpcf"
	local particle_fx = ParticleManager:CreateParticle(particle, PATTACH_ABSORIGIN, caster)
	ParticleManager:SetParticleControl(particle_fx, 0, caster:GetAbsOrigin())
	ParticleManager:ReleaseParticleIndex(particle_fx)

	local enemies = caster:FindEnemyUnitsInRadius(position, radius, nil)

	for _,enemy in ipairs(enemies) do
		DealDamage(caster, enemy, damage, DAMAGE_TYPE_PHYSICAL, nil, ability)
		local modifier = enemy:AddNewModifier(caster, ability, "modifier_aniki_stomps_debuff", {duration = debuff_duration})

	end
end

modifier_aniki_stomps_debuff = class({
	IsHidden 				= function(self) return false end,
	IsPurgable 				= function(self) return true end,
	IsDebuff 				= function(self) return true end,
	IsBuff                  = function(self) return false end,
	RemoveOnDeath 			= function(self) return true end,
	DeclareFunctions		= function(self) return 
		{
			MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		} end,
})

function modifier_aniki_stomps_debuff:OnRefresh()
	self:IncrementStackCount()
end

function modifier_aniki_stomps_debuff:GetModifierPhysicalArmorBonus()
	return self:GetAbility():GetSpecialValueFor("stack_armor")*self:GetStackCount()*(-1)
end

function modifier_aniki_stomps_debuff:GetEffectName()
	return "particles/neutral_fx/neutral_prowler_shaman_stomp_debuff.vpcf"
end

function modifier_aniki_stomps_debuff:GetEffectAttachType()
	return "PATTACH_OVERHEAD_FOLLOW"
end
