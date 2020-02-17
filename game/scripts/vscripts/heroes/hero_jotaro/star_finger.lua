LinkLuaModifier("modifier_jotaro_star_finger", "heroes/hero_jotaro/star_finger", LUA_MODIFIER_MOTION_NONE)
if not jotaro_star_finger then
	jotaro_star_finger = class({})
end
if not modifier_jotaro_star_finger then
	modifier_jotaro_star_finger = class({})
end
if IsServer() then
	function jotaro_star_finger:OnUpgrade()
		if not self.first then
			self.first = true
			self.mod = self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_jotaro_star_finger", {})
			self.mod:SetStackCount(self:GetSpecialValueFor("hits_num"))
			self:SetActivated(false)
			self.mod.check = false
		else
			if self.mod:GetStackCount() > self:GetSpecialValueFor("hits_num") then
				self.mod:SetStackCount(self:GetSpecialValueFor("hits_num"))
			end
		end
	end
	
	function jotaro_star_finger:OnSpellStart()
		self.mod:SetStackCount(self:GetSpecialValueFor("hits_num"))
		self.mod.check = false
		self:SetActivated(false)
		local caster = self:GetCaster()
		local target = self:GetCursorTarget()
		local damageTable = {
			victim = target,
			attacker = caster,
			damage = caster:GetAverageTrueAttackDamage(caster)*self:GetSpecialValueFor("multiplier"),
			damage_type = DAMAGE_TYPE_PURE,
			damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION ,
			ability = self,
		}
		caster:EmitSound("jotaro_star_finger")
		ApplyDamage(damageTable)
		local FX = ParticleManager:CreateParticle("particles/units/heroes/hero_tinker/tinker_laser.vpcf", PATTACH_POINT_FOLLOW, caster)
		ParticleManager:SetParticleControlEnt(FX, 9, caster, PATTACH_POINT_FOLLOW, "attach_attack2", caster:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(FX, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
		ParticleManager:ReleaseParticleIndex(FX)
	end
	function modifier_jotaro_star_finger:OnCreated(t)
		self.ab = self:GetAbility()
		self.parent = self:GetParent()
	end
	function modifier_jotaro_star_finger:DeclareFunctions()
		return {MODIFIER_EVENT_ON_ATTACK_LANDED}
	end
	function modifier_jotaro_star_finger:OnAttackLanded(t)
		if t.attacker == self.parent then
			local stacks = self:GetStackCount()
			if stacks > 0 then
				self:SetStackCount(stacks-1)
			end
			if stacks-1 <= 0 and not self.check then
				self.ab:SetActivated(true)
				self.check = true
			end
		end
	end
end
function modifier_jotaro_star_finger:GetAttributes()
    return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE + MODIFIER_ATTRIBUTE_PERMANENT
end