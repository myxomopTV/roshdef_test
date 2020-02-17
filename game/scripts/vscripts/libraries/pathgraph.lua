PATHGRAPH_VERSION = "0.85"

--[[
  Path Graph Instantiation Library by BMD (redacted by vulkantsk)

  Installation
  -"require" this file inside your code in order to gain access to the PathGraph global and functions.
  Usage
  -PathGraph:Initialize() should be called sometime during your game mode's initialization.
  -The Initialize function will find all of the connecting "path_corner" entities as placed on your map via hammer and connect them.
  -Each "path_corner" entity after Initialize will have a "edges" property containing a full edge graph for that node to all other connected nodes.
  -PathGraph:DrawPaths(pathCorner, duration, color) should be called for debugging purposes in order to show the path graph connections.
    -pathCorner is the path_corner entity to display the connected graph for.
    -duration is the duration to display the graph
    -color is the color to use for the graph lines and nodes
  Notes
  -Currently only supports path_corner and not path_track
  Examples:
  --Initialize the graph
    PathGraph:Initialize()
  --Iterate through all connected edges starting from a path_corner node named "start_node"
    local node = Entities:FindByName(nil, "start_node")
    for _,edge in pairs(node.edges) do
       ----print("'start_node' is connected to '" .. edge:GetName() .. "'")
    end
]]

if not PathGraph then
  PathGraph = class({})
end

local TableCount = function(t)
  local n = 0
  for _ in pairs( t ) do
    n = n + 1
  end
  return n
end

function PathGraph:OnGameRulesStateChange()
	if GameRules:State_Get() == DOTA_GAMERULES_STATE_CUSTOM_GAME_SETUP then
		PathGraph:Initialize()
	end
end

function PathGraph:Initialize()
  local corners = Entities:FindAllByClassname('path_corner')
  local points = {} 
  for _,corner in ipairs(corners) do
    points[corner:entindex()] = corner
  end

  local names = {}

  for _,corner in ipairs(corners) do
    local name = corner:GetName()
    if names[name] ~= nil then
       ----print("[PathGraph] Initialization error, duplicate path_corner named '" .. name .. "' found. Skipping...")
    else
      local parents = Entities:FindAllByTarget(corner:GetName())
      corner.edges = corner.edges or {}
      print("name = "..corner:GetName())
      
      for _,parent in ipairs(parents) do
      	print(parent:GetName())
       	corner.edges[parent:entindex()] = parent
        parent.edges = parent.edges or {}
        parent.edges[corner:entindex()] = corner
        parent.next_corner = corner
      end
    end
  end
end

function PathGraph:DrawPaths(pathCorner, duration, color)
  duration = duration or 10
  color = color or Vector(255,255,255)
  if pathCorner ~= nil then
    if pathCorner:GetClassname() ~= "path_corner" or pathCorner.edges == nil then
       ----print("[PathGraph] An invalid path_corner was passed to PathGraph:DrawPaths.")
      return
    end

    local seen = {}
    local toDo = {pathCorner}

    repeat 
      local corner = table.remove(toDo)
      local edges = corner.edges
      DebugDrawCircle(corner:GetAbsOrigin(), color, 50, 20, true, duration)
      seen[corner:entindex()] = corner

      for index,edge in pairs(edges) do
        if seen[index] == nil then
          DebugDrawLine_vCol(corner:GetAbsOrigin(), edge:GetAbsOrigin(), color, true, duration)
          table.insert(toDo, edge)
        end
      end
    until (#toDo == 0)
  else
    local corners = Entities:FindAllByClassname('path_corner')
    local points = {} 
    for _,corner in ipairs(corners) do
      points[corner:entindex()] = corner
    end

    repeat 
      local seen = {}
      local k,v = next(points)
      local toDo = {v}

      repeat 
        local corner = table.remove(toDo)
        points[corner:entindex()] = nil
        local edges = corner.edges
        DebugDrawCircle(corner:GetAbsOrigin(), color, 50, 20, true, duration)
        seen[corner:entindex()] = corner

        for index,edge in pairs(edges) do
          if seen[index] == nil then
            DebugDrawLine_vCol(corner:GetAbsOrigin(), edge:GetAbsOrigin(), color, true, duration)
            table.insert(toDo, edge)
          end
        end
      until (#toDo == 0)
    until (TableCount(points) == 0)
  end
end

function MoveToNextCornerThink(unit, corner_name)
	if unit:IsNull() or not unit:IsAlive() then return nil end

	if unit.current_corner == nil then
		unit.current_corner = Entities:FindByName(nil, corner_name)
		if unit.current_corner == nil then
			print("path corner with name of '"..corner_name.."' not exist!")
			return
		end
	end

	local current_corner = unit.current_corner
	local next_corner = current_corner.next_corner or nil
	local point_corner = unit.current_corner:GetAbsOrigin()
	local point_unit = unit:GetAbsOrigin()
	local vector_dist = (point_corner - point_unit):Length2D()

	if  vector_dist < 25 then 		
		if next_corner then
			unit.current_corner = next_corner
		else
			print("next corner for '"..current_corner:GetName().."' not exist!")
			return
		end
	else
		unit:MoveToPosition(point_corner)
--		Timers:CreateTimer(0, function()
--[[			ExecuteOrderFromTable({
				UnitIndex = unit:entindex(),
				OrderType = DOTA_UNIT_ORDER_ATTACK_MOVE,
				Position = point_corner,
				Queue = false,
			})
]]--		end)
		
	end

	
	return 0.1
end

function CDOTA_BaseNPC:SetInitialWaypoint(corner_name)
	self:SetContextThink( "Think", function()
		return MoveToNextCornerThink(self, corner_name) end,
		 0.1 )
end

ListenToGameEvent( "game_rules_state_change", Dynamic_Wrap( PathGraph, "OnGameRulesStateChange" ), PathGraph )
