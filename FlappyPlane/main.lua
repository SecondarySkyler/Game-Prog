-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------
local physics = require('physics')
physics.start()

local background = display.newGroup()
local downStalattiti = display.newGroup()
local foreground = display.newGroup()
local upperStalattiti = display.newGroup()


local bg = display.newImageRect(background, "img/background.png", 800, 480)
bg.x = display.contentCenterX
bg.y = display.contentCenterY


local groundGrass = display.newImageRect(foreground, "img/groundGrass.png", 800, 71)
groundGrass.x = display.contentCenterX
groundGrass.y = display.contentCenterY + 150

local upStalattite1 = display.newImageRect(upperStalattiti, "img/rockGrassDown.png", 108, 239)
upStalattite1.x = 390
upStalattite1.y = 90

local upStalattite1 = display.newImageRect(upperStalattiti, "img/rockGrassDown.png", 108, 239)
upStalattite1.x = 650
upStalattite1.y = 70



-- array + ciclo while per la rappresentazione delle stalattiti inferiori
local x = 250
local downStal = {}
local i = 1

while (x <= 800) do
    downStal[i] = display.newImageRect(downStalattiti, "img/rockGrass.png", 108, 239)
    downStal[i].x = x
    downStal[i].y = 340
    x = x + 300
    i = i + 1
end
downStal[2].y = 420 --sistemo l'altezza della seconda stalattite inferiore



-- airplane sheet
local sheetOptions = {
    width = 88,
    height = 73,
    numFrames = 3
}
local sheet_plane = graphics.newImageSheet("img/planeSheet.png", sheetOptions)
local planeSequences = {
    name = "fly",
    start = 1,
    count = 3,
    time = 100,
    loopCount = 0,
    loopDirection = "forward"
}
local sheetPlane = display.newSprite(sheet_plane, planeSequences)
sheetPlane.x = 100
sheetPlane.y = display.contentCenterY
sheetPlane:play()

-- stars + positioning
local stars = {}
    stars[1] = display.newImageRect("img/starBronze.png", 39, 38)
    stars[2] = display.newImageRect("img/starGold.png", 39, 38)
    stars[3] = display.newImageRect("img/starSilver.png", 39, 38)

local i = 1
local x = 100
while (i <= 3) do
    stars[i].x = x
    stars[i].y = 200
    x = x + 200
    i = i + 1
end
stars[2].x = 400
stars[2].y = 300

stars[3].x = 700
stars[3].y = 300

--testo
local score = "Score:1000"
local scoreText = display.newText(score, 80, 80, native.systemFont, 20)
scoreText:setFillColor(0,0,0)

-- adding physics to some element
physics.addBody(groundGrass, "static", {bounce = 0})
physics.addBody(sheetPlane, "dinamic")

-- function fo let the plane fly
local function fly()
    sheetPlane:applyLinearImpulse(0, -0.75, sheetPlane.x, sheetPlane.y)
    sheetPlane:rotate(-30)
end
sheetPlane:addEventListener("tap", fly)


