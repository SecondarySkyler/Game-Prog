local M = {}

local function checkCatPosition(self, event)
    if (self.x >= 304 or self.x <= 304 - 32 * 3) then
        self.speedDir = -self.speedDir
        self:setLinearVelocity(self.speedDir * self.speed, 0)
        self.xScale = -self.speedDir
    end
end


function M.findCat(level)
    local cat = level:findObject("cat")
    print("cat is at: "..cat.x)

    cat.speedDir = -1
    cat.speed = 16

    physics.removeBody(cat)
    local catShape={-10,16,10,16,-10,0,10,0}
    physics.addBody(cat, "kinematic",  {shape = catShape, isSensor = true})

    cat.enterFrame = checkCatPosition
end

function M.findCat2(level)
    local cat2 = level:findObject("cat2")
    print("cat2 is at: "..cat2.x)

    cat2.speedDir = -1
    cat2.speed = 16

    physics.removeBody(cat2)
    local catShape={-10,16,10,16,-10,0,10,0}
    physics.addBody(cat2, "kinematic",  {shape = catShape, isSensor = true})
    print("speed: "..cat2.speed)
    cat2.enterFrame = checkCatPosition
end

function M.animate(enemy)
    enemy:setLinearVelocity(enemy.speedDir * enemy.speed, 0)
    Runtime:addEventListener("enterFrame", enemy)
end

return M