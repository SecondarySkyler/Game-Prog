-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------
local physics = require('physics')
physics.start()

local background = display.newImageRect("img/bgClouds.png", 540, 960)
background.anchorX = 0
background.anchorY = 0
background.x = 0
background.y = 0

local ground = display.newImageRect("img/ground.png", 540, 95)
ground.anchorX = 0
ground.anchorY = 0
ground.x = 0
ground.y = display.contentHeight - ground.height
physics.addBody(ground, "static", {bounce = 0, friction = 1})

local platform1 = display.newImageRect("img/platform.png", 300, 50) 
platform1.anchorX = 0
platform1.anchorY = 0
platform1.x = 50
platform1.y = 160
platform1:rotate(30)

local platform2 = display.newImageRect("img/platform.png", 300, 50) 
platform2.anchorX = 0
platform2.anchorY = 0
platform2.x = display.contentWidth - 40
platform2.y = 400
platform2:rotate(-225)

local platform3 = display.newImageRect("img/platform.png", 300, 50) 
platform3.anchorX = 0
platform3.anchorY = 0
platform3.x = 10
platform3.y = 650
platform3:rotate(25)

physics.addBody(platform1, "static", {bounce = 0, friction = 0.5})
physics.addBody(platform2, "static", {bounce = 0, friction = 0.5})
physics.addBody(platform3, "static", {bounce = 0, friction = 0.5})

local crate = display.newImageRect("img/crate.png", 60, 60)
crate.anchorX = 0
crate.anchorY = 0
crate.x = 90
crate.y = -100
physics.addBody(crate, "dynamic", {bounce = 0})
