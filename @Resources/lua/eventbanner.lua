-- Small script to handle extraneous issues with the update banner.
local function CatalogData(index)
    local updatetitle = SKIN:GetMeasure("TitleModule"):GetStringValue()
    local updatedate = SKIN:GetMeasure("DateModule"):GetStringValue()
    local updatelink = SKIN:GetMeasure("LinkModule"):GetStringValue()

    if (updatetitle == '' or updatetitle == nil) then
        updatetitle = "No Recent Updates!"
    end

    if (updatedate == '' or updatedate == nil) then
        updatedate = os.date("01 Jan 1970")
    end

    if (updatelink == '' or updatelink == nil) then
        updatelink = 'https://store.steampowered.com/news/app/' .. GAME[index].id
    end

    GAME_DETAILS[index].title = updatetitle
    GAME_DETAILS[index].date = updatedate
    GAME_DETAILS[index].link = updatelink
    return 1
end

-- Sets the next channel to be transitioned in
local function SetNextGame(selection)
    if (selection < 0) then
        NEXT_GAME = (CURRENT_GAME % TOTAL_GAMES) + 1
    else
        NEXT_GAME = selection
    end

    return 1
end

-- Starts up the Rainmeter skin
local function Startup()
    CURRENT_GAME = 1
    SetNextGame(-1)
    JSON.writeFile(SKIN:GetVariable('@') .. 'json/steamevent.json', DATA)

    if (TOTAL_GAMES > 1) then
       SKIN:Bang('!EnableMeasure', 'Ticker')
    end

    SKIN:Bang('!UpdateMeterGroup', 'BannerGroup')
    SKIN:Bang('!ShowMeterGroup', 'BannerGroup')
    return 1
end

local function DownloadBanner(imagePath)
    SKIN:Bang('!EnableMeasure', 'ImageModule')
    SKIN:Bang('!CommandMeasure', 'ImageModule', 'Update')
    SKIN:Bang('!UpdateMeasure', 'ImageModule')

    return 1
end

local function IsDate(datestring)
    if (string.match(datestring, "01 Jan 1970")) then
        return "[No Date]"
    end

    return datestring
end

function Initialize()
    JSON = dofile(SKIN:GetVariable('@') .. 'lua/lib/jsonhandler.lua')

    DATA = JSON.readFile(SKIN:GetVariable('@') .. 'json/steamevent.json')
    GAME = JSON.filterEnabled(DATA.data)

    GAME_DETAILS = {}
    for k, v in ipairs(GAME) do
        GAME_DETAILS[k] = {}
    end
    TOTAL_GAMES = table.getn(GAME)

    CURRENT_GAME = 1
    NEXT_GAME = 2 % TOTAL_GAMES
    DOWNLOADED_GAMES = 0

    URL_CONTAINER = ""
    STEP = { 0.00, -0.05, -0.15, -0.30, -0.50, -0.70, -0.85, -0.95, -1.00 }
    PULL = { 1, 1 }

    if TOTAL_GAMES >= 1 then
        SKIN:Bang('!SetOption', 'LoadingText', 'Text', 'Loading...(0/' .. TOTAL_GAMES .. ')')
        SKIN:Bang('!UpdateMeter', 'LoadingText')
        SKIN:Bang('!EnableMeasure', 'SteamRSSModule')
    end

    return 1
end

-- Generates the RSS Feed Steam URL for data parsing
function GetSteamURL()
    if TOTAL_GAMES <= 0 then return 'https://store.steampowered.com' end

    return 'https://store.steampowered.com/feeds/news/app/' .. GAME[CURRENT_GAME].id .. '/'
end

-- Generates a filename for the app's image
function GenerateFileName()
    if TOTAL_GAMES <=0 then return '' end

    return GAME[CURRENT_GAME].id .. '.jpg'
end

-- Returns the image filename to download
function GetImageURL()
    if TOTAL_GAMES <=0 then return '' end

    return URL_CONTAINER
end

-- Downloads the appropriate banner image depending on if the update feed has an image or not
function ImageStep()
    local item = SKIN:GetMeasure('SteamRSSModule'):GetStringValue()
    local cacheLabel = ''

    if (string.find(item, '<enclosure')) then
        URL_CONTAINER = string.match(item, '<enclosure url="(.*)" length')
        cacheLabel = string.match(URL_CONTAINER, '^.+/(.+)$')
        -- print('Image is attached at URL ' .. URL_CONTAINER)
    else
        URL_CONTAINER = 'https://cdn.cloudflare.steamstatic.com/steam/apps/' .. GAME[CURRENT_GAME].id .. '/header.jpg'
        cacheLabel = 'header.jpg'
        -- print('No image attached. Use default banner at ' .. URL_CONTAINER)
    end

    CatalogData(CURRENT_GAME)

    if not DATA.cache[tostring(GAME[CURRENT_GAME].id)] or DATA.cache[tostring(GAME[CURRENT_GAME].id)] ~= cacheLabel then
        DownloadBanner()
        DATA.cache[tostring(GAME[CURRENT_GAME].id)] = cacheLabel
    else
        UpdateCheck()
    end

    return 1
end

-- A tracker function that is updated every time a component is downloaded
function UpdateCheck()
    SKIN:Bang('!DisableMeasure', 'ImageModule')
    DOWNLOADED_GAMES = DOWNLOADED_GAMES + 1
    URL_CONTAINER = ''
    
    if (DOWNLOADED_GAMES >= TOTAL_GAMES) then
        Startup()
        SKIN:Bang('!HideMeter', 'LoadingText')
        return 1
    else
        SetNextGame(-1)
        CURRENT_GAME = NEXT_GAME
        SKIN:Bang('!CommandMeasure', 'SteamRSSModule', 'Update')
        SKIN:Bang('!UpdateMeasure', 'SteamRSSModule')
        SKIN:Bang('!SetOption', 'LoadingText', 'Text', 'Loading...('.. DOWNLOADED_GAMES .. '/' .. TOTAL_GAMES .. ')')
        SKIN:Bang('!UpdateMeter', 'LoadingText')
        return 0
    end

    return -1
end

-- Returns the image location of the desired app's update banner
function GetBanner(index)
    if (DOWNLOADED_GAMES <= 0) then
        return ''
    end

    return SKIN:GetVariable('CURRENTPATH') .. "DownloadFile/" .. GAME[((CURRENT_GAME + index - 1) % TOTAL_GAMES) + 1].id .. ".jpg"
end

-- Returns the date of the desired app's update
function GetDate(index)
    if (DOWNLOADED_GAMES <= 0) then
        return "01 Jan 1970"
    end

    return IsDate(GAME_DETAILS[((CURRENT_GAME + index - 1) % TOTAL_GAMES) + 1].date)
end

-- Returns the title of the desired app's update
function GetTitle(index)
    if (DOWNLOADED_GAMES <= 0) then
        return "Lorem Ipsum"
    end

    return GAME_DETAILS[((CURRENT_GAME + index - 1) % TOTAL_GAMES) + 1].title
end

-- Returns the direct link of the desired update page
function GotoLink(index)
    if (DOWNLOADED_GAMES <= 0) then
        return ""
    end

    SKIN:Bang("steam://openurl/" .. GAME_DETAILS[((CURRENT_GAME + index - 1) % TOTAL_GAMES) + 1].link)

    return 1
end

function IsRecent(index)
    if (DOWNLOADED_GAMES <= 0) then
        return 0
    end

    local updatedate = GAME_DETAILS[((CURRENT_GAME + index - 1) % TOTAL_GAMES) + 1].date

    local rday, rmonth, ryear = updatedate:match("(%d+) (%a+) (%d+)")
    local wordmonth = { Jan = 1, Feb = 2, Mar = 3, Apr = 4, May = 5, Jun = 6, Jul = 7, Aug = 8, Sep = 9, Oct = 10, Nov = 11, Dec = 12 }
    rmonth = wordmonth[rmonth]

    local unixtime = os.time({year = ryear, month = rmonth, day = rday})

    if (os.time(os.date("!*t")) - unixtime >= (10*86400) or unixtime == 0) then
        return 0
    end

    return 255
end

-- Goes forwards in the Steam catalogue
function ChangeGame(direction)
    CURRENT_GAME = NEXT_GAME
    SetNextGame(-1)

    return 0
end

-- Changes the animation sequence to the specified values
function Step(a, b)

    PULL[1] = math.min(math.max(PULL[1] + tonumber(a), 1), 9)
    PULL[2] = math.min(math.max(PULL[2] + tonumber(b), 1), 9)

    return 0
end

-- Gets the current animation step
function GetStep(index)
    return STEP[PULL[index]]
end

-- Prints an error message
function Err(code)
    local error = { { msg = "Connection failed. Try again later.", display = "OFFLINE" }, { msg = "Download failed. Try again later.", display = "ERROR" } }
    print(error[tonumber(code)].msg)

    SKIN:Bang('!SetOption', 'LoadingText', 'Text', error[tonumber(code)].display)
    SKIN:Bang('!UpdateMeter', 'LoadingText')

    return 0
end