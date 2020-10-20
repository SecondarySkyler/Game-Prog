-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

local ball = display.newCircle(display.contentCenterX, display.contentCenterY, 30)
ball:setFillColor(0.4,0.9,0.3)
ball.speedX = 150
ball.speedY = 150
ball.time = 0

local function moveBall (event)
    -- durata del frame, per far si che eventuali rallentamenti hardware non influiscano sulla velocità della sfera
    local dur = (event.time - ball.time) / 1000
    print(dur)
    --aggiorno il tempo di esecuzione dell'applicazione
    ball.time = event.time
    -- check horizontal rebounds
    if (ball.x < 30) then
        ball.x = 30
        ball.speedX = -ball.speedX
    end
    if (ball.y < 30) then
        ball.y = 30
        ball.speedY = -ball.speedY
    end
    if (ball.x > display.contentWidth - 30) then
        ball.x = display.contentWidth - 30
        ball.speedX = -ball.speedX
    end
    if (ball.y > display.contentHeight - 30) then
        ball.y = display.contentHeight - 30
        ball.speedY = -ball.speedY
    end

    ball.x = ball.x + ball.speedX * dur
    ball.y = ball.y + ball.speedY * dur
end
Runtime:addEventListener("enterFrame", moveBall)
