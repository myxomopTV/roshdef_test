
penguin_sledding_ride = class({})

LinkLuaModifier( "modifier_penguin_sledding_ride_start", "abilities/penguin_sledding_ride", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_sled_penguin_movement", "modifiers/modifier_sled_penguin_movement", LUA_MODIFIER_MOTION_HORIZONTAL )
LinkLuaModifier( "modifier_sled_penguin_crash", "modifiers/modifier_sled_penguin_crash", LUA_MODIFIER_MOTION_HORIZONTAL )
LinkLuaModifier( "modifier_sled_penguin_impairment", "modifiers/modifier_sled_penguin_impairment", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function penguin_sledding_ride:OnToggle()
	local caster = self:GetCaster()
	local point = caster:GetAbsOrigin()
	local team = caster:GetTeam()
	local name = "npc_dota_sled_penguin"
	
	if not IsValidEntity(caster.penguin) then
		local fw = caster:GetForwardVector()
		caster.penguin = CreateUnitByName( name , point, true, nil, nil, team )
		caster.penguin:AddAbility("sled_penguin_passive"):SetLevel(self:GetLevel())
		caster.penguin:SetForwardVector(fw)
		
		Timers:CreateTimer(0.01, function()
			ExecuteOrderFromTable({
			UnitIndex = caster:entindex(),	--индекс кастера
			TargetIndex = caster.penguin:entindex(),
			OrderType = DOTA_UNIT_ORDER_MOVE_TO_TARGET,	-- тип приказа
			})		
		end)

--		local modifier = self.penguin:AddNewModifier( caster, self, "modifier_penguin_sledding_ride_start", {})
--		modifier.hPlayerEnt = self.penguin	
	else
		caster.penguin:RemoveSelf()
--		caster:RemoveModifierByName("modifier_sled_penguin_movement")
	end
end



