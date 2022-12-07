-- Small script to handle premium calculations.
local function Randomizer(time, seed, maximum, increment)
    return (math.floor((1000000 % (((seed * time) % 283) + 257)) % (maximum / increment))) * increment
end

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

local function FetchDatabase()
    local contents = ReadFile(SKIN:GetVariable('@') .. 'json/premium.json')
    if not contents then return end

    local jsonarray = JSON.parse(contents)

    local db = {}
    local count = 0

    for k, v in ipairs(jsonarray.data) do
        if v.enable then
            table.insert(db, { id = v.id, seed = v.seed, maximum = v.maximum, pullcost = v.pullcost, increment = v.increment, image = v.image, key = k } )
            count = count + 1
        end
    end

    return db, count, jsonarray
end

-- Formats a number string to have commas.
-- Credits to Bart Kiers from StackOverflow: https://stackoverflow.com/questions/10989788/format-integer-in-lua
function FormatIntString(number)
    local _, _, minus, int, fraction = tostring(number):find('([-]?)(%d+)([.]?%d*)')

    -- reverse the int-string and append a comma to all blocks of 3 digits
    int = int:reverse():gsub("(%d%d%d)", "%1,")

    -- reverse the int-string back remove an optional comma and put the
    -- optional minus and fractional part back
    return minus .. int:reverse():gsub("^,", "") .. fraction
end

function Initialize()
    JSON = dofile(SKIN:GetVariable('@') .. 'lua/json.lua')

    TIME = math.floor(os.time() / 86400)

    GAME, TOTAL_GAMES, _ = FetchDatabase()

    SELECTION = tonumber(SKIN:GetVariable('Selection', 1))

    if (SELECTION > TOTAL_GAMES) then ToggleSelection(1) end

    return 1
end

function GetGems()
    return FormatIntString(Randomizer(TIME, GAME[SELECTION].seed, GAME[SELECTION].maximum, GAME[SELECTION].increment))
end

function GetPulls()
    local pulls = math.floor(Randomizer(TIME, GAME[SELECTION].seed, GAME[SELECTION].maximum, GAME[SELECTION].increment) / GAME[SELECTION].pullcost)
    local punctuation = "."
    local plural = ""
    if ((pulls * GAME[SELECTION].pullcost) >= (GAME[SELECTION].maximum / 2)) then
        punctuation = "!"
    end
    if (pulls ~= 1) then
        plural = "s"
    end
    return FormatIntString(pulls) .. " lucky pull" .. plural .. " today" .. punctuation
end

function GetImage()
    return GAME[SELECTION].image
end

function ToggleSelection(param)
    if (param ~= nil) then
        SELECTION = param
    else
        SELECTION = (SELECTION % TOTAL_GAMES) + 1
    end

    SKIN:Bang('!WriteKeyValue', 'Variables', 'Selection', SELECTION)

    return 1
end