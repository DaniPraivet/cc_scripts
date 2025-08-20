local function round(n)
  return math.floor(n+0.5)
end

term.clear()
term.setCursorPos(1,1)
print("Write overworld coords:")

write("x: ")
local x = tonumber(read())
write("z: ")
local z = tonumber(read())

local netherX = round(x/8)
local netherZ = round(z/8)

print("Nether coords:")
print("x: " .. netherX .. " - z: " .. netherZ)
