-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

local volumeBar = {}
local num
for num = 1,3 do 
  volumeBar[num] = display.newImageRect("img/green_bar.png", 190, 45)
  volumeBar[num].x = display.contentCenterX
  volumeBar[num].anchorY = 0
  volumeBar[num].y = 100 + (num - 1) * 100
  volumeBar[num].sound = audio.loadSound("audio/"..num..".wav")
end 

local sliders = {}
for num = 1,3 do 
    sliders[num] = display.newImageRect("img/red_slider.png", 28, 42)
    sliders[num].x = display.contentCenterX
    sliders[num].y = 150 + (num - 1) * 100
    sliders[num].offsetX = 0
end

local barLeftMargin = 65
local barRightMargin = 255


local function moveSlider(event)
    for num = 1,3 do
        if (event.phase == "began") then
            sliders[num].x = event.x - sliders[num].offsetX
            display.currentStage:setFocus(sliders[num])

        elseif (event.phase == "moved") then
            if (sliders[num].x <= barLeftMargin) then
                sliders[num].x = barLeftMargin
            elseif (sliders[num].x >= barRightMargin) then
                sliders[num].x = barRightMargin
            else
                sliders[num].x = event.x - sliders[num].offsetX
            end
            newVolume = (sliders[num].x - 65) / 190
            audio.setVolume (newVolume, {channel = num})

        elseif (event.phase == "ended" or event.phase == "cancelled") then
            display.currentStage:setFocus(nil)
        end
    end      
end





for num = 1,3 do
    sliders[num]:addEventListener("touch", moveSlider)
end