local monitor = peripheral.wrap("right")
local w, h = monitor.getSize()
monitor.setTextScale(1)

local cellW = math.floor(w / 3)
local cellH = math.floor(h / 3)

local board = {
    {"", "", ""},
    {"", "", ""},
    {"", "", ""}
}

local function drawBoard()
    monitor.clear()
    monitor.setTextColor(colors.white)

    -- Draw vertical border
    for i = 1, 2 do
        local x = i * cellW + 1
        for y = 1, h do
            monitor.setCursorPos(x, y)
            monitor.write("|")
        end
    end

    -- Draw horizontal border
    for i = 1, 2 do
        local y = i * cellH
        for x = 1, w do
            monitor.setCursorPos(x, y)
            monitor.write("-")
        end
    end

    -- Draw symbols
    for row = 1, 3 do
        for col = 1, 3 do
            local symbol = board[row][col]
            local cx = (col - 1) * cellW + math.floor(cellW / 2)
            local cy = (col - 1) * cellH + math.floor(cellH / 2)
            monitor.setCursorPos(cx, cy)
            monitor.write(symbol == "" and " " or symbol)
        end
    end
end

local function checkWinner()
    for i = 1, 3 do
        -- Rows
        if board[i][1] ~= "" and board[i][1] == board[i][2] and board[i][2] == board[i][3] then
            return board[i][1]
        end
        -- Columns
        if board[1][i] ~= "" and board[1][i] == board[2][i] and board[2][i] == board[3][i] then
            return board[1][i]
        end
    end
        -- Diagonals
    if board[1][1] ~= "" and board[1][1] == board[2][2] and board[2][2] == board [3][3] then
        return board[1][1]
    end
    if board[1][3] ~= "" and board[1][3] == board[2][2] and board[2][2] == board [3][1] then
        return board[1][1]
    end
    return nil
end

-- Detect draw
local function isBoardFull()
    for row = 1, 3 do
        for col = 1, 3 do
            if board[row][col] == "" then
                return false
            end
        end
    end
    return true
end

-- Convert click to cell
local function getCellFromClick(x, y)
    local col = math.ceil(x / cellW)
    local row = math.ceil(y / cellH)
    if col >= 1 and col <= 3 and row >= 1 and row <= 3 then
        return row, col
    end
    return nil
end

-- Main
local currentPlayer = "x"
while true do
    drawBoard()
    local event, side, x, y = os.pullEvent("monitor_touch")
    local row, col = getCellFromClick(x, y)

    if row and col and board[row][col] == "" then
        board[row][col] = currentPlayer

        local winner = checkWinner()
        if winner then
            drawBoard()
            monitor.setCursorPos(1, h)
            monitor.write("Winner: " .. winner)
            sleep(3)
            break
        elseif isBoardFull then
            drawBoard()
            monitor.setCursorPos(1, h)
            monitor.write("Draw!")
            sleep(3)
            break
        end

        currentPlayer = (currentPlayer == "x") and "o" or "x"
    end
end

-- End of the game
monitor.clear()
monitor.setCursorPos(math.floor(w / 2 - 6), math.floor(h / 2))
monitor.write("Rebooting...")
sleep(2)
os.reboot()