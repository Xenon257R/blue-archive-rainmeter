-- Script to handle all styling adjustments for a non-programmer.
local COLOR, JSON

local DEFAULT_HIGHLIGHT_COLOR

local DATA

local CURRENT = {
    header = { { name = 'Banner', var = 'BannerColor' }, { name = 'Header Text', var = 'HeaderTextColor' }, { name = 'Inset', var = 'InsetColor' }, { name = 'Highlight', var = 'BrightHighlightColor' }, { name = 'Full Highlight', var = 'WealthColor' } },
    visualizer = { { name = 'Primary Color', var = 'BarColor1' }, { name = 'Fade Color', var = 'BarColor2' }, { name = 'Shadow', var = 'AudioShadowColor' } },
    color = { { name = 'Top', var = 'C1' }, { name = 'Middle', var = 'C2' }, { name = 'Bottom', var = 'C3' }, { name = 'Extraneous', var = 'C4' }, { name = 'Inner Border', var = 'C5' }, { name = 'Outer Border', var = 'C6' }, { name = 'Shadow', var = 'C7' } },
    tray = { { name = 'Tray', var = 'TrayColor' }, { name = 'Shadow', var = 'ShadowColor' }, { name = 'Text', var = 'TextColor' } },
    extras = { { name = 'Charm Color', var = 'C8' }, { name = 'Charm Border', var = 'CharmBorderColor' }, { name = 'Stop Color', var = 'StopColor' }, { name = 'Stop Border', var = 'StopBorderColor' }, { name = 'Off Color', var = 'OffColor' }, { name = 'Off Border', var = 'OffBorderColor' } },
    popup = { { name = 'Background', var = 'PopUpColor' }, { name = 'Text', var = 'PopUpTextColor' }, { name = 'Highlighted Text', var = 'HighlightColor' } },
    style = { { name = 'Primary Font', var = 'PrimaryFont' }, { name = 'Secondary Font', var = 'SecondaryFont' }, { name = 'Popup Edge', var = 'PopUpCap' }, { name = 'Skew', var = 'SkewX' }, { name = 'Roundness', var = 'Roundness' }, { name = 'Shadow Angle' , var = 'ShadowAngle' } }
}

local SELECTION = 'header'
local PRESET_SELECTION = 0
local COLOR_SELECTION = 1
local MADE_CHANGES = false
local WARN_BUFFER = 0

local INDEX_LIST

local TIP

-- creates and returns a default value table
local function GenerateDefault()
    return {
        name = "<untl>",
        HighlightColor = "50,201,255,255",
        BrightHighlightColor = "80,255,255,255",
        PopUpColor = "31,64,101,222",
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
        PrimaryFont= "Noto Sans",
        SecondaryFont= "Source Sans Pro",
        PopUpCap= "Round",
        SkewX= -10,
        Roundness= 5,
        ShadowAngle= 315
    }
end

-- parses an imported string into a data table
local function ParseImport(importString)
    importString = string.gsub(importString, '#', '-')
    importString = string.gsub(importString, '\\_', ' ')

    local tokens = {}
    local keytable = {
        a = 'C1',
        b = 'C2',
        c = 'C3',
        d = 'C4',
        e = 'C5',
        f = 'C6',
        g = 'C7',
        h = 'C8',
        i = 'HighlightColor',
        j = 'BrightHighlightColor',
        k = 'PopUpColor',
        l = 'BannerColor',
        m = 'PopUpTextColor',
        n = 'HeaderTextColor',
        o = 'CharmBorderColor',
        p = 'StopColor',
        q = 'StopBorderColor',
        r = 'OffColor',
        s = 'OffBorderColor',
        t = 'AudioShadowColor',
        u = 'WealthColor',
        v = 'TrayColor',
        w = 'InsetColor',
        x = 'BarColor1',
        y = 'ShadowColor',
        z = 'BarColor2',
        A = 'TextColor',
        B = 'PrimaryFont',
        C = 'SecondaryFont',
        D = 'PopUpCap',
        E = 'SkewX',
        F = 'Roundness',
        G = 'ShadowAngle'
    }

    -- tokenize string
    for x in string.gmatch(importString, '(.-)&') do
        table.insert(tokens, x)
    end

    -- creates a default template to build on
    local newscheme = GenerateDefault()

    -- extracts then name - if non-existsent, place '<impt>' instead
    newscheme.name = tokens[1]
    if newscheme.name == '' then newscheme.name = '<impt>' end

    -- extracts the colors
    for i = 1, string.len(tokens[2]), 9 do
        local higherdelim = string.sub(tokens[2], i, i + 8)
        local hexnum = string.sub(higherdelim, 2, -1)
        newscheme[keytable[string.sub(higherdelim, 1, 1)]] = tonumber('0x'.. hexnum:sub(1,2)) .. ',' .. tonumber('0x'.. hexnum:sub(3,4)) .. ',' .. tonumber('0x'.. hexnum:sub(5,6))  .. ',' .. tonumber('0x'.. hexnum:sub(7,8))
    end

    -- extracts the font and pop up cap style values
    for i = 3, #tokens, 1 do
        newscheme[keytable[string.sub(tokens[i], 1, 1)]] = string.sub(tokens[i], 2, -1)
    end

    -- clamps bad values
    newscheme[keytable.E] = math.min(math.max(newscheme[keytable.E], -20), 20)
    newscheme[keytable.F] = math.min(math.max(newscheme[keytable.F], 0), 20)
    newscheme[keytable.G] = math.min(math.max(newscheme[keytable.G], 0), 360)

    return newscheme
end

-- rounds [num] to a specified number of decimal places
local function Round(num, numDecimalPlaces)
    local mult = 10^(numDecimalPlaces or 0)
    return math.floor(num * mult + 0.5) / mult
end

-- CITATION: https://math.stackexchange.com/questions/4039873/given-a-point-on-a-circle-find-it-on-a-given-square
-- NOTE: the output offset is akin to the unit circle projected outwards onto a "unit square"
local function GenerateOffsets(angle)
    local x, y = 0, 0

    -- unique angle where it is assumed to be "no shadow"
    if angle == 0 then return x, y end

    -- generate unit circle point projected onto square
    if (angle < 45 or (angle > 135 and angle < 225) or angle >= 315) then
        x = 1
        y = math.abs(Round(math.tan(math.rad(angle)), 2))
    else
        x = math.abs(Round(math.cos(math.rad(angle)) / math.sin(math.rad(angle)), 2))
        y = 1
    end

    -- corrects inverted (co)tangent values
    if (angle >= 90 and angle <= 270) then x = -x end
    if (angle <= 180) then y = -y end

    return x, y
end

function Initialize()
    COLOR = dofile(SKIN:GetVariable('@') .. 'lua\\lib\\color.lua')
    JSON = dofile(SKIN:GetVariable('@') .. 'lua\\lib\\jsonhandler.lua')

    DEFAULT_HIGHLIGHT_COLOR = SKIN:GetVariable('HighlightColor')

    DATA = JSON.readFile(SKIN:GetVariable('@') .. 'json\\presets.json')

    INDEX_LIST = { size = #DATA.presets, buffer = 5, pointer = 0 }

    TIP = #DATA.tips

    for k, v in pairs(CURRENT) do
        for k2, v2 in ipairs(v) do
            if k == 'style' then
                CURRENT[k][k2].value = SKIN:GetVariable(v2.var) or '<empty>'
            else
                CURRENT[k][k2].value = COLOR.new(SKIN:GetVariable(v2.var))
            end
        end
    end

    return 0
end

-- generates a blurb text
function SetBlurb(text)
    SKIN:Bang('!SetOption', 'BlurbText', 'Text', text)
    SKIN:Bang('!UpdateMeter', 'BlurbText')

    if MADE_CHANGES then
        SKIN:Bang('!SetOption', 'ApplyPresetIcon', 'ImageTint', '#LockStopColor#')
        SKIN:Bang('!SetOption', 'SavePresetIcon', 'ImageTint', '#LockHighlightColor#')
    else
        SKIN:Bang('!SetOption', 'ApplyPresetIcon', 'ImageTint', '#LockFontColor#')
        SKIN:Bang('!SetOption', 'SavePresetIcon', 'ImageTint', '#LockFontColor#')
    end
    SKIN:Bang('!UpdateMeter', 'ApplyPresetIcon')
    SKIN:Bang('!UpdateMeter', 'SavePresetIcon')

    SKIN:Bang('!Redraw')

    return 1
end

-- returns the selected entry number
function GetSelectedNumber()
    return PRESET_SELECTION
end

-- returns the total number of entries
function GetTotalEntries()
    return INDEX_LIST.size
end

-- returns if [sel] matches the [SELECTION] value
function IsSelection(sel)
    if SELECTION == sel then return 1 end

    return 0
end

-- returns if the specified index is the active preset selection
-- NOTE: the returned value is an [rgba] string
function GetHighlight(index)
    if index + INDEX_LIST.pointer == PRESET_SELECTION then
        return DEFAULT_HIGHLIGHT_COLOR
    end

    return '0,0,0,0'
end

-- returns if the specified index is the active color element
-- NOTE: the returned value is a numeric boolean
function IsSelected(index)
    return tonumber(index) == COLOR_SELECTION and 1 or 0
end

-- returns the name of the label at the specified index according to the current type selection
function GetLabel(index)
    if not CURRENT[SELECTION][tonumber(index)] then return '-----' end

    return CURRENT[SELECTION][tonumber(index)].name or '-----'
end

-- returns the name of the preset at the specified index
function GetPresetName(index)
    if PRESET_SELECTION == 0 and not index then return '' end

    if not index then index = PRESET_SELECTION else index = tonumber(index) + INDEX_LIST.pointer end

    if index > INDEX_LIST.size then return '' end

    return DATA.presets[index].name
end

-- sets the name of the prest to the new [newName] value
function SetPresetName(newName)
    if PRESET_SELECTION <= 0 or PRESET_SELECTION > INDEX_LIST.size then return -1 end

    local oldName = DATA.presets[PRESET_SELECTION].name
    DATA.presets[PRESET_SELECTION].name = newName

    SKIN:Bang('!UpdateMeterGroup', 'EditGroup')

    SetBlurb('Changed preset name from [' .. oldName .. '] to [' .. newName .. '].')

    return oldName
end

-- get a string based on the passed [typestring] of the values in [index]
function GetValues(typestring, index)
    index = tonumber(index) or COLOR_SELECTION

    if not CURRENT[SELECTION][index] then
        local zeroes = {}
        for _ in string.gmatch(typestring, '([^%s])') do
           table.insert(zeroes, 0)
        end

        return table.concat(zeroes, ',')
    end

    -- NOTE: An extremely strange bug exists where DefaultValue cannot seem to pass non-numeric arguments
    local typetable = {}
    local num_table = { ['1'] = 'r', ['2'] = 'g', ['3'] = 'b', ['4'] = 'h', ['5'] = 's', ['6'] = 'v', ['7'] = 'a', ['8'] = 'x', r = 'r', g = 'g', b = 'b', h = 'h', s = 's', v = 'v', a = 'a', x = 'x' }

    for str in string.gmatch(typestring, '([^%s])') do
       table.insert(typetable, num_table[str])
    end

    return CURRENT[SELECTION][index].value:getValues(typetable)
end

-- get the style value in index or return whether the style value matches a specified [compare] parameter
-- NOTE: the [compare] alternative is primarily used for the Pop-Up Cap style
function GetStyleValue(index, compare)
    if compare then
        if CURRENT['style'][tonumber(index)].value == compare then
            return 1
        end

        return 0
    end

    return CURRENT['style'][tonumber(index)].value
end

-- returns a desaturated, devalued hue amount
-- NOTE: only used for the color plate
function GetBaseColor()
    local red, green, blue = CURRENT[SELECTION][COLOR_SELECTION].value:getBase()
    return red .. ',' .. green .. ',' .. blue .. ',255'
end

-- changes the selection group to [val]
function SetVariableGroup(val)
    SELECTION = val
    COLOR_SELECTION = 1
    SKIN:Bang('!UpdateMeterGroup', 'EditGroup')
    SKIN:Bang('!Redraw')

    return 0
end

-- changes the selected color to [val]
function SetColorSelection(val)
    if not CURRENT[SELECTION][tonumber(val)] then return -1 end

    COLOR_SELECTION = tonumber(val)
    SKIN:Bang('!UpdateMeterGroup', 'EditGroup')
    SKIN:Bang('!Redraw')

    return 0
end

-- sets currently selected color value's [colortype] to [value] multiplied by [modifier] and correct all other color values accordingly
function SetValue(value, modifier, colortype)
    if not CURRENT[SELECTION][COLOR_SELECTION] then return -1 end

    local oldValue = CURRENT[SELECTION][COLOR_SELECTION].value:getValues({ 'r', 'g', 'b', 'a' })
    CURRENT[SELECTION][COLOR_SELECTION].value:setValue(value, tonumber(modifier), colortype)

    if PRESET_SELECTION > 0 then DATA.presets[PRESET_SELECTION][CURRENT[SELECTION][COLOR_SELECTION].var] = CURRENT[SELECTION][COLOR_SELECTION].value:getValues({ 'r', 'g', 'b', 'a' }) end

    SKIN:Bang('!SetVariable', CURRENT[SELECTION][COLOR_SELECTION].var, CURRENT[SELECTION][COLOR_SELECTION].value:getValues({ 'r', 'g', 'b', 'a' }))
    SKIN:Bang('!UpdateMeterGroup', 'PreviewGroup')

    MADE_CHANGES = true
    SetBlurb(CURRENT[SELECTION][COLOR_SELECTION].name .. ' color changed from [' .. oldValue .. '] to [' .. CURRENT[SELECTION][COLOR_SELECTION].value:getValues({ 'r', 'g', 'b', 'a' }) .. '].')

    return 0
end

-- sets the currently selected style to [value]
-- if [increment] is not nil, instead increments the style by said [value]
function SetStyleValue(value, index, increment)
    local limits = { { 0, 0 }, { 0, 0 }, { 0, 0 }, { -20, 20 }, { 0, 20 }, { 0, 360 }  }
    local oldValue = CURRENT['style'][tonumber(index)].value

    if increment and value then
        CURRENT['style'][tonumber(index)].value = CURRENT['style'][tonumber(index)].value + value
    else
        CURRENT['style'][tonumber(index)].value = value or CURRENT['style'][tonumber(index)].value
    end

    -- numeric values
    if index >= 4 then CURRENT['style'][tonumber(index)].value = math.min(math.max(CURRENT['style'][tonumber(index)].value, limits[index][1]), limits[index][2]) end

    if PRESET_SELECTION > 0 then DATA.presets[PRESET_SELECTION][CURRENT['style'][tonumber(index)].var] = tostring(CURRENT['style'][tonumber(index)].value) end

    SKIN:Bang('!SetVariable', CURRENT['style'][tonumber(index)].var, CURRENT['style'][tonumber(index)].value)

    -- angle calculation
    if index == 6 then
        local x, y = GenerateOffsets(tonumber(CURRENT['style'][tonumber(index)].value))
        print('Offsets: ' .. x .. ', ' .. y)
        SKIN:Bang('!SetVariable', 'ShadowX', x)
        SKIN:Bang('!SetVariable', 'ShadowY', y)
    end

    MADE_CHANGES = true
    SetBlurb(CURRENT['style'][tonumber(index)].name .. ' changed from [' .. oldValue .. '] to [' .. CURRENT['style'][tonumber(index)].value .. '].')

    SKIN:Bang('!UpdateMeterGroup', 'PreviewGroup')
    SKIN:Bang('!Redraw')

    return CURRENT['style'][tonumber(index)].value
end

-- loads the selected preset
function LoadPreset()
    local preset_list = DATA.presets[PRESET_SELECTION] or GenerateDefault()

    for k, v in pairs(CURRENT) do
        for k2, v2 in ipairs(v) do
            if k == 'style' then
                CURRENT[k][k2].value = preset_list[v2.var] or '<empty>'
                SKIN:Bang('!SetVariable', CURRENT[k][k2].var, CURRENT[k][k2].value)
            else
                if not preset_list[v2.var] then
                    preset_list[v2.var] = '0,0,0,0'
                end

                CURRENT[k][k2].value:setAll(preset_list[v2.var])
                SKIN:Bang('!SetVariable', CURRENT[k][k2].var, CURRENT[k][k2].value:getValues({ 'r', 'g', 'b', 'a' }))
            end
        end
    end

    SKIN:Bang('!UpdateMeterGroup', 'EditGroup')
    SKIN:Bang('!UpdateMeterGroup', 'PreviewGroup')

    SetBlurb('Loaded [' .. preset_list.name .. '] preset.')

    return 0
end

-- selects preset [y]
function SelectPreset(y)
    local newSelection = math.floor(tonumber(y / 100) * INDEX_LIST.buffer) + 1 + INDEX_LIST.pointer
    if newSelection <= 0 or newSelection > INDEX_LIST.size then return -1 end

    PRESET_SELECTION = newSelection
    LoadPreset()

    return 1
end

-- adds a new preset at the end of the table and automatically selects it
function AddPreset(newvalues)
    local default = newvalues or GenerateDefault()

    table.insert(DATA.presets, default)

    INDEX_LIST.size = INDEX_LIST.size + 1
    Scroll(INDEX_LIST.size)
    SelectPreset((math.min(INDEX_LIST.size, 5)* 20) - 1)

    SKIN:Bang('!UpdateMeterGroup', 'EditGroup')
    SKIN:Bang('!UpdateMeterGroup', 'PreviewGroup')

    MADE_CHANGES = true
    SetBlurb('Created and selected new untitled default preset.')

    return 0
end

-- removes the selected preset and moves selection to the preset immediately before
function RemovePreset()
    if PRESET_SELECTION <= 0 or PRESET_SELECTION > INDEX_LIST.size then return -1 end
    local oldPreset = DATA.presets[PRESET_SELECTION].name

    table.remove(DATA.presets, PRESET_SELECTION)

    INDEX_LIST.size = INDEX_LIST.size - 1

    PRESET_SELECTION = math.max(PRESET_SELECTION - 1, 1)
    if INDEX_LIST.size == 0 then PRESET_SELECTION = 0 end

    LoadPreset()

    SKIN:Bang('!UpdateMeterGroup', 'EditGroup')
    SKIN:Bang('!UpdateMeterGroup', 'PreviewGroup')

    MADE_CHANGES = true
    SetBlurb('Deleted ' .. oldPreset .. ' preset.')

    return 0
end

-- scrolls the entry list in the vector of [num]
function Scroll(num)
    INDEX_LIST.pointer = math.max(math.min(INDEX_LIST.pointer + tonumber(num), INDEX_LIST.size - INDEX_LIST.buffer), 0)

    SKIN:Bang('!UpdateMeterGroup', 'EditGroup')
    SKIN:Bang('!Redraw')
    return INDEX_LIST.pointer
end

-- save all changes
function SaveChanges()
    JSON.writeFile(SKIN:GetVariable('@') .. 'json\\presets.json', DATA)

    SKIN:Bang('!UpdateMeterGroup', 'EditGroup')
    SKIN:Bang('!UpdateMeterGroup', 'PreviewGroup')

    MADE_CHANGES = false
    WARN_BUFFER = 0
    SetBlurb('Saved all changes!')

    return 0
end

-- apply currently selected style settings
function ApplyChanges()
    local msgtable = {
        'Changes you have made haven\'t been saved. Applying changes will refresh this skin, discarding all changes.',
        'Rainmeter makes it hard to refresh all skins BUT one. It is advised to save your changes before loading a preset.',
        'SAVE YOUR PRESETS. The button is highlighted and located to the right of the eyedropper tool.',
        '[!] You WILL lose unsaved changes. Are you sure about loading the preset now? [!]',
        '[!] Only the applied and previously saved presets can be recovered. This is your last warning! [!]'
    }
    if MADE_CHANGES and WARN_BUFFER < 5 then
        SetBlurb(msgtable[WARN_BUFFER + 1])

        WARN_BUFFER = WARN_BUFFER + 1
        return WARN_BUFFER
    end

    for k, v in pairs(CURRENT) do
        for _, v2 in ipairs(v) do
            if k == 'style' then
                SKIN:Bang('!WriteKeyValue', 'Variables', v2.var, v2.value, SKIN:GetVariable('@') .. 'user\\config.inc')
                if v2.var == 'ShadowAngle' then
                    local x, y = GenerateOffsets(tonumber(v2.value))
                    SKIN:Bang('!WriteKeyValue', 'Variables', 'ShadowX', x, SKIN:GetVariable('@') .. 'user\\config.inc')
                    SKIN:Bang('!WriteKeyValue', 'Variables', 'ShadowY', y, SKIN:GetVariable('@') .. 'user\\config.inc')
                end
            else
                SKIN:Bang('!WriteKeyValue', 'Variables', v2.var, v2.value:getValues({ 'r', 'g', 'b', 'a' }), SKIN:GetVariable('@') .. 'user\\config.inc')
            end
        end
    end

    SKIN:Bang('!Refresh', '*')

    return 0
end

-- returns an export-ready string of the selected style
function ExportPreset()
    local reserved = '[_#&]+'
    local delim = '&'
    local keytable = {
        C1 = 'a',
        C2 = 'b',
        C3 = 'c',
        C4 = 'd',
        C5 = 'e',
        C6 = 'f',
        C7 = 'g',
        C8 = 'h',
        HighlightColor = 'i',
        BrightHighlightColor = 'j',
        PopUpColor = 'k',
        BannerColor = 'l',
        PopUpTextColor = 'm',
        HeaderTextColor = 'n',
        CharmBorderColor = 'o',
        StopColor = 'p',
        StopBorderColor = 'q',
        OffColor = 'r',
        OffBorderColor = 's',
        AudioShadowColor = 't',
        WealthColor = 'u',
        TrayColor = 'v',
        InsetColor = 'w',
        BarColor1 = 'x',
        ShadowColor = 'y',
        BarColor2 = 'z',
        TextColor = 'A',
        PrimaryFont = 'B',
        SecondaryFont = 'C',
        PopUpCap = 'D',
        SkewX = 'E',
        Roundness = 'F',
        ShadowAngle = 'G'
    }

    -- abort export if reserved characters are found
    if string.find(GetPresetName(), reserved) then
        SetBlurb('Export failed. The selected preset is using one or more reserved characters: \'&\' and/or \'#\'.')
        return -1
    end

    local presetString = GetPresetName() .. delim

    local defaultValues = GenerateDefault()

    for k, v in pairs(CURRENT) do
        if k ~= 'style' then
            for _, v2 in ipairs(v) do
                if v2.value:getValues({ 'r', 'g', 'b', 'a' }) ~= defaultValues[v2.var] then presetString = presetString .. keytable[v2.var] .. v2.value:getValues({ 'x' }) .. string.format('%x', v2.value:getValues({ 'a' })) end
            end
        end
    end
    presetString = presetString .. delim

    -- abort export if reserved characters are found
    for _, v in ipairs(CURRENT.style) do
        if string.find(v.value, reserved) then
            SetBlurb('Export failed. The selected preset is using one or more reserved characters: \'&\' and/or \'#\'.')
            return -1
        end
        if v.value ~= defaultValues[v.var] then presetString = presetString .. keytable[v.var] .. v.value .. delim end
    end

    SetBlurb('Exported selected preset [' .. GetPresetName() .. '] onto clipboard.')

    -- subtitute double-click select unfriendly values with friendly ones for QoL
    presetString = string.gsub(presetString, ' ', '\\_')
    presetString = string.gsub(presetString, '-', '#')

    return presetString
end

-- imports the passed string and loads it if valid
function ImportPreset(importString)
    local status, newvalues = pcall(ParseImport, importString)

    if not status then
        print('Bad import.')
        SetBlurb('Imported string is incompatible or corrupted.')
        return -1
    end

    AddPreset(newvalues)

    MADE_CHANGES = true
    SetBlurb('Successfully imported [' .. DATA.presets[PRESET_SELECTION].name .. '] preset.')

    return 1
end

-- generates a new tip blurb
function GenerateTip()
    TIP = (TIP % #DATA.tips) + 1

    SetBlurb('(' .. TIP .. '/' .. #DATA.tips .. '): ' .. DATA.tips[TIP])

    return 1
end