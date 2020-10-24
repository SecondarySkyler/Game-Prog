-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- We define a camera group which will contain all non-fixed objects (that is, 
-- all display objects that must scroll) 

local camera = display.newGroup()

-- We also define a group for fixed display objects which will contain
-- the game control images
-- INSERT CODE HERE
local control = display.newGroup()

-- We create a map 5760x960 pixels which consists of 
-- three 1920x960 background images in a row (bgLeft, bgMiddle, bgRight) plus 
-- two aliens (alienBlue, alienYellow) and a bad guy (badGuy).
-- the camera will follow the bad guy.
local bgLeft = display.newImageRect(camera, "img/background.png", 1920, 960)
bgLeft.anchorX = 0
bgLeft.anchorY = 0
bgLeft.x = 0
bgLeft.y = display.contentHeight - bgLeft.height
local bgMiddle = display.newImageRect(camera, "img/background.png", 1920, 960)
bgMiddle.anchorX = 0
bgMiddle.anchorY = 0
bgMiddle.x = 1920
bgMiddle.y = display.contentHeight - bgMiddle.height
local bgRight = display.newImageRect(camera, "img/background.png", 1920, 960)
bgRight.anchorX = 0
bgRight.anchorY = 0
bgRight.x = 1920 * 2
bgRight.y = display.contentHeight - bgRight.height
local alienBlue = display.newImageRect(camera, "img/alienBlue.png", 124, 145)
local alienYellow = display.newImageRect(camera, "img/alienYellow.png", 124, 108)


-- these two variables store the left and right limit of the map

local mapLimitLeft = 0
local mapLimitRight =5760

-- let us load and place the display objects bgLeft,bgMiddle, bgRight
-- alienBue, alienGreen, and badGuy in the camera group, since
-- all this objets must scroll according to the position of the bad guy.
 
-- INSERT CODE HERE
alienBlue.x = display.contentCenterX
alienBlue.y = display.contentCenterY

alienYellow.x = 5000
alienYellow.y = display.contentCenterY - alienYellow.height
-- loading and placement of the bad guy sprite 
local opt = { width = 93, height = 140, numFrames = 60}
local badGuySheet = graphics.newImageSheet("img/badGuySheet.png", opt)
local seqs ={{
	          name = "runLeft",
			  start = 1,
              count = 30,
              time = 300,
			  loopCount = 1,
			  loopDirection ="forward"
	    	 },
			 {
			   name = "runRight",
			   start = 31,
			   count = 30,
			   time = 300,
			   loopCount = 1,
			   loopDirection ="forward"
			 }
			} 

-- The badGuy sprite is inserted in the camera group	
local badGuy=display.newSprite(camera,badGuySheet,seqs)
badGuy.x = 100
badGuy.y = display.contentHeight - 175
badGuy.offsetX = 20
-- By default, we set the runRight animation sequence
badGuy:setSequence("runRight")	

	
-- arrow images for game control are inserted in the control display group
-- INSERT CODE HERE
local arrowLeft = display.newImageRect(control, "img/arrowLeft.png", 80, 80)
arrowLeft.x = 50
arrowLeft.y = display.contentCenterY
arrowLeft.name = "left"

local arrowRight = display.newImageRect(control, "img/arrowRight.png", 80, 80)
arrowRight.x = display.contentWidth - 50
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


-- This is the function listener that control the badguy
local function moveBadGuy(event)
	-- INSERT CODE HERE
	local arrow = event.target
	if (arrow.name == "left") then
		if (badGuy.x <= mapLimitLeft) then
			badGuy.x = mapLimitLeft
		else
			badGuy:setSequence("runLeft")
			badGuy:play()
			badGuy.x = transition.moveBy(badGuy, {x = -70, time = 100})
			xBad.text = badGuy.x 
		end
	else
		if (badGuy.x >= mapLimitRight) then
			badGuy.x = mapLimitRight - badGuy.offsetX
		else
			badGuy:setSequence("runRight")
			badGuy:play()
			badGuy.x = transition.moveBy(badGuy, {x = 70, time = 100})
			xBad.text = badGuy.x 
		end
	end

end

-- activate moveBadGuy listener when left arrow or right arrow is tapped
-- INSERT CODE HERE
arrowLeft:addEventListener("tap", moveBadGuy)
arrowRight:addEventListener("tap", moveBadGuy)

-- Implement moveCamera listener (hint: follow the cameraTracking example)
local function moveCamera(event)
	-- INSERT CODE HERE
	local offsetX = 300
	local displayLeft = -camera.x
	local displayTop = -camera.y 
	local nonScrollingWidth =  display.contentWidth - offsetX
	

	if (badGuy.x >= mapLimitLeft + offsetX and badGuy.x <= mapLimitRight - offsetX) then
		if (badGuy.x > displayLeft + nonScrollingWidth) then
			camera.x = -badGuy.x + nonScrollingWidth
			xCam.text = -camera.x

		elseif (badGuy.x < displayLeft + offsetX) then
			camera.x = -badGuy.x + offsetX
			xCam.text = -camera.x
		end
	end
	return true
end

-- activate camera tracking
-- INSERT CODE HERE
Runtime:addEventListener("enterFrame", moveCamera)