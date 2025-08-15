-- Initial config
term.setBackgroundColor(colors.black)
term.setTextColor(colors.white)
term.clear()

-- Combat stats
local playerHP = 20
local enemyHP = 20
local turn = "menu" -- menu, defense
local selection = 1
local menuOptions = {"FIGHT", "ACT", "ITEM", "MERCY"}

-- Defense area
local w, h = term.getSize()
local boxW, boxH = math.floor(w * 0.6), math.floor(h * 0.5)
local boxX, boxY = math.floor((w - boxW) / 2), math.floor(h / 3)
local heartX, heartY = boxX + math.floor(boxW / 2), boxY + math.floor(boxH / 2)
local projectiles = {}

-- Draw functions
local function clear()
    term.setBackgroundColor(colors.black)
    term.clear()
end

local function drawMenu()
    clear()
    term.setCursorPos(1,1)
    term.write("HP: "..playerHP.."   ENEMY HP: "..enemyHP)
    term.setCursorPos(1,3)
    for i, option in ipairs(menuOptions) do
        if i == selection then
            term.setTextColor(colors.yellow)
        else
            term.setTextColor(colors.white)
        end
        term.write(option.."  ")
    end
end

local function drawDefense()
    clear()
    term.setCursorPos(1,1)
    term.write("HP: "..playerHP.."   ENEMY HP: "..enemyHP)

    -- Draw box
    term.setTextColor(colors.white)
    for x = boxX, boxX+boxW do
        term.setCursorPos(x, boxY)
        term.write("-")
        term.setCursorPos(x, boxY+boxH)
        term.write("-")
    end
    for y = boxY, boxY+boxH do
        term.setCursorPos(boxX, y)
        term.write("|")
        term.setCursorPos(boxX+boxW, y)
        term.write("|")
    end

    -- Draw heart
    term.setCursorPos(math.floor(heartX), math.floor(heartY))
    term.setTextColor(colors.red)
    term.write("♥")

    -- Draw projectiles
    term.setTextColor(colors.white)
    for _, p in ipairs(projectiles) do
        term.setCursorPos(math.floor(p.x), math.floor(p.y))
        term.write("*")
    end
end

-- Defense fase
local function startDefense()
    projectiles = {}

    -- Patterns
    local patterns = {
        -- Vertical rain
        function()
            for i = 1, 6 do
                table.insert(projectiles, {
                    x = boxX + math.random(1, boxW - 1),
                    y = boxY + 1,
                    dy = 0.2
                })
            end
        end,
        -- Horizontal bursts from left
        function()
            for i = 1, 6 do
                table.insert(projectiles, {
                    x = boxX + 1,
                    y = boxY + math.random(1, boxH - 1),
                    dx = 0.2
                })
            end
        end,
        -- Horizontal bursts from right
        function()
            for i = 1, 6 do
                table.insert(projectiles, {
                    x = boxX + boxW - 1,
                    y = boxY + math.random(1, boxH - 1),
                    dx = -0.2
                })
            end
        end,
        -- Crossed diagonals
        function()
            for i = 1, 4 do
                table.insert(projectiles, {
                    x = boxX + 1,
                    y = boxY + 1,
                    dx = 0.2,
                    dy = 0.2
                })
                table.insert(projectiles, {
                    x = boxX + boxW - 1,
                    y = boxY + 1,
                    dx = -0.2,
                    dy = 0.2
                })
            end
        end
    }

    local startTime = os.clock()
    local lastWave = 0

    while os.clock() - startTime < 5 do
        local elapsed = os.clock() - startTime

        -- Each 1 second, one random pattern
        if elapsed - lastWave >= 1 then
            lastWave = elapsed
            patterns[math.random(#patterns)]()
        end

        -- Move projectiles
        for _, p in ipairs(projectiles) do
            p.x = p.x + (p.dx or 0)
            p.y = p.y + (p.dy or 0)
            if math.floor(p.x) == math.floor(heartX)
            and math.floor(p.y) == math.floor(heartY) then
                playerHP = playerHP - 1
            end
        end

        -- Remove projectiles out of the box
        for i = #projectiles, 1, -1 do
            if projectiles[i].x < boxX + 1 or projectiles[i].x > boxX + boxW - 1 or
               projectiles[i].y < boxY + 1 or projectiles[i].y > boxY + boxH - 1 then
                table.remove(projectiles, i)
            end
        end

        -- Redraw
        drawDefense()

        -- Heart movement
        local e = {os.pullEventRaw()}
        if e[1] == "key" then
            if e[2] == keys.w and heartY > boxY + 1 then heartY = heartY - 1 end
            if e[2] == keys.s and heartY < boxY + boxH - 1 then heartY = heartY + 1 end
            if e[2] == keys.a and heartX > boxX + 1 then heartX = heartX - 1 end
            if e[2] == keys.d and heartX < boxX + boxW - 1 then heartX = heartX + 1 end
        elseif e[1] == "terminate" then
            return
        end
    end

    turn = "menu"
end

-- Main loop
while true do
    if turn == "menu" then
        drawMenu()
        local e = {os.pullEvent("key")}
        if e[2] == keys.left then selection = (selection - 2) % #menuOptions + 1 end
        if e[2] == keys.right then selection = selection % #menuOptions + 1 end
        if e[2] == keys.enter then
            if menuOptions[selection] == "FIGHT" then
                enemyHP = enemyHP - math.random(3,6)
                turn = "defense"
            elseif menuOptions[selection] == "ACT" then
                turn = "defense"
            elseif menuOptions[selection] == "ITEM" then
                playerHP = math.min(playerHP + 5, 20)
                turn = "defense"
            elseif menuOptions[selection] == "MERCY" then
                break
            end
        end
    elseif turn == "defense" then
        startDefense()
    end

    if playerHP <= 0 then
        clear()
        term.setCursorPos(5,5)
        term.write("GAME OVER")
        break
    elseif enemyHP <= 0 then
        clear()
        term.setCursorPos(5,5)
        term.write("YOU WIN!")
        break
    end
end
