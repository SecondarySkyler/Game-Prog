local composer = require("composer")
local scene = composer.newScene()

--physics
local physics = require("physics")
physics.setDrawMode("normal")
physics.start()

--display groups
local bg = display.newGroup()
local fg = display.newGroup()
local camera = display.newGroup()

--map barrier
local mapBorderLeft = 0
local mapBorderRight = display.contentWidth * 2

--all the variables
local backgroundLeft
local backgroundRight
local leftBarrier
local rightBarrier
local groundLeft
local groundRight
local baseVert
local baseHoriz
local smile
local column1
local column2
local column3
local roof



--create 
function scene:create(event)
    local sceneGroup = self.view

    backgroundLeft = display.newImageRect(bg, "img/backGrass1.png", 1920, 1080)
    backgroundRight = display.newImageRect(bg, "img/backGrass2.png", 1920, 1080)

    leftBarrier = display.newRect(bg, 0, 0, 1, 1080)
    physics.addBody(leftBarrier, "static", {bounce = 0.2, friction = 0.8, density = 1.5})
    
    rightBarrier = display.newRect(bg, 0, 0, 1, 1080)
    physics.addBody(rightBarrier, "static", {bounce = 0.2, friction = 0.8, density = 1.5})

    groundLeft = display.newImageRect(bg, "img/ground.png", 1920, 80)
    physics.addBody(groundLeft, "static", {bounce = 0.2, friction = 0.8, density = 1.5})
    
    groundRight = display.newImageRect(bg, "img/ground.png", 1920, 80)
    physics.addBody(groundRight, "static", {bounce = 0.2, friction = 0.8, density = 1.5})

    baseVert = display.newImageRect(bg, "img/woodVert.png", 70, 140)
    baseHoriz = display.newImageRect(bg, "img/woodHoriz.png", 70, 140)
    physics.addBody(baseVert, "static", {bounce = 0})
    physics.addBody(baseHoriz, "static", {bounce = 0})

    --creating smile
    smile = display.newImageRect(fg, "img/smile.png", 70, 70)
    physics.addBody(smile, "dynamic", {radius = 35, bounce = 0.6, friction = 0.1, density = 2.0})

    
    --creating obstacles
    column1 = display.newImageRect(fg, "img/stoneVert.png", 140, 220)
    physics.addBody(column1, "dynamic", {friction = 0.1, density = 3.0})
    
    column2 = display.newImageRect(fg, "img/stoneVertThin.png", 140, 220)
    physics.addBody(column2, "dynamic", {friction = 0.1, density = 3.0})
    
    column3 = display.newImageRect(fg, "img/stoneVert.png", 140, 220)
    physics.addBody(column3, "dynamic", {friction = 0.1, density = 3.0})

    roof = display.newImageRect(fg, "img/stoneTriangular", 140, 70)
    local triangleShape = {0, -35, 70, 35, -70, 35}
    physics.addBody(roof, "dynamic", {shape = triangleShape, friction = 0.1, density = 3.0})

    camera:insert(bg)
    camera:insert(fg)

    sceneGroup:insert(camera)

end

--shoot function
local function shoot(xForce,yForce)
	smile:applyLinearImpulse(xForce,yForce,smile.x,smile.y)
end

--replay function
local function goToreplay()
	composer.removeScene("replay")
	local options = { effect = "zoomInOutFade",time = 1000}
	composer.gotoScene("replay",options)
end

--draw line fucntion
local line 
local function drawLine(event)
	if event.phase=="moved" then
		if line ~= nil then
			display.remove(line)
			line = nil
		end
		line = display.newLine(fg,smile.x,smile.y,event.x,event.y)
		line.strokeWidth = 8
		line:setStrokeColor(0,0,0)
		line:toBack()
	end
	if event.phase=="ended" then
		display.remove(line)
		line=nil
		xForce = smile.x-event.x
		yForce = smile.y-event.y
		shoot(xForce,yForce)
		Runtime:removeEventListener("touch",drawLine)
		-- Three seconds after the shoot, call the function replay
		-- that goes to  replay scene	
		timer.performWithDelay(5000,goToreplay)
	end	
end 

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
    local displayLeft = -camera.x
    if (smile ~= nil) then
        if (smile.x > (mapBorderRight) or smile.x < (mapBorderLeft + offsetX) ) then
            gameOver = display.newText({parent = fg, text = "You lost your smile", fontSize = 100})
            gameOver.x = displayLeft + display.contentCenterX
            gameOver.y = display.contentCenterY
            Runtime:removeEventListener("enterFrame", moveCamera)
            display.remove(smile)
            smile = nil
        end
    end
end



----------------- SHOW ---------------------------------------
function scene:show(event)
    local sceneGroup = self.view
    local phase = event.phase

    if (phase == "will") then
        backgroundLeft.x = display.contentCenterX
        backgroundLeft.y = display.contentCenterY
        backgroundRight.x = display.contentCenterX
        backgroundRight.y = display.contentCenterY

        leftBarrier.x = 0
        leftBarrier.y = display.contentCenterY
        leftBarrier.alpha = 0
        
        rightBarrier.x = mapBorderRight
        rightBarrier.y = display.contentCenterY
        rightBarrier.alpha = 0

        groundLeft.x  = display.contentCenterX
        groundLeft.y = display.contentHeight - groundLeft.contentHeight/2
        
        groundRight.x  = display.contentCenterX + display.contentWidth
        groundRight.y = display.contentHeight - groundRight.contentHeight/2

        baseVert.x = 400
        baseVert.y = display.contentHeight-ground.contentHeight-70
        baseHoriz.x = 400
        baseHoriz.y = display.contentHeight-ground.contentHeight-baseVert.contentHeight-35
            
        smile.x = 400
        smile.y = display.contentHeight - groundLeft.contentHeight - baseVert.contentHeight-35

        column1.x = 3400
        column1.y = display.contentHeight-ground.contentHeight -110
        
        column2.x = 3400
        column2.y = display.contentHeight-ground.contentHeight -330
        
        column3.x = 3400
        column3.y = display.contentHeight-ground.contentHeight -550

        roof.x = 3400
        roof.y = display.contentHeight-ground.contentHeight-715

    elseif (phase == "did") then 
        physics.start()
        Runtime:addEventListener("touch", drawLine)
        Runtime:addEventListener("enterFrame",moveCamera)
        Runtime:addEventListener("enterFrame",checkSmilePosition)
    end
end


---------------------- HIDE ----------------------------
function scene:hide(event)

    local sceneGroup = self.view
    local phase = event.phase

    if (phase == "will") then
        physics.pause()
        Runtime:removeEventListener("enterFrame", moveCamera)
        Runtime:removeEventListener("enterFrame", checkSmilePosition)
    elseif (phase == "did") then

    end
end

function scene:destroy(event)
    sceneGroup = self.view

end



scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

return scene



    