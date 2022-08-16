-- Small script to track YouTube channel uploads.
function Initialize()
    CHANNELCOUNT = tonumber(SKIN:GetVariable('ChannelCount'))
    CHANNEL = 1
    CHECKTASK = 0
    ERRORFLAG = 0

    for i = CHANNEL, CHANNELCOUNT, 1 do
        SKIN:Bang('!EnableMeasureGroup', 'Group' .. i)
    end

    if (CHANNELCOUNT > 1) then
        -- SKIN:Bang('!SetOption', 'CaptionTextTitle1', 'Y', '16R')
        -- SKIN:Bang('!SetOption', 'CaptionTextTitle2', 'Y', '16R')
        SKIN:Bang('!SetOption', 'ScrollUI', 'Shape', 'Rectangle -8,-8,'.. (4 + (CHANNELCOUNT * 12)) .. ',16,8,8 | StrokeWidth 0 | Fill Color 255,255,255,255')
        for i = CHANNEL, CHANNELCOUNT, 1 do
            SKIN:Bang('!SetOption', 'ScrollUI', 'Shape' .. (i + 1), 'Ellipse ' .. ((i - 1) * 12) .. ',0,4 | StrokeWidth 0 | Fill Color #FrameColor#')
        end
        SKIN:Bang('!SetOption', 'ScrollUI', 'X', '((#BubbleSize#+#Indent#)-' .. ((CHANNELCOUNT * 6) - (12 / 2)) .. ')')

        SKIN:Bang('!SetOption', 'ScrollUI', 'Shape2', 'Ellipse 0,0,4 | StrokeWidth 0 | Fill Color #SelectColor#')
        SKIN:Bang('!UpdateMeter', 'ScrollUI')
    end

    return 1
end

local function NextChannel()
    return (CHANNEL % CHANNELCOUNT) + 1
end

local function Plural(value, time)
    if value == 1 then
        return value .. " " .. time
    end
    return value .. " " .. time .. "s"
end

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

function UpdateCheck()
    if (ERRORFLAG == 1) then
        return -1
    end

    CHECKTASK = CHECKTASK + 1
    print(CHECKTASK .. '/' .. (CHANNELCOUNT * 2) .. ' connections complete...')
    if (CHECKTASK < CHANNELCOUNT * 2) then
        return 0
    end

    print('Presets complete, now rendering...')

    SKIN:Bang('!ShowMeter', 'ScrollUI')
    SKIN:Bang('!UpdateMeter', 'ScrollUI')

    DrawImage(1, 1)
    DrawImage(2, (1 % CHANNELCOUNT) + 1)
    SetDate()
    SKIN:Bang('!UpdateMeterGroup', 'YouTubeGroup')
    if (CHANNELCOUNT > 1) then
        SKIN:Bang('!EnableMeasure', 'AutoScroller')
    end

    return 1
end

function WritePopUp(index)
    local elapsedTime = 0
    if (index == 0) then
        elapsedTime = CalculateTime(CHANNEL)
    else
        elapsedTime = CalculateTime(NextChannel())
    end

    if (elapsedTime == nil or elapsedTime == "") then
        return "Gathering data..."
    end

    return "Uploaded " .. elapsedTime
end

function DrawImage(index, image)

    local newicon = '[YouTubeIconURL' .. image .. '].'
    SKIN:Bang('!SetOption', 'YouTubeIcon' .. index, 'ImageName', newicon)
    SKIN:Bang('!UpdateMeter', 'YouTubeIcon' .. index)

    return 1
end

-- Credits to https://stackoverflow.com/questions/4105012/convert-a-string-date-to-a-timestamp
function CalculateTime(index)
    local dateMeasure = SKIN:GetMeasure('YouTubeVideoDate' .. index)
    local date = dateMeasure:GetStringValue()
    if date == nil then return "VOID" end
    if date == "" then return "" end

    -- 2022-08-01T18:36:57+00:00
    local pattern = "(%d+)-(%d+)-(%d+)T(%d+):(%d+):(%d+)"
    local ryear, rmonth, rday, rhour, rmin, rsec = date:match(pattern)

    local unixtime = os.time({year = ryear, month = rmonth, day = rday, hour = rhour, min = rmin, sec = rsec})
    local pasttime = os.time(os.date("!*t")) - unixtime

    return LargestTime(pasttime)
end

function SetDate()
    -- print('Captured date, rewriting...')
    SKIN:Bang('!SetOption', 'BubbleText1', 'Text', WritePopUp(0))
    SKIN:Bang('!UpdateMeter', 'BubbleText1')
    SKIN:Bang('!SetOption', 'BubbleText2', 'Text', WritePopUp(1))
    SKIN:Bang('!UpdateMeter', 'BubbleText2')

    return 1
end

function Equalize()
    local newname = 'YouTubeName' .. NextChannel()
    local newtitle = 'YouTubeVideoTitle' .. NextChannel()
    
    DrawImage(1, NextChannel())

    local newlink = '"[YouTubeVideoLink' .. NextChannel() .. ']"'
    SKIN:Bang('!SetOption', 'YouTubeIcon1', 'LeftMouseUpAction', newlink)

    SKIN:Bang('!SetOption', 'CaptionTextName1', 'MeasureName', newname)
    SKIN:Bang('!SetOption', 'CaptionTextTitle1', 'MeasureName', newtitle)
    SKIN:Bang('!UpdateMeter', 'CaptionTextName1')
    SKIN:Bang('!UpdateMeter', 'CaptionTextTitle1')
    SKIN:Bang('!SetOption', 'BubbleText1', 'Text', WritePopUp(1))
    SKIN:Bang('!UpdateMeter', 'BubbleText1')

    SKIN:Bang('!SetOption', 'ScrollUI', 'Shape' .. (CHANNEL + 1), 'Ellipse ' .. ((CHANNEL - 1) * 12) .. ',0,4 | StrokeWidth 0 | Fill Color #FrameColor#')
    SKIN:Bang('!SetOption', 'ScrollUI', 'Shape' .. (NextChannel() + 1), 'Ellipse ' .. ((NextChannel() - 1) * 12) .. ',0,4 | StrokeWidth 0 | Fill Color #SelectColor#')
    SKIN:Bang('!UpdateMeter', 'ScrollUI')

    return 1
end

function Step()
    CHANNEL = NextChannel()
    local newname = 'YouTubeName' .. NextChannel()
    local newtitle = 'YouTubeVideoTitle' .. NextChannel()

    DrawImage(2, NextChannel())

    local newlink = '"[YouTubeVideoLink' .. NextChannel() .. ']"'
    SKIN:Bang('!SetOption', 'YouTubeIcon2', 'LeftMouseUpAction', newlink)

    SKIN:Bang('!SetOption', 'CaptionTextName2', 'MeasureName', newname)
    SKIN:Bang('!SetOption', 'CaptionTextTitle2', 'MeasureName', newtitle)
    SKIN:Bang('!UpdateMeter', 'CaptionTextName2')
    SKIN:Bang('!UpdateMeter', 'CaptionTextTitle2')
    SKIN:Bang('!SetOption', 'BubbleText2', 'Text', WritePopUp(2))
    SKIN:Bang('!UpdateMeter', 'BubbleText2')

    return 1
end

function Error(errtype)
    ERRORFLAG = 1
    CHECKTASK = 0

    print("An error has occured: " .. errtype)

    SKIN:Bang('!SetOption', 'BubbleText1', 'Text', 'Error with ' .. errtype .. '.')
    SKIN:Bang('!UpdateMeter', 'BubbleText1')

    return 1
end