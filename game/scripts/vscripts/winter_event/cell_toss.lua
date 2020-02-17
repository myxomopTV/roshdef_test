cell_toss = class({})
LinkLuaModifier("modifier_cell_toss", "winter_event/cell_toss", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_cell_toss_passive", "winter_event/cell_toss", LUA_MODIFIER_MOTION_NONE)


function cell_toss:GetAOERadius()
    return self:GetSpecialValueFor("radius")
end

function cell_toss:GetIntrinsicModifierName()
	return "modifier_cell_toss_passive"
end

modifier_cell_toss_passive = class({
	IsHidden = function(self) return true end,
	OnCreated = function(self) self:StartIntervalThink(0.1) end,
})

function modifier_cell_toss_passive:OnIntervalThink()
	local parent = self:GetParent()
	local point = parent:GetAbsOrigin()
	local ability = self:GetAbility()
	local radius = ability:GetSpecialValueFor("radius")

	local team = parent:GetTeamNumber()
	local iTeam = DOTA_UNIT_TARGET_TEAM_ENEMY
	local iType = DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO
	local iFlag = DOTA_UNIT_TARGET_FLAG_NONE
	local iOrder =  FIND_ANY_ORDER

	local units = FindUnitsInRadius(team, point, nil, radius, iTeam, iType, iFlag, iOrder, false)
--	local units = parent:FindEnemyUnitsInRadius(point, radius, nil)

	local unit = units[1]
	if unit and not unit.toss then
		local cell_type = parent.cell_type or nil
		local cell_index = parent.cell_index or 2
		local sound = "jump_up"

		if cell_type == "up" then
			if cell_index >= 13 and cell_index <= 15 then
				cell_index = 20
			else
				cell_index = cell_index + 3
			end
			sound = "jump_up"
		elseif cell_type == "down" then
			if cell_index <= 3 then
				cell_index = 0
			elseif cell_index%3 == 0 then
				cell_index = cell_index - 5
			else
				cell_index = cell_index - 2
			end
			sound = "jump_down"
		elseif cell_type == "side" then
			if cell_index % 3 == 0 then
				cell_index = cell_index - 2
			else
				cell_index = cell_index + 1
			end
			sound = "jump_side"
		elseif cell_type == "secret" then
			cell_index = 16
			sound = "jump_side"
		end

	    ability.position = Entities:FindByName(nil, "cell_point_"..cell_index):GetAbsOrigin() 
	    local duration = CalculateDistance(ability.position, point) / ability:GetSpecialValueFor("duration") * FrameTime()

--	    EmitSoundOn("Ability.TossThrow", parent)
--		EmitSoundOn("Hero_Tiny.Toss.Target", unit)
		EmitSoundOn(sound, unit)
		unit:AddNewModifier(parent, ability, "modifier_cell_toss", {Duration = duration})
		unit.toss = true
	end
end 

modifier_cell_toss = class({})
function modifier_cell_toss:OnCreated()
	if IsServer() then
		local parent = self:GetParent()
		parent:Stop()
		self.endPos = self:GetAbility().position
		self.distance = CalculateDistance( self.endPos, parent )
		self.direction = CalculateDirection( self.endPos, parent )
		self.speed = self.distance / self:GetSpecialValueFor("duration") * FrameTime()
		self.initHeight = GetGroundHeight(parent:GetAbsOrigin(), parent)
		self.height = self.initHeight
		self.maxHeight = 650
		self:StartMotionController()
	end
end


function modifier_cell_toss:OnRemoved()
	if IsServer() then
		EmitSoundOn("Ability.TossImpact", self:GetParent())
		self:GetParent().toss = nil
--[[		local parent = self:GetParent()
		local parentPos = parent:GetAbsOrigin()
		local radius = self:GetSpecialValueFor("radius")
		GridNav:DestroyTreesAroundPoint(parentPos, radius, false)
		FindClearSpaceForUnit(parent, parentPos, true)
		local ability = self:GetAbility()
		local damage = self:GetSpecialValueFor("damage")
		local radius = self:GetSpecialValueFor("radius")
		local enemies = self:GetCaster():FindEnemyUnitsInRadius(parentPos, radius)
		for _,enemy in pairs(enemies) do
			if not enemy:TriggerSpellAbsorb( self ) then
				if self:GetCaster():HasScepter() then
					self:GetAbility():Stun(enemy, 1, false)
				end
				ability:DealDamage(self:GetCaster(), enemy, damage, {}, 0)
			end
		end]]
		self:StopMotionController()
	end
end

function modifier_cell_toss:DoControlledMotion()
	if IsServer() then
		if self:GetParent():IsNull() then return end
		local parent = self:GetParent()
		self.distanceTraveled =  self.distanceTraveled or 0
		if parent:IsAlive() and self.distanceTraveled < self.distance then
			local newPos = GetGroundPosition(parent:GetAbsOrigin(), parent) + self.direction * self.speed
			newPos.z = self.height + self.maxHeight * math.sin( (self.distanceTraveled/self.distance) * math.pi )
			parent:SetAbsOrigin( newPos )
			
			self.distanceTraveled = self.distanceTraveled + self.speed
		else
			FindClearSpaceForUnit(parent, parent:GetAbsOrigin(), true)
			self:Destroy()
			return nil
		end       
	end
end

function modifier_cell_toss:GetEffectName()
	return "particles/units/heroes/hero_tiny/tiny_toss_blur.vpcf"
end

function modifier_cell_toss:CheckState()
	return {[MODIFIER_STATE_STUNNED] = true,
			[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
			[MODIFIER_STATE_SILENCED] = true,}
end

function modifier_cell_toss:DeclareFunctions()
	return {MODIFIER_PROPERTY_OVERRIDE_ANIMATION}
end

function modifier_cell_toss:GetOverrideAnimation()
	return ACT_DOTA_FLAIL
end

function modifier_cell_toss:IsHidden()
	return true
end
