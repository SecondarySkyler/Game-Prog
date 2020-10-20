-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

local bg = display.newImageRect("img/bg.png", 960, 540)
bg.x = display.contentCenterX
bg.y = display.contentCenterY

local farCity = display.newImageRect("img/city2.png", 960, 204)
farCity.anchorX = 0
farCity.anchorY = 0
farCity:scale(1,2)
farCity.x = 0
farCity.y = display.contentHeight - farCity.height * 1.5
farCity.speed = 150
farCity.time = 0

local farCityNext = display.newImageRect("img/city2.png", 960, 204)
farCityNext.anchorX = 0
farCityNext.anchorY = 0
farCityNext:scale(1, 2)
farCityNext.x = display.contentWidth
farCityNext.y = display.contentHeight - farCityNext.height * 1.5
farCityNext.speed = 150
farCityNext.time = 0

local nearCity = display.newImageRect("img/city1.png", 960, 456)
nearCity.anchorX = 0
nearCity.anchorY = 0
nearCity:scale(1, 0.4)
nearCity.x = 0
nearCity.y = display.contentHeight - (nearCity.height / 2.5)
nearCity.speed = 200
nearCity.time = 0


local nearCityNext = display.newImageRect("img/city1.png", 960, 456)
nearCityNext.anchorX = 0
nearCityNext.anchorY = 0
nearCityNext:scale(1, 0.4)
nearCityNext.x = display.contentWidth
nearCityNext.y = display.contentHeight - (nearCityNext.height / 2.5)
nearCityNext.speed = 200
nearCityNext.time = 0


local function scroller (self, event) 
    local dur = (event.time - self.time) / 1000
    self.time = event.time
    if self.x < -(display.contentWidth) then -- removed "- self.speed", causing clipping
        self.x = display.contentWidth - 5  -- -5 is set to reduce the gap 
    else
        self.x = self.x - self.speed * dur
    end
end

farCity.enterFrame = scroller
Runtime:addEventListener("enterFrame", farCity)

farCityNext.enterFrame = scroller
Runtime:addEventListener("enterFrame", farCityNext)

nearCity.enterFrame = scroller
Runtime:addEventListener("enterFrame", nearCity)

nearCityNext.enterFrame = scroller
Runtime:addEventListener("enterFrame", nearCityNext)