-- Handles general statistics compilation of the Mahjong Soul fan site
-- Credits to SAPikachu: https://github.com/SAPikachu/amae-koromo
-- NOTE: Changing configuration file will require app to refresh to take effect
function Initialize()
    -- WARN: 3-player entries may work on a different master url. Re-check implementation when relevant

    -- Initializes URL information to request json file
    MASTER_URL = "https://ak-data-1.sapk.ch/api/v2/pl4/player_stats/"
    -- PLAYER_ID = 000000000
    -- PLAYER_NAME = "username"
    SAPK_EPOCH = 1262304000000
    MODES = "16.12.9.15.11.8"
    CACHE_TAG = 1

    -- Initializes constants
    RANK_MAX = { 20, 80, 200, 600, 800, 1000, 1200, 1400, 2000, 2800, 3200, 3600, 4000, 6000, 9000 };
    RANK_STRING = { "Novice", "Adept", "Expert", "Master", "Saint", "Celestial" }
    RANK_ABV = { "Nv", "Ad", "Ex", "Ms", "St", "Cl" }
    RANK_STAR = { "I", "II" , "III" }

    -- Prepares global data storage
    RANK_ID = 10101
    SCORE = 0

    -- Parses in-script; handles edge case of first-time usage of script
    ParseJSON()
end

function Update()
    ParseJSON()
end

-- Creates the URL to make json request for data
function MakeURL(playerid)
    local url = MASTER_URL .. playerid ..  "/" .. SAPK_EPOCH .. "/" .. os.time() .. "/?mode=" .. MODES .. "&tag=" .. CACHE_TAG
    -- print("Making new url:" .. url)

    return  url
end

-- Parses the sapk.json file for relevant data
function ParseJSON()
    if pcall(function () -- Opens file to read
        local filepath = SKIN:GetVariable('@') .. "/sapk.json"
        local file = assert(io.open(filepath, "r"), "file not found or does not exist")

        if (file == nil) then
            return -1
        end

        -- Reads .json file and erases all space characters
        local data = file:read("*all")
        data = data:gsub("%s+", "")

        -- Closes file
        file:close()

        local currentstats = data:match("\"level\":{(.-)},")
        -- Fetches rank ID
        RANK_ID = currentstats:match("\"id\":(%d*),")

        -- Fetches current ranking score
        SCORE = currentstats:match("\"score\":(%d*),") + currentstats:match("\"delta\":(%-?%d*)")

        -- print(SCORE .. "/" .. RankMax())
    end) then
        return 1
    else
        return 0
    end
end

-- Returns core rank ID
function Rank()
    return ((RANK_ID - RankStars()) / 100) % 10
end

-- Returns stringifed Rank
function RankString()
    return RANK_STRING[Rank()]
end

-- Returns abbreviated Rank and Star rating
function RankStringFull()
    return RANK_ABV[Rank()] .. " " .. RANK_STAR[RankStars()]
end

-- Returns number of rank stars
function RankStars()
    return RANK_ID % 10
end

-- Returns total Rank Points needed to Rank Up
function RankMax()
    return RANK_MAX[((Rank() - 1) * 3) + RankStars()]
end

-- Returns current Rank Points
function Score()
    return SCORE
end

-- Returns current Rank Points as a percentage
function ScorePercent()
    return SCORE / RankMax()
end

function Debug()
    print("Refreshing skin to reset network connection...")
    return 1
end