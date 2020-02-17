LinkLuaModifier("modifier_meatboy_more_meat", "heroes/meatboy/more_meat", LUA_MODIFIER_MOTION_NONE)

function WarriorAttack(keys)
	local ability = keys.ability
	local target = keys.target
	local caster = keys.caster
	local owner = caster:GetOwner()
	
	if owner and not target:IsBuilding() then
		local damage = ability:GetSpecialValueFor("str_dmg") * owner:GetStrength()/100
		DealDamage(owner, target, damage, DAMAGE_TYPE_PHYSICAL, nil, ability)
	
	end
end

function MarsFriendStart(keys)
    local caster = keys.caster
    local ability = keys.ability
	local unit_name = "npc_dota_mars_friend"
	local point = caster:GetAbsOrigin()
	
	caster.friend = CreateUnitByName(unit_name, point + RandomVector(300), true, caster, caster, caster:GetTeamNumber())
	EmitSoundOn("hello_there", caster)
	local effect = "particles/econ/events/ti6/teleport_start_ti6_lvl3_shield.vpcf"
	local pfx = ParticleManager:CreateParticle(effect, PATTACH_ABSORIGIN_FOLLOW, caster.friend)
	ParticleManager:SetParticleControl(pfx, 0, caster.friend:GetAbsOrigin()) -- Origin

	local effect = "particles/econ/events/ti6/teleport_start_ti6_lvl3_rays.vpcf"
	local pfx1 = ParticleManager:CreateParticle(effect, PATTACH_ABSORIGIN_FOLLOW, caster.friend)
	ParticleManager:SetParticleControl(pfx1, 0, caster.friend:GetAbsOrigin()) -- Origin
end

function MarsFriendEnd(keys)
	local caster = keys.caster
	caster.friend:RemoveSelf()
end


