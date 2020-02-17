-- 8-way stack-based recursive floodfill
-- See http://en.wikipedia.org/wiki/Flood_fill#Stack-based_recursive_implementation_.28Four-way.29

local function flood8(x, y, grid)
	if not grid:has(x,y) then return end
	local actualValue = grid:get(x,y)
	if actualValue and (actualValue == 0) then
		grid:set(x,y,1)
		flood8(x+1,y,grid)
		flood8(x-1,y,grid)
		flood8(x,y+1,grid)
		flood8(x,y-1,grid)
		flood8(x+1,y+1,grid)
		flood8(x+1,y-1,grid)
		flood8(x-1,y+1,grid)
		flood8(x-1,y-1,grid)
	end
end

return flood8
