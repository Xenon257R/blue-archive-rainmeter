-- Handles general statistics compilation of the Mahjong Soul fan site.
-- NOTE: Old script first downloads then parses the data on the local machine; this one skips the download step.
--       - As a byproduct, the widget will no longer function properly without an internet connection.
-- Credits to SAPikachu: https://github.com/SAPikachu/amae-koromo

-- Checks rank point overflow edge case of JSON data
-- NOTE: Currently does not handle underflow; is unknown if an implementation is needed or not for this case
local function CheckOverflow()
    if (SCORE >= RankMax()) then
        local rankup = RANK_MAX[((Rank() - 1) * 3) + RankStars() + 1]
        SCORE = rankup / 2

        local newstars = (RankStars() % 3) + 1
        local newrank = Rank()
        if (newstars == 1) then
            newrank = newrank + 1
        end
        RANK_ID = 10000 + (newrank * 100) + newstars

        return 1
    end
    return 0
end

function Initialize()
    -- WARN: 3-player entries may work on a different master url. Re-check implementation when relevant

    -- Initializes URL information to request json file
    -- NOTE: [MASTER_URL] has appeared to have changed on the website; if this no longer works, refer to the new master link
    MASTER_URL = "https://ak-data-1.sapk.ch/api/v2/pl4/player_stats/"
    PLAYER_ID = SKIN:GetVariable('MajSoulID')
    PLAYER_NAME = ""
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

    return 1
end

-- Creates the URL to make json request for data
function MakeURL()
    local url = MASTER_URL .. PLAYER_ID ..  "/" .. SAPK_EPOCH .. "/" .. os.time() .. "/?mode=" .. MODES .. "&tag=" .. CACHE_TAG
    -- print("Making new url:" .. url)

    return  url
end

-- Parses all the newly acquired information into desireable pieces of data
function ParseData()
    print('Parsing newly acquired information...')
    -- Updates the nickname
    local newname = SKIN:GetMeasure('SapkNickname'):GetStringValue()

    if (newname ~= nil or newname ~= "") then
        PLAYER_NAME = newname
    end

    -- Updates scores and other relevant data

    local newid = tonumber(SKIN:GetMeasure('SapkID'):GetStringValue())
    local newscore = tonumber(SKIN:GetMeasure('SapkScore'):GetStringValue())
    local delta = tonumber(SKIN:GetMeasure('SapkDelta'):GetStringValue())

    RANK_ID = newid
    SCORE = newscore + delta

    CheckOverflow()

    return 1
end

-- Handles case where user is offline or there was a connection problem
function ErrorTask()
    if (PLAYER_NAME == "") then
        PLAYER_NAME = "[OFFLINE]"
    end

    print('There was an issue connecting to the database. Please try again later.')
    return 1
end

-- Returns the nickname of the user
function GetNickname()
    return PLAYER_NAME
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