
local unify = require("lunify")
local var = unify.var
local tail = unify.tail

local a = { var("a"), var("b"), 
  x = {
    z = var("c")
  }, 
  y = var("rest"),
  tail("rest") }

local b = { 1, 2, 3, 4, 5, 6, 
  x = {
    z = "hello world",
  },
  y = {3, 4, 5, 6}
}

local success, result = unify(a, b)

if success then 
    for k, v in pairs(result) do 
        print(k .. " := " .. inspect(v))
    end
else
    print("Failed to unify")
end

--[[

Prints the following:
y := 3
x := 1
z := 2
w := p

]]
