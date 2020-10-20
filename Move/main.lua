-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

local rect = display.newRect(0,0,100,100)
rect.x = 100
rect.y = display.contentCenterY

local function move (event) 
    while (event.keyName == "d") do
        rect.x = rect.x + 10
    end
end

rect:addEventListener("d", move)
