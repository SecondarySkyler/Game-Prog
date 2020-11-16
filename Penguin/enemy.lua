local M = {}

function M.findCat(level)
    local enemy = level:findObject("cat")
    print("enemy is at: "..enemy.x)
end

function M.findCat2(level)
    local enemy = level:findObject("cat2")
    print("enemy is at: "..enemy.x)
end

return M