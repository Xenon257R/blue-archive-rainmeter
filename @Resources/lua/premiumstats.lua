local function Randomizer(time, seed)
    return math.floor(200 / (1000000 % (((seed * time) % 283) + 257)))
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
    TIME = math.floor(os.time() / 86400)
end

function GetGems(id)
    return FormatIntString(Randomizer(TIME, id) * 120)
end

function GetPulls(id)
    local pulls = Randomizer(TIME, id)
    local punctuation = "."
    if (pulls >= 100) then
        punctuation = "!"
    end
    return FormatIntString(Randomizer(TIME, id)) .. " allotted pulls today" .. punctuation
end