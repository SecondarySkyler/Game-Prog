local enemy = require("enemy")
local physics = require("physics")
local map = require("map")

physics.start()

local level = map.loadMap("newLevel.json")


local cat = enemy.findCat(level)
local cat2 = enemy.findCat2(level)

enemy.animate(cat)
enemy.animate(cat2)

