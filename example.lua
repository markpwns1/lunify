
local unify = require("lunify")
local var = unify.var
local tail = unify.tail

local a = { var("a"), var("b"), 
  x = {
    z = var("a")
  }, 
  y = var("rest"),
  tail("rest") }

local b = { "hello world", 2, 3, 4, 5, 6, 
  x = {
    z = "hello world",
  },
  y = {3, 4, 5, 6}
}

local success, result = unify(a, b)

if success then 
    for k, v in pairs(result) do 
        print(k .. " := " .. tostring(v))
    end
else
    print("Failed to unify")
end

--[[

Prints the following:
a := hello world
b := 2
c := table: 0x5626f8c691f0 (which is {3,4,5,6})

]]
