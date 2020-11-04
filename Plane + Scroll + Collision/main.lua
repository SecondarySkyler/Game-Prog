local physics = require('physics')
physics.start()
physics.pause()
physics.setDrawMode("hybrid")
physics.setGravity(0, 20)

--table to manage rock
local rocks = {}

--background and foregorund group
local bg = display.newGroup()
local fg = display.newGroup()

local background = display.newImageRect(bg, "img/background.png", 960, 540)
background.x = display.contentCenterX
background.y = display.contentCenterY

local ground = display.newImageRect(fg,"img/groundGrass.png",960,84)
ground.anchorX=0
ground.anchorY=0
ground.x = 0
ground.y = display.contentHeight-84

local ground_next = display.newImageRect(fg,"img/groundGrass.png",960,84)
ground_next.anchorX=0
ground_next.anchorY=0
ground_next.x = display.contentWidth
ground_next.y = display.contentHeight-84

--adding ground and ground_next to the physics with coarseness outline
local ground_outline = graphics.newOutline(1, "img/groundGrass.png")
physics.addBody(ground, "kinematic", {outline = ground_outline})
physics.addBody(ground_next, "kinematic", {outline = ground_outline})


-- ceiling and ceiling_next creation
local top = display.newImageRect(fg,"img/top.png",960,84)
top.anchorX=0
top.anchorY=0
top.x = -300
top.y = 0

local top_next = display.newImageRect(fg,"img/top.png",960,84)
top_next.anchorX=0
top_next.anchorY=0
top_next.x = display.contentWidth-300
top_next.y = 0

--adding top and top_next to the physics with coarseness outline
local top_outline = graphics.newOutline(1, "img/top.png")
physics.addBody(top, "kinematic", {outline = top_outline})
physics.addBody(top_next, "kinematic", {outline = top_outline})

--defining the explosion sheet
local optionsExplo = {width = 96, height = 95, numFrames = 18}
local explosionSheet = graphics.newImageSheet("img/explosion_sheet.png", optionsExplo)
local explosionSequences = {name = "explode", start = 1, count = 18, time = 900, loopCount = 1}


--defining the plane sheet
local optionsPlane = {width = 88, height = 73, numFrames = 3}
local planeSheet = graphics.newImageSheet("img/planeSheet.png", optionsPlane)
local planeSequences = {name = "fly", start = 1, count = 3, time = 100, loopCount = 0, loopDirection = "bounce"}
local plane_outline = graphics.newOutline(1, "img/plane.png")

local plane = display.newSprite(planeSheet, planeSequences)
plane.x = display.contentCenterX
plane.y = -100
physics.addBody(plane, {outline = plane_outline})
plane.isFixedRotation = true
--transition for plane
local planeEnter = transition.to(plane, {time = 300, y = display.contentCenterY})

--creating the explosion object
local explosion = display.newSprite(explosionSheet, explosionSequences)
explosion.x = plane.x
explosion.y = plane.y 
explosion.isVisible = false

--defining tap images and their transition with blink
local tapLeft = display.newImageRect("img/tapLeft.png", 85, 42)
tapLeft.x = 1060
tapLeft.y = display.contentCenterY

local tapRight = display.newImageRect("img/tapRight.png", 85, 42)
tapRight.x = -100
tapRight.y = display.contentCenterY

local tapLeftEnter = transition.to(tapLeft, {delay = 600, x = plane.x + 90, transition = easing.outBounce})
local tapRightEnter = transition.to(tapRight, {delay = 600, x = plane.x - 90, transition = easing.outBounce})

transition.blink (tapLeft, {time = 1000})
transition.blink (tapRight, {time = 1000})


local function startGame()
    physics.start()
    plane:removeEventListener("tap", plane)

    local function groundScroll(self, event)
        if (self.x < -display.contentWidth) then
            self.x = display.contentWidth - 10
        else
            self:setLinearVelocity(-200, 0)
        end
    end
    
    
    local function createRock(event)
        local rock 
        local boolean = math.random(1, 2)
        if (boolean == 1) then
            rock = display.newImageRect(fg, "img/rockGrass.png", 108, 239)
            rock.x = 1080
            rock.y = display.contentHeight - math.random(10, 120)
            rock.outline = graphics.newOutline(1, "img/rockGrass.png")
        else
            rock = display.newImageRect(fg, "img/rockGrassDown.png", 108, 239)
            rock.x = 1080
            rock.y = 0 + math.random(10, 120)
            rock.outline = graphics.newOutline(1, "img/rockGrassDown.png")
        end
        rock:toBack()
        table.insert(rocks, rock)
        physics.addBody(rock, "kinematic", {outline = rock.outline})
        return rock
    end
    
    local function moveRock(self, event)
        self:setLinearVelocity(-200, 0)
    end
    
    local function gameLoop(event)
        local rock = createRock()
        rock.enterFrame = moveRock
        Runtime:addEventListener("enterFrame", rock)
    
        for i, thisRock in ipairs(rocks) do 
            if (thisRock.x < -80) then
                Runtime:removeEventListener("enterFrame", thisRock)
                display.remove(thisRock)
                table.remove(rocks, i)
            end
        end
    end

    local function movePlane(event)
        if (plane ~= nil) then
            plane:applyLinearImpulse(0, -0.6, plane.x, plane.y)
        end
    end

    local function gameOver(event)
        if (plane ~= nil) then
            timer.cancel(timer)
            display.remove(plane)
            Runtime:removeEventListener("enterFrame", top)
            Runtime:removeEventListener("enterFrame", top_next)
            Runtime:removeEventListener("enterFrame", ground)
            Runtime:removeEventListener("enterFrame", ground_next)
            local go_image = display.newImageRect("img/GameOver.png", 412, 78)
            go_image.x = display.contentCenterX
            go_image.y = display.contentCenterY

            for i = #rocks, 1, -1 do
                Runtime:removeEventListener("enterFrame", rocks[i])
            end 
        end

    end

    local function planeCollision(self,event)
        if (event.phase == "began") then
            Runtime:removeEventListener("tap", movePlane)
            plane.isVisible = false
            explosion.x = plane.x
            explosion.y = plane.y
            explosion.isVisible = true
            explosion:play()
        elseif (event.phase == "ended") then
            gameOver()
        end
        return true
    end

    plane:addEventListener("collision", planeCollision)

    

    
    Runtime:addEventListener("tap", movePlane)
    
    top.enterFrame = groundScroll
    Runtime:addEventListener("enterFrame",top)
    top_next.enterFrame = groundScroll
    Runtime:addEventListener("enterFrame",top_next)
    ground.enterFrame = groundScroll
    Runtime:addEventListener("enterFrame",ground)
    ground_next.enterFrame = groundScroll
    Runtime:addEventListener("enterFrame",ground_next)

    local timer = timer.performWithDelay(1000, gameLoop, 0)

end

local function endIntro(self, event)
    transition.cancelAll()
    display.remove(tapLeft)
    display.remove(tapRight)

    plane:play()
    --plane.x = transition.to(plane, {x = 220, time = 300})

    startGame()

end

plane.tap = endIntro
plane:addEventListener("tap", plane)





