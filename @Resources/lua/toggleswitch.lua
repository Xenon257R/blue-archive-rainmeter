-- Small Lua script to cleanly hide/unhide all relevant Blue Archive widgets with a single button

-- Returns stringified file content located in [filepath]
local function ReadFile(filepath)
    filepath = SKIN:MakePathAbsolute(filepath)

    local file = io.open(filepath)
    if not file then
        print('Unable to open file at ' .. filepath)
        return
    end

    local contents = file:read('*all')
    file:close()

    return contents
end

-- Fetches channel data from db.json located in the respective skin folder
local function FetchDatabase()
    local contents = ReadFile(SKIN:GetVariable('@') .. 'json/layout.json')
    if not contents then return end

    local jsonarray = JSON.parse(contents)

    local db = {}
    local count = 0

    for k, v in ipairs(jsonarray.data) do
        table.insert(db, { skin = v.skin } )
        count = count + 1

        if v.variant and v.variant ~= "" then
            db[count].variant = v.variant
        end
    end

    return db, count, jsonarray
end

function Initialize()
    JSON = dofile(SKIN:GetVariable('@') .. 'lua/json.lua')
    -- Variants can be specified in the corresponding index in VARIANT_LIST
    SKIN_LIST, _, _ = FetchDatabase()

    FUNCTION_LIST = { "Deactivate", "Activate" }
    STATE = 0
end

-- Hides/Unhides all relevant skins
function ToggleCommand(st)
    local f = FUNCTION_LIST[STATE + 1]

    if st ~= nil and st ~= STATE then
        return 0
    end

    STATE = (STATE + 1) % 2

    if st ~= nil then
        f = FUNCTION_LIST[st + 1]
        STATE = (st + 1) % 2
    end

    -- Fades in/out the skins
    for i, s in ipairs(SKIN_LIST) do
        if s.variant ~= nil then
            SKIN:Bang('!' .. f .. 'Config', s.skin, s.variant .. '.ini')
        else
            SKIN:Bang('!' .. f .. 'Config', s.skin)
        end
    end

    return 1
end