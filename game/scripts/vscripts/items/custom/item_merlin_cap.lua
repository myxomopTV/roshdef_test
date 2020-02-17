
LinkLuaModifier( "modifier_item_merlin_cap", "items/custom/item_merlin_cap.lua", LUA_MODIFIER_MOTION_NONE )

item_merlin_cap = class({})

function item_merlin_cap:OnSpellStart()
	local caster = self:GetCaster()

	caster:AddNewModifier(caster, self, "modifier_item_merlin_cap", {})
	caster:RemoveItem(self)
end

--------------------------------------------------------------------------------

modifier_item_merlin_cap = class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	DeclareFunctions		= function(self) return 
		{
			MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE,
		} end,
})

function modifier_item_merlin_cap:OnCreated()
	local ability = self:GetAbility()
	local interval  = ability:GetSpecialValueFor("interval")
	self.cd_reduce = ability:GetSpecialValueFor("cd_reduce")
	self.hp_pct = ability:GetSpecialValueFor("hp_pct")/100
	self.mp_pct = ability:GetSpecialValueFor("mp_pct")/100

	self:StartIntervalThink(interval)
end

function modifier_item_merlin_cap:OnIntervalThink()
	local caster = self:GetCaster()

	if IsValidEntity(caster) and caster:IsAlive() then
	  	local effect = "particles/units/heroes/hero_keeper_of_the_light/keeper_of_the_light_chakra_magic.vpcf"
		local pfx = ParticleManager:CreateParticle(effect, PATTACH_ABSORIGIN_FOLLOW, caster)
		ParticleManager:SetParticleControl(pfx, 0, caster:GetAbsOrigin())
		ParticleManager:SetParticleControl(pfx, 1, caster:GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex(pfx)
		caster:EmitSound("Hero_KeeperOfTheLight.ChakraMagic.Target")

		local health_bonus = caster:GetMaxHealth()*self.hp_pct
		local mana_bonus = caster:GetMaxMana()*self.mp_pct

		caster:Heal(health_bonus, nil)
		caster:SetMana(caster:GetMana() + mana_bonus )
	end
end

function modifier_item_merlin_cap:GetModifierPercentageCooldown()
	return self.cd_reduce
end

