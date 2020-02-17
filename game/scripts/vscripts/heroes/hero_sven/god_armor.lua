LinkLuaModifier("modifier_sven_god_armor", "heroes/hero_sven/god_armor", LUA_MODIFIER_MOTION_NONE)

sven_god_armor = class({})

function sven_god_armor:GetIntrinsicModifierName()
	return "modifier_sven_god_armor"
end

modifier_sven_god_armor = class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	DeclareFunctions		= function(self) return 
		{
			MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
			MODIFIER_PROPERTY_STATUS_RESISTANCE,
		} end,
})
function modifier_sven_god_armor:OnCreated()	
	local parent = self:GetParent()
	local point = parent:GetAbsOrigin()
	local effect = "particles/econ/items/sven/sven_warcry_ti5/sven_spell_warcry_ti_5.vpcf"
	local pfx = ParticleManager:CreateParticle(effect, PATTACH_ABSORIGIN_FOLLOW, parent)
	ParticleManager:ReleaseParticleIndex(pfx)
	
	EmitSoundOn("Hero_Sven.WarCry", parent)
end

function modifier_sven_god_armor:GetEffectName()
	return "particles/econ/items/sven/sven_warcry_ti5/sven_warcry_buff_ti_5.vpcf"
end

function modifier_sven_god_armor:GetModifierIncomingDamage_Percentage()
	return self:GetAbility():GetSpecialValueFor("dmg_resist")*(-1)
end

function modifier_sven_god_armor:GetModifierStatusResistance()
	return self:GetAbility():GetSpecialValueFor("status_resist")
end
