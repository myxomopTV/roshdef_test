
LinkLuaModifier( "modifier_mark_intellect", "heroes/hero_mark/intellect.lua", LUA_MODIFIER_MOTION_NONE )

mark_intellect = class({})

function mark_intellect:OnSpellStart()
	local caster = self:GetCaster()
	local heal = self:GetSpecialValueFor("int_heal") * caster:GetIntellect() + self:GetSpecialValueFor("base_heal")

	local effect = "particles/units/heroes/hero_chen/chen_holy_persuasion_h_b.vpcf"
	local pfx = ParticleManager:CreateParticle(effect, PATTACH_ABSORIGIN_FOLLOW, caster)
	ParticleManager:SetParticleControl(pfx, 1, caster:GetAbsOrigin()) -- Origin
	ParticleManager:ReleaseParticleIndex(pfx)
	
	caster:Heal(heal, self)
end

function mark_intellect:GetIntrinsicModifierName()
	return "modifier_mark_intellect"
end
--------------------------------------------------------------------------------

modifier_mark_intellect = class({
	IsHidden 				= function(self) return false end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return true end,
	DeclareFunctions		= function(self) return 
		{MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE } end,
})

function modifier_mark_intellect:GetModifierPercentageCooldown()
	local stack_count = self:GetStackCount()
if stack_count >= 90 then
		return 90
	else
		return stack_count
	end
end

function modifier_mark_intellect:OnCreated()
	if IsServer() then
		local ability = self:GetAbility()
		self.value_need = 1/ability:GetSpecialValueFor("int_cooldown")
		self:StartIntervalThink(1)
	end
end

function modifier_mark_intellect:OnIntervalThink()
	local caster = self:GetCaster()
	local value = caster:GetIntellect()
	local stack_count = math.floor(value/ self.value_need)

	self:SetStackCount(stack_count)
	
end
