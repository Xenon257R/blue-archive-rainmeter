-- Small script to handle premium calculations.
local function Randomizer(time, seed, maximum, increment)
    seed, maximum, increment = tonumber(seed) or 0, tonumber(maximum) or 1, tonumber(increment) or 1
    return (math.floor((1000000 % (((seed * time) % 283) + 257)) % (maximum / increment))) * increment
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
    JSON = dofile(SKIN:GetVariable('@') .. 'lua/lib/jsonhandler.lua')

    DATA = JSON.readFile(SKIN:GetVariable('@') .. 'json/premium.json')
    GAME = JSON.filterEnabled(DATA.data)
    TOTAL_GAMES = table.getn(GAME)

    TIME = math.floor(os.time() / 86400)

    SELECTION = tonumber(SKIN:GetVariable('Selection', 1))

    if (SELECTION > TOTAL_GAMES) then ToggleSelection(1) end

    return 1
end

function GetGems()
    if TOTAL_GAMES <= 0 then return "-24,000" end

    return FormatIntString(Randomizer(TIME, GAME[SELECTION].seed, GAME[SELECTION].maximum, GAME[SELECTION].increment))
end

function GetPulls()
    if TOTAL_GAMES <= 0 then return "In gacha debt." end

    local pulls = math.floor(Randomizer(TIME, GAME[SELECTION].seed, GAME[SELECTION].maximum, (tonumber(GAME[SELECTION].increment)) or 1) / (tonumber(GAME[SELECTION].pullcost) or 1))
    local punctuation = "."
    local plural = ""
    if ((pulls * (tonumber(GAME[SELECTION].pullcost) or 1)) >= ((tonumber(GAME[SELECTION].maximum) or 1) / 2)) then
        punctuation = "!"
    end
    if (pulls ~= 1) then
        plural = "s"
    end
    return FormatIntString(pulls) .. " lucky pull" .. plural .. " today" .. punctuation
end

function GetImage()
    if TOTAL_GAMES <= 0 then return "Common_Icon_Diamond.png" end

    return GAME[SELECTION].image or "Common_Icon_Diamond.png"
end

function ToggleSelection(param)
    if (param ~= nil) then
        SELECTION = param
    elseif (TOTAL_GAMES <= 0) then
        SELECTION = 1
    else
        SELECTION = (SELECTION % TOTAL_GAMES) + 1
    end

    SKIN:Bang('!WriteKeyValue', 'Variables', 'Selection', SELECTION)

    return 1
end