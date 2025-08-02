monitor = peripheral.wrap("right")
monitor.setTextScale(1)
w, h = monitor.getSize()
math.randomseed(os.time())

while true do

    targetX = math.random(1, w)
    targetY = math.random(1, h)

    monitor.clear()
    monitor.setCursorPos(targetX, targetY)
    monitor.setTextColor(colors.white)
    monitor.write("X")

    event, side, xPos, yPos = os.pullEvent("monitor_touch")

    monitor.clear()
    monitor.setCursorPos(w / 2 - 4, h / 2)
    if xPos == targetX and yPos == targetY then
        monitor.setTextColor(colors.green)
        monitor.write(":>")
    else
        monitor.setTextColor(colors.red)
        monitor.write(">:(")
    end

    sleep(1.5)
end
