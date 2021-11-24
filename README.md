# Lunify
Lunify is a lightweight unification library for Lua. Simply drag-and-drop `lunify.lua` into your project and follow the example below:

```lua

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
        print(k .. " := " .. inspect(v))
    end
else
    print("Failed to unify")
end

--[[

Prints the following:
a := hello world
b := 2
rest := table: 0x5626f8c691f0 (which is {3,4,5,6})

]]

```

## In detail

Lunify works on all types (including mixed tables) *except for* `thread` and `userdata`. The value that `require("lunify")` returns is a callable table. Let us refer to it as `unify` for brevity's sake. Let `Replacements` represent the type `{ [string]: any }`. 

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
- `tail(name: string): Tail` - a constructor for the `Tail` type, which is a child class of `Var`. Represents a variable at the end of a table, which captures the rest of the elements.
- `_` - simply equivalent to `var("_")`. Variables with the name "_" will be ignored during unification.
- `replace(value: T, replacements: Replacements): T` - given a value and a set of replacements, returns the given value with the replacements applied. Tables will not be modified, but instead the function returns a deep-copy with metatables preserved.
- `combine(a: Replacements, b: Replacements): bool, Replacements` - given two sets of replacements, attempts to combine them, returning `true` if successful, and returning the combined set of replacements. An example where combination would not be successful is if two variables had conflicting values. Again, if the operation was not successful, then the table returned is not well-defined. Note that you can artifically substitute variables by simply creating a table of replacements yourself, like `unify.combine(r, { a = 1, b = 2 })`.


