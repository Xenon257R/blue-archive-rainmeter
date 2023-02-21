local jsonhandler = {}

local json = dofile(SKIN:GetVariable('@') .. 'lua/lib/json.lua')

-- Parses a directly passed string
function jsonhandler.parseRaw(contents)
    return json.parse(contents)
end

-- Stringifies a directly passed string
function jsonhandler.stringifyRaw(luaTable)
    return json.stringify(luaTable)
end

-- Returns stringified file content located in [filepath]
function jsonhandler.readFile(filepath)
    filepath = SKIN:MakePathAbsolute(filepath)

    local file = io.open(filepath)
    if not file then
        -- print('Unable to open file at ' .. filepath)
        return
    end

    local contents = file:read('*all')
    file:close()

    local json_contents = json.parse(contents)

    return json_contents
end

-- Writes [contents] to the specified [filepath]
-- [contents] expected in lua array format to be converted to json
function jsonhandler.writeFile(filepath, contents)
    filepath = SKIN:MakePathAbsolute(filepath)

    local file = io.open(filepath, "w")
    if not file then
        -- print('Unable to open file at ' .. filepath)
        return
    end

    file:write(json.stringify(contents))
    file:close()

    return 1
end

-- filters [data] by the presence of positive [enable] flags
function jsonhandler.filterEnabled(data, limit, msg)
    local n = 0
    local filteredList = {}
    for k, v in ipairs(data) do
        if v.enable then
            table.insert(filteredList, v)
            n = n + 1
            if limit and n >= limit then
                print(limit .. '-entry limit reached, ignoring remaining entries. ' .. (msg or ''))
                break
            end
        end
    end

    return filteredList
end

return jsonhandler