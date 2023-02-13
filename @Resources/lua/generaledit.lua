local function generateDefault()
    return {
        name = "<untl>",
        HighlightColor = "50,201,255,255",
        BrightHighlightColor = "80,255,255,255",
        PopUpColor = "21,64,101,222",
        BannerColor = "19,52,83,255",
        PopUpTextColor = "255,255,255,255",
        HeaderTextColor = "255,255,255,255",
        C1 = "22,147,222,255",
        C2 = "39,203,252,255",
        C3 = "167,248,255,255",
        C4 = "255,255,255,255",
        C5 = "47,80,109,255",
        C6 = "255,255,255,255",
        C7 = "47,80,109,255",
        C8 = "247,168,187,255",
        CharmBorderColor = "110,25,67,255",
        StopColor = "239,64,67,255",
        StopBorderColor = "100,10,10,255",
        OffColor = "122,122,122,255",
        OffBorderColor = "61,61,61,255",
        AudioShadowColor = "120,140,185,200",
        WealthColor = "237,203,60,255",
        TrayColor = "255,255,255,222",
        InsetColor = "44,76,115,255",
        BarColor1 = "131,213,243,255",
        ShadowColor = "0,0,0,66",
        BarColor2 = "255,255,255,255",
        TextColor = "32,60,93,255",
        PrimaryFont="Noto Sans",
        SecondaryFont="RSU",
        PopUpCap="Round",
        SkewX="-10",
        Roundness="5",
        ShadowAngle="45"
    }
end

local function parseImport(importString)
    local tokens = {}
    local newdata = {}
    local keytable = {
        a = "C1",
        b = "C2",
        c = "C3",
        d = "C4",
        e = "C5",
        f = "C6",
        g = "C7",
        h = "C8",
        i = "HighlightColor",
        j = "BrightHighlightColor",
        k = "PopUpColor",
        l = "BannerColor",
        m = "PopUpTextColor",
        n = "HeaderTextColor",
        o = "CharmBorderColor",
        p = "StopColor",
        q = "StopBorderColor",
        r = "OffColor",
        s = "OffBorderColor",
        t = "AudioShadowColor",
        u = "WealthColor",
        v = "TrayColor",
        w = "InsetColor",
        x = "BarColor1",
        y = "ShadowColor",
        z = "BarColor2",
        A = "TextColor",
        B = "PrimaryFont",
        C = "SecondaryFont",
        D = "PopUpCap",
        E = "SkewX",
        F = "Roundness",
        G = "ShadowAngle"
    }

    for x in string.gmatch(importString, "(.-)&") do
        table.insert(tokens, x)
    end

    local newscheme = generateDefault()

    newscheme.name = tokens[1] or '<impt>'

    for i = 1, string.len(tokens[2]), 9 do
        local higherdelim = string.sub(tokens[2], i, i + 8)
        local hexnum = string.sub(higherdelim, 2, -1)
        newscheme[keytable[string.sub(higherdelim, 1, 1)]] = tonumber("0x".. hexnum:sub(1,2)) .. ',' .. tonumber("0x".. hexnum:sub(3,4)) .. ',' .. tonumber("0x".. hexnum:sub(5,6))  .. ',' .. tonumber("0x".. hexnum:sub(7,8))
    end

    for i = 3, 8 do
        newscheme[keytable[string.sub(tokens[i], 1, 1)]] = string.gsub(string.sub(tokens[i], 2, -1), '_', ' ')
    end

    return newscheme
end

local function round(num, numDecimalPlaces)
    local mult = 10^(numDecimalPlaces or 0)
    return math.floor(num * mult + 0.5) / mult
  end  

-- CITATION: https://math.stackexchange.com/questions/4039873/given-a-point-on-a-circle-find-it-on-a-given-square
-- NOTE: the output offset is akin to the unit circle projected outwards onto a "unit square"
local function generateOffsets(angle)
    local x, y = 0, 0
    -- unique angle where it is assumed to be "no shadow"
    if angle == 0 then return x, y end

    if (angle < 45 or (angle > 135 and angle < 225) or angle >= 315) then
        x = 1
        y = math.abs(round(math.tan(math.rad(angle)), 2))
    else
        x = math.abs(round(math.cos(math.rad(angle)) / math.sin(math.rad(angle)), 2))
        y = 1
    end

    if (angle >= 90 and angle <= 270) then x = -x end
    if (angle <= 180) then y = -y end

    return x, y
end

function Initialize()
    COLOR = dofile(SKIN:GetVariable('@') .. 'lua/lib/color.lua')
    JSON = dofile(SKIN:GetVariable('@') .. 'lua/lib/jsonhandler.lua')

    DEFAULT_HIGHLIGHT_COLOR = SKIN:GetVariable('HighlightColor')

    DATA = JSON.readFile(SKIN:GetVariable('@') .. 'json/presets.json')

    CURRENT = {
        header = { { name = "Banner", var = "BannerColor" }, { name = "Header Text", var = "HeaderTextColor" }, { name = "Inset", var = "InsetColor" }, { name = "Highlight", var = "BrightHighlightColor" }, { name = "Full Highlight", var = "WealthColor" } },
        visualizer = { { name = "Primary Color", var = "BarColor1" }, { name = "Fade Color", var = "BarColor2" }, { name = "Shadow", var = "AudioShadowColor" } },
        color = { { name = "Top", var = "C1" }, { name = "Middle", var = "C2" }, { name = "Bottom", var = "C3" }, { name = "Extraneous", var = "C4" }, { name = "Inner Border", var = "C5" }, { name = "Outer Border", var = "C6" }, { name = "Shadow", var = "C7" } },
        tray = { { name = "Tray", var = "TrayColor" }, { name = "Shadow", var = "ShadowColor" }, { name = "Text", var = "TextColor" } },
        extras = { { name = "Charm Color", var = "C8" }, { name = "Charm Border", var = "CharmBorderColor" }, { name = "Stop Color", var = "StopColor" }, { name = "Stop Border", var = "StopBorderColor" }, { name = "Off Color", var = "OffColor" }, { name = "Off Border", var = "OffBorderColor" } },
        popup = { { name = "Background", var = "PopUpColor" }, { name = "Text", var = "PopUpTextColor" }, { name = "Highlighted Text", var = "HighlightColor" } },
        style = { { name = "Primary Font", var = "PrimaryFont" }, { name = "Secondary Font", var = "SecondaryFont" }, { name = "Popup Edge", var = "PopUpCap" }, { name = "Skew", var = "SkewX" }, { name = "Roundness", var = "Roundness" }, { name = "Shadow Angle" , var = "ShadowAngle" } }
    }

    SELECTION = "header"
    PRESET_SELECTION = 0
    COLOR_SELECTION = 1
    INDEX_LIST = { size = table.getn(DATA.presets), buffer = 5, pointer = 0 }

    for k, v in pairs(CURRENT) do
        for k2, v2 in ipairs(v) do
            if k == "style" then
                CURRENT[k][k2].value = SKIN:GetVariable(v2.var) or "<empty>"
            else
                CURRENT[k][k2].value = COLOR.new(SKIN:GetVariable(v2.var))
            end
        end
    end

    return 0
end

function GetSelectedNumber()
    return PRESET_SELECTION
end

function GetTotalEntries()
    return INDEX_LIST.size
end

function IsSelection(sel)
    if SELECTION == sel then return 1 end

    return 0
end

-- Returns if the specified index is the active preset selection
-- NOTE: the returned value is an [rgba] string
function GetHighlight(index)
    if index + INDEX_LIST.pointer == PRESET_SELECTION then
        return DEFAULT_HIGHLIGHT_COLOR
    end

    return '0,0,0,0'
end

-- Returns if the specified index is the active color element
-- NOTE: the returned value is a numeric boolean
function IsSelected(index)
    return tonumber(index) == COLOR_SELECTION and 1 or 0
end

-- Returns the name of the label at the specified index according to the current type selection
function GetLabel(index)
    if not CURRENT[SELECTION][tonumber(index)] then return '-----' end

    return CURRENT[SELECTION][tonumber(index)].name or '-----'
end

-- Returns the name of the preset at the specified index
function GetPresetName(index)
    if PRESET_SELECTION == 0 and not index then return '' end

    if not index then index = PRESET_SELECTION else index = tonumber(index) + INDEX_LIST.pointer end
    
    if index > INDEX_LIST.size then return '' end

    return DATA.presets[index].name
end

-- Sets the name of the prest to the new [newname] value
function SetPresetName(newname)
    if PRESET_SELECTION <= 0 or PRESET_SELECTION > INDEX_LIST.size then return -1 end

    DATA.presets[PRESET_SELECTION].name = newname

    SKIN:Bang('!UpdateMeterGroup', 'EditGroup')

    return 0
end

function GetValues(typestring, index)
    index = tonumber(index) or COLOR_SELECTION
    if not CURRENT[SELECTION][index] then
        local zeroes = {}
        for str in string.gmatch(typestring, "([^%s])") do
           table.insert(zeroes, 0)
        end

        return table.concat(zeroes, ',')
    end

    -- NOTE: An extremely strange bug exists where DefaultValue cannot seem to pass non-numeric arguments
    local typetable = {}
    local num_table = { ['1'] = 'r', ['2'] = 'g', ['3'] = 'b', ['4'] = 'h', ['5'] = 's', ['6'] = 'v', ['7'] = 'a', ['8'] = 'x', r = 'r', g = 'g', b = 'b', h = 'h', s = 's', v = 'v', a = 'a', x = 'x' }

    for str in string.gmatch(typestring, "([^%s])") do
       table.insert(typetable, num_table[str])
    end

    return CURRENT[SELECTION][index].value:getValues(typetable)
end

function GetStyleValue(index)
    return CURRENT["style"][tonumber(index)].value
end

function GetBaseColor()
    local red, green, blue = CURRENT[SELECTION][COLOR_SELECTION].value:getBase()
    return red .. "," .. green .. "," .. blue .. ",255" 
end

function SetVariableGroup(val)
    SELECTION = val
    COLOR_SELECTION = 1
    SKIN:Bang('!UpdateMeterGroup', 'EditGroup')
    
    return 0
end

function SetColorSelection(val)
    if not CURRENT[SELECTION][tonumber(val)] then return -1 end

    COLOR_SELECTION = tonumber(val)
    SKIN:Bang('!UpdateMeterGroup', 'EditGroup')

    return 0
end

function SetValue(value, modifier, colortype)
    if not CURRENT[SELECTION][COLOR_SELECTION] then return -1 end

    CURRENT[SELECTION][COLOR_SELECTION].value:setValue(value, tonumber(modifier), colortype)

    if PRESET_SELECTION > 0 then DATA.presets[PRESET_SELECTION][CURRENT[SELECTION][COLOR_SELECTION].var] = CURRENT[SELECTION][COLOR_SELECTION].value:getValues({ "r", "g", "b", "a" }) end

    SKIN:Bang('!SetVariable', CURRENT[SELECTION][COLOR_SELECTION].var, CURRENT[SELECTION][COLOR_SELECTION].value:getValues({ "r", "g", "b", "a" }))
    SKIN:Bang('!UpdateMeterGroup', 'PreviewGroup')

    return 0
end

function SetStyleValue(value, index, increment)
    local limits = { { 0, 0 }, { 0, 0 }, { 0, 0 }, { -35, 35 }, { 0, 20 }, { 0, 360 }  }

    if increment and value then
        CURRENT["style"][tonumber(index)].value = CURRENT["style"][tonumber(index)].value + value
    else
        CURRENT["style"][tonumber(index)].value = value or CURRENT["style"][tonumber(index)].value
    end

    -- numeric values
    if index >= 4 then CURRENT["style"][tonumber(index)].value = math.min(math.max(CURRENT["style"][tonumber(index)].value, limits[index][1]), limits[index][2]) end

    if PRESET_SELECTION > 0 then DATA.presets[PRESET_SELECTION][CURRENT["style"][tonumber(index)].var] = tostring(CURRENT["style"][tonumber(index)].value) end

    SKIN:Bang('!SetVariable', CURRENT["style"][tonumber(index)].var, CURRENT["style"][tonumber(index)].value)

    -- angle calculation
    if index == 6 then
        local x, y = generateOffsets(CURRENT["style"][tonumber(index)].value)
        print("Offsets: " .. x .. ", " .. y)
        SKIN:Bang('!SetVariable', 'ShadowX', x)
        SKIN:Bang('!SetVariable', 'ShadowY', y)
    end

    SKIN:Bang('!UpdateMeterGroup', 'PreviewGroup')

    return CURRENT["style"][tonumber(index)].value
end

function LoadPreset()
    local preset_list = DATA.presets[PRESET_SELECTION]

    for k, v in pairs(CURRENT) do
        for k2, v2 in ipairs(v) do
            if k == "style" then
                CURRENT[k][k2].value = preset_list[v2.var] or "<empty>"
                SKIN:Bang('!SetVariable', CURRENT[k][k2].var, CURRENT[k][k2].value)
            else
                if not preset_list[v2.var] then
                    preset_list[v2.var] = "0,0,0,0"
                end

                CURRENT[k][k2].value:setAll(preset_list[v2.var])
                SKIN:Bang('!SetVariable', CURRENT[k][k2].var, CURRENT[k][k2].value:getValues({ "r", "g", "b", "a" }))
            end
        end
    end

    SKIN:Bang('!UpdateMeterGroup', 'EditGroup')
    SKIN:Bang('!UpdateMeterGroup', 'PreviewGroup')

    return 0
end

function SelectPreset(y)
    local newSelection = math.floor(tonumber(y / 100) * INDEX_LIST.buffer) + 1 + INDEX_LIST.pointer
    if newSelection <= 0 or newSelection > INDEX_LIST.size then return -1 end

    PRESET_SELECTION = newSelection
    LoadPreset()
    SKIN:Bang('!UpdateMeterGroup', 'EditGroup')
    return 1
end

function AddPreset(newvalues)
    local default = newvalues or generateDefault()

    table.insert(DATA.presets, default)

    INDEX_LIST.size = INDEX_LIST.size + 1

    SKIN:Bang('!UpdateMeterGroup', 'EditGroup')
    SKIN:Bang('!UpdateMeterGroup', 'PreviewGroup')

    return 0
end

function RemovePreset()
    if PRESET_SELECTION <= 0 or PRESET_SELECTION > INDEX_LIST.size then return -1 end

    if PRESET_SELECTION == 1 then return 0 end

    table.remove(DATA.presets, PRESET_SELECTION)
    
    INDEX_LIST.size = INDEX_LIST.size - 1
    PRESET_SELECTION = math.max(PRESET_SELECTION - 1, 1)
    LoadPreset()

    SKIN:Bang('!UpdateMeterGroup', 'EditGroup')
    SKIN:Bang('!UpdateMeterGroup', 'PreviewGroup')

    return 0
end

function Scroll(num)
    INDEX_LIST.pointer = math.max(math.min(INDEX_LIST.pointer + tonumber(num), INDEX_LIST.size - INDEX_LIST.buffer), 0)

    SKIN:Bang('!UpdateMeterGroup', 'EditGroup')
    return INDEX_LIST.pointer
end

function SaveChanges()
    if PRESET_SELECTION <= 0 or PRESET_SELECTION > INDEX_LIST.size then return -1 end

    JSON.writeFile(SKIN:GetVariable('@') .. 'json/presets.json', DATA)

    SKIN:Bang('!UpdateMeterGroup', 'EditGroup')
    SKIN:Bang('!UpdateMeterGroup', 'PreviewGroup')

    return 0
end

function ApplyChanges()
    for k, v in pairs(CURRENT) do
        for k2, v2 in ipairs(v) do
            if k == "style" then
                SKIN:Bang('!WriteKeyValue', 'Variables', v2.var, v2.value, SKIN:GetVariable('@') .. 'config.inc')
                if v2.var == "ShadowAngle" then
                    local x, y = generateOffsets(v2.value)
                    SKIN:Bang('!WriteKeyValue', 'Variables', "ShadowX", x, SKIN:GetVariable('@') .. 'config.inc')
                    SKIN:Bang('!WriteKeyValue', 'Variables', "ShadowY", y, SKIN:GetVariable('@') .. 'config.inc')
                end
            else
                SKIN:Bang('!WriteKeyValue', 'Variables', v2.var, v2.value:getValues({ "r", "g", "b", "a" }), SKIN:GetVariable('@') .. 'config.inc')
            end
        end
    end

    SKIN:Bang('!Refresh', '*')

    return 0
end

function ExportPreset()
    local delim = "&"
    local keytable = {
        C1 = "a",
        C2 = "b",
        C3 = "c",
        C4 = "d",
        C5 = "e",
        C6 = "f",
        C7 = "g",
        C8 = "h",
        HighlightColor = "i",
        BrightHighlightColor = "j",
        PopUpColor = "k",
        BannerColor = "l",
        PopUpTextColor = "m",
        HeaderTextColor = "n",
        CharmBorderColor = "o",
        StopColor = "p",
        StopBorderColor = "q",
        OffColor = "r",
        OffBorderColor = "s",
        AudioShadowColor = "t",
        WealthColor = "u",
        TrayColor = "v",
        InsetColor = "w",
        BarColor1 = "x",
        ShadowColor = "y",
        BarColor2 = "z",
        TextColor = "A",
        PrimaryFont = "B",
        SecondaryFont = "C",
        PopUpCap = "D",
        SkewX = "E",
        Roundness = "F",
        ShadowAngle = "G"
    }
    local presetString = GetPresetName() .. delim
    local styleString = ""

    for k, v in pairs(CURRENT) do
        if k ~= "style" then
            for k2, v2 in ipairs(v) do
                presetString = presetString .. keytable[v2.var] .. v2.value:getValues({ "x" }) .. string.format("%x", v2.value:getValues({ "a" }))
            end
        end
    end
    presetString = presetString .. delim

    for k, v in ipairs(CURRENT.style) do
        presetString = presetString .. keytable[v.var] .. v.value .. delim
    end

    presetString = string.gsub(presetString, " ", "_")
    return presetString
end

function ImportPreset(importString)
    local status, newvalues = pcall(parseImport, importString)

    if not status then
        print("Bad import.")
        return -1
    end

    AddPreset(newvalues)
    Scroll(INDEX_LIST.size)
    SelectPreset((math.min(INDEX_LIST.size, 5)* 20) - 1)

    return 1
end