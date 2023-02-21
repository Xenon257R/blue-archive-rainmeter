-- Script to catalog listed YouTube channels and provide functions for the parent skin.

-- Draws the scroll bar at the bottom of the widget
-- NOTE: Should NOT be called if only one YouTube channel is defined
local function DrawScrollUI()
    local pinSize = SKIN:GetVariable('PinSize')
    local len = (TOTAL_CHANNELS - 1) * pinSize * 1.5

    SKIN:Bang('!SetOption', 'ScrollUI', 'Shape', 'Line (' .. len / -2 .. '*#GScale#),0,(' .. len / 2 .. '*#GScale#),0 | StrokeWidth (' .. pinSize * 2 .. '*#GScale#) | StrokeColor #TrayColor# | StrokeStartCap #PopUpCap# | StrokeEndCap #PopUpCap#')
    SKIN:Bang('!SetOption', 'ScrollUI', 'Shape2', 'Line (' .. (len / -2) .. '*#GScale#),0,(' .. (len / 2) .. '*#GScale#),0 | StrokeWidth (' .. pinSize .. '*#GScale#) | StrokeColor #DeselectColor# | StrokeStartCap #PopUpCap# | StrokeEndCap #PopUpCap# | StrokeDashCap #PopUpCap# | StrokeDashes 0, 1.5 | StrokeDashOffset 0')

    SKIN:Bang('!SetOption', 'ScrollHitbox', 'Shape', 'Rectangle ' .. len / -2 .. ',' .. -pinSize .. ',('.. len .. '*#GScale#),(' .. (pinSize * 2) .. '*#GScale#) | #Hitbox#')

    return 1
end

-- Highlights the appropriate node in the Scroll UI according to the displayed channel
local function SelectNode(newindex)
    local pinSize = SKIN:GetVariable('PinSize')
    local len = (TOTAL_CHANNELS - 1) * pinSize * 1.5

    SKIN:Bang('!SetOption', 'ScrollUI', 'Shape3', 'Line ('.. (len / -2) + ((newindex - 1) * 1.5 * pinSize) .. '*#GScale#),0,(' .. (len / -2) + ((newindex - 1) * 1.5 * pinSize) .. '*#GScale#),0 | StrokeWidth (' .. pinSize .. '*#GScale#) | StrokeColor #SelectColor# | StrokeStartCap #PopUpCap# | StrokeEndCap #PopUpCap# | StrokeDashCap #PopUpCap# | StrokeDashes 0, 1.5 | StrokeDashOffset 0')

    return 1
end

-- Sets the next channel to be transitioned in
local function SetNextChannel(selection)
    if (selection < 0) then
        NEXT_CHANNEL = (CURRENT_CHANNEL % TOTAL_CHANNELS) + 1
    else
        NEXT_CHANNEL = selection
    end

    return 1
end

-- A checker function for an empty database for case handlers
local function IsEmpty()
    return TOTAL_CHANNELS <= 0
end

-- Renders starting information once all assets have been downloaded and verified
local function Startup(cacheFlag)
    CURRENT_CHANNEL = 1
    SetNextChannel(-1)
    if cacheFlag then
        C.date = os.time()
        CI.date = os.time()
        JSON.writeFile(SKIN:GetVariable('CURRENTPATH') .. "DownloadFile/youtube.cache", C:getTable())
        JSON.writeFile(SKIN:GetVariable('CURRENTPATH') .. "DownloadFile/youtubeimg.cache", CI:getTable())
    end
    DrawScrollUI()
    SelectNode(1)

    if (TOTAL_CHANNELS > 1) then
       SKIN:Bang('!EnableMeasure', 'Ticker')
    end

    SKIN:Bang('!UpdateMeterGroup', 'YouTubeGroup')

    return 1
end

-- Handles grammar structure for upload time strings
local function Plural(value, time)
    if value == 1 then
        return value .. " " .. time
    end
    return value .. " " .. time .. "s"
end

-- Calculates the appropriate time estimates since video upload
local function LargestTime(pasttime)
    pasttime = pasttime / 60
    if (pasttime < 60) then
        pasttime = math.floor(pasttime)
        return Plural(pasttime, "min") .. " ago!!!"
    end
    pasttime = pasttime / 60
    if (pasttime < 24) then
        pasttime = math.floor(pasttime)
        return Plural(pasttime, "hr") .. " ago!"
    end
    pasttime = pasttime / 24
    if (pasttime < 7) then
        pasttime = math.floor(pasttime)
        return Plural(pasttime, "day") .. " ago!"
    end
    pasttime = pasttime / 7
    if (pasttime < 5) then
        pasttime = math.floor(pasttime)
        return Plural(pasttime, "wk") .. " ago."
    end
    pasttime = (pasttime * 7) / 30.5
    if (pasttime < 12) then
        pasttime = math.floor(pasttime)
        return pasttime .. " mo. ago..."
    end
    pasttime = (pasttime * 30.5) / 365
    pasttime = math.floor(pasttime)
    return Plural(pasttime, "yr") .. " ago..."
end

-- Extrapolates a Unix timestamp from a string and returns a formatted dialog string
-- CREDITS: https://stackoverflow.com/questions/4105012/convert-a-string-date-to-a-timestamp
-- NOTE: Time structure is as follows: YYYY-MM-DDTHH:MM:SS+HH:MM where [T] is a literal
local function CalculateTime(videotime)

    local pattern = "(%d+)-(%d+)-(%d+)T(%d+):(%d+):(%d+)"
    local ryear, rmonth, rday, rhour, rmin, rsec = videotime:match(pattern)

    local unixtime = os.time({year = ryear, month = rmonth, day = rday, hour = rhour, min = rmin, sec = rsec})
    local pasttime = os.time(os.date("!*t")) - unixtime

    return LargestTime(pasttime)
end

function Initialize()
    JSON = dofile(SKIN:GetVariable('@') .. 'lua/lib/jsonhandler.lua')
    CACHE = dofile(SKIN:GetVariable('@') .. 'lua/lib/cache.lua')

    LIMIT = 15

    DATA = JSON.readFile(SKIN:GetVariable('@') .. 'json/youtube.json')
    CHANNEL = JSON.filterEnabled(DATA.data, LIMIT, 'This is to prevent the Navigation UI from spilling.')
    TOTAL_CHANNELS = table.getn(CHANNEL)

    CURRENT_CHANNEL = 1
    NEXT_CHANNEL = 2 % TOTAL_CHANNELS
    DOWNLOADED_CHANNELS = 0

    TRANSITIONING = false

    STEP = { 0.00, -0.05, -0.15, -0.30, -0.50, -0.70, -0.85, -0.95, -1.00 }
    PULL = { 1, 1 }


    C = CACHE.new(JSON.readFile(SKIN:GetVariable('CURRENTPATH') .. "DownloadFile/youtube.cache"))
    CI = CACHE.new(JSON.readFile(SKIN:GetVariable('CURRENTPATH') .. "DownloadFile/youtubeimg.cache"))
    local idTable = {}
    for k, v in pairs(CHANNEL) do
        table.insert(idTable, v.id)
    end

    if TOTAL_CHANNELS <= 0 then
        return 1
    elseif (C:isRecent(3600, idTable)) then
        DOWNLOADED_CHANNELS = TOTAL_CHANNELS + 1
        -- print("Using cache - only " .. math.floor((timestamp - CACHE.date) / 60) .. "m" .. (timestamp - CACHE.date) % 60  .. "s has elapsed since last update.")
        Startup()
        return 0
    end

    if TOTAL_CHANNELS >= 1 then
        SKIN:Bang('!EnableMeasure', 'VideoModule')
    end

    return 1
end

-- Creates a filename. Used primarily to save YouTube channel profile pictures
function GenerateFileName()
    if IsEmpty() or DOWNLOADED_CHANNELS > TOTAL_CHANNELS then return '' end

    return CHANNEL[DOWNLOADED_CHANNELS + 1].id .. ".jpg"
end

function StoreMainData()
    if not C.data[tostring(CHANNEL[DOWNLOADED_CHANNELS + 1].id)] then C.data[tostring(CHANNEL[DOWNLOADED_CHANNELS + 1].id)] = {} end

    C.data[tostring(CHANNEL[DOWNLOADED_CHANNELS + 1].id)].name = SKIN:GetMeasure("NameModule"):GetStringValue()
    C.data[tostring(CHANNEL[DOWNLOADED_CHANNELS + 1].id)].title = SKIN:GetMeasure("TitleModule"):GetStringValue()
    C.data[tostring(CHANNEL[DOWNLOADED_CHANNELS + 1].id)].link = SKIN:GetMeasure("LinkModule"):GetStringValue()
    C.data[tostring(CHANNEL[DOWNLOADED_CHANNELS + 1].id)].date = SKIN:GetMeasure("DateModule"):GetStringValue()

    -- [WTF]: I legitimately do not know the EXACT circumstances where WebParser prematurely fires its OnFinishAction and returns null values from its children.
    --        Actually, I don't even know if that's the behavior of the issue; it could be caching issues from the previous instance, something to do with how [Refresh *] works, etc.
    --        Bottom line, DO NOT REMOVE THIS IF STATEMENT. It will "ESCAPE" the premature FinishAction call and discard it. A second instance comes anyways.
    --        I have no idea why the other downloader modules work perfectly fine. Especially the Steam one. It uses child measures, decoders and everything.
    --
    --        If you're really curious, the issue can be reproduced by the following steps (make sure [bubble.ini] is active):
    --        1) Remove/comment out the if statement below and save changes.
    --        2) Open the Color Picker and pick a new color preset.
    --        3) Apply the color preset.
    --        4) If nothing out of the ordinary happens, repeat steps 2 and 3 sufficiently.
    --
    --        At some point, the FIRST CHANNEL ENTRY should break. The images are "cached", so the channel icon will still render, but everything else will be broken.
    --        After repeating the procedure once more, the entire skin should freeze up at 1/[n] and fail to work again until Rainmeter is terminated and relaunched.
    if C.data[tostring(CHANNEL[DOWNLOADED_CHANNELS + 1].id)].date == '' then return -1 end

    if CI.data[tostring(CHANNEL[DOWNLOADED_CHANNELS + 1].id)] then
        UpdateCheck()
        return 0
    end

    SKIN:Bang('!EnableMeasure', 'IconModule')
    SKIN:Bang('!CommandMeasure', 'IconModule', 'Update')
    SKIN:Bang('!UpdateMeasure', 'IconModule')

    return 0
end

function CheckImage()
    SKIN:Bang('!EnableMeasure', 'IconDownloadModule')
    SKIN:Bang('!CommandMeasure', 'IconDownloadModule', 'Update')
    SKIN:Bang('!UpdateMeasure', 'IconDownloadModule')

    return 0
end

function CatalogImage()
    CI.data[tostring(CHANNEL[DOWNLOADED_CHANNELS + 1].id)] = true

    UpdateCheck()

    return 0
end

function UpdateCheck()
    DOWNLOADED_CHANNELS = DOWNLOADED_CHANNELS + 1

    if (DOWNLOADED_CHANNELS >= TOTAL_CHANNELS) then
        Startup(true)
        return 1
    else
        SKIN:Bang('!CommandMeasure', 'VideoModule', 'Update')
        SKIN:Bang('!UpdateMeasure', 'VideoModule')
        SKIN:Bang('!UpdateMeter', 'BubbleText1')
    end

    return 0
end

-- Returns the appropriate URL to fetch a YouTube channel profile icon
function GetThumbnailURL()
    if IsEmpty() or DOWNLOADED_CHANNELS > TOTAL_CHANNELS then return '' end

    return "https://www.youtube.com/channel/" .. CHANNEL[DOWNLOADED_CHANNELS + 1].id
end

-- Returns the appropriate URL to fetch the most recent YouTube channel uploads
function GetVideoURL()
    if IsEmpty() or DOWNLOADED_CHANNELS > TOTAL_CHANNELS then return '' end

    return "https://www.youtube.com/feeds/videos.xml?channel_id=" .. CHANNEL[DOWNLOADED_CHANNELS + 1].id
end

-- Returns the Filepath to the desired YouTube channel icon
function GetIcon(index)
    if (DOWNLOADED_CHANNELS <= 0) then
        return SKIN:GetVariable('@') .. "assets/icons/youtube_default.png"
    end

    local element = CURRENT_CHANNEL
    if index == 1 then element = NEXT_CHANNEL end

    return SKIN:GetVariable('CURRENTPATH') .. "DownloadFile/" .. CHANNEL[element].id .. ".jpg"
end

-- Returns the name of the desired YouTube channel
function GetName(index)
    if (DOWNLOADED_CHANNELS <= 0) then
        return "YouTube"
    end

    local element = CURRENT_CHANNEL
    if index == 1 then element = NEXT_CHANNEL end

    if CHANNEL[element].use_name then return CHANNEL[element].name end

    return C.data[tostring(CHANNEL[element].id)].name
end

-- Returns the title of the desired YouTube channel video
function GetTitle(index)
    if (TOTAL_CHANNELS <= 0) then
        return ""
    end
    if (DOWNLOADED_CHANNELS < TOTAL_CHANNELS) then
        return "Please wait a moment..."
    end

    local element = CURRENT_CHANNEL
    if index == 1 then element = NEXT_CHANNEL end

    return C.data[tostring(CHANNEL[element].id)].title
end

-- Returns the direct link of the desired YouTube channel video
function GetLink(index)
    if (DOWNLOADED_CHANNELS <= 0) then
        return ""
    end

    local element = CURRENT_CHANNEL
    if index == 1 then element = NEXT_CHANNEL end

    return C.data[tostring(CHANNEL[element].id)].link
end

-- Opens the appropriate video link in the user's preferred browser
function GotoLink(index)
    if (DOWNLOADED_CHANNELS <= 0) then
        return ""
    end

    local element = CURRENT_CHANNEL
    if index == 1 then element = NEXT_CHANNEL end

    SKIN:Bang(C.data[tostring(CHANNEL[element].id)].link)

    return 1
end

-- Returns the formatted upload date dialog of the desired YouTube channel video
function GetTime(index)
    if (TOTAL_CHANNELS <= 0) then
        return "Not tracking channels."
    end
    if (DOWNLOADED_CHANNELS < TOTAL_CHANNELS) then
        return "Connecting...(" .. DOWNLOADED_CHANNELS .. "/" .. TOTAL_CHANNELS .. ")"
    end

    local element = CURRENT_CHANNEL
    if index == 1 then element = NEXT_CHANNEL end

    return "Uploaded " .. CalculateTime(C.data[tostring(CHANNEL[element].id)].date)
end

-- Sets the offset bubble to a user-defined input [x] and immediately performs a transition
function ManualSelect(x)
    x = (x + 100) / 2
    if (DOWNLOADED_CHANNELS < TOTAL_CHANNELS or TRANSITIONING) then
        return -1
    end

    local selection = (math.floor((x / 100) * TOTAL_CHANNELS))
    if (selection < 0 or selection >= TOTAL_CHANNELS) then
        return -1
    end

    if (selection + 1 == CURRENT_CHANNEL) then
        return 0
    end

    TRANSITIONING = true

    SetNextChannel(selection + 1)

    SKIN:Bang('!UpdateMeterGroup', 'YouTubeGroup')
    SKIN:Bang('!UpdateMeasure', 'Ticker')
    return 1
end

-- Goes forwards in the YouTube catalogue
function ChangeChannel(direction)
    SelectNode(NEXT_CHANNEL)
    CURRENT_CHANNEL = NEXT_CHANNEL
    SetNextChannel(-1)

    TRANSITIONING = false

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

    SKIN:Bang('!SetOption', 'CaptionTextTitle1', 'Text', error[tonumber(code)].display)
    SKIN:Bang('!SetOption', 'BubbleText1', 'Text', 'Connection/parse error.')
    SKIN:Bang('!UpdateMeterGroup', 'YouTubeGroup')

    return 0
end

-- Clears cache files.
-- NOTE: Skin will be refreshed to update the cache. If extraneous files get put in [/DownloadFile] they will be left untouched.
function ClearCache(allFlag)
    if allFlag then
        CI:clearCache(function(k, v) return SKIN:GetVariable('CURRENTPATH') .. "DownloadFile/" .. k .. ".jpg" end)
        JSON.writeFile(SKIN:GetVariable('CURRENTPATH') .. "DownloadFile/youtubeimg.cache", CI:getTable())
    end

    C:clearCache()
    JSON.writeFile(SKIN:GetVariable('CURRENTPATH') .. "DownloadFile/youtube.cache", C:getTable())

    SKIN:Bang('!Refresh')

    return 1
end

function ManualUpdate()
    C:resetTime()

    JSON.writeFile(SKIN:GetVariable('CURRENTPATH') .. "DownloadFile/youtube.cache", C:getTable())

    SKIN:Bang('!Refresh')

    return 1
end