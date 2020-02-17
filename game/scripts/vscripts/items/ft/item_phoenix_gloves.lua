

--------------------------------------------------------------------------------

item_phoenix_gloves = class({})
LinkLuaModifier( "modifier_item_phoenix_gloves", "items/ft/item_phoenix_gloves", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function item_phoenix_gloves:GetIntrinsicModifierName()
	return "modifier_item_phoenix_gloves"
end
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------


if modifier_item_phoenix_gloves == nil then
    modifier_item_phoenix_gloves = class({})
end

function modifier_item_phoenix_gloves:IsHidden()
	return false
end

function modifier_item_phoenix_gloves:IsPurgable()
	return false
end

function modifier_item_phoenix_gloves:GetTexture()
    return "centaur_double_edge"
end

function modifier_item_phoenix_gloves:RemoveOnDeath()
	return true
end

function modifier_item_phoenix_gloves:DeclareFunctions()
    local funcs = {
    	MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
    	MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
    	MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_EVENT_ON_ATTACK_LANDED
    }
    return funcs
end

function modifier_item_phoenix_gloves:GetAbilityDamageType()	
	return DAMAGE_TYPE_PHYSICAL
end


function modifier_item_phoenix_gloves:GetModifierPreAttack_BonusDamage()	
	return self.damageBonus
end

function modifier_item_phoenix_gloves:GetModifierBonusStats_Strength()	
	return self.strBonus
end

function modifier_item_phoenix_gloves:GetModifierBonusStats_Intellect()	
	return -self.intBonus
end

function modifier_item_phoenix_gloves:OnCreated(data)
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

function modifier_item_phoenix_gloves:OnIntervalThink()
	if self:GetParent() then
		if self.parent:GetMana() <= 0 or not self.parent:IsAlive() then
			self:Destroy()
		end
	end
end

function modifier_item_phoenix_gloves:OnAttackLanded(data)
	if IsServer() then
		if data.attacker == self:GetParent() then
			self.parent:EmitSound("Hero_PhantomAssassin.CoupDeGrace")
			self:ApplyDamage(data.target)
		end
	end
end


function modifier_item_phoenix_gloves:OnDestroy()
	if IsServer() then
		if self.particle_id then
			ParticleManager:DestroyParticle(self.particle_id, false)
			ParticleManager:ReleaseParticleIndex(self.particle_id)
			self.particle_id = nil
		end
	end
end

function modifier_item_phoenix_gloves:ApplyDamage(target)
	if self:GetParent() then
		local damage =  self.dmgMultiply*self.parent:GetAttackDamage()
		local particle = "particles/econ/items/sven/sven_ti7_sword/sven_ti7_sword_spell_great_cleave_gods_strength_crit.vpcf"
		DoCleaveAttack(self.parent, target, self, damage, self.cleaveStRadius, self.cleaveEndRadius, self.cleaveDistance, particle)
	end
end

