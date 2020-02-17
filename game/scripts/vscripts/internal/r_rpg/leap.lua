--[[
function ParabolaZ(h, d, x)
	return (4 * h / d) * (d - x) * (x / d)
end
]]

--If damage gets dealt to a leaping unit their height gets reset
--Will require hardsetting the vector each tick to fix




function LeapFromDatadriven(keys)
	local point
	if keys.target then
		point = keys.target:GetAbsOrigin()
	end
	if keys.target_points[1] then
		point = keys.target_points[1]
	end

	Leap(keys.caster, point, keys.height, keys.speed, keys.bPassWalls)
end

function Leap(unit, point, height, speed, time, passWalls, leapCallback)
	local rotate = unit.bRotate

	--Convert to new format if do
	if type(unit) == "table" and unit.unit then
		--print("Unit type was table")
		--PrintTable(unit)
		leapCallback = point
		point = unit.point
		height = unit.height
		speed = unit.speed
		time = unit.time
		passWalls = unit.bPassWalls
		color = unit.color
		unit = unit.unit

		--print(point, height, speed, time, passWalls)
	end

	if not height then
		height = 0
	end
	if not speed then
		speed = 1000
	end
	if not passWalls then
		passWalls = false
	end

	local origin = unit:GetAbsOrigin()

	unit:Stop()

	local loc = origin
	loc.z = point.z

	if rotate then
		unit:SetForwardVector((point - loc):Normalized())
	end

	if color then
		unit.leapParticle = ParticleManager:CreateParticle("particles/leap.vpcf", PATTACH_ABSORIGIN_FOLLOW, unit)
        ParticleManager:SetParticleControl(unit.leapParticle,1,Vector(color[1], color[2], color[3]))
	end

	--print("---", point, height, speed, time, passWalls)

	Knockback(unit, point, height, speed, time, passWalls, leapCallback)
end

--Same as leap except doesn't change forwardVector
function Knockback(unit, point, height, speed, time, bPassWalls, leapCallback)
	unit.isLeaping = true
	--unit.temporaryDisableWeather = true

	if not height then
		height = 0
	end
	if not speed then
		speed = 1000
	end

	local origin = unit:GetAbsOrigin()
	local z = origin.z

	unit:Stop()

	local loc = origin
	loc.z = point.z
	--unit:SetForwardVector((point - loc):Normalized())

	Physics:Unit(unit)
	unit:SetGroundBehavior(PHYSICS_GROUND_ABOVE)
	unit:AdaptiveNavGridLookahead(true)
	unit:SetNavGridLookahead(6)
	unit:FollowNavMesh(true)
	unit:PreventDI(true)

	if bPassWalls then
		unit:SetNavCollisionType(PHYSICS_NAV_NOTHING)
	end

	

	local distance = (unit:GetAbsOrigin() - point):Length2D()
	if not time then
		time = distance / speed
	else
		speed = distance / time
	end
	local startTime = GameRules:GetGameTime()
	local expireTime = GameRules:GetGameTime() + time

	--print("pre-calc height", height)
	--print("originHeight",originHeight)
	--print("pointHeight",pointHeight)
	local originHeight = GetGroundHeight(origin, nil)
	local pointHeight = GetGroundHeight(point, nil)
	--If height + originHeight is less than pointHeight then set height to pointHeight
	if height + originHeight < pointHeight then
		height = pointHeight - originHeight
	end
	local upSpeed = height / (time/2)
	local downSpeed = ((originHeight + height) - pointHeight) / (time/2)

	--print("post-calc height", height)
	--print("upSpeed", upSpeed)
	--print("downSpeed", downSpeed)

	unit:SetStaticVelocity("leap", (point - origin):Normalized() * speed)

	local leapTimerString = DoUniqueString("leapTimer")
	local lastGoodLocation = origin

	Timers:CreateTimer(leapTimerString, {
	    useGameTime = false,
	    callback = function()
	      	if not IsValidEntity(unit) then return end

	      	local curLoc = unit:GetAbsOrigin()

	    	if not bPassWalls and not GridNav:CanFindPath(origin, curLoc) then
	    		unit:SetAbsOrigin(lastGoodLocation)
	    	else
	    		lastGoodLocation = curLoc
	    	end

	      	return .03
	    end
  	})

--	ApplyModifier( unit, "modifier_command_restricted_global")

	Timers:CreateTimer({
		--endTime = time, -- when this timer should first execute, you can omit this if you want it to run first on the next frame
		callback = function()

			--unit:SetForwardVector((point - loc):Normalized())

			if GameRules:GetGameTime() < (startTime + (time / 4)) then
				--unit:SetStaticVelocity("leap_height", (Vector(0,0,1) * (upSpeed * 1.25)))
				z = z + ((upSpeed * 1.25)/30)
			elseif GameRules:GetGameTime() < (startTime + (time / 2)) then
				--unit:SetStaticVelocity("leap_height", (Vector(0,0,1) * (upSpeed * .75)))
				z = z + ((upSpeed * .75)/30)
			elseif GameRules:GetGameTime() < (startTime + (time * .75)) then
				--unit:SetStaticVelocity("leap_height", (Vector(0,0,-1) * (downSpeed * .75)))
				z = z - ((downSpeed * .75)/30)
			elseif expireTime > GameRules:GetGameTime() then
				--unit:SetStaticVelocity("leap_height", (Vector(0,0,-1) * (downSpeed * 1.25)))
				z = z - ((downSpeed * 1.25)/30)
			end

			local vect = unit:GetAbsOrigin()
			vect.z = z
			unit:SetAbsOrigin(vect)

			if expireTime < GameRules:GetGameTime() then
				StopLeap(unit, leapCallback, leapTimerString)
				return false
			end

			return .03
		end
	})
end



function Knockup(unit, height, time)
	if not height then height = 225 end
    if not time then time = .5 end

    local startTime = GameRules:GetGameTime()
    local expireTime = GameRules:GetGameTime() + time
    
    local verticalSpeed = height / (time/2)


    if unit.knockup then
        return
    else
        unit.knockup = true
    end

    --[[Physics:Unit(unit)
    unit:SetGroundBehavior(PHYSICS_GROUND_ABOVE)
    unit:AdaptiveNavGridLookahead(true)
    unit:SetNavGridLookahead(4)
    unit:FollowNavMesh(true)
    unit:PreventDI(true)]]

    ApplyModifier( unit, "modifier_stun_global")

    Timers:CreateTimer({
        --endTime = time, -- when this timer should first execute, you can omit this if you want it to run first on the next frame
        callback = function()

            if not IsValidEntity(unit) or not unit:IsAlive() then return false end

            local origin = unit:GetAbsOrigin()

            if GameRules:GetGameTime() < (startTime + (time / 4)) then
                unit:SetAbsOrigin(Vector(origin.x, origin.y, origin.z + ((verticalSpeed*1.25) / 30)))
            elseif GameRules:GetGameTime() < (startTime + (time / 2)) then
                unit:SetAbsOrigin(Vector(origin.x, origin.y, origin.z + ((verticalSpeed*.75) / 30)))
            elseif GameRules:GetGameTime() < (startTime + (time * .75)) then
                unit:SetAbsOrigin(Vector(origin.x, origin.y, origin.z - ((verticalSpeed*.75) / 30)))
            elseif expireTime > GameRules:GetGameTime() then
                unit:SetAbsOrigin(Vector(origin.x, origin.y, origin.z - ((verticalSpeed*1.25) / 30)))
            end

            --print("Static Velocity natures_wraith_knockup:", unit:GetStaticVelocity("natures_wraith_knockup"))

            if expireTime < GameRules:GetGameTime() then
                --[[unit:SetStaticVelocity("natures_wraith_knockup", Vector(0,0,0))
                unit:PreventDI(false)
                unit:Stop()]]
                unit.knockup = nil
                unit:RemoveModifierByName("modifier_stun_global")
                FindClearSpaceForUnit(unit, unit:GetAbsOrigin(), true)
                return false
            end

            return .03
        end
    })
end


function Rise(unit, height, time)
	if not height then height = 150 end
    if not time then time = .5 end

    local startTime = GameRules:GetGameTime()
    local expireTime = GameRules:GetGameTime() + time

    local startVec = unit:GetAbsOrigin()
    local curVec = startVec
    
    local verticalSpeed = height / (time/2)

	ApplyModifier( unit, "modifier_stun_global")

    Timers:CreateTimer({
        --endTime = time, -- when this timer should first execute, you can omit this if you want it to run first on the next frame
        callback = function()

            if not IsValidEntity(unit) or not unit:IsAlive() then return false end

            local origin = unit:GetAbsOrigin()

            --unit:SetAbsOrigin(Vector(origin.x, origin.y, origin.z + ((verticalSpeed) / 30)))
            unit:SetAbsOrigin(curVec)

            --print("Static Velocity natures_wraith_knockup:", unit:GetStaticVelocity("natures_wraith_knockup"))

            if expireTime < GameRules:GetGameTime() then
                unit:RemoveModifierByName("modifier_stun_global")
                Timers:CreateTimer(function()
                	unit:SetAbsOrigin(curVec)
                end)
                return false
            end

            curVec.z = curVec.z + ((verticalSpeed) / 30)

            return .03
        end
    })
end

function Descend(unit, height, time)
	if not height then height = 150 end
    if not time then time = .5 end

    local startTime = GameRules:GetGameTime()
    local expireTime = GameRules:GetGameTime() + time

    local startVec = unit:GetAbsOrigin()
    local curVec = startVec
    
    local verticalSpeed = height / (time/2)

	ApplyModifier( unit, "modifier_stun_global")

    Timers:CreateTimer({
        --endTime = time, -- when this timer should first execute, you can omit this if you want it to run first on the next frame
        callback = function()

            if not IsValidEntity(unit) or not unit:IsAlive() then return false end

            local origin = unit:GetAbsOrigin()

            --unit:SetAbsOrigin(Vector(origin.x, origin.y, origin.z - ((verticalSpeed) / 30)))
            unit:SetAbsOrigin(curVec)

            --print("Static Velocity natures_wraith_knockup:", unit:GetStaticVelocity("natures_wraith_knockup"))

            if expireTime < GameRules:GetGameTime() then
                unit:RemoveModifierByName("modifier_stun_global")
                Timers:CreateTimer(function()
                	unit:SetAbsOrigin(curVec)
                end)
                return false
            end

            curVec.z = curVec.z - ((verticalSpeed) / 30)

            return .03
        end
    })
end



--Doesn't work currently
function Flip(unit, point, height, speed, bPassWalls, leapCallback)
	if not height then
		height = 0
	end
	if not speed then
		speed = 2000
	end

	local origin = unit:GetAbsOrigin()

	Physics:Unit(unit)
	unit:SetGroundBehavior(PHYSICS_GROUND_NOTHING)
	unit:AdaptiveNavGridLookahead(true)
	unit:SetNavGridLookahead(4)
	unit:FollowNavMesh(true)
	unit:PreventDI(true)

	if bPassWalls then
		unit:SetNavCollisionType(PHYSICS_NAV_NOTHING)
	end

	unit:SetStaticVelocity("leap", (point - unit:GetAbsOrigin()):Normalized() * speed)

	local distance = (unit:GetAbsOrigin() - point):Length2D()
	local time = distance / speed
	local startTime = GameRules:GetGameTime()
	local expireTime = GameRules:GetGameTime() + time

	local rot = 360/(time*30)

	local verticalSpeed = height / (time/2)

	ApplyModifier( unit, "modifier_command_restricted_global")

	Timers:CreateTimer({
		--endTime = time, -- when this timer should first execute, you can omit this if you want it to run first on the next frame
		callback = function()

			unit:SetAngles(rot, 0, 0)
			rot = rot + 360/(time*30)

			if GameRules:GetGameTime() < (startTime + (time / 4)) then
				unit:SetStaticVelocity("leap_height", (Vector(0,0,1) * (verticalSpeed * 1.25)))
			elseif GameRules:GetGameTime() < (startTime + (time / 2)) then
				unit:SetStaticVelocity("leap_height", (Vector(0,0,1) * (verticalSpeed * .75)))
			elseif GameRules:GetGameTime() < (startTime + (time * .75)) then
				unit:SetStaticVelocity("leap_height", (Vector(0,0,-1) * (verticalSpeed * .75)))
			elseif expireTime > GameRules:GetGameTime() then
				unit:SetStaticVelocity("leap_height", (Vector(0,0,-1) * (verticalSpeed * 1.25)))
			end

			if expireTime < GameRules:GetGameTime() then
				StopLeap(unit, leapCallback)
				return false
			end

			return .03
		end
	})
end


function StopLeap(unit, leapCallback, timerString)
	unit.isLeaping = nil
	unit.temporaryDisableWeather = nil
	unit:SetAbsOrigin(unit:GetAbsOrigin() + Vector(1,0,0))
	if unit.leapParticle then
		ParticleManager:DestroyParticle(unit.leapParticle, false)
		ParticleManager:ReleaseParticleIndex(unit.leapParticle)
		unit.leapParticle = nil
	end

	unit:SetStaticVelocity("leap", Vector(0,0,0))
	unit:SetStaticVelocity("leap_height", Vector(0,0,0))
	unit:PreventDI(false)
	unit:Stop()
	unit:RemoveModifierByName("modifier_command_restricted_global")
	FindClearSpaceForUnit(unit, unit:GetAbsOrigin(), true)

	if leapCallback and type(leapCallback) == "function" then
		leapCallback(unit)
	end

	if not timerString then return end

	Timers:RemoveTimer(timerString)
end