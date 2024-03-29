-- Script to handle search dungeon list.
local JSON, DATA, DUNGEON
local STARTUP_EASE_ORDER = {
    { 'S_H', 1.0 }, { 'S_H', 0.9 }, { 'S_H', 0.8 }, { 'S_H', 0.7 }, { 'S_H', 0.6 }, { 'S_H', 0.5 }, { 'S_H', 0.4 }, { 'S_H', 0.3 }, { 'S_H', 0.2 }, { 'S_H', 0.1 }, { 'S_H', 0.0 },
    { 'S_L', 0.0 }, { 'S_L', 0.1 }, { 'S_L', 0.2 }, { 'S_L', 0.3 }, { 'S_L', 0.4 }, { 'S_L', 0.5 }, { 'S_L', 0.6 }, { 'S_L', 0.7 }, { 'S_L', 0.8 }, { 'S_L', 0.9 }, { 'S_L', 1.0 }
}
CURRENT_STARTUP = 1

-- CITATION :https://stackoverflow.com/questions/13462001/ease-in-and-ease-out-animation-formula
local function ParametericBlend(t)
    local sqt = t * t;
    return sqt / (2.0 * (sqt - t) + 1.0)
end

function Initialize()
    JSON = dofile(SKIN:GetVariable('@') .. 'lua\\lib\\jsonhandler.lua')

    DATA = JSON.readFile(SKIN:GetVariable('@') .. 'json\\dungeonlist.json')
    DUNGEON = JSON.filterEnabled(DATA.data, 3)

    for i = (#DUNGEON + 1), 3, 1 do
        SKIN:Bang('!HideMeter', 'Base' .. i)
        SKIN:Bang('!HideMeter', 'ImageContainer' .. i)
        SKIN:Bang('!HideMeter', 'Image' .. i)
        SKIN:Bang('!HideMeter', 'Shine' .. i)
        SKIN:Bang('!HideMeter', 'Ribbon' .. i)
        SKIN:Bang('!HideMeter', 'SearchIcon' .. i)
        SKIN:Bang('!HideMeter', 'ListText' .. i)
        SKIN:Bang('!HideMeter', 'ListSearchText' .. i)
        SKIN:Bang('!HideMeter', 'RibbonText' .. i)
        SKIN:Bang('!HideMeter', 'InputHitbox' .. i)
    end

    return 1
end

-- Returns the name of the entry
function GetName(index)
    index = tonumber(index)
    if (index > #DUNGEON) then return '' end

    return DUNGEON[index].name
end

-- Returns the image of the entry
function GetImage(index)
    index = tonumber(index)
    if (index > #DUNGEON or DUNGEON[index].image == '') then return 'google.png' end

    return DUNGEON[index].image
end

-- Returns the description of the entry
function GetDescription(index)
    index = tonumber(index)
    if (index > #DUNGEON) then return '' end

    return DUNGEON[index].description
end

-- Returns the last searched value of the entry
-- NOTE: This value is never written from the .json and is a temporary value discard on unload
function GetLastSearch(index)
    index = tonumber(index)
    if (index > #DUNGEON or not DUNGEON[index].last_search) then return '' end

    return DUNGEON[index].last_search
end

-- Searches the passed parameter value in the specified element's search pattern
function Search(index, param)
    index = tonumber(index)
    if (index > #DUNGEON or param == '' or not param) then return '' end

    DUNGEON[index].last_search = param
    SKIN:Bang('!UpdateMeter', 'RibbonText' .. index)
    SKIN:Bang('!Redraw')

    if not param or param == '' then return '' end

    return string.gsub(DUNGEON[index].base_url, "%%x", string.gsub(param, " ", "+") or param)
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