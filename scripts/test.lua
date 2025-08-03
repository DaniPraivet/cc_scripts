monitor = peripheral.wrap("right")

monitor.setTextScale(1)

w,h = monitor.getSize()
isColor = monitor.isColor()
monitor.setCursorPos(1,h/2)
monitor.clear()

if isColor then
    monitor.setBackgroundColor(colors.gray)

    monitor.write("You are using a ")

    monitor.setTextColor(colors.red)
    monitor.write("C")

    monitor.setTextColor(colors.yellow)
    monitor.write("o")

    monitor.setTextColor(colors.blue)
    monitor.write("l")

    monitor.setTextColor(colors.green)
    monitor.write("o")

    monitor.setTextColor(colors.cyan)
    monitor.write("r")

    monitor.setTextColor(colors.white)
    monitor.write(" monitor")
else
    monitor.write("You are using a normal monitor")
end

monitor.setCursorPos(1, h / 2 + 1)
monitor.write("with size " .. w .. "x" .. h)