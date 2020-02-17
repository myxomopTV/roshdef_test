
function ParticleStart(keys)
	local target = keys.target
    local ability = keys.ability
	local radius = ability:GetSpecialValueFor("far_radius")
	
	EmitSoundOn("Hero_Enigma.Black_Hole", target)
	local effect = "particles/other/mega_black_hole.vpcf"
	ability.pfx = ParticleManager:CreateParticle(effect, PATTACH_ABSORIGIN_FOLLOW, target)
	ParticleManager:SetParticleControl(ability.pfx, 0, target:GetAbsOrigin()) -- Origin
	ParticleManager:SetParticleControl(ability.pfx, 1, Vector(radius, radius, radius)) -- Origin
	ParticleManager:SetParticleControl(ability.pfx, 2, Vector(radius, radius, radius)) -- Origin

end

function ParticleEnd(keys)
	local target = keys.target
	local ability = keys.ability
	ParticleManager:DestroyParticle(ability.pfx, true)
	ParticleManager:ReleaseParticleIndex(ability.pfx)
	StopSoundOn("Hero_Enigma.Black_Hole",target)
	EmitSoundOn("Hero_Enigma.Black_Hole.Stop",target)
end
