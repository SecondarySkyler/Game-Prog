-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

local plane = display.newImageRect("img/planeRed1.png", 88, 73)
plane.x = display.contentCenterX
plane.y = display.contentCenterY

local function moveOnTouch(event)
    plane.y = event.y
    if (plane.y <= 0) then
        plane.y = 0 
    elseif (plane.y >= display.contentHeight) then
        plane.y = display.contentHeight
    end
end



plane:addEventListener("touch", moveOnTouch)
