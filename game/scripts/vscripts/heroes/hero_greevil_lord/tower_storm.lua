
function PlayParticle( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local stun_duration = ability:GetSpecialValueFor("stun_duration")

--	EmitSoundOn("Hero_Leshrac.Lightning_Storm",target)
--	target:AddNewModifier(target, nil, "modifier_stunned", {duration = stun_duration})

	local effect = "particles/units/heroes/hero_disruptor/disruptor_thunder_strike_bolt.vpcf"
	local pfx = ParticleManager:CreateParticle(effect, PATTACH_ABSORIGIN_FOLLOW, target)
	local point = target:GetAbsOrigin()
	ParticleManager:SetParticleControl(pfx, 0, point) -- Origin
	ParticleManager:SetParticleControl(pfx, 1, Vector(point.x, point.y, point.z + 400)) -- Destination
	
end