local cache = {}
cache.__index = cache

function cache.new(table)
    local o = setmetatable({}, cache)

    table = table or { date = 0, data = {} }

    o.date = table.date or 0
    o.data = table.data or {}

    return o
end

-- sets a global time value as well as individual timestamps for each parsed [table] entry
function cache:setTime(table)
    local u = os.time()
    if table then
        for _, v in ipairs(table) do
            if self.data[tostring(v)] then self.data[tostring(v)].t = u end
        end
    end

    self.date = u

    return u
end

-- sets global time to 0
function cache:resetTime()
    local oldTime = self.date
    self.date = 0

    return oldTime
end

-- checks if all entries listed in [table] are recent within a value of [delta]
function cache:isRecent(delta, table)
    local u = os.time()

    if (u - self.date) >= delta then return false end

    if table then
        for _, v in ipairs(table) do
            if not self.data[tostring(v)] then
                return false
            elseif self.data[tostring(v)].t and ((u - self.data[tostring(v)].t) >= delta) then
                return false
            end
        end
    end

    return true
end

-- returns [data, table] as a Lua table without the functions
function cache:getTable()
    return { date = self.date, data = self.data }
end

-- removes all cache entries; if filepathGen is specified, uses said function to delete the approrpriate files
function cache:clearCache(filepathGen)
    for k, v in pairs(self.data) do
        if filepathGen then os.remove(filepathGen(k, v)) end
        self.data[tostring(k)] = nil
    end

    self.date = 0

    return self.date
end

return cache