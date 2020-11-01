-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

local physics = require("physics")
physics.setDrawMode("hybrid")
physics.start()

local bg = display.newGroup()
local fg = display.newGroup()
local camera = display.newGroup()

local mapBorderLeft = 0
local mapBorderRight = display.contentWidth * 2

local fridaySound = audio.loadSound("audio/friday.wav")

-- Background elements

local backgroundLeft = display.newImageRect(bg,"img/backGrass2.png",1920,1080)
backgroundLeft.x=display.contentCenterX
backgroundLeft.y=display.contentCenterY
local backgroundRight = display.newImageRect(bg,"img/backGrass1.png",1920,1080)
backgroundRight.x=display.contentCenterX+display.contentWidth
backgroundRight.y=display.contentCenterY


local groundLeft = display.newImageRect(bg,"img/ground.png",1920,80)
groundLeft.x=display.contentCenterX
groundLeft.y=display.contentHeight-groundLeft.contentHeight/2
physics.addBody(groundLeft,"static",{bounce=0.2,friction=1.0,density=1.5})

local groundRight = display.newImageRect(bg,"img/ground.png",1920,80)
groundRight.x=display.contentCenterX+display.contentWidth
groundRight.y=display.contentHeight-groundLeft.contentHeight/2
physics.addBody(groundRight,"static",{bounce=0.2,friction=1.0,density=1.5})

local baseVert = display.newImageRect(bg,"img/woodVert.png",70,140)
local baseHoriz = display.newImageRect(bg,"img/woodHoriz.png",140,70)
baseVert.x = 400
baseVert.y = display.contentHeight-groundLeft.contentHeight-70
baseHoriz.x = 400
baseHoriz.y = display.contentHeight-groundLeft.contentHeight-baseVert.contentHeight-35
physics.addBody(baseHoriz,"static",{bounce=0})
physics.addBody(baseVert,"static",{bounce=0})

-- Smile element
local smile = display.newImageRect(fg,"img/smile.png",70,70)
smile.x = 400
smile.y = display.contentHeight-groundLeft.contentHeight-baseVert.contentHeight-105
physics.addBody(smile,"dynamic",{radius=35,bounce=0.6,friction=1.0,density=2.0})

smile.linearDamping = 0
smile.angularDamping = 0.8

-- Obstacles
local column1 = display.newImageRect(fg,"img/stoneVertThin.png",70,220)
column1.x = 3400
column1.y = display.contentHeight-groundLeft.contentHeight -110
physics.addBody(column1,"dynamic",{friction=0.1,density=3.0})


local column2 = display.newImageRect(fg,"img/stoneVert.png",140,220)
column2.x = 3400
column2.y = display.contentHeight-groundLeft.contentHeight -330
physics.addBody(column2,"dynamic",{friction=0.1,density=3.0})


local column3 = display.newImageRect(fg,"img/stoneVertThin.png",70,220)
column3.x = 3400
column3.y = display.contentHeight-groundLeft.contentHeight -550
physics.addBody(column3,"dynamic",{friction=0.1,density=3.0})


local roof = display.newImageRect(fg,"img/stoneTriangular.png",140,70)
roof.x = 3400
roof.y = display.contentHeight-groundLeft.contentHeight-715
local triangleShape={0,-35,70,35,-70,35}
physics.addBody(roof,"dynamic",{shape=triangleShape,friction=0.1,density=3.0})

--manca un pezzo di codice che non capisco
camera:insert(backgroundLeft)
camera:insert(backgroundRight)
camera:insert(smile)
camera:insert(baseHoriz)
camera:insert(baseVert)
camera:insert(groundLeft)
camera:insert(groundRight)
camera:insert(column1)
camera:insert(column2)
camera:insert(column3)
camera:insert(roof)



local function shoot(xForce, yForce)
    smile:applyLinearImpulse(xForce, yForce, smile.x, smile.y)
end

local line
local function drawLine(event)
    if (event.phase == "moved") then
        if (line ~= nil) then --this if is used to cancel all the line you will create leaving only 1
            display.remove(line)
            line = nil
        end
        line = display.newLine(fg, smile.x, smile.y, event.x, event.y)
        line.strokeWidth = 8
        line:setStrokeColor(0,0,0)
        line:toBack()
    elseif (event.phase == "ended") then
        display.remove(line)
        line = nil
        xForce = smile.x - event.x 
        yForce = smile.y-event.y
		shoot(xForce,yForce)
        Runtime:removeEventListener("touch",drawLine)
    end
end

Runtime:addEventListener("touch", drawLine)

local function moveCamera(event)
	-- if the smile object exists, track the smile object
    if (smile ~= nil) then
        local offsetX = 100
        local displayLeft = -camera.x
        local nonScrollingWidth = display.contentWidth / 2 

        if (smile.x >= (mapBorderLeft + offsetX) and smile.x <= (mapBorderRight - nonScrollingWidth) ) then
            if (smile.x > displayLeft + nonScrollingWidth) then
                camera.x = -smile.x + nonScrollingWidth
            elseif (smile.x < displayLeft + offsetX) then
                camera.x = -smile.x + offsetX
            end
        end
    end	
    return true
end
-- moveCamera is executed whenever a new frame is drawn.
Runtime:addEventListener("enterFrame",moveCamera)

local gameOver
local function checkSmilePosition(event)
    local offsetX = 35
    local displayLeft = -camera.x
    if (smile ~= nil) then
        if (smile.x > (mapBorderRight - offsetX) or smile.x < (mapBorderLeft + offsetX) ) then
            gameOver = display.newText("You lost your smile :-(",camera.x, camera.y, native.systemFont, 16)
            Runtime:removeEventListener(moveCamera)
            display.remove(smile)
        end
    end
end
Runtime:addEventListener("enterFrame", checkSmilePosition)
