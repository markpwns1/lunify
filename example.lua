
local unify = require("lunify")
local var = unify.var

local a = {
    var("x"),
    a = var("y"),
    b = { var("x"), 2, var("y") },
    c = { var("_"), var("_"), 3},
    var("w"),
    var("p")
}

local b = {
    var("x"),
    a = 3,
    b = { var("x"), var("z"), 3 },
    c = { 1, var("x"), 3 },
    var("p"),
    var("w")
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
y := 3
x := 1
z := 2

]]
