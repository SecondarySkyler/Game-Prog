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
  volumeBar[num].sound = audio.loadSound("audio/"..num..".mp3")
  audio.play(volumeBar[num].sound, {channel = num, loops = -1})
end 

local sliders = {}
for num = 1,3 do 
    sliders[num] = display.newImageRect("img/red_slider.png", 28, 42)
    sliders[num].x = display.contentCenterX
    sliders[num].y = 150 + (num - 1) * 100
    sliders[num].offsetX = 0
    sliders[num].chn = num
end


local barLeftMargin = 65
local barRightMargin = 255


local function moveSlider(event)
    local slider = event.target
    if (event.phase == "began") then
        slider.x = event.x - slider.offsetX
        display.currentStage:setFocus(slider)

    elseif (event.phase == "moved") then
        if (slider.x <= barLeftMargin) then
            slider.x = barLeftMargin
        elseif (slider.x >= barRightMargin) then
            slider.x = barRightMargin
        else
            slider.x = event.x - slider.offsetX
        end
        newVolume = (slider.x - 65) / 190
        audio.setVolume(newVolume, {channel = slider.chn})

    elseif (event.phase == "ended" or event.phase == "cancelled") then
        display.currentStage:setFocus(nil)
    end
    return true
end





for num = 1,3 do
    sliders[num]:addEventListener("touch", moveSlider)
end