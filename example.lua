
local unify = require("lunify")
local var = unify.var

local a = {
    var("x"),
    a = var("y"),
    b = { var("_"), var("_"), var("y") }
}

local b = {
    1,
    a = 3,
    b = { 3, 2, 3 }
}

local success, result = unify(a, b)
if success then 
    for k, v in pairs(result) do 
        print(k .. " := " .. tostring(v))
    end
else
    print("Failed to unify")
end
