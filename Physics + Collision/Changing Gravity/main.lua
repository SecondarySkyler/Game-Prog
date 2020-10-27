-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

local physics = require('physics')
physics.start()
local gravityX = 0
local gravityY = 9.8
physics.setGravity(gravityX, gravityY)
physics.pause()

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
physics.addBody(ground, "static", {bounce = 0.3, friction = 0.5, })

local topBarrier = display.newRect(0, 0, 540, 1)
topBarrier.anchorX = 0
topBarrier.anchorY = 0
physics.addBody(topBarrier, "static", {friction = 0.2, bounce = 0.6})

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
    crate.isSleepingAllowed = "false"
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
    display.remove(button)
    Runtime:removeEventListener("tap", createCrate)
    physics.start()

    local arrowUp = display.newImageRect("img/arrowUp.png", 80, 80)
    arrowUp.x = display.contentWidth - 130
    arrowUp.y = display.contentHeight - 170
    local arrowDown = display.newImageRect("img/arrowDown.png", 80, 80)
    arrowDown.x = display.contentWidth - 130
    arrowDown.y = display.contentHeight - 75
    local arrowRight = display.newImageRect("img/arrowRight.png", 80, 80)
    arrowRight.x = display.contentWidth - 45
    arrowRight.y = (arrowUp.y + arrowDown.y) / 2
    local arrowLeft = display.newImageRect("img/arrowLeft.png", 80, 80)
    arrowLeft.x = display.contentWidth - 215
    arrowLeft.y = (arrowUp.y + arrowDown.y) / 2

    local function gravityUp(event)
        local gravityX = 0
        local gravityY = -9.8
        physics.setGravity(gravityX, gravityY)
    end
    local function gravityDown(event)
        local gravityX = 0
        local gravityY = 9.8
        physics.setGravity(gravityX, gravityY)
    end
    local function gravityRight(event)
        local gravityX = 9.8
        local gravityY = 0
        physics.setGravity(gravityX, gravityY)
    end
    local function gravityLeft(event)
        local gravityX = -9.8
        local gravityY = 0
        physics.setGravity(gravityX, gravityY)
    end

    arrowUp:addEventListener("tap", gravityUp)
    arrowDown:addEventListener("tap", gravityDown)
    arrowRight:addEventListener("tap", gravityRight)
    arrowLeft:addEventListener("tap", gravityLeft)
end

button:addEventListener("tap", fall)