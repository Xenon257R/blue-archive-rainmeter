-- Small script to handle extraneous issues with the update banner.
local JSON, CACHE, TWEEN

local DATA, GAME, LIMIT, LANGUAGE, LOAD_TEXT, NO_UPDATE_TEXT, NO_DATE_TEXT

local CURRENT_GAME, NEXT_GAME, DOWNLOADED_GAMES

local URL_CONTAINER = ''
local CURRENT_SCROLL = 0.00

local C, ID_TABLE, ANIM

-- stores downloaded data into local cache
local function CatalogData(index)
    local updatetitle = SKIN:GetMeasure('TitleModule'):GetStringValue()
    local updatedate = SKIN:GetMeasure('DateModule'):GetStringValue()
    local updatelink = SKIN:GetMeasure('LinkModule'):GetStringValue()

    if not C.data[tostring(GAME[index].id)] then C.data[tostring(GAME[index].id)] = {} end

    if (updatetitle == '' or updatetitle == nil) then
        updatetitle = NO_UPDATE_TEXT
    end

    if (updatedate == '' or updatedate == nil) then
        updatedate = os.date('01 Jan 1970')
    end

    if (updatelink == '' or updatelink == nil) then
        updatelink = 'https://store.steampowered.com/news/app/' .. GAME[index].id
    end

    C.data[tostring(GAME[index].id)].title = updatetitle
    C.data[tostring(GAME[index].id)].date = updatedate
    C.data[tostring(GAME[index].id)].link = updatelink

    return 1
end

-- sets the next channel to be transitioned in
local function SetNextGame(selection)
    if (selection < 0) then
        NEXT_GAME = (CURRENT_GAME % #GAME) + 1
    else
        NEXT_GAME = selection
    end

    return 1
end

-- starts up the Rainmeter skin functions
local function Startup(cacheFlag)
    SetNextGame(-1)

    if cacheFlag then
        C:setTime(ID_TABLE)
        JSON.writeFile(SKIN:GetVariable('CURRENTPATH') .. 'DownloadFile\\steam.cache', C:getTable())
    end

    if (#GAME > 1) then
       SKIN:Bang('!EnableMeasure', 'Ticker')
    end

    SKIN:Bang('!ShowMeterGroup', 'BannerGroup')
    SKIN:Bang('!UpdateMeterGroup', 'BannerGroup')
    SKIN:Bang('!HideMeter', 'LoadingText')
    SKIN:Bang('!Redraw')

    return 1
end

-- prompts the ImageModule to download current selection
local function DownloadBanner()
    SKIN:Bang('!EnableMeasure', 'ImageModule')
    SKIN:Bang('!CommandMeasure', 'ImageModule', 'Update')
    SKIN:Bang('!UpdateMeasure', 'ImageModule')

    return 1
end

-- checks if passed [datestring] is a valid, non-Unix-epoch time
local function IsDate(datestring)
    if (string.match(datestring, '01 Jan 1970')) then
        return '[' .. NO_DATE_TEXT .. ']'
    end

    return datestring
end

function Initialize()
    LANGUAGE = SKIN:GetVariable('StrSteamRegionType', 'english')
    LOAD_TEXT = SKIN:GetVariable('StrSteamLoadingText', 'Loading...')
    NO_UPDATE_TEXT = SKIN:GetVariable('StrSteamNoUpdateText', 'No Updates Found!')
    NO_DATE_TEXT = SKIN:GetVariable('StrSteamNoDateText', 'No Date')

    JSON = dofile(SKIN:GetVariable('@') .. 'lua\\lib\\jsonhandler.lua')
    CACHE = dofile(SKIN:GetVariable('@') .. 'lua\\lib\\cache.lua')
    TWEEN = dofile(SKIN:GetVariable('@') .. 'lua\\lib\\tween.lua')

    LIMIT = tonumber(SKIN:GetVariable('Limit', 10))

    DATA = JSON.readFile(SKIN:GetVariable('@') .. 'json\\steamevent.json')
    GAME = JSON.filterEnabled(DATA.data, LIMIT)

    CURRENT_GAME = 1
    NEXT_GAME = 2 % #GAME
    DOWNLOADED_GAMES = 0

    C = CACHE.new(JSON.readFile(SKIN:GetVariable('CURRENTPATH') .. 'DownloadFile\\steam.cache'))
    ID_TABLE = {}
    for _, v in pairs(GAME) do
        table.insert(ID_TABLE, v.id)
    end

    ANIM = TWEEN.new(0.1, { 1 })

    if #GAME <= 0 then
        return 1
    elseif (C:isRecent(3600, ID_TABLE)) then
        DOWNLOADED_GAMES = #GAME + 1
        Startup()

        return 0
    end

    if #GAME >= 1 then
        SKIN:Bang('!SetOption', 'LoadingText', 'Text', LOAD_TEXT .. '(0/' .. #GAME .. ')')
        SKIN:Bang('!UpdateMeter', 'LoadingText')
        SKIN:Bang('!EnableMeasure', 'SteamRSSModule')
        SKIN:Bang('!Redraw')
    end

    return 1
end

-- generates the RSS Feed Steam URL for data parsing
function GetSteamURL()
    if #GAME <= 0 or DOWNLOADED_GAMES > #GAME then return 'https://store.steampowered.com' end

    return 'https://store.steampowered.com/feeds/news/app/' .. GAME[DOWNLOADED_GAMES + 1].id .. '/?l=' .. LANGUAGE
end

-- generates a filename for the app's image with parsed file extension
function GenerateFileName()
    if #GAME <= 0 or DOWNLOADED_GAMES > #GAME then return '' end

    return GAME[DOWNLOADED_GAMES + 1].id .. (string.sub(URL_CONTAINER, -4, -1) or '.jpg')
end

-- returns the image filename to download
function GetImageURL()
    if #GAME <= 0 then return '' end

    return URL_CONTAINER .. '?t=0' or 'header.jpg'
end

-- downloads the appropriate banner image depending on if the update feed has an image or not
function ImageStep()
    local item = SKIN:GetMeasure('SteamRSSModule'):GetStringValue()
    local cacheLabel

    if (string.find(item, '<enclosure')) then
        URL_CONTAINER = string.match(item, '<enclosure url="(.*)" length')
        cacheLabel = string.match(URL_CONTAINER, '^.+/(.+)$')
    else
        URL_CONTAINER = 'https://cdn.cloudflare.steamstatic.com/steam/apps/' .. GAME[DOWNLOADED_GAMES + 1].id .. '/header.jpg'
        cacheLabel = 'header.jpg'
    end

    CatalogData(DOWNLOADED_GAMES + 1)

    if not C.data[tostring(GAME[DOWNLOADED_GAMES + 1].id)] or C.data[tostring(GAME[DOWNLOADED_GAMES + 1].id)].img ~= cacheLabel then
        DownloadBanner()
        C.data[tostring(GAME[DOWNLOADED_GAMES + 1].id)].img = cacheLabel
    else
        UpdateCheck()
    end

    return 1
end

-- checks whether all entry information has been downloaded and whether there is more to download
function UpdateCheck()
    SKIN:Bang('!DisableMeasure', 'ImageModule')

    DOWNLOADED_GAMES = DOWNLOADED_GAMES + 1
    URL_CONTAINER = ''

    if (DOWNLOADED_GAMES >= #GAME) then
        Startup(true)
        return 1
    end

    SKIN:Bang('!CommandMeasure', 'SteamRSSModule', 'Update')
    SKIN:Bang('!UpdateMeasure', 'SteamRSSModule')
    SKIN:Bang('!SetOption', 'LoadingText', 'Text', LOAD_TEXT .. '('.. DOWNLOADED_GAMES .. '/' .. #GAME .. ')')
    SKIN:Bang('!UpdateMeter', 'LoadingText')
    SKIN:Bang('!Redraw')

    return 0
end

-- returns the image location of the desired app's update banner
function GetBanner(index)
    if (DOWNLOADED_GAMES <= 0) then
        return ''
    end

    return SKIN:GetVariable('CURRENTPATH') .. 'DownloadFile\\' .. GAME[((CURRENT_GAME + index - 1) % #GAME) + 1].id .. (string.sub(C.data[tostring(GAME[((CURRENT_GAME + index - 1) % #GAME) + 1].id)].img or '.jpg', -4, -1))
end

-- returns the date of the desired app's update
function GetDate(index)
    if (DOWNLOADED_GAMES <= 0) then
        return '01 Jan 1970'
    end

    return IsDate(C.data[tostring(GAME[((CURRENT_GAME + index - 1) % #GAME) + 1].id)].date)
end

-- returns the title of the desired app's update
function GetTitle(index)
    if (DOWNLOADED_GAMES <= 0) then
        return 'Lorem Ipsum'
    end

    return C.data[tostring(GAME[((CURRENT_GAME + index - 1) % #GAME) + 1].id)].title
end

-- returns the direct link of the desired update page
function GetLink(index)
    if (DOWNLOADED_GAMES <= 0) then
        return ''
    end

    return 'steam://openurl/' .. C.data[tostring(GAME[((CURRENT_GAME + index - 1) % #GAME) + 1].id)].link
end

-- checks if the active entry's latest news is within 10 days of current time
function IsRecent(index)
    if (DOWNLOADED_GAMES <= 0) then
        return 0
    end

    local updatedate = C.data[tostring(GAME[((CURRENT_GAME + index - 1) % #GAME) + 1].id)].date

    local rday, rmonth, ryear = updatedate:match('(%d+) (%a+) (%d+)')
    local wordmonth = { Jan = 1, Feb = 2, Mar = 3, Apr = 4, May = 5, Jun = 6, Jul = 7, Aug = 8, Sep = 9, Oct = 10, Nov = 11, Dec = 12 }
    rmonth = wordmonth[rmonth]

    local unixtime = os.time({year = ryear, month = rmonth, day = rday})

    if (os.time(os.date('!*t')) - unixtime >= (10*86400) or unixtime == 0) then
        return 0
    end

    return 1
end

-- goes forwards in the Steam catalogue
function ChangeGame()
    CURRENT_GAME = NEXT_GAME
    SetNextGame(-1)

    return 0
end

-- handles tweening
function Scroll(a)
    return ANIM:scroll(tonumber(a))
end

-- gets the current animation step
function GetStep(index)
    return ANIM:getFrame(tonumber(index), 'p', -1)
end

-- prints an error message
function Err(code)
    local error = { { msg = 'Connection failed. Try again later.', display = 'OFFLINE' }, { msg = 'Download failed. Try again later.', display = 'ERROR' } }
    print(error[tonumber(code)].msg)

    SKIN:Bang('!SetOption', 'LoadingText', 'Text', error[tonumber(code)].display)
    SKIN:Bang('!UpdateMeter', 'LoadingText')
    SKIN:Bang('!Redraw')

    return 0
end

-- forces a data update
function ManualUpdate()
    C:resetTime()

    JSON.writeFile(SKIN:GetVariable('CURRENTPATH') .. 'DownloadFile\\steam.cache', C:getTable())

    SKIN:Bang('!Refresh')

    return 1
end

-- forces a data update by clearing cache files
function ClearCache()
    C:clearCache(function (k, v) return SKIN:GetVariable('CURRENTPATH') .. 'DownloadFile\\' .. k .. (string.sub(v.img or '.jpg', -4, -1)) end)

    JSON.writeFile(SKIN:GetVariable('CURRENTPATH') .. 'DownloadFile\\steam.cache', C:getTable())

    SKIN:Bang('!Refresh')

    return 1
end