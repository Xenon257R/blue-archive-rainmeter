

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

-- Writes [content] to the specified [filepath]
local function WriteFile(filepath, content)
    filepath = SKIN:MakePathAbsolute(filepath)

    local file = io.open(filepath, "w")
    if not file then
        print('Unable to open file at ' .. filepath)
        return
    end

    file:write(content)
    file:close()

    return 0
end

-- Fetches channel data from db.json located in the respective skin folder
local function FetchDatabase()
    local contents = ReadFile(SKIN:GetVariable('@') .. 'json/manga.json')
    if not contents then return end

    local jsonarray = JSON.parse(contents)

    local db = {}
    local count = 0

    for k, v in ipairs(jsonarray.data) do
        if v.enable then
            table.insert(db, { id = v.id, key = k } )
            count = count + 1

            if v.use_name then
                db[count].name = v.name
            end
        end
    end

    return db, count, jsonarray
end

-- Displays whether any enabled manga is caught up or not
local function SetHasUnread()
    for k, v in pairs(MANGA) do
        if not v.chapter or not MANGA_JSON.data[v.key].lastread or v.chapter ~= MANGA_JSON.data[v.key].lastread then
            SKIN:Bang('!ShowMeterGroup', 'NoticeGroup')
            return 1
        end
    end

    SKIN:Bang('!HideMeterGroup', 'NoticeGroup')
    return 0
end

-- Starts up initial Skin renders for the manga components and enables the button to view them
local function Setup()
    SKIN:Bang('!UpdateMeterGroup', 'PageGroup')
    SKIN:Bang('!ShowMeter', 'ToggleMangaOnHitbox')

    SetHasUnread()

    return 0
end

function Initialize()
    JSON = dofile(SKIN:GetVariable('@') .. 'lua/json.lua')

    MANGA, TOTAL_MANGA, MANGA_JSON = FetchDatabase()
    CURRENT_DOWNLOAD = math.min(1, TOTAL_MANGA)
    DOWNLOADED = 0
    SELECTED = 1

    LANGUAGE = "en"
    SORT_PARAM = { "createdAt", "updatedAt", "publishAt", "readableAt" }
    SORT_SELECT = 1
    STATUS = { ongoing = "4,208,0,255", completed = "0,201,245,255", cancelled = "255,64,64,255", hiatus = "247,148,33,255" }
    STEP = { 0.00, 0.05, 0.15, 0.30, 0.50, 0.70, 0.85, 0.95, 1.00 }
    PULL = { 1, 1, 1 }
    ERROR = { { msg = "Connection failed. Try again later.", display = "OFFLINE" }, { msg = "Download failed. Try again later.", display = "ERROR" } }

    return 0
end

-- Generates the parent URL for the currently selected manga
function GenerateMainURL()
    return "https://api.mangadex.org/manga/" .. MANGA_JSON.data[MANGA[CURRENT_DOWNLOAD].key].id .. "?includes%5B%5D=cover_art"
end

-- Escapes the ["] code points with the [\] escape character before Rainmeter handles all code points in bulk, making quotations inescapable by the .json parser
function EscapeQuotes()
    local tempfile = SKIN:GetMeasure("CoreModule"):GetStringValue()
    local tempjson = io.open(tempfile, "r")
    local tempstring = tempjson:read("*all")
    tempjson:close()
    local tempstring, num = tempstring:gsub("\\u0022", "\\\"")
    tempjson = io.open(tempfile, "w")
    tempjson:write(tempstring)
    tempjson:close()

    SKIN:Bang('!EnableMeasure', 'DecoderModule')
    SKIN:Bang('!CommandMeasure', 'DecoderModule', 'Update')
    SKIN:Bang('!UpdateMeasure', 'DecoderModule')

    return 0
end

-- Stores and parses the primary details of the currently selected manga
function StoreMainData()
    local jsontable = JSON.parse(SKIN:GetMeasure("DecoderModule"):GetStringValue())
    MANGA[CURRENT_DOWNLOAD].coverid = jsontable.data.relationships[3].attributes.fileName
    MANGA[CURRENT_DOWNLOAD].status = STATUS[jsontable.data.attributes.status]

    if not MANGA[CURRENT_DOWNLOAD].name then MANGA[CURRENT_DOWNLOAD].name = jsontable.data.attributes.title.en end

    SKIN:Bang('!EnableMeasure', 'ChapterModule')
    SKIN:Bang('!CommandMeasure', 'ChapterModule', 'Update')
    SKIN:Bang('!UpdateMeasure', 'ChapterModule')

    return 0
end

-- Stores the currently selected manga's latest chapter's information
function StoreChapterData()
    local jsontable = JSON.parse(SKIN:GetMeasure("ChapterModule"):GetStringValue())
    if not jsontable.data[1] then
        print("No entries exist for this manga in the [" .. LANGUAGE .. "] language! Errors may occur.")
        return -1
    end

    -- manually removes the temp folder; Rainmeter does not properly delete the last captured instance
    os.remove(SKIN:GetMeasure("CoreModule"):GetStringValue())

    MANGA[CURRENT_DOWNLOAD].chapter = jsontable.data[1].attributes.chapter

    if jsontable.data[1].attributes.externalUrl == JSON.null then
        MANGA[CURRENT_DOWNLOAD].link = "https://mangadex.org/chapter/" .. jsontable.data[1].id
    else
        MANGA[CURRENT_DOWNLOAD].link = jsontable.data[1].attributes.externalUrl
    end

    if not MANGA_JSON.cache[MANGA[CURRENT_DOWNLOAD].id] or MANGA_JSON.cache[MANGA[CURRENT_DOWNLOAD].id] ~= MANGA[CURRENT_DOWNLOAD].coverid then
        SKIN:Bang('!EnableMeasure', 'ImageModule')
        SKIN:Bang('!CommandMeasure', 'ImageModule', 'Update')
        SKIN:Bang('!UpdateMeasure', 'ImageModule')
    else
        CheckDownloadStatus()
    end

    return 0
end

-- Checks the progress of downloaded data and iterates to the next manga or complete the setup appropriately
function CheckDownloadStatus()
    if MANGA_JSON.cache[MANGA[CURRENT_DOWNLOAD].id] and MANGA_JSON.cache[MANGA[CURRENT_DOWNLOAD].id] ~= MANGA[CURRENT_DOWNLOAD].coverid then
        os.remove(SKIN:GetVariable('CURRENTPATH') .. "DownloadFile/" .. MANGA_JSON.cache[MANGA[CURRENT_DOWNLOAD].id])
    end

    MANGA_JSON.cache[MANGA[CURRENT_DOWNLOAD].id] = MANGA[CURRENT_DOWNLOAD].coverid
    WriteFile(SKIN:GetVariable('@') .. 'json/manga.json', JSON.stringify(MANGA_JSON))

    DOWNLOADED = DOWNLOADED + 1
    SKIN:Bang('!UpdateMeter', 'TotalEntries')
    if (DOWNLOADED == TOTAL_MANGA) then
        Setup()
        return 0
    end

    CURRENT_DOWNLOAD = CURRENT_DOWNLOAD + 1
    SKIN:Bang('!CommandMeasure', 'CoreModule', 'Update')
    SKIN:Bang('!UpdateMeasure', 'CoreModule')

    return 1
end

-- Returns the URL to the selected manga's cover art
function GenerateCoverURL()
    if not MANGA[CURRENT_DOWNLOAD].coverid then return "" end

    return "https://uploads.mangadex.org/covers/" .. MANGA_JSON.data[MANGA[CURRENT_DOWNLOAD].key].id .. "/" .. MANGA[CURRENT_DOWNLOAD].coverid
end

-- Returns the URL to make an API call for the most recent chapter of the currently selected manga
function GenerateChapterURL()
    return "https://api.mangadex.org/chapter?manga=" .. MANGA_JSON.data[MANGA[CURRENT_DOWNLOAD].key].id .. "&limit=1&translatedLanguage%5B%5D=" .. LANGUAGE .. "&order%5B" .. SORT_PARAM[SORT_SELECT] .. "%5D=desc"
end

-- Returns the quote-handled downloaded file path
function GetCodedJSON()
    return "file://" .. SKIN:GetMeasure("CoreModule"):GetStringValue()
end

-- Returns the parsed filename from the CoverArt API call
function GenerateFilename()
    if not MANGA[CURRENT_DOWNLOAD].coverid then return '' end

    return MANGA[CURRENT_DOWNLOAD].coverid
end

-- Returns the download progress; if completed, returns 'OPEN' instead
function StatusSelect()
    if DOWNLOADED == TOTAL_MANGA then return "OPEN" end

    return DOWNLOADED .. "/" .. TOTAL_MANGA
end

-- Returns the currently selected manga's name
function GetName(index)
    local s = math.min(math.max(SELECTED + tonumber(index), 1),TOTAL_MANGA)
    if not MANGA[s].name then return "MangaDex" end

    return MANGA[s].name
end

-- Returns the currently selected manga's cover image name
function GetCoverImage(index)
    local s = math.min(math.max(SELECTED + tonumber(index), 1),TOTAL_MANGA)
    if not MANGA[s].coverid then return "" end

    return SKIN:GetVariable('CURRENTPATH') .. "DownloadFile/" .. MANGA[s].coverid
end

-- Returns the currently selected manga's latest chapter number
function GetLatestChapter(index)
    local s = math.min(math.max(SELECTED + tonumber(index), 1),TOTAL_MANGA)
    if not MANGA[s].chapter then return "0" end

    return MANGA[s].chapter
end

-- Returns the currently selected manga's URL
function GetLatestChapterLink(index)
    local s = math.min(math.max(SELECTED + tonumber(index), 1),TOTAL_MANGA)
    if not MANGA[s].link then return '' end

    return MANGA[s].link
end

-- Returns the currently selected manga's publication status
function GetStatus(index)
    local s = math.min(math.max(SELECTED + tonumber(index), 1),TOTAL_MANGA)
    if not MANGA[s].status then return "130,130,130,255" end

    return MANGA[s].status
end

-- Returns whether the currently selected manga is read or not
function GetRead(index)
    local s = math.min(math.max(SELECTED + tonumber(index), 1),TOTAL_MANGA)
    if not MANGA[s].chapter or not MANGA_JSON.data[MANGA[s].key].lastread then return 0 end

    if MANGA[s].chapter == MANGA_JSON.data[MANGA[s].key].lastread then return 255 end

    return 0
end

-- Mark the currently selected manga as read, i.e. caught up
function SetRead()
    MANGA_JSON.data[MANGA[SELECTED].key].lastread = MANGA[SELECTED].chapter

    WriteFile(SKIN:GetVariable('@') .. 'json/manga.json', JSON.stringify(MANGA_JSON))
    SKIN:Bang('!UpdateMeterGroup', 'PageGroup')

    SetHasUnread()

    return 0
end

-- Goes forwards or backwards in the manga catalogue
function ChangeManga(direction)
    if (tonumber(direction) < 0) then
        SELECTED = math.max(1, SELECTED - 1)
    else
        SELECTED = math.min(TOTAL_MANGA, SELECTED + 1)
    end

    return 0
end

-- Changes the animation sequence to the specified values
function Step(a, b, c)
    if (c > 0 and SELECTED == 1) or (a > 0 and SELECTED == TOTAL_MANGA) then return -1 end

    PULL[1] = math.min(math.max(PULL[1] + tonumber(a), 1), 9)
    PULL[2] = math.min(math.max(PULL[2] + tonumber(b), 1), 9)
    PULL[3] = math.min(math.max(PULL[3] + tonumber(c), 1), 9)

    return 0
end

-- Gets the current animation step
function GetStep(index)
    return STEP[PULL[index]]
end

-- Prints an error message
function Err(code)
    print(ERROR[tonumber(code)].msg)

    SKIN:Bang('!SetOption', 'TotalEntries', 'Text', ERROR[tonumber(code)].display)
    SKIN:Bang('!UpdateMeter', 'TotalEntries')

    return 0
end

-- Deletes catalogued image files and cleans up their entry in the .json file
function ClearCache()
    print("Clearing cache...")
    for k, v in pairs(MANGA_JSON.cache) do
        os.remove(SKIN:GetVariable('CURRENTPATH') .. "DownloadFile/" .. v)
    end

    MANGA_JSON.cache = JSON.null
    WriteFile(SKIN:GetVariable('@') .. 'json/manga.json', JSON.stringify(MANGA_JSON))

    return 0
end