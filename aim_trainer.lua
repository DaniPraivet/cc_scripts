-- Variables
local monitor = peripheral.wrap("right")
local w, h = monitor.getSize()
monitor.setTextScale(1)
math.randomseed(os.time())

local rounds = 30
local reactionTimes = {}

for round = 1, rounds do
    -- Round counter
    monitor.setTextColor(colors.white)
    monitor.clear()
    monitor.setCursorPos(1, 1)
    monitor.write("Round: " .. round)

    -- Generate random position    
    local targetX = math.random(1, w)
    local targetY = math.random(1, h)

    -- Show target
    monitor.setCursorPos(targetX, targetY)
    monitor.write("o")

    -- Start time
    local startTime = os.clock()
    
    while true do
        local event, side, xPos, yPos = os.pullEvent("monitor_touch")
    
        monitor.clear()
        monitor.setCursorPos(w / 2 - 4, h / 2)
        if xPos == targetX and yPos == targetY then
            break
        end
        -- If miss, just wait
    end
    -- Reaction time end time timestamp
    local endtime = os.clock()
    local reactionTime = endTime - startTime
    table.insert(reactionTimes, reactionTime)
end

--  Calculate average reaction time
local sum = 0
for _, time in ipairs(reactionTimes) do
    sum = sum + time
end
local average = sum / #reactionTimes

-- Show results
monitor.clear()
local resultText = string.format("Average time: %.2f s", average)
local x = math.floor((w - #resultText) / 2)
local y = math.floor(h / 2)
monitor.setCursorPos(x, y)
monitor.write(resultText)
