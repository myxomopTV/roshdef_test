---
--- Created by JoBoDo.
--- DateTime: 7/19/2017 12:30 PM
---

if not RangeActions then
    RangeActions = class({}, {
        activeActions = {}
    })
end

function RangeActions:Activate()

    OrderFilter:AddFilterTo("OrderedUnit", "RangeActions_RemoveRangeAction", Dynamic_Wrap(RangeActions, "RemoveRangeAction"))


    Timers:CreateTimer(function()


        for id, action in pairs(RangeActions.activeActions) do
            if not IsValidEntity(action.unit) or not action.unit:IsAlive() then
                RangeActions:RemoveRangeAction({order = {entityIndex = id}})
            else
                local range = action.range or 100

                if not (action.targetPos or action.targetEntity) then
                    Debug("RangeActions", "No targetPos or targetEntity has been set")
                    RangeActions:RemoveRangeAction({order = {entityIndex = id}})
                    return
                end

                if action.targetEntity and not IsValidEntity(action.targetEntity) then 
                    RangeActions:RemoveRangeAction({order = {entityIndex = id}})
                    return 
                end

                local destination = action.targetPos or action.targetEntity:GetAbsOrigin()
                local distance = (action.unit:GetAbsOrigin() - destination):Length2D()
                --print("Distance : ", distance)
                --print("Range : ", range)


                if distance <= range then
                    action.unit:Stop()
                    local status, result = xpcall(
                    function() return action.callback(action) end,
                    function(msg) return msg .. '\n' .. debug.traceback() .. 'n' end
                    )
                    RangeActions:RemoveRangeAction({order = {entityIndex = id}})
                    if not status then Debug("RangeActions", "[ERROR]", result) end
                end
            end
        end
        return 0.03
    end)
end

--This will override an existing range action
function RangeActions:CreateRangeAction(unit, targetPos, targetEnt, range, playerID, callback, bGiveOrder)

    bGiveOrder = bGiveOrder or true

    local tempTargetPos = targetPos
    if not tempTargetPos then tempTargetPos = targetEnt:GetAbsOrigin() end


    local diff = unit:GetAbsOrigin() - tempTargetPos
    local dist = diff:Length2D()
    local runToPos = unit:GetAbsOrigin()

    if(dist > range) then
        runToPos = tempTargetPos + diff:Normalized() * range
    end

    --check for contained item or fish. If it's one of these two we can't execute a new order
    --because otherwise it will create an infinite loop.

    if bGiveOrder then
        if targetEnt and not targetEnt.GetContainedItem and not targetEnt.Fish then
            --Debug("RangeAction", "Act On Unit: ", unit:GetEntityIndex())
            --Debug("RangeAction", "Act On Target: ", targetEnt:GetEntityIndex())

            ExecuteOrderFromTable({
                  UnitIndex = unit:GetEntityIndex(),
                  OrderType = DOTA_UNIT_ORDER_MOVE_TO_TARGET,
                  TargetIndex = targetEnt:GetEntityIndex(),
              })

        elseif(targetPos) then
            --Debug("RangeAction", "Act On Unit: ", unit:GetEntityIndex())
            --Debug("RangeAction", "Move To Pos: ", targetPos)

            ExecuteOrderFromTable({
                  UnitIndex = unit:GetEntityIndex(),
                  OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
                  Position = targetPos,
              })
        end
    end

    RangeActions.activeActions[unit:GetEntityIndex()] = {
        unit = unit,
        targetPos = targetPos,
        targetEntity = targetEnt,
        range = range,
        playerID = playerID,
        callback = callback
    }
end

function RangeActions:RemoveRangeAction(order)
    local order = order.order
    local entityIndex = order.entityIndex or order.units["0"]
    if(RangeActions.activeActions[entityIndex]) then
        RangeActions.activeActions[entityIndex] = nil
    end
end

function RangeActions:ConvertTargetOrderToPosition(order)

    local orderedUnit = EntIndexToHScript(order.units["0"])
    local targetEntity = EntIndexToHScript(order.entindex_target)
    if not targetEntity then return false end

    local startPos = orderedUnit:GetAbsOrigin()
    local targetPos = targetEntity:GetAbsOrigin()

    local diff = startPos - targetPos
    local dist = diff:Length2D()

    local pos = startPos

    if dist > 50 then
        pos = targetPos + diff:Normalized() * 50
    end

    order.order_type = DOTA_UNIT_ORDER_MOVE_TO_POSITION
    order.position_x = pos.x
    order.position_y = pos.y
    order.position_z = pos.z
end

Event:BindActivate(RangeActions)