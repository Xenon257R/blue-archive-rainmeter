-- Script to handle scrollable and switchable quest list.
local JSON, DATA, QUEST
local SCROLL_AMOUNT = 0
local BUFFER = 4
local CURRENT_STARTUP = 1
local STARTUP_EASE_ORDER = {
    { 'S_H', 1.0 }, { 'S_H', 0.9 }, { 'S_H', 0.8 }, { 'S_H', 0.7 }, { 'S_H', 0.6 }, { 'S_H', 0.5 }, { 'S_H', 0.4 }, { 'S_H', 0.3 }, { 'S_H', 0.2 }, { 'S_H', 0.1 }, { 'S_H', 0.0 },
    { 'S_L', 0.0 }, { 'S_L', 0.1 }, { 'S_L', 0.2 }, { 'S_L', 0.3 }, { 'S_L', 0.4 }, { 'S_L', 0.5 }, { 'S_L', 0.6 }, { 'S_L', 0.7 }, { 'S_L', 0.8 }, { 'S_L', 0.9 }, { 'S_L', 1.0 }
}

local SELECTED_TAB = 1
local FILTER_FUNC = {
    function(_) return true end,
    function(v) return string.lower(v.class) == 'daily' end,
    function(v) return string.lower(v.class) == 'weekly' end,
    function(v) return string.lower(v.class) == 'challenges' end,
    function(v) return string.lower(v.class) ~= 'daily' and string.lower(v.class) ~= 'weekly' and string.lower(v.class) ~= 'challenges' end
}

local CLASS_COLOR_CODE = {
    daily = '56,157,236,255',
    weekly = '63,202,72,255',
    challenges = '223,134,0,255',
    misc = '235,86,145,255'
}

local COUNT_TEXT, COMPLETE_TEXT, RELIST_TEXT
local TAG_TEXT = {
    daily = '',
    weekly = '',
    challenges = '',
    misc = ''
}

-- Saves and applies local progress changes
local function applyChanges()
    SKIN:Bang('!UpdateMeterGroup', 'ListGroup')
    SKIN:Bang('!UpdateMeterGroup', 'PostListGroup')
    SKIN:Bang('!Redraw')

    JSON.writeFile(SKIN:GetVariable('CURRENTPATH') .. 'quest.cache', C:getTable())
end

-- Determines if the 5th and 6th elements are to be rendered or not depending on scroll
local function RenderLast()
    bang = { [5] = '!ShowMeter', [6] = '!ShowMeter' }
    if (SCROLL_AMOUNT == (#QUEST - BUFFER)) then
        bang[5] = '!HideMeter'
    end
    if (SCROLL_AMOUNT >= (#QUEST - BUFFER - 1)) then
        bang[6] = '!HideMeter'
    end

    for k, v in pairs(bang) do
        SKIN:Bang(v, 'Base' .. k)
        SKIN:Bang(v, 'ListLaunch' .. k)
        SKIN:Bang(v, 'ListLaunchText' .. k)
        SKIN:Bang(v, 'ListText' .. k)
        SKIN:Bang(v, 'ClassBackdrop' .. k)
        SKIN:Bang(v, 'ClassText' .. k)
        SKIN:Bang(v, 'ProgressBar' .. k)
        SKIN:Bang(v, 'ProgressCount' .. k)
        SKIN:Bang(v, 'Image' .. k)
        -- SKIN:Bang(v, 'BlurOut' .. k)
    end

    return bang
end

-- Hides excess elements
local function hideExcess()
    for i = 1, math.min(#QUEST + 1, 6), 1 do
        SKIN:Bang('!ShowMeter', 'Base' .. i)
        SKIN:Bang('!ShowMeter', 'ListLaunch' .. i)
        SKIN:Bang('!ShowMeter', 'ListLaunchText' .. i)
        SKIN:Bang('!ShowMeter', 'ListText' .. i)
        SKIN:Bang('!ShowMeter', 'ClassBackdrop' .. i)
        SKIN:Bang('!ShowMeter', 'ClassText' .. i)
        SKIN:Bang('!ShowMeter', 'ProgressBar' .. i)
        SKIN:Bang('!ShowMeter', 'ProgressCount' .. i)
        SKIN:Bang('!ShowMeter', 'Image' .. i)
        -- SKIN:Bang('!HideMeter', 'BlurOut' .. i)
    end

    for i = (#QUEST + 1), 6, 1 do
        SKIN:Bang('!HideMeter', 'Base' .. i)
        SKIN:Bang('!HideMeter', 'ListLaunch' .. i)
        SKIN:Bang('!HideMeter', 'ListLaunchText' .. i)
        SKIN:Bang('!HideMeter', 'ListText' .. i)
        SKIN:Bang('!HideMeter', 'ClassBackdrop' .. i)
        SKIN:Bang('!HideMeter', 'ClassText' .. i)
        SKIN:Bang('!HideMeter', 'ProgressBar' .. i)
        SKIN:Bang('!HideMeter', 'ProgressCount' .. i)
        SKIN:Bang('!HideMeter', 'Image' .. i)
        -- SKIN:Bang('!HideMeter', 'BlurOut' .. i)
    end
end

-- CITATION :https://stackoverflow.com/questions/13462001/ease-in-and-ease-out-animation-formula
local function ParametericBlend(t)
    local sqt = t * t;
    return sqt / (2.0 * (sqt - t) + 1.0)
end

-- checks if a day or week has passed, and do the appropriate functions.
-- NOTE: works on a local timescale instead of unix epoch, meaning all resets depend on the day rolling over at 12 AM locally.
local function checkExpiry()
    local time = os.date("%Y%m%d")
    local oldTime = os.date("%Y%m%d", C.date)
    local isNextDay = tonumber(time) > tonumber(oldTime)
    local week = os.date("%w")
    local oldWeek = os.date("%w", C.date)
    local isNextWeek = isNextDay and ((tonumber(time) - tonumber(oldTime) >= 7) or tonumber(week) < tonumber(oldWeek))

    for _, v in pairs(DATA.data) do
        if (v.class == 'daily' and C.data[v.name] and isNextDay) then C.data[v.name] = nil end
        if (v.class == 'weekly' and C.data[v.name] and isNextWeek) then C.data[v.name] = nil end
    end

    applyChanges()

    C:setTime()
end

-- pushes down all [complete] elements to the bottom of the list
local function pushDownComplete()
    local completeTable = {}
    for i = #QUEST, 1, -1 do
        if C.data[QUEST[i].name] and C.data[QUEST[i].name].completed then
            table.insert(completeTable, table.remove(QUEST, i))
        end
    end
    for j = #completeTable, 1, -1 do
        table.insert(QUEST, completeTable[j])
    end

    return 1
end

-- Changes the selected tab
local function changeTab()

    local filteredList = {}
    for _, v in pairs(JSON.filterEnabled(DATA.data)) do
        if FILTER_FUNC[SELECTED_TAB](v) then table.insert(filteredList, v) end
    end

    SCROLL_AMOUNT = 0
    QUEST = filteredList

    pushDownComplete()
    hideExcess()

    SKIN:Bang("!UpdateMeterGroup", "ListGroup")
    SKIN:Bang("!UpdateMeterGroup", "PostListGroup")
    SKIN:Bang('!Redraw')
end

function Initialize()
    TAG_TEXT.daily = SKIN:GetVariable('StrQuestListDailyTag', 'Daily')
    TAG_TEXT.weekly =SKIN:GetVariable('StrQuestListWeeklyTag', 'Weekly')
    TAG_TEXT.challenges = SKIN:GetVariable('StrQuestListChallengesTag', 'Challenges')
    TAG_TEXT.misc = SKIN:GetVariable('StrQuestListMiscellaneousTag', 'Misc.')
    COUNT_TEXT = SKIN:GetVariable('StrQuestListCountLabel', 'Count')
    COMPLETE_TEXT = SKIN:GetVariable('StrQuestListCompleteButton', 'Complete')
    RELIST_TEXT = SKIN:GetVariable('StrQuestListRelistButton', 'Relist')

    JSON = dofile(SKIN:GetVariable('@') .. 'lua\\lib\\jsonhandler.lua')
    CACHE = dofile(SKIN:GetVariable('@') .. 'lua\\lib\\cache.lua')

    DATA = JSON.readFile(SKIN:GetVariable('@') .. 'json\\questlist.json')
    QUEST = JSON.filterEnabled(DATA.data)

    C = CACHE.new(JSON.readFile(SKIN:GetVariable('CURRENTPATH') .. 'quest.cache'))
    checkExpiry()

    SelectTab(0)

    return 1
end

-- Returns the description of a specified element
function GetDescription(index)
    index = tonumber(index) + math.floor(SCROLL_AMOUNT)
    if (index > #QUEST) then return '' end

    return QUEST[index].description
end

-- Returns the class string of a specified element
function GetClass(index)
    index = tonumber(index) + math.floor(SCROLL_AMOUNT)
    if (index > #QUEST) or QUEST[index].class == '' then return TAG_TEXT.misc end

    return TAG_TEXT[string.lower(QUEST[index].class)] or QUEST[index].class
end

-- Returns the class color code of a specified index's class
function GetClassColor(index)
    index = tonumber(index) + math.floor(SCROLL_AMOUNT)
    if (index > #QUEST) then return CLASS_COLOR_CODE.misc end

    return CLASS_COLOR_CODE[QUEST[index].class] or CLASS_COLOR_CODE.misc
end

-- Returns the completion value of a specified element in a [n / n] format
function GetCountString(index)
    index = tonumber(index) + math.floor(SCROLL_AMOUNT)
    if (index > #QUEST) then return COUNT_TEXT .. ' 0 / 0' end
    if (not C.data[QUEST[index].name]) then return COUNT_TEXT .. ' 0 / ' .. (QUEST[index].count or 0) end

    return COUNT_TEXT .. ' ' .. math.floor(((C.data[QUEST[index].name].progress or 0) * (QUEST[index].count or 0)) + 0.5) .. ' / ' .. (QUEST[index].count or 0)
end

-- Returns the completion percentage of a specified element
function GetCountPercent(index)
    index = tonumber(index) + math.floor(SCROLL_AMOUNT)
    if (index > #QUEST or not C.data[QUEST[index].name]) then return 0 end

    return C.data[QUEST[index].name].progress or 0
end

-- Sets the completion percentage of a specified element to a discrete value
function SetCountPercent(index, x)
    index = tonumber(index) + math.floor(SCROLL_AMOUNT)
    if (index > #QUEST or not QUEST[index].count or QUEST[index].count <= 0 or (C.data[QUEST[index].name] and C.data[QUEST[index].name].completed)) then return 0 end
    local percent = math.floor((tonumber(x) * 0.01 * QUEST[index].count) + 0.5) / QUEST[index].count

    if not C.data[QUEST[index].name] then C.data[QUEST[index].name] = {} end
    C.data[QUEST[index].name].progress = percent

    applyChanges()
    return percent
end

-- Manipulates the completion percentage of a specified element by a specified vector
function ScrollCountPercent(index, vector)
    if tonumber(vector) <= 50 then vector = -1 else vector = 1 end
    index = tonumber(index) + math.floor(SCROLL_AMOUNT)
    if (index > #QUEST or not QUEST[index].count or QUEST[index].count <= 0 or (C.data[QUEST[index].name] and C.data[QUEST[index].name].completed)) then return 0 end
    if not C.data[QUEST[index].name] then C.data[QUEST[index].name] = {} end

    local percent = math.max(math.min(tonumber(vector) + ((C.data[QUEST[index].name].progress or 0) * QUEST[index].count), QUEST[index].count), 0) / QUEST[index].count
    C.data[QUEST[index].name].progress = percent

    applyChanges()
    return percent
end

-- Toggles the [complete] state of the specified element
function SetComplete(index)
    index = tonumber(index) + math.floor(SCROLL_AMOUNT)
    if (index > #QUEST) then return 0 end

    if not C.data[QUEST[index].name] then C.data[QUEST[index].name] = {} end
    C.data[QUEST[index].name].completed = not C.data[QUEST[index].name].completed
    C.data[QUEST[index].name].progress = C.data[QUEST[index].name].completed and 1 or 0

    pushDownComplete()
    applyChanges()
    return 1
end

-- Returns whether or not an element has the completed status or not (1 or 0)
function IsCompleted(index)
    index = tonumber(index) + math.floor(SCROLL_AMOUNT)
    if (index > #QUEST) then return 0 end

    return ((C.data[QUEST[index].name] and C.data[QUEST[index].name].completed) and 1) or 0
end

-- Returns the appropriate button string according to the state of the element
function ButtonString(index)
    index = tonumber(index) + math.floor(SCROLL_AMOUNT)
    if (index > #QUEST) then return '' end
    if C.data[QUEST[index].name] and C.data[QUEST[index].name].completed then return RELIST_TEXT end

    return COMPLETE_TEXT
end

-- Returns the current scroll amount. Inverted due to graphical logic inversely related to stored value
function GetScroll()
    return -(SCROLL_AMOUNT % 1)
end

-- Emulates appropriate functions when button is pressed
function PressButton(index)
    SKIN:Bang("!SetOption", "ListLaunch" .. index, "Shape", "Rectangle ((#ButtonWidth#-(#LaunchWidth#+(10*#GScale#)+(#LaunchWidth#*0.5*#Leg#)))+(5*#GScale#)+#SX#),((55*#GScale#)+(5*#GScale#)+#SY#),(#LaunchWidth#-(10*#GScale#)),(#ButtonHeight#-(70*#GScale#)-(10*#GScale#)),#Edgeround# | Fill Color #ShadowColor# | StrokeWidth 0 | Skew #FullSkew#")
    SKIN:Bang("!SetOption", "ListLaunch" .. index, "Shape2", "Rectangle (#ButtonWidth#-(#LaunchWidth#+(10*#GScale#)+(#LaunchWidth#*0.5*#Leg#))+(5*#GScale#)),((55*#GScale#)+(5*#GScale#)),(#LaunchWidth#-(10*#GScale#)),(#ButtonHeight#-(70*#GScale#)-(10*#GScale#)),#Edgeround# | Fill Color #HighlightColor# | StrokeWidth 0 | Skew #FullSkew#")
    SKIN:Bang("!UpdateMeter", "ListLaunch" .. index)

    SKIN:Bang("!SetOption", "ListLaunchText" .. index, "FontSize", "(15*#GScale#)")
    SKIN:Bang("!UpdateMeter", "ListLaunchText" .. index)

    SKIN:Bang('!Redraw')
    return 1
end

-- Emulates appropriate functions when button is released
function ReleaseButton(index)
    SKIN:Bang("!SetOption", "ListLaunch" .. index, "Shape", "Rectangle ((#ButtonWidth#-(#LaunchWidth#+(10*#GScale#)+(#LaunchWidth#*0.5*#Leg#)))+#SX#),((55*#GScale#)+#SY#),#LaunchWidth#,(#ButtonHeight#-(70*#GScale#)),#Edgeround# | Fill Color #ShadowColor# | StrokeWidth 0 | Skew #FullSkew#")
    SKIN:Bang("!SetOption", "ListLaunch" .. index, "Shape2", "Rectangle (#ButtonWidth#-(#LaunchWidth#+(10*#GScale#)+(#LaunchWidth#*0.5*#Leg#))),(55*#GScale#),#LaunchWidth#,(#ButtonHeight#-(70*#GScale#)),#Edgeround# | Fill LinearGradient ButtonGradient | StrokeWidth 0 | Skew #FullSkew#")
    SKIN:Bang("!UpdateMeter", "ListLaunch" .. index)

    SKIN:Bang("!SetOption", "ListLaunchText" .. index, "FontSize", "(16*#GScale#)")
    SKIN:Bang("!UpdateMeter", "ListLaunchText" .. index)

    SKIN:Bang('!Redraw')
    return 0
end

-- Switches to a new tab and filters the database accordingly
function SelectTab(x)
    SKIN:Bang('!SetOption', 'TabText' .. SELECTED_TAB, 'FontColor', '#TextColor#')
    SKIN:Bang('!UpdateMeter', 'TabText' .. SELECTED_TAB)

    SELECTED_TAB = math.min(math.floor(tonumber(x) * 0.01 * #FILTER_FUNC) + 1, #FILTER_FUNC)

    SKIN:Bang('!SetOption', 'ListContainerBackdrop', 'Shape6', 'Rectangle ((#ButtonWidth#+(20*#GScale#))*0.2*' .. (SELECTED_TAB - 1) .. '),0,((#ButtonWidth#+(20*#GScale#))*0.2),(70*#GScale#) | Fill Color #BannerColor# | StrokeWidth 0')
    SKIN:Bang('!UpdateMeter', 'ListContainerBackdrop')

    SKIN:Bang('!SetOption', 'TabText' .. SELECTED_TAB, 'FontColor', '#WealthColor#')
    SKIN:Bang('!UpdateMeter', 'TabText' .. SELECTED_TAB)

    changeTab()
    return 1
end

-- Handles the introductory scroll in
function IntroScroll()
    SKIN:Bang("!SetVariable", STARTUP_EASE_ORDER[CURRENT_STARTUP][1], ParametericBlend(STARTUP_EASE_ORDER[CURRENT_STARTUP][2]))
    SKIN:Bang("!UpdateMeterGroup", "HeaderGroup")
    SKIN:Bang("!UpdateMeterGroup", "ListGroup")
    SKIN:Bang("!Redraw")

    CURRENT_STARTUP = math.min(CURRENT_STARTUP + 1, #STARTUP_EASE_ORDER)

    return 1
end

-- Scrolls the list in the defined [vector] direction
function Scroll(vector)
    vector = tonumber(vector or 0)

    if (vector < 0 and SCROLL_AMOUNT <= 0) then
        return -1
    elseif (vector > 0 and SCROLL_AMOUNT > (#QUEST - BUFFER)) then
        return -1
    end

    SCROLL_AMOUNT = math.max(math.min((SCROLL_AMOUNT + vector), (#QUEST - BUFFER)), 0)
    RenderLast()

    return SCROLL_AMOUNT
end