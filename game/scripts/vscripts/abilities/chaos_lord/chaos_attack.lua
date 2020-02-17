LinkLuaModifier("modifier_chaos_attack", "abilities/chaos_lord/chaos_attack", LUA_MODIFIER_MOTION_NONE)

if not chaos_attack then chaos_attack = class({}) end

function chaos_attack:GetIntrinsicModifierName()
	return "modifier_chaos_attack"
end

modifier_chaos_attack = class({
	IsHidden 			= function(self) return true end,
	DeclareFunctions  	= function(self) return
		{MODIFIER_EVENT_ON_ATTACK_LANDED}
	end,
})

function modifier_chaos_attack:OnAttackLanded(data)
	local target = data.target
	local attacker = data.attacker
	local parent = self:GetParent()

	if parent == attacker and not target:IsMagicImmune() then
		local point = target:GetAbsOrigin()
		local ability = self:GetAbility()
		local radius = ability:GetSpecialValueFor("radius")
		local damage = ability:GetSpecialValueFor("damage")

		local effect = "particles/econ/items/shadow_fiend/sf_fire_arcana/sf_fire_arcana_shadowraze.vpcf"
		local pfx = ParticleManager:CreateParticle(effect, PATTACH_ABSORIGIN, parent)
		ParticleManager:SetParticleControl(pfx, 0, point)
		ParticleManager:SetParticleControl(pfx, 1, Vector(radius, radius, radius))
		ParticleManager:ReleaseParticleIndex(pfx)

		target:EmitSound("Hero_Nevermore.Shadowraze")

		local enemies = parent:FindEnemyUnitsInRadius(point, radius, nil)

		for _,enemy in ipairs(enemies) do
			DealDamage( parent, enemy, damage, DAMAGE_TYPE_MAGICAL, nil, ability )
		end
	end
end

creature_chaos_attack = class (chaos_attack)
boss_chaos_attack = class (chaos_attack)