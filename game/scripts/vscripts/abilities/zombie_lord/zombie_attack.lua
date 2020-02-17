LinkLuaModifier("modifier_zombie_attack", "abilities/zombie_lord/zombie_attack", LUA_MODIFIER_MOTION_NONE)

if not zombie_attack then zombie_attack=class({}) end

function zombie_attack:GetIntrinsicModifierName()
	return "modifier_zombie_attack"
end

modifier_zombie_attack = class({
	IsHidden 		= function(self) return true end,
	DeclareFunctions= function(self) return {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}end,
})
function modifier_zombie_attack:OnAttackLanded( data )
	local parent = self:GetParent()
	local target = data.target
	local attacker = data.attacker

	if parent == attacker and not target:IsMagicImmune() then
		local ability = self:GetAbility()
		local dmg_pct = ability:GetSpecialValueFor("dmg_pct")
		local health_missing_pct = target:GetMaxHealth()-target:GetHealth()
		local damage = health_missing_pct*dmg_pct/100
		
		DealDamage(parent, target, damage, DAMAGE_TYPE_PHYSICAL, nil, ability)
		print(damage)
	end
end

creature_zombie_attack = class(zombie_attack)
boss_zombie_attack = class(zombie_attack)