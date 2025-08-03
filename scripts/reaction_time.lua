-- Variables
local monitor = peripheral.wrap("right")
local w, h = monitor.getSize()
monitor.setTextScale(2)
math.randomseed(os.time())

local rounds = 5
local reactionTimes = {}
local currentRound = 1

while currentRound <= rounds do
    monitor.setBackgroundColor(colors.red)
    monitor.clear()
    monitor.setTextColor(colors.white)
    monitor.setCursorPos(1, 1)
    monitor.write("Espera...")

    local waitTime = math.random(3, 7)
    local startWait = os.clock()
    local tooSoon = false
    -- While it waits, if the player interacts with the monitor, mark as a fail
    parallel.waitForAny(
        function()
            sleep(waitTime)
        end,
        function()
            local event, side, xPos, yPos = os.pullEvent("monitor_touch")
            tooSoon = true
        end
    )

    if tooSoon then
        monitor.setBackgroundColor(colors.black)
        monitor.clear()
        monitor.setCursorPos(1, 1)
        monitor.write("Too soon")
        sleep(2)
        -- Retry the round
    else
        -- Change to green
        monitor.setBackgroundColor(colors.green)
        monitor.clear()
        monitor.setCursorPos(1, 1)
        monitor.write("CLICK!")
        local startTime = os.clock()

        -- Wait for the correct click
        os.pullEvent("monitor_touch")
        local endTime = os.clock()
        local reactionTime = endTime - startTime
        table.insert(reactionTimes, reactionTime)

        -- Show individual score
        monitor.setBackgroundColor(colors.black)
        monitor.clear()
        local resultText = string.format("Tiempo: %.2f s", reactionTime)
        local x = math.floor((w - #resultText) / 2)
        local y = math.floor(h / 2)
        monitor.setCursorPos(x, y)
        monitor.write(resultText)
        sleep(2)

        currentRound = currentRound + 1
    end
end

-- Show average
monitor.setBackgroundColor(colors.black)
monitor.clear()
local sum = 0
for _, time in ipairs(reactionTimes) do
    sum = sum + time
end
local average = sum / #reactionTimes

local resultText = string.format("Average: %.2f s", average)
local x = math.floor((w - #resultText) / 2)
local y = math.floor(h / 2)
monitor.setCursorPos(x, y)
monitor.setTextColor(colors.white)
monitor.write(resultText)
