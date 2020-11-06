-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

local physics = require('physics')
physics.start()
physics.setGravity(0,0)

--background
local bg = display.newImageRect("img/vortex.png",960,540)
bg.x = display.contentCenterX
bg.y = display.contentCenterY

--score text
local score = 0 
local scoreTxt = display.newText({text="Score: 0", fontSize=60})
scoreTxt.x = display.contentCenterX
scoreTxt.y = 30

--border barriers
local  topBarrier = display.newRect(0,0,960,1)
topBarrier.x = display.contentCenterX
topBarrier.y = 0
topBarrier.type="barrier"

local  bottomBarrier = display.newRect(0,0,960,1)
bottomBarrier.x = display.contentCenterX
bottomBarrier.y = 540
bottomBarrier.type="barrier"


local  leftBarrier = display.newRect(0,0,1,540)
leftBarrier.x = 0
leftBarrier.y = display.contentCenterY
leftBarrier.type="barrier"


local  rightBarrier = display.newRect(0,0,1,540)
rightBarrier.x = 960
rightBarrier.y = display.contentCenterY
rightBarrier.type="barrier"

--adding all the barriers to the physics
local topBarrier_filter = {categoryBits = 16, maskBits = 15}
physics.addBody(topBarrier, "static", {bounce = 1, friction = 0})

local bottomBarrier_filter = {categoryBits = 16, maskBits = 15}
physics.addBody(bottomBarrier, "static", {bounce = 1, friction = 0})

local leftBarrier_filter = {categoryBits = 16, maskBits = 15}
physics.addBody(leftBarrier, "static", {bounce = 1, friction = 0})

local rightBarrier_filter = {categoryBits = 16, maskBits = 15}
physics.addBody(rightBarrier, "static", {bounce = 1, friction = 0})


local function newCandy(type,x,y,width,height)
	local candyNumber -- random number used to generate the random candy
	local candy       -- variable to store the new candy
	local candyFilter -- collision filter for the new candy
	local candyOutline -- outline of the new candy
	local forceDirX -- direction of the horizontal force of the candy
	                --  -1 = left, 1 = right
	local forceDirY  -- direction of the vertical force of the candy
	                 --  -1 = up, 1 = down
	local forceX  -- value for the horizontal force component
    local forceY  -- value for the vertical force component	
    
    if (type == "pillow") then
        candyNumber = math.random(1, 6)
        candyFilter = {categoryBits = 1, maskBits = 17}
        candyOutline = graphics.newOutline(1, "img/"..candyNumber..".png")
    elseif (type == "star") then
        candyNumber = math.random(7, 12)    
        candyFilter = {categoryBits = 2, maskBits = 18}
        candyOutline = graphics.newOutline(1, "img/"..candyNumber..".png")
    elseif (type == "rounded") then
        candyNumber = math.random(13, 18)
        candyFilter = {categoryBits = 4, maskBits = 20}
        candyOutline = graphics.newOutline(1, "img/"..candyNumber..".png")
    elseif (type == "stick") then 
        candyNumber = 19
        candyFilter = {categoryBits = 8, maskBits = 24}
        candyOutline = graphics.newOutline(1, "img/"..candyNumber..".png")
    end

    --forceDirX and forceDirY
    if math.random() >= 0.5 then		  
        forceDirX=1
    else
        forceDirX=-1
    end 
    if math.random() >= 0.5 then		  
            forceDirY=1
    else
            forceDirY=-1
    end 

    --forceX and forceY
    forceX = math.random(10, 140)
    forceY = math.random(10, 140)
    --generating the candy
    candy = display.newImageRect("img/"..candyNumber..".png", candy.width, candy.height)
    candy.x = event.x 
    candy.y = event.y
    candy.type = type
    physics.addBody(candy, "dynamic", {outline = candyOutline, filter = candyFilter})
    candy:applyForce(forceX * forceDirX, forceY * forceDirY, candy.x, candy.y)

    return candy
end

-- this listener generates a candy of the category pillow
-- at the tapped position.
local function generateCandy(event)	
	local select = math.random(5)
	local candy
	if select == 1 then
	   candy = newCandy("pillow",event.x,event.y,35,35)
    elseif select == 2 then
       candy = newCandy("star",event.x,event.y,28,28)
    elseif select == 3 then
      candy = newCandy("rounded",event.x,event.y,44,24)   
    elseif select == 4 then
     candy = newCandy("stick",event.x,event.y,32,56)    
	end 
	return true
end

Runtime:addEventListener("tap", generateCandy)

local function onCandyCollision(event)
    local candy
    local candyNumber	
    
    -- candy1 and candy2 are the two candies involved in the collision 
    local candy1 = event.object1
    local candy2 = event.object2

    if (event.phase == "began") then 
        if (candy1.type == candy2.type) then
            local plus_one = display.newText({text = "+1", x = event.x, y = event.y})
            transition.to(plus_one, {x = 80, alpha = 0})
            score = score + 1
            scoreTxt.text = score
            local Score = display.newText(scoreTxt)
        elseif (event.phase == "ended") then
            if (event.element1 == candy1 and event.element2 == candy2) then
                candy1:removeSelf()
                candy2:removeSelf()
            end
        end
    end
    return true
end

Runtime:addEventListener("collsion", onCandyCollision)