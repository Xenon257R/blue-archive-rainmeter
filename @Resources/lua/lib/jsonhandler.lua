local jsonhandler = {}

local json = dofile(SKIN:GetVariable('@') .. 'lua/lib/json.lua')

-- Returns stringified file content located in [filepath]
function jsonhandler.readFile(filepath)
    filepath = SKIN:MakePathAbsolute(filepath)

    local file = io.open(filepath)
    if not file then
        print('Unable to open file at ' .. filepath)
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
        print('Unable to open file at ' .. filepath)
        return
    end

    file:write(json.stringify(contents))
    file:close()

    return 1
end

-- filters [data] by the presence of positive [enable] flags
function jsonhandler.filterEnabled(data)
    local removelist = {}
    for k, v in ipairs(data) do
        if not v.enable then
            table.insert(removelist, 1, k)
        end
    end

    for k, v in ipairs(removelist) do
        table.remove(data, v)
    end

    return data
end

return jsonhandler