local M = {}

function M.new()
    local penguinOptions = {numFrames = 51, width = 32, height = 32}
    local penguinSheet = graphics.newImageSheet("img/penguinSheet.png", penguinOptions)

    local penguinSequences = {
        {
            count = 8,
            start = 1,
            name = "walk",
            loopCount = 0,
            loopDirection = "forward",
            time = 600
        },
        {
            count = 8,
            start = 9,
            name = "climbUp",
            loopCount = 0,
            loopDirection = "forward",
            time = 100
        },
        {
            count = 6,
            start = 32,
            name = "jump",
            loopCount = 0,
            loopDirection = "forward",
            time = 600
        },
        {
            count = 8,
            start = 44,
            name = "die",
            loopCount = 1,
            loopDirection = "forward",
            time = 800
        }
    }

    local penguin = display.newSprite(penguinSheet, penguinSequences)
    local penguinShape = {-6, 0, 6, 0, -6, 16, 6, 16}

    physics.addBody(penguin, "dynamic", {bounce = 0.0, density = 1.6, shape = penguinShape})
    penguin.isFixedRotation = true



    return penguin
end


function M.init(penguin, xPos, yPos, speed, speedDir, jumpAllowed, isOnLadder)
    penguin.x = xPos
    penguin.y = yPos

    penguin.speed = speed
    penguin.speedDir = speedDir

    penguin.jumpAllowed = jumpAllowed
    penguin.isOnLadder = isOnLadder
end

function M.activate(penguin)
    penguin:setSequence("walk")
    penguin:play()
    penguin:setLinearVelocity(penguin.speedDir * penguin.speed)
    penguin:addEventListener("preCollision", penguin)
    penguin:addEventListener("collision", penguin)
end

return M

