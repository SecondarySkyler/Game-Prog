local tiled = require("com.ponywolf.ponytiled")
local json = require("json")

local M = {}

function M.loadMap(level)
    local mapData = json.decodeFile(system.pathForFile("map/"..level, system.ResourceDirectory))
    return tiled.new(mapData, "map")
end

return M