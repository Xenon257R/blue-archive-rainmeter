-- Small script to handle premium calculations.
local JSON, DATA, GAME
local TIME
local SELECTION, NO_DATA_TEXT

-- pseudo-random number generator
local function Randomizer(time, seed, maximum, pullcost)
    seed, maximum, pullcost = tonumber(seed) or 0, tonumber(maximum) or 1, tonumber(pullcost) or 1

    math.randomseed(seed + time)

    -- Voids the first random value as it seems in Lua random the first "random" value returned is always fixed
    -- CITATION: https://stackoverflow.com/questions/461978/why-is-the-first-random-number-always-the-same-on-some-platforms-in-lua
    _ = math.random(0, 283)

    local value = math.random(0, maximum)
    value = math.floor(value / pullcost) * pullcost

    return value
end

-- formats a number string to have commas
-- CITATION: https://stackoverflow.com/questions/10989788/format-integer-in-lua
function FormatIntString(number)
    local _, _, minus, int, fraction = tostring(number):find('([-]?)(%d+)([.]?%d*)')

    -- reverse the int-string and append a comma to all blocks of 3 digits
    int = int:reverse():gsub('(%d%d%d)', '%1,')

    -- reverse the int-string back remove an optional comma and put the
    -- optional minus and fractional part back
    return minus .. int:reverse():gsub('^,', '') .. fraction
end

function Initialize()
    NO_DATA_TEXT = SKIN:GetVariable('StrPremiumNoData', 'No value.')

    JSON = dofile(SKIN:GetVariable('@') .. 'lua\\lib\\jsonhandler.lua')

    DATA = JSON.readFile(SKIN:GetVariable('@') .. 'json\\premium.json')
    GAME = JSON.filterEnabled(DATA.data)

    TIME = math.floor(os.time() / 86400)

    SELECTION = tonumber(SKIN:GetVariable('Selection', 1))

    if (SELECTION > #GAME) then ToggleSelection(1) end

    return 1
end

-- returns the number of gems in today's stash
function GetGems()
    if #GAME <= 0 then return '-24,000' end

    return FormatIntString(Randomizer(TIME, GAME[SELECTION].seed, GAME[SELECTION].maximum, GAME[SELECTION].pullcost))
end

-- returns the number of pulls the gem stash translates to
function GetPulls()
    if #GAME <= 0 or not GAME[SELECTION].message then return NO_DATA_TEXT end

    local pulls = math.floor(Randomizer(TIME, GAME[SELECTION].seed, GAME[SELECTION].maximum) / (tonumber(GAME[SELECTION].pullcost) or 1))
    local punctuation = '.'

    if ((pulls * (tonumber(GAME[SELECTION].pullcost) or 1)) >= ((tonumber(GAME[SELECTION].maximum) or 1) / 2)) then
        punctuation = '!'
    end

    return (string.gsub(GAME[SELECTION].message, "%%p", pulls) or GAME[SELECTION].message) .. punctuation
end

-- returns the image asset of the current selection
function GetImage()
    if #GAME <= 0 then return 'Common_Icon_Diamond.png' end

    return GAME[SELECTION].image or 'Common_Icon_Diamond.png'
end

-- iterates to the next entry in the database, wrapping around to the start
function ToggleSelection(param)
    if (param ~= nil) then
        SELECTION = param
    elseif (#GAME <= 0) then
        SELECTION = 1
    else
        SELECTION = (SELECTION % #GAME) + 1
    end

    TIME = math.floor(os.time() / 86400)
    SKIN:Bang('!WriteKeyValue', 'Variables', 'Selection', SELECTION)

    return 1
end