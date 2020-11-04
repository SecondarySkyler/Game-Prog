-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------
local physics = require('physics')
physics.start()
--physics.setGravity(0,0)

local plane = display.newImageRect("img/planeRed1.png", 88, 73)
plane.x = display.contentCenterX
plane.y = display.contentCenterY
physics.addBody(plane)

local plate = display.newRect(0,0,1080, 1)
plate.x = display.contentCenterX
plate.y = 530
physics.addBody(plate, "static")

local function moveOnTouch(event)
    plane:applyLinearImpulse(0, -0.6, plane.x, plane.y)
end



plane:addEventListener("tap", moveOnTouch)
