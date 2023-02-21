local cache = {}
cache.__index = cache

function cache.new(table)
    local o = setmetatable({}, cache)

    table = table or { date = 0, data = {} }

    o.date = table.date or 0
    o.data = table.data or {}

    return o
end

function cache:resetTime()
    local oldTime = self.date
    self.date = 0

    return oldTime
end

function cache:isRecent(delta, table)
    for k, v in ipairs(table) do
        if not self.data[tostring(v)] then
            return false
        end
    end

    return (os.time() - self.date) < delta
end

function cache:getTable()
    return { date = self.date, data = self.data }
end

function cache:clearCache(filepathGen)
    for k, v in pairs(self.data) do
        if filepathGen then os.remove(filepathGen(k, v)) end
        self.data[tostring(k)] = nil
    end

    self.date = 0

    return self.date
end

return cache