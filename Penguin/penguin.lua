local M = {}

local audioData = require("audioData")

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


    --====== COLLISION ==========
    local function onCollision(self, event)
        local collidedObject = event.other
        local collidedObjectTop = collidedObject.y - collidedObject.height / 2
        local penguinBottom = penguin.y + 16

        if (event.phase == "began") then
            if (collidedObject.type == "barrier") then
                self.speedDir = -self.speedDir
                self:setLinearVelocity(penguin.speedDir * penguin.speed, 0)
                self.xScale = self.speedDir
                audio.play(audioData.soundTable.wall)
            end

            if (collidedObject.type == "platform") then
                if (event.contact.isTouching == true and penguinBottom <= collidedObjectTop) then
                    self.jumpAllowed = true
                    self:setSequence("walk")
                    self:play()
                    self:setLinearVelocity(self.speedDir * self.speed, 0)
                end
            end

            if (collidedObject.name == "egg") then
                collidedObject.isVisible = false
                audio.play(audioData.soundTable.bonus)
            end

            if (collidedObject.name == "cat" or collidedObject.name == "cat2") then
                audio.pause(bgMusic)
                --audio.play(audioData.soundTable.evil) PROBLEM WITH .WAV FILE NVM IT WORKS FINE
                self:setSequence("die")
                self:play()
                Runtime:removeEventListener("tap", onJump)
                physics.pause()
            end

            if (collidedObject.name == "door") then
                audio.pause(bgMusic)
                audio.play(audioData.soundTable.exit) 
                self:pause()
                Runtime:removeEventListener("tap", onJump)
                physics.pause()
            end
            
        end

        if (event.phase == "ended") then
            if (collidedObject.name == "egg") then
                if (collidedObject ~= nil) then
                    display.remove(collidedObject)
                    collidedObject = nil
                end
            end
        end

    end

    local function onJump(self,event)
        if (self.jumpAllowed == true) then
            self:applyLinearImpulse(self.speedDir * 0.09, -2.6, self.x, self.y)
            --audio
            self:setSequence("jump")
            self:play()
            self.jumpAllowed = false
        end
    end

    penguin.collision = onCollision
    penguin.tap = onJump
    

    return penguin
end


function M.init(penguin, xPos, yPos, speed, speedDir, jumpAllowed)
    penguin.x = xPos
    penguin.y = yPos

    penguin.speed = speed
    penguin.speedDir = speedDir

    penguin.jumpAllowed = jumpAllowed
    
end

function M.activate(penguin)
    penguin:setSequence("walk")
    penguin:play()
    penguin:setLinearVelocity(penguin.speedDir * penguin.speed)
    penguin:addEventListener("collision", penguin)
    Runtime:addEventListener("tap", penguin)
end

return M

