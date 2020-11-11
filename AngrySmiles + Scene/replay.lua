local composer = require( "composer" )
 
local scene = composer.newScene()
 
-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
 
 
 
 
-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------
 
local background  -- variable that stores the background image 
local retry       -- variable that stores the retry image button 

-- create()
function scene:create( event )
 
    local sceneGroup = self.view
	
	-- Load the background image
	background = display.newImageRect("img/backGrass1.png",1920,1080)
	-- load the retry.png image
    retry = display.newImageRect("img/retry.png",400,400)
	
	sceneGroup:insert(background)
	sceneGroup:insert(retry)	  
end
 
 
-- restart is a table listener associated with the retry button
-- which is executed when the retry button is tapped 
local function restart()
	-- go to the game scene
	composer.removeScene("game")
	composer.gotoScene("game")
	return true
end
	 
-- show()
function scene:show( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        
		-- place the retry object at the center of the display
		background.x = display.contentCenterX
		background.y = display.contentCenterY
		-- place the retry object at the center of the display
		retry.x = display.contentCenterX
		retry.y = display.contentCenterY
		
 
    elseif ( phase == "did" ) then
        -- activate the tap listener 
		retry.tap = restart
		retry:addEventListener("tap", restart)
    end
end
 
 
-- hide()
function scene:hide( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is on screen (but is about to go off screen)
		-- Remove the tap listener associated with the retry button
		retry:removeEventListener("tap",replay)
 
    elseif ( phase == "did" ) then
        -- Code here runs immediately after the scene goes entirely off screen
 
    end
end
 
 
-- destroy()
function scene:destroy( event )
 
    local sceneGroup = self.view
    -- Code here runs prior to the removal of scene's view
 
end
 
 
-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
-- -----------------------------------------------------------------------------------
 
return scene