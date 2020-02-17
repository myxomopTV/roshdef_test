greevil_portal = class({})

LinkLuaModifier("modifier_greevil_portal", "abilities/greevil_portal", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_greevil", "abilities/greevil_portal", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_greevil_fly", "abilities/greevil_portal", LUA_MODIFIER_MOTION_NONE)

function greevil_portal:GetAbilityTextureName()
	return "rubick_empty1"
end
function greevil_portal:GetIntrinsicModifierName()
	return "modifier_greevil_portal"
end

modifier_greevil_portal = class({
	IsPurgable = function() return false end,
	IsHidden = function() return true end,
})

if IsServer() then
	function modifier_greevil_portal:OnCreated(kv)
		self:StartIntervalThink(10.0)
	end

	function modifier_greevil_portal:OnIntervalThink()
		if GameRules:State_Get() == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
			local greevils = FindGreevilsInRadius(Vector(0,0,0), 9000)
			if #greevils < 10 then
				local greevilName = "npc_greevil_naked"
				if RollPercentage(25) then
					greevilName = "npc_greevil_red"
				end
				if RollPercentage(25) then
					greevilName = "npc_greevil_blue"
				end
				if RollPercentage(25) then
					greevilName = "npc_greevil_white"
				end
				if RollPercentage(25) then
					greevilName = "npc_greevil_black"
				end
				local greevil = CreateUnitByName(greevilName, self:GetParent():GetOrigin(), false, nil, nil, DOTA_TEAM_NEUTRALS)
				greevil:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_greevil", {})
				greevil:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_greevil_fly", {})

				local greevilPos = greevil:GetOrigin()
				local landPoint = Vector(0,0,0) + RandomVector(RandomFloat(600, MAP_BORDER_RADIUS))
				local direction = (landPoint - greevilPos):Normalized()
				local distance = (landPoint - greevilPos):Length2D()
				local height = 600
				local time = 4.0
				local flySpeed = distance / time
				local flyTime = distance / flySpeed

				local currentTime = 0
				Timers:CreateTimer(0.03, function()
					currentTime = currentTime + 0.03

					local currentHeight
					if currentTime <= (flyTime / 2) then
						currentHeight = height * currentTime / flyTime * 2
					else
						currentHeight = height * (1 - currentTime / flyTime) * 2
					end

					local current_position = greevilPos + direction * distance * currentTime / flyTime

					greevil:SetOrigin(Vector(current_position.x, current_position.y, GetGroundHeight(current_position, greevil) + currentHeight))
					
					if currentTime < flyTime then
						return 0.03
					else
						greevil:RemoveModifierByName("modifier_greevil_fly")
						FindClearSpaceForUnit(greevil, greevil:GetOrigin(), true)
					end
				end)
			end
		end
	end
end

modifier_greevil = class({
	IsPurgable = function() return false end,
	IsHidden = function() return true end,
})

if IsServer() then
	function modifier_greevil:OnCreated(kv)
		self:StartIntervalThink(0.1)
	end

	function modifier_greevil:OnIntervalThink()
		local movePoint = nil
		local moveCause = ""
		if not self:GetParent():IsAttacking() and not self:GetParent():IsMoving() then
			movePoint = Vector(0,0,0) + RandomVector(RandomFloat(600, MAP_BORDER_RADIUS))
			moveCause = "move"
		end
		--[[if not self:GetParent():IsAttacking() and (self:GetParent():GetOrigin() - Vector(0,0,0)):Length2D() < 1800 then
			movePoint = self:GetParent():GetOrigin() + (self:GetParent():GetOrigin() - Vector(0,0,0)):Normalized() * 500
			moveCause = "moveFromCenter"
		end]]
		if moveCause == "move" and movePoint ~= nil then
			ExecuteOrderFromTable({
				UnitIndex = self:GetParent():entindex(),
				OrderType = DOTA_UNIT_ORDER_ATTACK_MOVE,
				Position = movePoint
			})
		end
		--[[if moveCause == "moveFromCenter" and movePoint ~= nil then
			ExecuteOrderFromTable({
				UnitIndex = self:GetParent():entindex(),
				OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
				Position = movePoint
			})
		end]]
	end
end

modifier_greevil_fly = class({
	IsPurgable = function() return false end,
	IsHidden = function() return true end,
})

function modifier_greevil_fly:CheckState() 
	return {
		[MODIFIER_STATE_STUNNED] = true,
		[MODIFIER_STATE_INVULNERABLE] = true
	}
end

function modifier_greevil_fly:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION
	}
end

function modifier_greevil_fly:GetOverrideAnimation()
	return ACT_DOTA_FLAIL
end