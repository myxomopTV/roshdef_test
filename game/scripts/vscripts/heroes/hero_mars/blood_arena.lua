
function ParticleStart(keys)
	local target = keys.target
    local ability = keys.ability
	local radius = ability:GetSpecialValueFor("radius")

	local effect = "particles/units/heroes/hero_mars/mars_arena_of_blood_colosseum_columns.vpcf"
	ability.pfx = ParticleManager:CreateParticle(effect, PATTACH_ABSORIGIN_FOLLOW, target)
	ParticleManager:SetParticleControl(ability.pfx, 0, target:GetAbsOrigin()) -- Origin
	ParticleManager:SetParticleControl(ability.pfx, 1, Vector(radius, 0, 0)) -- Origin
	ParticleManager:SetParticleControl(ability.pfx, 2, target:GetAbsOrigin()) -- Origin

	local effect = "particles/units/heroes/hero_mars/mars_arena_of_blood_decal.vpcf"
	ability.pfx1 = ParticleManager:CreateParticle(effect, PATTACH_ABSORIGIN_FOLLOW, target)
	ParticleManager:SetParticleControl(ability.pfx1, 0, target:GetAbsOrigin()) -- Origin
	ParticleManager:SetParticleControl(ability.pfx1, 1, Vector(radius, 0, 0)) -- Origin
end

function ParticleEnd(keys)
	local ability = keys.ability
	ParticleManager:DestroyParticle(ability.pfx, true)
	ParticleManager:ReleaseParticleIndex(ability.pfx)
	ParticleManager:DestroyParticle(ability.pfx1, true)
	ParticleManager:ReleaseParticleIndex(ability.pfx1)
end
