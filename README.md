# Lunify
Lunify is a lightweight unification library for Lua. Simply drag-and-drop `lunify.lua` into your project and follow the example below:

```lua
local unify = require("lunify")
local var = unify.var

local a = {
    var("x"),
    a = var("y"),
    b = { var("x"), 2, var("y") },
    c = { var("_"), var("_"), 3}
}

local b = {
    var("x"),
    a = 3,
    b = { var("x"), var("z"), 3 },
    c = { 1, var("x"), 3 }
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
```

## In detail

The value that `require("lunify")` returns is a callable table. Let us refer to it as `unify` for brevity's sake. Let `Replacements` represent the type `{ [string]: any }`. 

`unify`'s function signature is `unify(a: any, b: any): bool, Replacements`. In other words, `unify` takes in two arbitrary values and returns two values: a boolean which will be set to `true` if unification was successful, and a table where the keys are variable names and the values are the variable's values after unification. In the event that unification is not successful, this table is not well-defined, meaning that the values are probably wrong and should not be used. 

Note that there may still be unresolved variables after unification. For example, unifying the following:
```lua
local a = { var("y"), var("z"), var("x") }
local b = { var("x"), var("y"), var("z") }
```
will return
```
y := x
z := x
```

`unify` contains the following fields:
- `var(name: string): Var` - a constructor for the `Var` type, which represents a unification variable. It takes in a string representing the variable's name. Any two variables with the same name are considered equal.
- `_` - simply equivalent to `var("_")`. Variables with the name "_" will be ignored during unification.
- `replace(value: T, replacements: Replacements): T` - given a value and a set of replacements, returns the given value with the replacements applied. Tables will not be modified, but instead the function returns a deep-copy with metatables preserved.
- `combine(a: Replacements, b: Replacements): bool, Replacements` - given two sets of replacements, attempts to combine them, returning a `true` if successful, and returning the combined set of replacements. An example where combination would not be successful is if two variables had conflicting values. Again, if the operation was not successful, then the table returned is not well-defined.


