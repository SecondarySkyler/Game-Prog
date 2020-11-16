local tiled = require("com.ponywolf.ponytiled")
local json = require("json")
local enemy = require("enemy")

local mapData = json.decodeFile(system.pathForFile("map/newLevel.json", system.ResourceDirectory))
local map = tiled.new(mapData, "map")


local cat = enemy.findCat(map)
local cat2 = enemy.findCat2(map)

