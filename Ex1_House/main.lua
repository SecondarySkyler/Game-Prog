-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

local background = display.newRect(0, 0, 320, 480)
background.x = display.contentCenterX
background.y = display.contentCenterY

--wall
local wall = display.newRect(0,0,125,75)
wall.x = display.contentCenterX
wall.y = display.contentCenterY
wall:setFillColor(255,255,0)
wall:setStrokeColor(0,0,0)
wall.strokeWidth = 3

--door
local door = display.newRect(0,0,20, 40)
door.x = display.contentCenterX
door.y = display.contentCenterY + 15
door:setFillColor(0.59,0.29,0)
door:setStrokeColor(0,0,0)
door.strokeWidth = 3

--roof
local x1 = wall.x - (125/2)
local y1 = wall.y - (75/2)
local x2 = wall.x 
local y2 = wall.y - 100
local x3 = wall.x + (125/2)
local y3 = wall.y - (75/2)
local roof = display.newLine(x1, y1, x2, y2, x3, y3)
roof:setStrokeColor(0,0,0)
roof.strokeWidth = 4

--orange square
local rect = display.newRect(x2, y2+30, 20, 20)
rect:setFillColor(1,0.65,0.3)
rect:rotate(45)

--windows
local leftWindow = display.newCircle(x2-35, y2+90, 10)
leftWindow:setFillColor(0.5,0.92,1)

local rightWindow = display.newCircle(x2+35, y2+90, 10)
rightWindow:setFillColor(0.5, 0.92, 1)