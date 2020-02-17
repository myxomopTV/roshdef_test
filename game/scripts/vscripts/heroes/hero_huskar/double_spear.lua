LinkLuaModifier("modifier_huskar_double_spear", "heroes/hero_huskar/double_spear", LUA_MODIFIER_MOTION_NONE)

if not huskar_double_spear then huskar_double_spear = class({}) end

function huskar_double_spear:GetIntrinsicModifierName()
	return "modifier_huskar_double_spear"
end


modifier_huskar_double_spear = class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return true end,
	DeclareFunctions		= function(self) return 
		{   MODIFIER_EVENT_ON_ATTACK} end,
})

function modifier_huskar_double_spear:OnAttack(params)
	if not IsServer() then return end
	local attacker = params.attacker
	local caster = self:GetCaster()
	local ability = self:GetAbility()


	if attacker == caster and ability.split ~= false   then

		local attack_range = caster:Script_GetAttackRange() + 100
		local arrow_count = ability:GetSpecialValueFor("arrow_count")
		local attack_interval = ability:GetSpecialValueFor("attack_interval")
		local trigger_chance = ability:GetSpecialValueFor("trigger_chance")
		
		if RollPercentage(trigger_chance) then
			Timers:CreateTimer(attack_interval, function()
				local units = FindUnitsInRadius(caster:GetTeamNumber(), 
												caster:GetAbsOrigin(),
												nil,
												attack_range,
												DOTA_UNIT_TARGET_TEAM_ENEMY,
												DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_BUILDING, 
												DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE,
												FIND_ANY_ORDER, 
												false) 
				
				ability.split = false 
				if arrow_count > #units  then 
					arrow_count = #units
				end

				local index = 1
				local arrow_deal = 0
				
				while arrow_deal < arrow_count   do
--					if units[index] == target then
--						print("bingo!!!")
--					else
						caster:PerformAttack(units[ index ], false, true, true, false, true, false, false)
						arrow_deal = arrow_deal + 1
--					end	
					index = index + 1
				end
				
				ability.split = true
			end)
		end
	end
	
end
