function Genocide(keys)
	local caster = keys.caster
	local particle_index = keys.particle
	local sound = keys.sound
	local particle = ParticleManager:CreateParticle(particle_index, PATTACH_ABSORIGIN_FOLLOW, caster)
	ParticleManager:SetParticleControlEnt(particle, 0, caster, PATTACH_POINT_FOLLOW, "attach_eye", caster:GetAbsOrigin(), true)
--	EmitGlobalSound(sound)
	EmitSoundOn(sound, caster)

end

function GenocideMusic(keys)
	local sound = keys.sound
	local caster = keys.caster
--	EmitGlobalSound(sound)
	EmitSoundOn(sound, caster)

end

function GenocideEnd(keys)
	local sound = keys.sound
	local caster = keys.caster
--	StopSoundEvent(sound, keys.caster)
	StopSoundOn(sound, caster)
end
