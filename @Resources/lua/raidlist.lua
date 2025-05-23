-- Script to handle scrollable raid list.
local JSON, DATA, GAME
local SCROLL_AMOUNT = 0
local BUFFER = 4
local CURRENT_STARTUP = 1
local STARTUP_EASE_ORDER = {
    { 'S_H', 1.0 }, { 'S_H', 0.9 }, { 'S_H', 0.8 }, { 'S_H', 0.7 }, { 'S_H', 0.6 }, { 'S_H', 0.5 }, { 'S_H', 0.4 }, { 'S_H', 0.3 }, { 'S_H', 0.2 }, { 'S_H', 0.1 }, { 'S_H', 0.0 },
    { 'S_L', 0.0 }, { 'S_L', 0.1 }, { 'S_L', 0.2 }, { 'S_L', 0.3 }, { 'S_L', 0.4 }, { 'S_L', 0.5 }, { 'S_L', 0.6 }, { 'S_L', 0.7 }, { 'S_L', 0.8 }, { 'S_L', 0.9 }, { 'S_L', 1.0 }
}

local AVAILABLE_TEXT

-- Determines if the 5th and 6th elements are to be rendered or not depending on scroll
local function RenderLast()
    bang = { [5] = '!ShowMeter', [6] = '!ShowMeter' }
    if (SCROLL_AMOUNT == (#GAME - BUFFER)) then
        bang[5] = '!HideMeter'
    end
    if (SCROLL_AMOUNT >= (#GAME - BUFFER - 1)) then
        bang[6] = '!HideMeter'
    end

    for k, v in pairs(bang) do
        SKIN:Bang(v, 'Image' .. k)
        SKIN:Bang(v, 'ListLaunch' .. k)
        SKIN:Bang(v, 'ListLaunchText' .. k)
        SKIN:Bang(v, 'Shine' .. k)
        SKIN:Bang(v, 'ListText' .. k)
        SKIN:Bang(v, 'Base' .. k)
        SKIN:Bang(v, 'BlurOut' .. k)
    end

    return bang
end

-- CITATION :https://stackoverflow.com/questions/13462001/ease-in-and-ease-out-animation-formula
local function ParametericBlend(t)
    local sqt = t * t;
    return sqt / (2.0 * (sqt - t) + 1.0)
end

function Initialize()
    AVAILABLE_TEXT = SKIN:GetVariable('StrRaidListAvailability', 'Games Available:')

    JSON = dofile(SKIN:GetVariable('@') .. 'lua\\lib\\jsonhandler.lua')

    DATA = JSON.readFile(SKIN:GetVariable('@') .. 'json\\raidlist.json')
    GAME = DATA.data

    for i = (#GAME + 1), 6, 1 do
        SKIN:Bang('!HideMeter', 'Image' .. i)
        SKIN:Bang('!HideMeter', 'ListLaunch' .. i)
        SKIN:Bang('!HideMeter', 'ListLaunchText' .. i)
        SKIN:Bang('!HideMeter', 'Shine' .. i)
        SKIN:Bang('!HideMeter', 'ListText' .. i)
        SKIN:Bang('!HideMeter', 'Base' .. i)
        SKIN:Bang('!HideMeter', 'BlurOut' .. i)
    end

    SKIN:Bang('!SetOption', 'TicketQuantityText', 'Text', AVAILABLE_TEXT .. ' ' .. #(JSON.filterEnabled(DATA.data)) .. '/' .. #GAME)

    return 1
end

-- Returns the name and subtext of the specified element, separated by a newline
function GetFullString(index)
    index = tonumber(index) + math.floor(SCROLL_AMOUNT)
    if (index > #GAME) then return '' end

    return GAME[index].name .. "\n" .. GAME[index].subtext
end

-- Returns the launch text of the specified element
function GetLaunchText(index)
    index = tonumber(index) + math.floor(SCROLL_AMOUNT)
    if (index > #GAME or GAME[index].launch_text == '') then return 'Open' end

    return GAME[index].launch_text
end

-- Returns the image of the specified element
function GetImage(index)
    index = tonumber(index) + math.floor(SCROLL_AMOUNT)
    if (index > #GAME) then return '0.jpg' end

    return GAME[index].image
end

-- Returns (and executes) the execution value of the specified element
function ExecuteLine(index)
    ReleaseButton(index)
    index = tonumber(index) + math.floor(SCROLL_AMOUNT)
    if (index > #GAME or not GAME[index].enable) then return '[]' end

    return '[' .. GAME[index].execution .. ']'
end

-- Returns if the specifed element is [enable]d
function IsEnabled(index)
    index = tonumber(index) + math.floor(SCROLL_AMOUNT)
    if ((index > #GAME) or not GAME[index].enable) then return 1 end

    return 0
end

-- Returns the current scroll amount. Inverted due to graphical logic inversely related to stored value
function GetScroll()
    return -(SCROLL_AMOUNT % 1)
end

-- Emulates appropriate functions when button is pressed
function PressButton(index)
    SKIN:Bang("!SetOption", "ListLaunch" .. index, "Shape", "Rectangle ((#ButtonWidth#-(#LaunchSize#+(10*#GScale#)+(#LaunchSize#*0.5*#Leg#)))+(#LaunchSize#*0.05)+#SX#),((10*#GScale#)+(#LaunchSize#*0.05)+#SY#),(#LaunchSize#*0.9),(#LaunchSize#*0.9),#Edgeround# | Fill Color #ShadowColor# | StrokeWidth 0 | Skew #FullSkew#")
    SKIN:Bang("!SetOption", "ListLaunch" .. index, "Shape2", "Rectangle (#ButtonWidth#-(#LaunchSize#+(10*#GScale#)+(#LaunchSize#*0.5*#Leg#))+(#LaunchSize#*0.05)),(10*#GScale#+(#LaunchSize#*0.05)),(#LaunchSize#*0.9),(#LaunchSize#*0.9),#Edgeround# | Fill LinearGradient ButtonGradient | StrokeWidth 0 | Skew #FullSkew#")
    SKIN:Bang("!UpdateMeter", "ListLaunch" .. index)

    SKIN:Bang("!SetOption", "ListLaunchText" .. index, "FontSize", "(15*#GScale#)")
    SKIN:Bang("!UpdateMeter", "ListLaunchText" .. index)

    SKIN:Bang('!Redraw')
    return 1
end

-- Emulates appropriate functions when button is released
function ReleaseButton(index)
    SKIN:Bang("!SetOption", "ListLaunch" .. index, "Shape", "Rectangle ((#ButtonWidth#-(#LaunchSize#+(10*#GScale#)+(#LaunchSize#*0.5*#Leg#)))+#SX#),((10*#GScale#)+#SY#),#LaunchSize#,#LaunchSize#,#Edgeround# | Fill Color #ShadowColor# | StrokeWidth 0 | Skew #FullSkew#")
    SKIN:Bang("!SetOption", "ListLaunch" .. index, "Shape2", "Rectangle (#ButtonWidth#-(#LaunchSize#+(10*#GScale#)+(#LaunchSize#*0.5*#Leg#))),(10*#GScale#),#LaunchSize#,#LaunchSize#,#Edgeround# | Fill LinearGradient ButtonGradient | StrokeWidth 0 | Skew #FullSkew#")
    SKIN:Bang("!UpdateMeter", "ListLaunch" .. index)

    SKIN:Bang("!SetOption", "ListLaunchText" .. index, "FontSize", "(16*#GScale#)")
    SKIN:Bang("!UpdateMeter", "ListLaunchText" .. index)

    SKIN:Bang('!Redraw')
    return 0
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
    elseif (vector > 0 and SCROLL_AMOUNT > (#GAME - BUFFER)) then
        return -1
    end

    SCROLL_AMOUNT = math.max(math.min((SCROLL_AMOUNT + vector), (#GAME - BUFFER)), 0)
    RenderLast()

    return SCROLL_AMOUNT
end