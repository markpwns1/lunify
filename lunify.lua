
local var_mt = { 
    __tostring = function(self) return self.name end,
    __eq = function(a, b) return a.name == b.name end
}

local function var(name) 
    return setmetatable({ name = name }, var_mt)
end

local function is_var(v)
    return getmetatable(v) == var_mt
end

local function concat(a, b)
    for i, v in ipairs(b) do a[#a+1] = v end
    return a
end

local function compatible(a, b)
    if is_var(a) or is_var(b) then
        return true
    elseif type(a) ~= type(b) then 
        return false
    elseif type(a) == "table" then
        for k, v in pairs(a) do
            if not compatible(v, b[k]) then return false end 
        end
        for k, v in pairs(b) do 
            if not compatible(v, a[k]) then return false end 
        end
        return true
    else
        return a == b 
    end
end

local function get_replacements(a, b)
    if not compatible(a, b) then 
        return {}, false
    elseif is_var(a) and is_var(b) then
        return { { from = a, to = b }, { from = b, to = a } }, true
    elseif is_var(a) then
        return { { from = a, to = b } }, true
    elseif is_var(b) then
        return { { from = b, to = a } }, true
    elseif type(a) == "table" then 
        local replacements = {}
        local success = true
        for k, v in pairs(a) do 
            local r, s = get_replacements(v, b[k])
            if not s then success = false end
            concat(replacements, r)
        end
        return replacements, success
    else 
        return {}, true
    end
end

local function resolve(r)
    local success = true
    for _, r0 in pairs(r) do
        for k, r1 in pairs(r) do 
            if r0 ~= r1 then
                if r0.from == r1.from and r0.from.name ~= "_" and not compatible(r1.to, r0.to) then 
                    success = false 
                end

                if r1.to == r0.from then 
                    r1.to = r0.to 
                end
            end
        end
    end

    local a = {}
    for i, v in ipairs(r) do
        if v.from ~= v.to then 
            a[v.from.name] = v.to
        end
    end
    a["_"] = nil

    return success, a 
end

local function unify(a, b, c, ...)
    if c ~= nil then error("expected 2 arguments to 'unify' but got " .. (3+#({...})), 2) end
    return resolve(get_replacements(a, b))
end

local function apply(t, r)
    if is_var(t) then 
        return r[t.name] or t
    elseif type(t) == "table" then 
        local t0 = setmetatable({}, getmetatable(t))
        for k, v in pairs(t) do 
            t0[k] = apply(v, r)
        end
        return t0
    else 
        return t
    end
end

return setmetatable({
    replace = apply,
    var = var,
    _ = var("_")
}, {
    __call = function(_, ...) return unify(...) end
})

