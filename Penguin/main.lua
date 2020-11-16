local tiled = require("com.ponywolf.ponytiled")
local json = require("json")

local mapData = json.decodeFile(system.pathForFile("map/newLevel.json", system.ResourceDirectory))
local map = tiled.new(mapData, "map")