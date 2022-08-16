local function Randomizer(time, seed, maxpulls)
    return math.floor((1000000 % (((seed * time) % 283) + 257)) % maxpulls)
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

    SELECTION = SKIN:GetVariable('Selection', 'BA')

    GAME = {
        BA = {
            next = "AL",
            seed = SKIN:GetVariable('BlueArchiveID', 0),
            modifier = 120,
            pity = 200,
            image = "Common_Icon_Diamond"
        },
        AL = {
            next = "MJ",
            seed = SKIN:GetVariable('AzurLaneID', 0),
            modifier = 1,
            pity = 200,
            image = "Azur_Lane_Wisdom_Cube"
        },
        MJ = {
            next = "BA",
            seed = SKIN:GetVariable('MajSoulID', 0),
            modifier = 1,
            pity = 20, -- self-imposed pity, true pity is 150 (200 for special characters)
            image = "Mahjong_Soul_Summoning_Scroll"
        }
    }
end

function GetGems()
    return FormatIntString(Randomizer(TIME, GAME[SELECTION]["seed"], GAME[SELECTION]["pity"]) * GAME[SELECTION]["modifier"])
end

function GetPulls()
    local pulls = Randomizer(TIME, GAME[SELECTION]["seed"], GAME[SELECTION]["pity"])
    local punctuation = "."
    local plural = ""
    if (pulls >= (GAME[SELECTION]["pity"] / 2)) then
        punctuation = "!"
    end
    if (pulls ~= 1) then
        plural = "s"
    end
    return FormatIntString(pulls) .. " allotted pull" .. plural .. " today" .. punctuation
end

function GetImage()
    return GAME[SELECTION]["image"]
end

function ToggleSelection()
    SELECTION = GAME[SELECTION]["next"]
    SKIN:Bang('!WriteKeyValue', 'Variables', 'Selection', SELECTION)

    return 1
end