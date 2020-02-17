
if modifier_fire_axe == nil then
    modifier_fire_axe = class({})
end

function modifier_fire_axe:IsHidden()
	return false
end

function modifier_fire_axe:IsPurgable()
	return false
end

function modifier_fire_axe:GetTexture()
    return "centaur_double_edge"
end

function modifier_fire_axe:DeclareFunctions()
    local funcs = {
    	MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS
 		MODIFIER_EVENT_ON_ATTACK_LANDED
    }
    return funcs
end

function modifier_fire_axe:GetAbilityDamageType()	
	return DAMAGE_TYPE_PHYSICAL
end


function modifier_fire_axe:GetModifierPreAttack_BonusDamage()	
	return self.damageBonus
end

function modifier_fire_axe:GetModifierBonusStats_Strength()	
	return self.strBonus
end

function modifier_fire_axe:GetModifierBonusStats_Intellect()	
	return self.intBonus
end

function modifier_fire_axe:OnCreated(data)
	self.damageBonus = self:GetAbility():GetSpecialValueFor("bonus_dmg") or 0
	self.strBonus = self:GetAbility():GetSpecialValueFor("bonus_str") or 0
	self.intBonus = self:GetAbility():GetSpecialValueFor("bonus_int") or 0
	
	if IsServer() then
		self.parent = self:GetParent()
		self.dmgMultiply = self:GetAbility():GetSpecialValueFor("dmg_perc")/100 or 0
		self.cleaveStRadius = 100
		self.cleaveEndRadius = 500
		self.cleaveDistance = 500
		self.think = 0.03
		
		self.particle_id = ParticleManager:CreateParticle("particles/units/heroes/hero_clinkz/clinkz_strafe.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
		self.parent:EmitSound("Hero_Clinkz.Strafe")

		self:StartIntervalThink(self.think)
	end
end

function modifier_fire_axe:OnAttackLanded(data)
	if IsServer() then
		if data.attacker == self:GetParent() then
			self.parent:EmitSound("Hero_PhantomAssassin.CoupDeGrace")
			self:ApplyDamage(data.target)
		end
	end
end


function modifier_fire_axe:OnDestroy()
	if IsServer() then
		if self.particle_id then
			ParticleManager:DestroyParticle(self.particle_id, false)
			ParticleManager:ReleaseParticleIndex(self.particle_id)
			self.particle_id = nil
		end
	end
end

function modifier_fire_axe:ApplyDamage(target)
	if self:GetParent() then
		local damage =  self.dmgMultiply*self.parent:GetAttackDamage()
		local particle = "particles/econ/items/sven/sven_ti7_sword/sven_ti7_sword_spell_great_cleave_gods_strength_crit.vpcf"
		DoCleaveAttack(self.parent, target, self, damage, self.cleaveStRadius, self.cleaveEndRadius, self.cleaveDistance, particle)
	end
end