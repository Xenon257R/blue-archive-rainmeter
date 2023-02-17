-- Script to catalog listed YouTube channels and provide functions for the parent skin.

-- Draws the scroll bar at the bottom of the widget
-- NOTE: Should NOT be called if only one YouTube channel is defined
local function DrawScrollUI()
    SKIN:Bang('!SetOption', 'ScrollUI', 'Shape', 'Rectangle (-8*#GScale#),(-8*#GScale#),(('.. (TOTAL_CHANNELS * 12) .. '+4)*#GScale#),(16*#GScale#),(6*#GScale#),(6*#GScale#) | StrokeWidth 0 | Fill Color #ScrollUIColor#')
    for i = 1, TOTAL_CHANNELS, 1 do
        SKIN:Bang('!SetOption', 'ScrollUI', 'Shape' .. (i + 1), 'Ellipse (' .. ((i - 1) * 12) .. '*#GScale#),0,(3.5*#GScale#) | StrokeWidth 0 | Fill Color #DeselectColor#')
    end
    SKIN:Bang('!SetOption', 'ScrollUI', 'X', '((#BubbleSize#+#Indent#)-((' .. (TOTAL_CHANNELS * 6) .. '-6)*#GScale#))')

    SKIN:Bang('!SetOption', 'ScrollHitbox', 'Shape', 'Rectangle 0,0,('.. (TOTAL_CHANNELS * 12) .. '*#GScale#),(16*#GScale#) | #Hitbox#')
    SKIN:Bang('!SetOption', 'ScrollHitbox', 'X', '((#BubbleSize#+#Indent#)-(' .. (TOTAL_CHANNELS * 6) .. '*#GScale#))')

    return 1
end

-- Highlights the appropriate node in the Scroll UI according to the displayed channel
local function SelectNode(oldindex, newindex)
    SKIN:Bang('!SetOption', 'ScrollUI', 'Shape' .. (oldindex + 1), 'Ellipse (' .. ((oldindex - 1) * 12) .. '*#GScale#),0,(3.5*#GScale#) | StrokeWidth 0 | Fill Color #DeselectColor#')
    SKIN:Bang('!SetOption', 'ScrollUI', 'Shape' .. (newindex + 1), 'Ellipse (' .. ((newindex - 1) * 12) .. '*#GScale#),0,(3.5*#GScale#) | StrokeWidth 0 | Fill Color #SelectColor#')

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
local function Startup()
    JSON.writeFile(SKIN:GetVariable('CURRENTPATH') .. "DownloadFile/youtube.cache", CACHE)
    CURRENT_CHANNEL = 1
    SetNextChannel(-1)

    if (TOTAL_CHANNELS > 1) then
       SKIN:Bang('!EnableMeasure', 'Ticker')
       DrawScrollUI()
       SelectNode(TOTAL_CHANNELS, 1)
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

    DATA = JSON.readFile(SKIN:GetVariable('@') .. 'json/youtube.json')
    CHANNEL = JSON.filterEnabled(DATA.data)

    CHANNEL_DETAILS = {}
    for k, v in ipairs(CHANNEL) do
        CHANNEL_DETAILS[k] = {}
    end
    TOTAL_CHANNELS = table.getn(CHANNEL)

    CURRENT_CHANNEL = 1
    NEXT_CHANNEL = 2 % TOTAL_CHANNELS
    DOWNLOADED_CHANNELS = 0

    CACHE = JSON.readFile(SKIN:GetVariable('CURRENTPATH') .. "DownloadFile/youtube.cache")
    if not CACHE then
        CACHE = { date = os.time(), cache = {} }
    end

    TRANSITIONING = false

    STEP = { 0.00, -0.05, -0.15, -0.30, -0.50, -0.70, -0.85, -0.95, -1.00 }
    PULL = { 1, 1 }

    if TOTAL_CHANNELS >= 1 then
        SKIN:Bang('!EnableMeasure', 'VideoModule')
    end

    return 1
end

-- Creates a filename. Used primarily to save YouTube channel profile pictures
function GenerateFileName()
    if IsEmpty() then return '' end

    return CHANNEL[CURRENT_CHANNEL].id .. ".jpg"
end

function StoreMainData()
    if CHANNEL[CURRENT_CHANNEL].use_name then
        CHANNEL_DETAILS[CURRENT_CHANNEL].name = CHANNEL[CURRENT_CHANNEL].name
    else
        CHANNEL_DETAILS[CURRENT_CHANNEL].name = SKIN:GetMeasure("NameModule"):GetStringValue()
    end

    CHANNEL_DETAILS[CURRENT_CHANNEL].title = SKIN:GetMeasure("TitleModule"):GetStringValue()
    CHANNEL_DETAILS[CURRENT_CHANNEL].link = SKIN:GetMeasure("LinkModule"):GetStringValue()
    CHANNEL_DETAILS[CURRENT_CHANNEL].date = SKIN:GetMeasure("DateModule"):GetStringValue()

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
    if CHANNEL_DETAILS[CURRENT_CHANNEL].date == '' then return -1 end

    if CACHE.cache[CHANNEL[CURRENT_CHANNEL].id] then
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
    CACHE.cache[CHANNEL[CURRENT_CHANNEL].id] = true

    UpdateCheck()

    return 0
end

function UpdateCheck()
    DOWNLOADED_CHANNELS = DOWNLOADED_CHANNELS + 1

    if (DOWNLOADED_CHANNELS >= TOTAL_CHANNELS) then
        Startup()
        return 1
    else
        SetNextChannel(-1)
        CURRENT_CHANNEL = NEXT_CHANNEL
        SKIN:Bang('!CommandMeasure', 'VideoModule', 'Update')
        SKIN:Bang('!UpdateMeasure', 'VideoModule')
        SKIN:Bang('!UpdateMeter', 'BubbleText1')
    end

    return 0
end

-- Returns the appropriate URL to fetch a YouTube channel profile icon
function GetThumbnailURL()
    if IsEmpty() then return '' end

    return "https://www.youtube.com/channel/" .. CHANNEL[CURRENT_CHANNEL].id
end

-- Returns the appropriate URL to fetch the most recent YouTube channel uploads
function GetVideoURL()
    if IsEmpty() then return '' end

    return "https://www.youtube.com/feeds/videos.xml?channel_id=" .. CHANNEL[CURRENT_CHANNEL].id
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

    return CHANNEL_DETAILS[element].name
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

    return CHANNEL_DETAILS[element].title
end

-- Returns the direct link of the desired YouTube channel video
function GetLink(index)
    if (DOWNLOADED_CHANNELS <= 0) then
        return ""
    end

    local element = CURRENT_CHANNEL
    if index == 1 then element = NEXT_CHANNEL end

    return CHANNEL_DETAILS[element].link
end

-- Opens the appropriate video link in the user's preferred browser
function GotoLink(index)
    if (DOWNLOADED_CHANNELS <= 0) then
        return ""
    end

    local element = CURRENT_CHANNEL
    if index == 1 then element = NEXT_CHANNEL end

    SKIN:Bang(CHANNEL_DETAILS[element].link)

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

    return "Uploaded " .. CalculateTime(CHANNEL_DETAILS[element].date)
end

-- Sets the offset bubble to a user-defined input [x] and immediately performs a transition
function ManualSelect(x)
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
    SelectNode(CURRENT_CHANNEL, NEXT_CHANNEL)
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
function ClearCache()
    for k, v in pairs(CACHE.cache) do
        os.remove(k .. ".jpg")
    end
    os.remove(SKIN:GetVariable('CURRENTPATH') .. "DownloadFile/youtube.cache")

    print("Cleared cache!")

    SKIN:Bang('!Refresh')

    return 1
end