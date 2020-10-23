-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------
local camera = display.newGroup()
local control = display.newGroup()
camera.anchorX = 0
camera.anchorY = 0
camera.x = 0
camera.y = 0

--Map borders
local borderTop = 0
local borderLeft = 0
local borderRight = 3840
local borderBottom = 2048


local background = display.newImageRect(camera, "img/sea.png", 3840, 2048)
background.anchorX = 0
background.anchorY = 0
background.x = 0
background.y = 0
local islands = display.newImageRect(camera, "img/islands.png", 3840, 2048)
islands.anchorX = 0
islands.anchorY = 0
islands.x = 0
islands.y = 0


local arrowUp = display.newImageRect(control, "arrows/arrowUp.png", 80, 80)
arrowUp.x = 150
arrowUp.y = display.contentHeight - arrowUp.height * 2
arrowUp.name = "up"
local arrowDown = display.newImageRect(control, "arrows/arrowDown.png", 80, 80)
arrowDown.x = 150
arrowDown.y = display.contentHeight - arrowDown.height + 30
arrowDown.name = "down"
local arrowLeft = display.newImageRect(control, "arrows/arrowLeft.png", 80, 80)
arrowLeft.x = 80
arrowLeft.y = (arrowUp.y + arrowDown.y) / 2
arrowLeft.name = "left"
local arrowRight = display.newImageRect(control, "arrows/arrowRight.png", 80, 80)
arrowRight.x = 220
arrowRight.y = (arrowUp.y + arrowDown.y) / 2
arrowRight.name = "right"

local function moveCamera(event)
    local arrow = event.target
    local displayLeft = - camera.x 
    local displayRight = displayLeft + display.contentWidth
    local displayTop = - camera.y 
    local displayBottom = displayTop + display.contentHeight

    if (arrow.name == "up") then
        if (displayTop > borderTop) then
            camera.y = camera.y + 240
        end
        --stuff
    elseif (arrow.name == "down") then
        if (displayBottom < borderBottom) then
            camera.y = camera.y - 240
        end
        --stuff
    elseif (arrow.name == "left") then
        if (displayLeft > borderLeft) then
            camera.x = camera.x + 270
        end
        --stuff
    elseif (arrow.name == "right") then
        if (displayRight < borderRight) then
            camera.x = camera.x - 270
        --stuff
        end
    end
end

arrowUp:addEventListener("tap", moveCamera)
arrowDown:addEventListener("tap", moveCamera)
arrowLeft:addEventListener("tap", moveCamera)
arrowRight:addEventListener("tap", moveCamera)