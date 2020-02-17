greevil_black_return = class({})

LinkLuaModifier("modifier_greevil_black_return", "abilities/greevil_black_return", LUA_MODIFIER_MOTION_NONE)

function greevil_black_return:GetAbilityTextureName()
	return "greevil_black_return"
end
function greevil_black_return:GetIntrinsicModifierName()
	return "modifier_greevil_black_return"
end

modifier_greevil_black_return = class({
	IsPurgable = function() return false end,
	IsHidden = function() return true end,
})

if IsServer() then
	function modifier_greevil_black_return:DeclareFunctions()
		return {MODIFIER_EVENT_ON_TAKEDAMAGE}
	end

	function modifier_greevil_black_return:OnTakeDamage(event)
		if event.unit == self:GetParent() then
			local unit = event.unit
			local attacker = event.attacker
			if attacker:IsAlive() and attacker:GetTeamNumber() ~= unit:GetTeamNumber() and event.damage_type == DAMAGE_TYPE_PHYSICAL and not HasDamageFlag(event.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION) then
				ApplyDamage({
					victim = attacker,
					attacker = unit,
					damage = event.original_damage * (self:GetAbility():GetSpecialValueFor("damage_return") * 0.01),
					damage_type = DAMAGE_TYPE_PHYSICAL,
					damage_flags = DOTA_DAMAGE_FLAG_REFLECTION,
					ability = self:GetAbility()
				})
			end
        end
    end
end