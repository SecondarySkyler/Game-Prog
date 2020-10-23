-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------
physics = require('physics')
physics.start()
local plane = display.newImageRect("img/planeRed1.png",88,73)
plane.x = 200
plane.y = display.contentCenterY



local mountain = display.newImageRect("img/rockGrass.png",108 ,239)
mountain.x = 700
mountain.y = display.contentCenterY
mountain.name = "mountain"
physics.addBody (mountain, "static", {density = 1.0})

local button = display.newRect(900,500,50,50)

local options = {width = 44, height = 32, numFrames = 4}
local missileSheet = graphics.newImageSheet("img/missileSheet.png", options)

local seqs = {
    name = "missile",
    start = 1,
    count = 4,
    time = 100,
    loopCount = 0,
    loopDirection = "forward"
}

local function onCollision(event)
    if (event.phase == "began") then
        print("began: " ..event.object1.name.. "and" ..event.object2.name)
    elseif (event.phase == "ended") then
        display.remove(mountain)    
    end
end

local function shoot (event)
    local missile = display.newSprite(missileSheet, seqs)
    missile.x = 200
    missile.y = display.contentCenterY
    missile.name = "missile"
    physics.addBody (missile, {density = 1.0})
    missile:play()
    local shoot = transition.to(missile, {x = 1080, time = 800})
end

Runtime:addEventListener("collision", onCollision)
button:addEventListener("tap", shoot)