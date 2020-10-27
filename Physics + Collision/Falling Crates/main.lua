-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

local physics = require('physics')
physics.start()

local bg = display.newGroup()
local fg = display.newGroup()

local background = display.newImageRect(bg, "img/bgClouds.png", 540, 960)
background.anchorX = 0
background.anchorY = 0
background.x = 0 
background.y = 0 

local ground = display.newImageRect(fg, "img/ground.png", 540, 95)
ground.anchorX = 0
ground.anchorY = 0
ground.x = 0 
ground.y = display.contentHeight - ground.height 
physics.addBody(ground, "static", {bounce = 0})

local leftBarrier = display.newRect(0, 0, 1, display.contentHeight)
leftBarrier.anchorX = 0
leftBarrier.anchorY = 0
leftBarrier:setFillColor(0.5, 0.78, 0.24)
physics.addBody(leftBarrier, "static", {bounce = 0})

local rightBarrier = display.newRect(display.contentWidth, 0, 1, display.contentHeight)
rightBarrier.anchorX = 0
rightBarrier.anchorY = 0
rightBarrier:setFillColor(1)
physics.addBody(rightBarrier, "static", {bounce = 0})

local button = display.newImageRect(fg, "img/redButton.png", 280, 175)
button.x = display.contentWidth - 60
button.y = display.contentHeight - 50

local function createCrate (event)
    local crate = display.newImageRect("img/crate.png", 60, 60)
    crate.x = event.x 
    crate.y = event.y
    physics.addBody(crate, "dynamic", {bounce = 0.1})
    local scaleUp
    local function scaleDown(event)
        transition.to(crate, {y = crate.y + 30, time = 400, onComplete = scaleUp})
    end
    scaleUp = function(event)
        transition.to(crate, {y = crate.y - 30, time = 400, onComplete = scaleDown})
    end
    scaleDown()
end

Runtime:addEventListener("tap", createCrate)

local function fall(event)
    transition.cancelAll()
    physics.start()
    return true
end

button:addEventListener("tap", fall)


