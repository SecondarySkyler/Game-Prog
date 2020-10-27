-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------
physics = require('physics')
physics.start()
physics.setGravity(0,0)

local plane = display.newImageRect("img/planeRed1.png",88,73)
plane.x = 200
plane.y = display.contentCenterY
plane.name = "plane"
physics.addBody(plane, "static", {density = 1.0})



local mountain = display.newImageRect("img/rockGrass.png",108 ,239)
mountain.x = 700
mountain.y = display.contentCenterY
mountain.name = "mountain"
mountain.speed = 3
physics.addBody (mountain, "dinamic", {density = 1.0})


local explosionOpt = {width = 192, height = 192, numFrames = 7}
local explosionSheet = graphics.newImageSheet("img/explosionSheet.png", explosionOpt)
local explSequences = {name = "explosion", start = 1, count = 7, time = 1000, loopCount = 0, loopDirection = "forward"}

local function onCollision(self, event)
    if (event.phase == "began") then
        local explosion = display.newSprite (explosionSheet, explSequences)
        explosion.x = (plane.x + mountain.x) / 2
        explosion.y = display.contentCenterY
    elseif (event.phase == "ended") then
          mountain:removeSelf()
          mountain = nil
    end
end

local function groundScroll (self, event) 
    if (self.x < -display.contentWidth) then
        self.x = display.contentWidth - self.speed * 2
    else
        self.x = self.x - self.speed
    end
end



mountain.enterFrame = groundScroll
Runtime:addEventListener("enterFrame", mountain)

plane.collision = onCollision
plane:addEventListener("collision")

mountain.collision = onCollision
mountain:addEventListener("collision")