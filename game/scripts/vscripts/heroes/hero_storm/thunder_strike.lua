
storm_thunder_strike = class({})

function storm_thunder_strike:GetCastRange()
	return self:GetSpecialValueFor("cast_range")
end

function storm_thunder_strike:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	local base_damage = self:GetSpecialValueFor("base_damage")
	local int_damage = self:GetSpecialValueFor("int_damage")*caster:GetIntellect()
	local damage = base_damage + int_damage

	EmitSoundOn("Hero_Zuus.GodsWrath.Target", target)
	local effect = "particles/econ/items/zeus/arcana_chariot/zeus_arcana_blink_start.vpcf"
	local pfx = ParticleManager:CreateParticle(effect, PATTACH_ABSORIGIN_FOLLOW, target)
	ParticleManager:SetParticleControl(pfx, 0, target:GetAbsOrigin()) -- Origin
	ParticleManager:ReleaseParticleIndex(pfx)	

	DealDamage( caster, target, damage, DAMAGE_TYPE_MAGICAL, nil, self)
end



