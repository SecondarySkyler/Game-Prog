-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

local background = display.newGroup()
local foreground = display.newGroup()

local rocks = {}
local missiles = {}

local bg = display.newImageRect(background, "img/background.png", 960, 540)
bg.x = display.contentCenterX
bg.y = display.contentCenterY

local ground = display.newImageRect(foreground, "img/groundGrass.png", 960, 71)
ground.anchorX = 0
ground.anchorY = 0
ground.x = 0
ground.y = display.contentHeight - ground.height
ground.speed = 5

local ground_next = display.newImageRect(foreground, "img/groundGrass.png", 960, 71)
ground_next.anchorX = 0
ground_next.anchorY = 0
ground_next.x = display.contentWidth
ground_next.y = display.contentHeight - ground_next.height
ground_next.speed = 5

local topGround = display.newImageRect(foreground, "img/top.png", 960, 84)
topGround.anchorX = 0
topGround.anchorY = 0
topGround.x = 0
topGround.y = 0
topGround.speed = 5

local topGround_next = display.newImageRect(foreground, "img/top.png", 960, 84)
topGround_next.anchorX = 0
topGround_next.anchorY = 0
topGround_next.x = display.contentWidth
topGround_next.y = 0
topGround_next.speed = 5

local optionsPlane = {
    width = 88,
    height = 73,
    numFrames = 3
}

local missileOptions = {
    width = 44,
    height = 32,
    numFrames = 4
}
local missileSheet = graphics.newImageSheet("img/missileSheet.png", missileOptions)

local missile_seqs = {
    name = "missile",
    start = 1,
    count = 4,
    time = 100,
    loopCount = 4,
    loopDirection = "forward"
}

local planeSheet = graphics.newImageSheet("img/planeSheet.png", optionsPlane)

local plane_seqs = {
     name = "fly",
     start = 1,
     count = 3,
     time = 100,
     loopCount = 0,
     loopDirection = "bounce"
 }

local plane = display.newSprite(planeSheet, plane_seqs)
plane.x = 100
plane.y = display.contentCenterY
plane:play()

local button = display.newImageRect(foreground, "img/redButton.png", 280, 175)
button.x = display.contentWidth - 75
button.y = display.contentHeight - 50

local function shoot(event)
    local missile = display.newSprite(foreground, missileSheet, missile_seqs)
    missile:toBack()
    missile.x = plane.x
    missile.y = plane.y 
    missile:play()
    table.insert(missiles, missile)
    local shoot = transition.to(missile, {time = 800, x = 1080})
end

local function groundScroll(self, event)
    if (self.x < -display.contentWidth) then
        self.x = display.contentWidth - self.speed * 2
    else
        self.x = self.x - self.speed
    end
end


local function create(event) 
    local rock
    local boolean = math.random(1,2)
    if (boolean == 1) then
        rock = display.newImageRect(foreground, "img/rockGrass.png", 108, 239)
        rock.x = 1080
        rock.y = display.contentHeight - math.random(10, 120)
    else
        rock = display.newImageRect(foreground, "img/rockGrassDown.png", 108, 239)
        rock.x = 1080
        rock.y = 0 + math.random(10, 120)
    end
    rock:toBack()
    table.insert(rocks, rock)
    return rock
end

local function moveRock(self, event)
    self.x = self.x - 5
end

local function gameLoop()
    local rock = create()
    rock.enterFrame = moveRock
    Runtime:addEventListener("enterFrame", rock)

    for i, thisRock in ipairs(rocks) do
        if thisRock.x < -80 then
            Runtime:removeEventListener("enterFrame", thisRock)
            display.remove(thisRock)
            table.remove(rocks, i)
            print(table.maxn(rocks))
        end
    end

    for i, thisMissile in ipairs(missiles) do 
        if thisMissile.x >= 980 then
            display.remove(thisMissile)
            table.remove(missiles, i)
        end
    end
end

local timer = timer.performWithDelay(1000, gameLoop, 0)


ground.enterFrame = groundScroll
Runtime:addEventListener("enterFrame", ground)
ground_next.enterFrame = groundScroll
Runtime:addEventListener("enterFrame", ground_next)
topGround.enterFrame = groundScroll
Runtime:addEventListener("enterFrame", topGround)
topGround_next.enterFrame = groundScroll
Runtime:addEventListener("enterFrame", topGround_next)

button:addEventListener("tap", shoot)





