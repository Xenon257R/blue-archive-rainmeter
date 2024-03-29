-- Script to handle grid building.
local JSON, DATA, CELL
local CELL_SIZE, GAP_SIZE
local SUCCESS = false

local SPEC_CLASSES = { version = { used = false, w = 5, h = 2, group = 'VersionGroup' }, resources = { used = false, w = 4, h = 4, group = 'ResourceGroup' } }

-- Tokenizes dimension string [x,y,w,h] into Lua table
-- CITATION: https://stackoverflow.com/questions/1426954/split-string-in-lua
local function tokenize(inputstr, sep)
    if sep == nil then
            sep = "%s"
    end
    local t={}
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
            table.insert(t, str)
    end
    return t
end

-- Calculates pixel length including the gap in between grid cells
local function paddedLength(i)
    i = tonumber(i)
    return '(' .. (CELL_SIZE * i) + (GAP_SIZE * (i - 1)) .. '*#GScale#)'
end

-- Constructs the base template of an element cell
local function base(v, i, t)
    local int = i
    if i == 1 then int = '' end
    local rect = paddedLength(t[1]) .. ',' .. paddedLength(t[2]) .. ',' .. paddedLength(t[3]) .. ',' .. paddedLength(t[4]) .. ',#Edgeround#'

    SKIN:Bang('!SetOption', 'BackdropGrid', 'Shape' .. int, 'Rectangle' .. rect .. ' | Fill Color #TrayColor# | StrokeWidth 0')
    SKIN:Bang('!SetOption', 'BackdropGridShadow', 'Shape' .. int, 'Rectangle' .. rect .. ' | Fill Color #ShadowColor# | StrokeWidth 0')
    SKIN:Bang('!SetOption', 'ShineGrid', 'Shape' .. int, 'Rectangle' .. rect .. ' | Fill LinearGradient GradientValue | StrokeWidth 0')

    -- NOTE: This math was trial and error. I have ZERO clue why this is the way it is.
    SKIN:Bang('!SetOption', 'ImageContainer' .. i, 'Shape', 'Rectangle (' .. paddedLength(1) .. '*(1+#Leg#)),0,' .. paddedLength(t[3]) .. ',' .. paddedLength(t[4]) .. ',#Edgeround# | Fill Color 0,0,0,255 | StrokeWidth 0 | Skew #FullSkew#')
    SKIN:Bang('!SetOption', 'ImageContainer' .. i, 'X', '(' .. paddedLength(t[1]) .. '+#ListX#+(((960*#GScale#)-#GridSize#)*0.5)+((' .. paddedLength(t[2] + (t[4] / 2)) .. ')*#Leg#*-1)-(' .. paddedLength(1) .. '*(1+#Leg#)))')
    SKIN:Bang('!SetOption', 'ImageContainer' .. i, 'Y', '(' .. paddedLength(t[2]) .. '+#ListY#)')

    SKIN:Bang('!SetOption', 'Hitbox' .. i, 'Shape', 'Rectangle 0,0,' .. paddedLength(t[3]) .. ',' .. paddedLength(t[4]) .. ' | #Hitbox# | Skew #FullSkew#')
    SKIN:Bang('!SetOption', 'Hitbox' .. i, 'X', '(' .. paddedLength(t[1]) .. '+#ListX#+(((960*#GScale#)-#GridSize#)*0.5)+((' .. paddedLength(t[2] + (t[4] / 2)) .. ')*#Leg#*-1))')
    SKIN:Bang('!SetOption', 'Hitbox' .. i, 'Y', '(' .. paddedLength(t[2]) .. '+#ListY#)')

    SKIN:Bang('!SetOption', 'Name' .. i, 'Text', v.name)
    SKIN:Bang('!SetOption', 'Name' .. i, 'X', '(' .. paddedLength(t[1]) .. '+#ListX#)')
    SKIN:Bang('!SetOption', 'Name' .. i, 'Y', '(' .. paddedLength(t[2]) .. '+#ListY#)')
    SKIN:Bang('!SetOption', 'Name' .. i, 'W', '(' .. paddedLength(t[3]) .. '-(20*#GScale#))')

    SKIN:Bang('!SetOption', 'Decal' .. i, 'H', paddedLength(t[4]))

    SKIN:Bang('!SetOption', 'Image' .. i, 'ImageName', '#@#assets\\largebuttons\\' .. v.image)
    SKIN:Bang('!SetOption', 'Image' .. i, 'W', '(' .. paddedLength(t[3]) .. '+(' .. paddedLength(1) .. '*2*(1+#Leg#)))')
    SKIN:Bang('!SetOption', 'Image' .. i, 'H', paddedLength(t[4]))

    SUCCESS = true
    return 0
end

-- Constructs special class 1: Version Checker
local function specClass1(i, _)
    SKIN:Bang('!SetOption', 'VersionSubtext', 'X', '([Name' .. i ..':X]+(10*#GScale#))')
    SKIN:Bang('!SetOption', 'VersionSubtext', 'Y', '([Name' .. i ..':YH])')

    return 0
end

-- Constructs special class 2: Resource Monitor
local function specClass2(i, t)
    SKIN:Bang('!SetVariable', 'ResourceWidth', '(' .. paddedLength(t[3]) .. '-(20*#GScale#))')
    SKIN:Bang('!SetOption', 'ResourceName1', 'X', '([Name' .. i ..':X]+(10*#GScale#))')
    SKIN:Bang('!SetOption', 'ResourceName1', 'Y', '([Name' .. i ..':YH]+(10*#GScale#))')

    return 1
end

-- Identifies the dimensions of the parameters to check for overflow
local function checkDimensions(t, class)
    if ((tonumber(t[1]) + tonumber(t[3])) > 12) or ((tonumber(t[2]) + tonumber(t[4])) > 12) then
        print("Provided dimensions spill outside the 12x12 bounds. Reposition the cell or reduce its size.")
        return false
    end

    if class and (tonumber(t[3]) < SPEC_CLASSES[class].w or tonumber(t[4]) < SPEC_CLASSES[class].h) then
        print("Provided dimensions too small for special class [" .. class .. "]. Minimum dimensions: [" .. SPEC_CLASSES[class].w .. ", " .. SPEC_CLASSES[class].h .. "].")
        return false
    end

    return true
end

-- Constructs the full cell grid
local function buildGrid(griddata)
    local i = 1
    for _, v in pairs(griddata) do
        local t = tokenize(v.dimensions, ',')

        if checkDimensions(t) then base(v, i, t) end

        if (v.class == 'version' and not SPEC_CLASSES['version'].used) then
            if (checkDimensions(t, 'version')) then
                SPEC_CLASSES['version'].used = true
                v.execution = 'https://github.com/Xenon257R/blue-archive-rainmeter/releases'
                specClass1(i, t)
            end
        end

        if (v.class == 'resources' and not SPEC_CLASSES['resources'].used) then
            if (checkDimensions(t, 'resources')) then
                SPEC_CLASSES['resources'].used = true
                v.execution = ''
                specClass2(i, t)
            end
        end

        i = i + 1
    end
    SKIN:Bang('!Redraw')

    for _, v in pairs(SPEC_CLASSES) do
        if v.used then
            SKIN:Bang('!UpdateMeterGroup', v.group)
            SKIN:Bang('!ShowMeterGroup', v.group)
        end
    end
end

function Initialize()
    JSON = dofile(SKIN:GetVariable('@') .. 'lua\\lib\\jsonhandler.lua')

    DATA = JSON.readFile(SKIN:GetVariable('@') .. 'json\\aronagrid.json')
    CELL = JSON.filterEnabled(DATA.data, 12, "Only 12 cells have been reserved for rendering.")

    CELL_SIZE = SKIN:GetVariable('CellSize', 0)
    GAP_SIZE = SKIN:GetVariable('GapSize', 0)

    buildGrid(CELL)

    if (not SUCCESS) then
        buildGrid({ { enable = true, name = "Empty/Faulty Grid - Placeholder cell to allow access to Context Menu for 'Edit Database'", dimensions = '0,0,12,12', image = 'BG_CS_Arona2_03.jpg' , class = '', execution = '!Manage' } })
        SUCCESS = false
    end

    return 1
end

-- Emulates appropriate functions when button is pressed
function PressButton(index)
    SKIN:Bang('!SetOption', 'Name' .. index, 'FontColor', '#HighlightColor#')
    SKIN:Bang('!UpdateMeter', 'Name' .. index)
    SKIN:Bang('!Redraw')

    return 1
end

-- Emulates appropriate functions when button is released
function ReleaseButton(index)
    SKIN:Bang('!SetOption', 'Name' .. index, 'FontColor', '#TextColor#')
    SKIN:Bang('!UpdateMeter', 'Name' .. index)
    SKIN:Bang('!Redraw')

    return 1
end

-- Displays the available update version, but only when the special [version] class is used
function DisplayUpdate()
    if SPEC_CLASSES['version'].used then
        SKIN:Bang('!ShowMeterGroup', 'UpdateGroup')
        SKIN:Bang('!UpdateMeterGroup', 'UpdateGroup')
    end

    return 1
end

-- Executes the specified path
function Execute(index)
    if not SUCCESS then return '[!Manage]' end
    index = tonumber(index)

    if index > #CELL then return '' end

    return '[' .. CELL[index].execution .. ']'
end