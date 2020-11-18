local physics = require("physics")
local enemy = require("enemy")
local map = require("map")
local penguin = require("penguin")
local audioData = require("audioData")

physics.start()

local level = map.loadMap("newLevel.json")

audio.play(audioData.bgMusic, {loops = -1, channel = 1})
audio.setVolume(0.2, {channel = 1})


local cat = enemy.findCat(level)
local cat2 = enemy.findCat2(level)

enemy.animate(cat)
enemy.animate(cat2)

local character = penguin.new()
penguin.init(character, 8, 13 * 32, 32, 1, false)
penguin.activate(character)


