-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

local physics = require('physics')
physics.start()
physics.setGravity(0,0)

local camera = display.newGroup()
local control = display.newGroup()

local mapLimitLeft = 0
local mapLimitRight =5760

local bgLeft = display.newImageRect(camera,"img/background.png",1920,960)
bgLeft.x = display.contentCenterX
bgLeft.y = display.contentCenterY

local bgMiddle = display.newImageRect(camera,"img/background.png",1920,960)
bgMiddle.x = display.contentWidth+display.contentWidth/2
bgMiddle.y = display.contentCenterY

local bgRight = display.newImageRect(camera,"img/background.png",1920,960)
bgRight.x = 2*display.contentWidth+display.contentWidth/2
bgRight.y = display.contentCenterY

local alienBlue = display.newImageRect(camera,"img/alienBlue.png",124,145)
alienBlue.x = display.contentWidth+400
alienBlue.y = display.contentCenterY-300

local alienYellow = display.newImageRect(camera,"img/alienYellow.png",124,145)
alienYellow.x = display.contentWidth*2+900
alienYellow.y = display.contentCenterY+200

-- loading and placement of the bad guy sprite 
local opt = { width = 93, height = 140, numFrames = 60}
local badGuySheet = graphics.newImageSheet("img/badGuySheet.png", opt)
local seqs ={{
	          name = "runLeft",
			  start = 1,
              count = 30,
              time = 300,
			  loopCount = 0,
			  loopDirection ="forward"
	    	 },
			 {
			   name = "runRight",
			   start = 31,
			   count = 30,
			   time = 300,
			   loopCount = 0,
			   loopDirection ="forward"
			 }
			} 

-- The badGuy sprite is inserted in the camera group	
local badGuy = display.newSprite(camera, badGuySheet, seqs)
badGuy.x = 100
badGuy.y = display.contentHeight-232
-- By default, we set the runRight animation sequence
badGuy:setSequence("runRight")

physics.addBody(badGuy, "dynamic")

local arrowLeft = display.newImageRect(control,"img/arrowLeft.png",80,80)
arrowLeft.x = 100
arrowLeft.y = display.contentCenterY
arrowLeft.name = "left"

local arrowRight = display.newImageRect(control,"img/arrowRight.png",80,80)
arrowRight.x = display.contentWidth-100
arrowRight.y = display.contentCenterY
arrowRight.name = "right"

-- textual object containing the x-coordinate of the bad guy
local xBad = display.newText({parent=control,text = "x guy: ",font="Arial"})
xBad:setFillColor(0)
xBad.x = 200
xBad.y= 200
xBad.anchorX = 0
xBad.anchorY = 0 

-- textual object containing the x-coordinate of the camera group
local xCam = display.newText({parent=control,text = "x cam: ",font="Arial"})
xCam:setFillColor(0)
xCam.x = 200
xCam.y= 300
xCam.anchorX = 0
xCam.anchorY = 0 

local function moveBadGuy(event)
    local arrow = event.target

    if (event.phase == "began") then
        if (arrow.name == "left") then
            badGuy:setSequence("runLeft")
            badGuy:play()
            badGuy:setLinearVelocity(-200, 0)
        
        elseif (arrow.name == "right") then
            badGuy:setSequence("runRight")
            badGuy:play()
            badGuy:setLinearVelocity(200,0)
        end
    elseif (event.phase == "ended") then 
        badGuy:pause()
        badGuy:setLinearVelocity(0,0)
    end
    return true
end

arrowLeft:addEventListener("touch", moveBadGuy)
arrowRight:addEventListener("touch", moveBadGuy)

local function checkBadGuyBorderTrespassing(event)
    if (badGuy.x > mapLimitRight) then
        badGuy.x = mapLimitRight
        badGuy:setLinearVelocity(0,0)
    elseif (badGuy.x < mapLimitLeft) then
        badGuy.x = mapLimitLeft
        badGuy:setLinearVelocity(0,0)
    end
    return true
end

Runtime:addEventListener("enterFrame", checkBadGuyBorderTrespassing)

-- moveCamera listener
local function moveCamera(event)
	local offsetX = badGuy.width
	local displayLeft = -camera.x

	xBad.text = "x bad guy: "..badGuy.x
	xCam.text = "x cam: "..camera.x
	
	local nonScrollingWidth = display.contentWidth-badGuy.width
	if badGuy.x >= mapLimitLeft+offsetX and badGuy.x <= mapLimitRight - offsetX then
		  if badGuy.x>displayLeft+nonScrollingWidth then
	        	    camera.x = -badGuy.x+nonScrollingWidth
	      elseif badGuy.x < displayLeft+offsetX then
	            	camera.x = -badGuy.x+offsetX	
	      end
	end
end

-- activate moveCamera
Runtime:addEventListener("enterFrame",moveCamera)



