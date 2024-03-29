-- Script to handle scrollable raid list.
local JSON, DATA, ITEM
local SCROLL_AMOUNT = 0
local BUFFER = 2
local CURRENT_STARTUP = 1

local CURRENT_DOWNLOAD = 1

local STARTUP_EASE_ORDER = {
    { 'S_H', 1.0 }, { 'S_H', 0.9 }, { 'S_H', 0.8 }, { 'S_H', 0.7 }, { 'S_H', 0.6 }, { 'S_H', 0.5 }, { 'S_H', 0.4 }, { 'S_H', 0.3 }, { 'S_H', 0.2 }, { 'S_H', 0.1 }, { 'S_H', 0.0 },
    { 'S_L', 0.0 }, { 'S_L', 0.1 }, { 'S_L', 0.2 }, { 'S_L', 0.3 }, { 'S_L', 0.4 }, { 'S_L', 0.5 }, { 'S_L', 0.6 }, { 'S_L', 0.7 }, { 'S_L', 0.8 }, { 'S_L', 0.9 }, { 'S_L', 1.0 }
}

-- Hides excess elements
local function hideExcess()
    for i = 1, math.min((#ITEM - math.floor(SCROLL_AMOUNT) * 5), 20), 1 do
        SKIN:Bang('!ShowMeter', 'Base' .. i)
        SKIN:Bang('!ShowMeter', 'Name' .. i)
        SKIN:Bang('!ShowMeter', 'ListLaunch' .. i)
        SKIN:Bang('!ShowMeter', 'ListLaunchNum' .. i)
        SKIN:Bang('!ShowMeter', 'ListLaunchImage' .. i)
        SKIN:Bang('!ShowMeter', 'ListLaunchText' .. i)
        SKIN:Bang('!ShowMeter', 'ListItemImage' .. i)
        SKIN:Bang('!ShowMeter', 'AddToMass' .. i)
    end

    for i = (#ITEM - math.floor(SCROLL_AMOUNT) * 5) + 1, 20, 1 do
        SKIN:Bang('!HideMeter', 'Base' .. i)
        SKIN:Bang('!HideMeter', 'Name' .. i)
        SKIN:Bang('!HideMeter', 'ListLaunch' .. i)
        SKIN:Bang('!HideMeter', 'ListLaunchNum' .. i)
        SKIN:Bang('!HideMeter', 'ListLaunchImage' .. i)
        SKIN:Bang('!HideMeter', 'ListLaunchText' .. i)
        SKIN:Bang('!HideMeter', 'ListItemImage' .. i)
        SKIN:Bang('!HideMeter', 'AddToMass' .. i)
    end
end

-- Graphically updates the mass launch button according to the state of the queue
local function updateLaunchButton()
    if (IsQueued(-1) == 1) then
        SKIN:Bang('!SetOption', 'MassLaunchButton', 'Shape2', 'Rectangle 0,0,(150*#GScale#),(50*#GScale#),#Edgeround# | Fill LinearGradient ButtonGradient | StrokeWidth 0 | Skew #FullSkew#')
        SKIN:Bang('!SetOption', 'MassLaunchText', 'FontColor', '#TextColor#')
    else
        SKIN:Bang('!SetOption', 'MassLaunchButton', 'Shape2', 'Rectangle 0,0,(150*#GScale#),(50*#GScale#),#Edgeround# | Fill LinearGradient OffGradient | StrokeWidth 0 | Skew #FullSkew#')
        SKIN:Bang('!SetOption', 'MassLaunchText', 'FontColor', '#OffBorderColor#')
    end
end

-- Returns whether or not the specified string is a web domain
local function getDomain(s)
    s = string.gsub(s, '^https?://', '')
    local _, _, checkSlash = string.find(s, '(.-)/.*')
    s = checkSlash or s
    return string.gsub(s, '%.', '')
end

-- CITATION: https://stackoverflow.com/questions/68694608/how-to-check-url-whether-url-is-valid-in-lua
local function isURL(s)
    return string.match(s, '[a-z]*://[^ >,;]*')
end

-- CITATION :https://stackoverflow.com/questions/13462001/ease-in-and-ease-out-animation-formula
local function ParametericBlend(t)
    local sqt = t * t;
    return sqt / (2.0 * (sqt - t) + 1.0)
end

function Initialize()
    JSON = dofile(SKIN:GetVariable('@') .. 'lua\\lib\\jsonhandler.lua')
    CACHE = dofile(SKIN:GetVariable('@') .. 'lua\\lib\\cache.lua')

    DATA = JSON.readFile(SKIN:GetVariable('@') .. 'json\\shoplist.json')
    ITEM = JSON.filterEnabled(DATA.data)

    C = CACHE.new(JSON.readFile(SKIN:GetVariable('CURRENTPATH') .. 'DownloadFile\\shoplist.cache'))

    for k, v in pairs(ITEM) do
        if isURL(v.path) and not C.data[getDomain(v.path)] then
            CURRENT_DOWNLOAD = k
            SKIN:Bang('!EnableMeasure', 'FaviconModule')
            SKIN:Bang('!CommandMeasure', 'FaviconModule', 'Update')
            SKIN:Bang('!UpdateMeasure', 'FaviconModule')
            break;
        end
    end

    for i = (#ITEM + 1), 20, 1 do
        SKIN:Bang('!HideMeter', 'Base' .. i)
        SKIN:Bang('!HideMeter', 'Name' .. i)
        SKIN:Bang('!HideMeter', 'ListLaunch' .. i)
        SKIN:Bang('!HideMeter', 'ListLaunchNum' .. i)
        SKIN:Bang('!HideMeter', 'ListLaunchImage' .. i)
        SKIN:Bang('!HideMeter', 'ListLaunchText' .. i)
        SKIN:Bang('!HideMeter', 'ListItemImage' .. i)
        SKIN:Bang('!HideMeter', 'AddToMass' .. i)
    end

    return 1
end

-- Returns the URL the favicon should be downloaded from
function GetFaviconURL()
    return 'https://www.google.com/s2/favicons?sz=32&domain=' .. ITEM[CURRENT_DOWNLOAD].path
end

-- Returns the filename the favicon should be saved under
function GetFaviconFilename()
    return getDomain(ITEM[CURRENT_DOWNLOAD].path) .. '.png'
end

-- Catalogs the newly downloaded favicon for future use
function CatalogFavicon()
    C.data[getDomain(ITEM[CURRENT_DOWNLOAD].path)] = getDomain(ITEM[CURRENT_DOWNLOAD].path) .. '.png'
    JSON.writeFile(SKIN:GetVariable('CURRENTPATH') .. 'DownloadFile\\shoplist.cache', C:getTable())

    for k = CURRENT_DOWNLOAD + 1, #ITEM, 1 do
        if isURL(ITEM[k].path) and not C.data[getDomain(ITEM[k].path)] then
            CURRENT_DOWNLOAD = k
            SKIN:Bang('!CommandMeasure', 'FaviconModule', 'Update')
            SKIN:Bang('!UpdateMeasure', 'FaviconModule')
            return 1
        end
    end

    return 1
end

-- Returns the item name of the specified element
function GetName(index)
    index = tonumber(index) + (math.floor(SCROLL_AMOUNT) * 5)
    if (index > #ITEM) then return 'Peroro' end

    return ITEM[index].name
end

-- Returns the launch value of the specified element
function GetLaunchValue(index)
    index = tonumber(index) + (math.floor(SCROLL_AMOUNT) * 5)
    if (index > #ITEM or ITEM[index].launch_cost == '') then return 0 end

    return ITEM[index].launch_cost
end

-- Returns the image of the specified element
function GetImage(index)
    index = tonumber(index) + (math.floor(SCROLL_AMOUNT) * 5)
    if (index > #ITEM or ITEM[index].image == '') then return SKIN:GetVariable('@') .. 'assets\\shopitems\\peroro.png' end

    return SKIN:GetVariable('@') .. 'assets\\shopitems\\' .. ITEM[index].image
end

-- Returns the favicon image of the specified element
function GetLaunchImage(index)
    index = tonumber(index) + (math.floor(SCROLL_AMOUNT) * 5)
    if (index > #ITEM) then return SKIN:GetVariable('@') .. 'assets\\shopitems\\peroro.png' end
    if (not C.data[getDomain(ITEM[index].path)]) then
        if isURL(ITEM[index].path) then return SKIN:GetVariable('@') .. 'assets\\misc\\favicon.png' end
        return SKIN:GetVariable('@') .. 'assets\\misc\\shortcut.png'
    end

    return SKIN:GetVariable('CURRENTPATH') .. 'DownloadFile\\' .. C.data[getDomain(ITEM[index].path)]
end

-- Adds the element at the specified index to the Mass Launch queue. If already there, removes it from the queue instead
function AddToMass(index)
    index = tonumber(index) + (math.floor(SCROLL_AMOUNT) * 5)
    if (index > #ITEM) then return -1 end

    ITEM[index].queued = not ITEM[index].queued

    updateLaunchButton()
    SKIN:Bang('!UpdateMeterGroup', 'CheckmarkGroup')
    SKIN:Bang('!Redraw')

    return 1
end

-- Empties the Mass Launch queue
function EmptyMass()
    for _, v in pairs(ITEM) do
        v.queued = false
    end

    updateLaunchButton()
    SKIN:Bang('!UpdateMeterGroup', 'CheckmarkGroup')
    SKIN:Bang('!Redraw')

    return 0
end

-- Returns if there are any items in the Mass Launch queue or not (1 or 0)
function IsQueued(index)
    if (index < 0) then
        for _, v in pairs(ITEM) do
            if v.queued then return 1 end
        end
        return 0
    end

    index = tonumber(index) + (math.floor(SCROLL_AMOUNT) * 5)
    if (index > #ITEM) then return 0 end

    return ITEM[index].queued and 1 or 0
end

-- Returns how many items are in the MassLaunch queue
function NumQueued()
    local count = 0
    for _, v in pairs(ITEM) do
        if v.queued then count = count + 1 end
    end

    return count
end

-- Returns (and executes) the execution value of the specified element
function ExecuteLine(index)
    local massString = ''
    local modifiedIndex = tonumber(index) + (math.floor(SCROLL_AMOUNT) * 5)
    if (modifiedIndex > #ITEM) then
        massString = ''
    elseif (tonumber(index) < 0) then
        for _, v in pairs(ITEM) do
            if v.queued then
                massString = massString .. '[' .. v.path .. ']'
                v.queued = false
            end
        end
    else
        massString = '[' .. ITEM[modifiedIndex].path .. ']'
    end

    updateLaunchButton()
    SKIN:Bang('!UpdateMeterGroup', 'CheckmarkGroup')
    SKIN:Bang('!Redraw')

    return massString
end

-- Returns the current scroll amount. Inverted due to graphical logic inversely related to stored value
function GetScroll()
    return -(SCROLL_AMOUNT % 1)
end

-- Emulates appropriate functions when button is pressed
function PressButton(index)
    SKIN:Bang('!SetOption', 'ListLaunchText' .. index, 'FontColor', '#HighlightColor#')
    SKIN:Bang('!UpdateMeter', 'ListLaunchText' .. index)

    SKIN:Bang('!Redraw')
    return 1
end

-- Emulates appropriate functions when button is released
function ReleaseButton(index)
    SKIN:Bang('!SetOption', 'ListLaunchText' .. index, 'FontColor', '#TextColor#')
    SKIN:Bang('!UpdateMeter', 'ListLaunchText' .. index)

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
    len = math.ceil(#ITEM / 5)

    if (vector < 0 and SCROLL_AMOUNT <= 0) then
        return -1
    elseif (vector > 0 and SCROLL_AMOUNT > (len - BUFFER)) then
        return -1
    end

    SCROLL_AMOUNT = math.max(math.min((SCROLL_AMOUNT + vector), (len - BUFFER)), 0)
    hideExcess()

    return SCROLL_AMOUNT
end