-- displays whether any enabled manga is caught up or not
local JSON, CACHE, TWEEN
local LIMIT = 15

local DATA, MANGA

local DOWNLOADED = 0
local SELECTED
local FINISH_PRELIM = false
local DISCARD_FIRST = false

local C, ANIM
local ID_TABLE = {}

local LANGUAGE, NO_TITLE_TEXT, OPEN_TEXT, EMPTY_TEXT, ERROR_TEXT, OFFLINE_TEXT

local CURRENT_SCROLL = { 0.00, 0.00, 0.00 }
local STEP = { 0.00, 0.05, 0.15, 0.30, 0.50, 0.70, 0.85, 0.95, 1.00 }
local PULL = { 1, 1, 1 }

local function SetHasUnread()
    for _, v in pairs(C.data) do
        if not v.readatdate or v.readatdate < v.pubDate then
            SKIN:Bang('!ShowMeterGroup', 'NoticeGroup')
            return 1
        end
    end

    SKIN:Bang('!HideMeterGroup', 'NoticeGroup')

    return 0
end

-- starts up initial Skin renders for the manga components and enables the button to view them
local function Startup(cacheFlag)
    if cacheFlag then
        C:setTime(ID_TABLE)
        JSON.writeFile(SKIN:GetVariable('CURRENTPATH') .. 'DownloadFile\\manga.cache', C:getTable())
    end

    SetHasUnread()

    SKIN:Bang('!UpdateMeterGroup', 'PageGroup')
    SKIN:Bang('!ShowMeter', 'ToggleMangaOnHitbox')
    SKIN:Bang('!Redraw')

    return 0
end

function Initialize()
    LANGUAGE = SKIN:GetVariable('StrMangaFolderLanguage', 'en')
    NO_TITLE_TEXT = SKIN:GetVariable('StrMangaFolderNoTitle', 'No Title')
    OPEN_TEXT = SKIN:GetVariable('StrMangaFolderOpen', 'OPEN')
    EMPTY_TEXT = SKIN:GetVariable('StrMangaFolderEmpty', 'EMPTY')
    ERROR_TEXT = SKIN:GetVariable('StrMangaFolderError', 'ERROR')
    OFFLINE_TEXT = SKIN:GetVariable('StrMangaFolderOffline', 'OFFLINE')

    JSON = dofile(SKIN:GetVariable('@') .. 'lua\\lib\\jsonhandler.lua')
    CACHE = dofile(SKIN:GetVariable('@') .. 'lua\\lib\\cache.lua')
    TWEEN = dofile(SKIN:GetVariable('@') .. 'lua\\lib\\tween.lua')

    DATA = JSON.readFile(SKIN:GetVariable('@') .. 'json\\manga.json')
    MANGA = JSON.filterEnabled(DATA.data, LIMIT, 'This limit exists to reduce excessive usage of the Mangadex API.')

    SELECTED = math.min(1, #MANGA)

    C = CACHE.new(JSON.readFile(SKIN:GetVariable('CURRENTPATH') .. 'DownloadFile\\manga.cache'))
    for _, v in pairs(MANGA) do
        table.insert(ID_TABLE, v.id)
    end

    ANIM = TWEEN.new(0.1, { 0, 0, 0 })

    if #MANGA <= 0 then
        Err(3)
        return 1
    elseif (C:isRecent(3600, ID_TABLE)) then
        DOWNLOADED = #MANGA + 1
        Startup()

        return 0
    end

    SKIN:Bang('!EnableMeasure', 'CoreModule')

    return 0
end

-- generates the all-encompassing URL for all enabled manga (up to limit)
function GenerateMainURL()
    if #MANGA <=0 then return '' end

    local urlString = 'https://api.mangadex.org/manga?limit=15'

    for i = 1, math.min(20, #MANGA) do
        urlString = urlString .. '&ids%5B%5D=' .. MANGA[i].id
    end

    return urlString .. '&order%5BlatestUploadedChapter%5D=desc&includes%5B%5D=cover_art'
end

-- parses and store data in cache
-- NOTE: In case parsing breaks, valuable resources for potential bugfix:
--       ["] Unicode = "\\u0022"
--       Disable auto decode points in .ini
--       Refer to CITATION: http://lua-users.org/wiki/LuaUnicode
function ParseInfo()
    local available, jsontable = pcall(JSON.parseRaw, SKIN:GetMeasure('CoreModule'):GetStringValue())
    if not available then
        Err(4)
        return -1
    end

    if not jsontable or not jsontable.data then
        Err(2)
        return -1
    end

    for _, v in ipairs(jsontable.data) do
        if not C.data[v.id] then C.data[v.id] = {} end

        C.data[v.id].title = v.attributes.title[LANGUAGE] or '[' .. NO_TITLE_TEXT .. ']'
        C.data[v.id].status = v.attributes.status

        for _, v2 in ipairs(v.relationships) do
            if v2.type == 'cover_art' then
                C.data[v.id].coverid = v2.attributes.fileName
                break
            end
        end
    end

    -- one-time flag to discard bad starting WebParser data on ChapterModule
    FINISH_PRELIM = true

    SKIN:Bang('!EnableMeasure', 'ChapterModule')
    SKIN:Bang('!CommandMeasure', 'ChapterModule', 'Update')
    SKIN:Bang('!UpdateMeasure', 'ChapterModule')

    return 1
end

-- stores the currently selected manga's latest chapter's information
function StoreChapterData()
    local jsontable = JSON.parseRaw(SKIN:GetMeasure('ChapterModule'):GetStringValue())

    if #jsontable.data <= 0 then
        C.data[MANGA[DOWNLOADED + 1].id].readatdate = os.time()
        C.data[MANGA[DOWNLOADED + 1].id].pubDate = 0
        C.data[MANGA[DOWNLOADED + 1].id].link = 'https://mangadex.org/title/' .. MANGA[DOWNLOADED + 1].id
    else
        local yyyy, mm, dd, h, m, s = jsontable.data[1].attributes.publishAt:match('(%d%d%d%d)-(%d%d)-(%d%d)T(%d%d):(%d%d):(%d%d)')
        C.data[MANGA[DOWNLOADED + 1].id].pubDate = os.time{year = yyyy, month = mm, day = dd, hour = h, min = m, sec = s }
        C.data[MANGA[DOWNLOADED + 1].id].link = jsontable.data[1].attributes.externalURL or ('https://mangadex.org/chapter/' .. jsontable.data[1].id)
    end

    if not C.data[MANGA[DOWNLOADED + 1].id].image or C.data[MANGA[DOWNLOADED + 1].id].coverid ~= C.data[MANGA[DOWNLOADED + 1].id].image then
        -- one-time secondary flag to discard bad starting WebParser data on ImageModule
        DISCARD_FIRST = true

        SKIN:Bang('!EnableMeasure', 'ImageModule')
        SKIN:Bang('!CommandMeasure', 'ImageModule', 'Update')
        SKIN:Bang('!UpdateMeasure', 'ImageModule')
    else
        CheckDownloadStatus()
    end

    return 0
end

-- checks the progress of downloaded data and iterates to the next manga or complete the setup appropriately
function CheckDownloadStatus()
    if not C.data[MANGA[DOWNLOADED + 1].id].image or C.data[MANGA[DOWNLOADED + 1].id].coverid ~= C.data[MANGA[DOWNLOADED + 1].id].image then
        if C.data[MANGA[DOWNLOADED + 1].id].image then os.remove(SKIN:GetVariable('CURRENTPATH') .. 'DownloadFile\\' .. C.data[MANGA[DOWNLOADED + 1].id].image) end
        C.data[MANGA[DOWNLOADED + 1].id].image = C.data[MANGA[DOWNLOADED + 1].id].coverid
    end

    C.data[MANGA[DOWNLOADED + 1].id].coverid = nil

    DOWNLOADED = DOWNLOADED + 1
    SKIN:Bang('!UpdateMeter', 'TotalEntries')
    SKIN:Bang('!Redraw')
    if (DOWNLOADED >= #MANGA) then
        Startup(true)
        return 0
    end

    SKIN:Bang('!CommandMeasure', 'ChapterModule', 'Update')
    SKIN:Bang('!UpdateMeasure', 'ChapterModule')

    return 1
end

-- returns the URL to the selected manga's cover art
function GenerateCoverURL()
    if #MANGA <= 0 or not DISCARD_FIRST then return '' end

    return 'https://uploads.mangadex.org/covers/' .. MANGA[DOWNLOADED + 1].id .. '/' .. C.data[MANGA[DOWNLOADED + 1].id].coverid
end

-- returns the URL to make an API call for the most recent chapter of the currently selected manga
function GenerateChapterURL()
    if #MANGA <= 0 or not FINISH_PRELIM then return '' end

    return 'https://api.mangadex.org/chapter?limit=1&manga=' .. MANGA[DOWNLOADED + 1].id .. '&translatedLanguage%5B%5D=' .. LANGUAGE .. '&publishAtSince=' .. string.gsub(os.date('%Y-%m-%dT%X', C.data[MANGA[DOWNLOADED + 1].id].readatdate or 0), ':', '%%3A') .. '&order%5Bchapter%5D=asc'
end

-- returns the parsed filename from the CoverArt API call
function GenerateFilename()
    if #MANGA <= 0 or not DISCARD_FIRST then return '' end

    return C.data[MANGA[DOWNLOADED + 1].id].coverid
end

-- returns the download progress; if completed, returns 'OPEN' instead
function StatusSelect()
    if DOWNLOADED >= #MANGA then return OPEN_TEXT end

    return DOWNLOADED .. '/' .. #MANGA
end

-- returns the visible state of [arrow] according to selected manga
function GetArrowState(arrow)
    if #MANGA <= 1 then return 0 end

    if tonumber(arrow) < 0 and SELECTED <= 1 then return 0 end
    if tonumber(arrow) > 0 and SELECTED >= #MANGA then return 0 end

    return 1
end

-- returns the currently selected manga's name
function GetName(index)
    local s = math.min(math.max(SELECTED + tonumber(index), 1),#MANGA)
    if #MANGA <= 0 then return NO_TITLE_TEXT end

    if MANGA[s].use_name or not C.data[MANGA[s].id] then return MANGA[s].name or '' end

    return C.data[MANGA[s].id].title or ''
end

-- returns the currently selected manga's cover image name
function GetCoverImage(index)
    local s = math.min(math.max(SELECTED + tonumber(index), 1),#MANGA)
    if #MANGA <= 0 or not C.data[MANGA[s].id] then return '' end

    return SKIN:GetVariable('CURRENTPATH') .. 'DownloadFile\\' .. C.data[MANGA[s].id].image
end

-- returns the currently selected manga's latest chapter number
function GetLatestChapter(index)
    local s = math.min(math.max(SELECTED + tonumber(index), 1),#MANGA)
    if #MANGA <= 0 or not C.data[MANGA[s].id] then return '' end

    return string.sub(MANGA[s].id, 1, 1) .. '-' .. string.sub(MANGA[s].id, 10, 10) .. '-' .. string.sub(MANGA[s].id, 15, 15) .. '-' .. string.sub(MANGA[s].id, 20, 20) .. '-' .. string.sub(MANGA[s].id, 25, 25)
end

-- returns the currently selected manga's URL
function GetLatestChapterLink(index)
    local s = math.min(math.max(SELECTED + tonumber(index), 1),#MANGA)
    if #MANGA <= 0 or not C.data[MANGA[s].id].link then return '' end

    return C.data[MANGA[s].id].link
end

-- returns the currently selected manga's publication status as a color code
function GetStatus(index)
    local statusKey = { ongoing = '4,208,0,255', completed = '0,201,245,255', cancelled = '255,64,64,255', hiatus = '247,148,33,255' }
    local s = math.min(math.max(SELECTED + tonumber(index), 1),#MANGA)
    if #MANGA <= 0 or not C.data[MANGA[s].id] then return '130,130,130,255' end

    return statusKey[C.data[MANGA[s].id].status]
end

-- returns whether the currently selected manga is read or not
function GetRead(index)
    local s = math.min(math.max(SELECTED + tonumber(index), 1),#MANGA)
    if #MANGA <= 0 or not C.data[MANGA[s].id] then return 0 end

    if not C.data[MANGA[s].id].readatdate or C.data[MANGA[s].id].readatdate < C.data[MANGA[s].id].pubDate then return 0 end

    return 255
end

-- mark the currently selected manga as read, i.e. caught up
function SetRead()
    if not (C.data[MANGA[SELECTED].id].pubDate > (C.data[MANGA[SELECTED].id].readatdate or 0)) then return -1 end

    -- Unexplained edge case where publication date is hours into the future
    if C.data[MANGA[SELECTED].id].pubDate < os.time() then
        C.data[MANGA[SELECTED].id].readatdate = os.time()
    else
        C.data[MANGA[SELECTED].id].readatdate = C.data[MANGA[SELECTED].id].pubDate + 1
    end

    C.data[MANGA[SELECTED].id].link = 'https://mangadex.org/title/' .. MANGA[SELECTED].id
    JSON.writeFile(SKIN:GetVariable('CURRENTPATH') .. 'DownloadFile\\manga.cache', C:getTable())

    SetHasUnread()

    SKIN:Bang('!UpdateMeterGroup', 'PageGroup')
    SKIN:Bang('!Redraw')

    return 0
end

-- goes forwards or backwards in the manga catalogue
function ChangeManga(direction)
    if (tonumber(direction) < 0) then
        SELECTED = math.max(1, SELECTED - 1)
    else
        SELECTED = math.min(#MANGA, SELECTED + 1)
    end

    return 0
end

-- Handles parametric tweening
function Scroll(a, b, c)
    if (tonumber(c) > 0 and SELECTED == 1) or (tonumber(a) > 0 and SELECTED == #MANGA) then return -1 end

    return ANIM:scroll(tonumber(a), tonumber(b), tonumber(c))
end

-- gets the current animation step
function GetStep(index)
    return ANIM:getFrame(tonumber(index), 'p')
end

-- prints an error message
function Err(code)
    local error = {
        { msg = 'Connection failed. Try again later.', display = OFFLINE_TEXT },
        { msg = 'Download failed. Double-check your manga entries for bad IDs and try again later.', display = ERROR_TEXT },
        { msg = 'No manga entries. Maybe you want to use schalefolder.ini instead?', display = EMPTY_TEXT },
        { msg = 'Mangadex services are currently unavailable due to high load or maintenance. Please try again later.', display = 'ERR-503' }
    }
    print(error[tonumber(code)].msg)

    SKIN:Bang('!SetOption', 'TotalEntries', 'Text', error[tonumber(code)].display)
    SKIN:Bang('!UpdateMeter', 'TotalEntries')
    SKIN:Bang('!Redraw')

    return 0
end

-- forces a data update
function ManualUpdate()
    C:resetTime()

    JSON.writeFile(SKIN:GetVariable('CURRENTPATH') .. 'DownloadFile\\manga.cache', C:getTable())

    SKIN:Bang('!Refresh')

    return 1
end

-- forces a data update by clearing cache files
function ClearCache()
    C:clearCache(function (_, v) return SKIN:GetVariable('CURRENTPATH') .. 'DownloadFile\\' .. v.image end)

    JSON.writeFile(SKIN:GetVariable('CURRENTPATH') .. 'DownloadFile\\manga.cache', C:getTable())

    SKIN:Bang('!Refresh')

    return 0
end