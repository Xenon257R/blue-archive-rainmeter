local contentlist = {}
contentlist.__index = contentlist

function contentlist.new(list, buffer)
    local o = setmetatable({}, contentlist)

    o.list, o.buffer, o.pointer = list or {}, buffer or 0, 0

    return o
end

-- Scrolls the index pointer in the specified step
function contentlist:scroll(step)
    self.pointer = math.max(0, math.min(table.getn(self.list) - (self.buffer + 1), self.pointer + step))

    return self.pointer
end

-- Returns the entry at the specified index after pointer adjustment
-- NOTE: [index] is zero-based
function contentlist:getData(index)
    if index < 0 or index + self.pointer > table.getn(self.list) then return end

    return self.list[index + self.pointer]
end

-- Returns whether or not the list is scrolled fully up and down
-- returns two boolean values, first for scrolled up and second for scrolled down
function contentlist:getScrollState()
    return self.pointer <= 0, self.pointer + 1 + self.buffer >= table.getn(self.list)
end

return contentlist