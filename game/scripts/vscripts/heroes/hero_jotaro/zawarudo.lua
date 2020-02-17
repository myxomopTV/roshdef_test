LinkLuaModifier("modifier_jotaro_zawarudo", "heroes/hero_jotaro/zawarudo", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_jotaro_zawarudo_debuff", "heroes/hero_jotaro/zawarudo", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_jotaro_zawarudo_buff", "heroes/hero_jotaro/zawarudo", LUA_MODIFIER_MOTION_NONE)
if not jotaro_zawarudo then
	jotaro_zawarudo = class({})
end
if not modifier_jotaro_zawarudo then
	modifier_jotaro_zawarudo = class({})
end
if not modifier_jotaro_zawarudo_debuff then
	modifier_jotaro_zawarudo_debuff = class({})
end
if not modifier_jotaro_zawarudo_buff then
	modifier_jotaro_zawarudo_buff = class({})
end
function jotaro_zawarudo:GetCastRange()
	return self:GetSpecialValueFor("radius")
end

if IsServer() then
	function jotaro_zawarudo:OnAbilityPhaseStart()
		local caster = self:GetCaster()
		
		caster:EmitSound("jotaro_zawarudo_start")
		return true
	end
	function jotaro_zawarudo:OnSpellStart()
		local caster = self:GetCaster()
		
		local duration = self:GetSpecialValueFor("duration")
--		CreateModifierThinker(caster, self, "modifier_jotaro_zawarudo", {duration = duration}, caster:GetOrigin(), caster:GetTeamNumber(), false)
		caster:AddNewModifier(caster, self, "modifier_jotaro_zawarudo_buff", {duration = duration})
		caster:AddNewModifier(caster, self, "modifier_jotaro_zawarudo", {duration = duration})
	end

	function modifier_jotaro_zawarudo:OnCreated(t)
		self.ab = self:GetAbility()
		self.parent = self:GetParent()
		self.radius = self.ab:GetSpecialValueFor("radius") 
--		local nfx3 = ParticleManager:CreateParticle("particles/units/heroes/hero_faceless_void/faceless_void_chronosphere.vpcf", PATTACH_POINT, self.parent)
--        ParticleManager:SetParticleControl(nfx3, 0, self.parent:GetOrigin())
--        ParticleManager:SetParticleControl(nfx3, 1, Vector(self.radius, self.radius, self.radius))
		self.particle_ground = ParticleManager:CreateParticle("particles/dio/dio_sphere_ground.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		ParticleManager:SetParticleControl(self.particle_ground, 0, self:GetParent():GetAbsOrigin())
		ParticleManager:SetParticleControl(self.particle_ground, 1, Vector(450, 450, 1))

		self.particle_sphere = ParticleManager:CreateParticle("particles/dio/dio_stand.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		ParticleManager:SetParticleControl(self.particle_sphere, 0, self:GetParent():GetAbsOrigin())
		ParticleManager:SetParticleControl(self.particle_sphere, 1, Vector(0, 0, 1))
		local interval_count = 30
		local radius_grow = self.radius/ interval_count
		for interval = 1,30 do
			Timers:CreateTimer(0.03*interval,function ()
				local radius = radius_grow*interval
				ParticleManager:SetParticleControl(self.particle_sphere, 1, Vector(radius, radius, 1))
			end)
		end
	    self:AddParticle(self.particle_ground, true, false, 101, false, false)
	    self:AddParticle(self.particle_sphere, true, false, 101, false, false)
--        ParticleManager:ReleaseParticleIndex(nfx3)
	end
	function modifier_jotaro_zawarudo:OnDestroy()
		self.parent:EmitSound("jotaro_zawarudo_end")
	end
	function modifier_jotaro_zawarudo:GetAuraRadius()
		return self.radius
	end
	function modifier_jotaro_zawarudo:GetAuraSearchTeam()
		return DOTA_UNIT_TARGET_TEAM_ENEMY
	end
	function modifier_jotaro_zawarudo:GetAuraSearchType()
		return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_BUILDING
	end
	function modifier_jotaro_zawarudo:GetModifierAura()
		return "modifier_jotaro_zawarudo_debuff"
	end
	function modifier_jotaro_zawarudo:IsAura()
		return true
	end
end
function modifier_jotaro_zawarudo:GetAttributes()
    return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE + MODIFIER_ATTRIBUTE_PERMANENT
end
function modifier_jotaro_zawarudo_buff:GetAttributes()
    return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE + MODIFIER_ATTRIBUTE_PERMANENT
end
function modifier_jotaro_zawarudo_buff:OnCreated(t)
	self.ab = self:GetAbility()
	self.parent = self:GetParent()
	self.bat = self.ab:GetSpecialValueFor('bat')
	self.ms = self.ab:GetSpecialValueFor('ms')
end
function modifier_jotaro_zawarudo_buff:GetModifierBaseAttackTimeConstant(t)
	return self.bat
end
function modifier_jotaro_zawarudo_buff:GetModifierMoveSpeedBonus_Constant(t)
	return self.ms
end
function modifier_jotaro_zawarudo_buff:DeclareFunctions()
	return {MODIFIER_PROPERTY_BASE_ATTACK_TIME_CONSTANT,MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT}
end
function modifier_jotaro_zawarudo_debuff:CheckState(self)
    return {[MODIFIER_STATE_DISARMED] = true,
    		[MODIFIER_STATE_STUNNED] = true,
    		[MODIFIER_STATE_FROZEN] = true, 
    		[MODIFIER_STATE_MUTED] = true, 
    		[MODIFIER_STATE_SILENCED] = true}
end
function modifier_jotaro_zawarudo_debuff:GetAttributes()
    return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE + MODIFIER_ATTRIBUTE_PERMANENT
end