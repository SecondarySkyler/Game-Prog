-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

local physics = require("physics")
physics.start()

-- define a ground platform with a static body
local ground = display.newRect( 0,0,display.contentWidth,20 )
ground.x=display.contentCenterX
ground.y=display.contentHeight-10
physics.addBody( ground, "static", { friction=0.5, bounce=0.4 } )
ground.name="ground"

-- define a yellow ball with a static body and place it
-- close to the top of the display 
local yellowBall = display.newCircle( 0, 0 , 40 )
yellowBall.x=display.contentCenterX
yellowBall.y=50
yellowBall:setFillColor( 1, 1, 0) 
yellowBall.name="yellowBall"
physics.addBody( yellowBall, "static",{  bounce=0.5, radius=40 } )

-- define a red ball  with a dynamic body and place it
-- on the ground
local redBall = display.newCircle( 0, 0 , 20 )
redBall.x=display.contentCenterX
redBall.y=display.contentHeight-30
redBall:setFillColor( 1, 0, 0) 
redBall.name="redBall"
physics.addBody( redBall, "dynamic",{  bounce=0.5, radius=20 } )

-- this is a listener that makes the redBall jump when it is tapped
local function jump(event)
	redBall:applyLinearImpulse(0,-0.3,redBall.x,redBall.y) 
	return true
end
-- Activate the tap listener jump on redBall
redBall:addEventListener("tap",jump)


--initializing physicsWorldChange
local physicsWorldChange = false

local function onGlobalCollision(event)
    if (event.phase == "began") then
        if (event.object1.name == "yellowBall" and event.object2.name == "redBall")
            or (event.object1.name == "redball" and event.object2.name == "yellowBall") then
                physicsWorldChange = true
            end
    elseif (event.phase == "ended") then
            if (event.object1.name == "yellowBall" and event.object2.name == "redBall")
            or (event.object1.name == "redball" and event.object2.name == "yellowBall") then
                yellowBall:removeSelf()
                yellowBall = nil 
            end
    end  
end

Runtime:addEventListener("collision", onGlobalCollision)


local function createTwoGreenBalls(event)
    if (physicsWorldChange == true) then
       local greenBall1 = display.newCircle(0,0,20) 
       local greenBall2 = display.newCircle(0,0,20)
       greenBall1.x = display.contentCenterX + 10 
       greenBall2.x = display.contentCenterX - 10 
       greenBall1.y = 50
       greenBall2.y = 50 
       greenBall1:setFillColor(0,1,0)
       greenBall2:setFillColor(0,1,0)
       physics.addBody(greenBall1, "dynamic")
       physics.addBody(greenBall2, "dynamic")
       greenBall1:setLinearVelocity(-30, 140)
       greenBall2:setLinearVelocity(30, 140)
       physicsWorldChange = false
    end
end

Runtime:addEventListener("enterFrame", createTwoGreenBalls)