-- Returns stringified file content located in [filepath]
local function ReadFile(filepath)
    filepath = SKIN:MakePathAbsolute(filepath)

    local file = io.open(filepath)
    if not file then
        print('Unable to open file at ' .. filepath)
        return
    end

    local contents = file:read('*all')
    file:close()

    return contents
end

local function WriteFile(filepath, content)
    filepath = SKIN:MakePathAbsolute(filepath)

    local file = io.open(filepath, "w")
    if not file then
        print('Unable to open file at ' .. filepath)
        return
    end

    file:write(content)
    file:close()

    return 0
end

local function FetchTree(filepath)
    local contents = ReadFile(filepath)
    if not contents then return end

    local jsonarray = JSON.parse(contents)
    local count = 0

    for k, v in pairs(jsonarray.presets) do
        count = count + 1
    end
    
    return jsonarray, count
end

function Initialize()
    COLOR = dofile(SKIN:GetVariable('@') .. 'lua/color.lua')
    JSON = dofile(SKIN:GetVariable('@') .. 'lua/json.lua')
    FILEPATH = SKIN:GetVariable('@') .. 'json/presets.json'

    CURRENT = {
        header = { { name = "Banner", var = "BannerColor" }, { name = "Header Text", var = "HeaderTextColor" }, { name = "Inset", var = "InsetColor" }, { name = "Highlight", var = "BrightHighlightColor" }, { name = "Full Highlight", var = "WealthColor" } },
        visualizer = { { name = "Primary Color", var = "BarColor1" }, { name = "Fade Color", var = "BarColor2" }, { name = "Shadow", var = "AudioShadowColor" } },
        color = { { name = "Top", var = "C1" }, { name = "Middle", var = "C2" }, { name = "Bottom", var = "C3" }, { name = "Extraneous", var = "C4" }, { name = "Inner Border", var = "C5" }, { name = "Outer Border", var = "C6" }, { name = "Shadow", var = "CS" } },
        tray = { { name = "Tray", var = "TrayColor" }, { name = "Shadow", var = "ShadowColor" }, { name = "Text", var = "TextColor" } },
        popup = { { name = "Background", var = "PopUpColor" }, { name = "Text", var = "PopUpTextColor" }, { name = "Highlighted Text", var = "HighlightColor" } }
    }

    PRESET_ARRAY, NUM_PRESETS = FetchTree(FILEPATH)

    for k, v in pairs(CURRENT) do
        for k2, v2 in ipairs(v) do
            CURRENT[k][k2].value = COLOR.new(SKIN:GetVariable(v2.var, "0,0,0,0"))
        end
    end

    SELECTION = "header"
    PRESET_SELECTION = 0
    COLOR_SELECTION = 1
    BUFFER = 0
    BUFFER_AMOUNT = 5

    return 0
end

function IsSelected(index)
    return tonumber(index) == COLOR_SELECTION and 1 or 0
end

function GetLabel(index)
    if not CURRENT[SELECTION][tonumber(index)] then return '-----' end

    return CURRENT[SELECTION][tonumber(index)].name or '-----'
end

function GetHighlight(index)
    if tonumber(index) == PRESET_SELECTION then
        for k, v in pairs(CURRENT) do
            for k2, v2 in ipairs(v) do
                if CURRENT[k][k2].value:getValues({ "r", "g", "b", "a" }) ~= PRESET_ARRAY.presets[PRESET_SELECTION][v2.var] then return "122,122,122,255" end
            end
        end
        return SKIN:GetVariable('HighlightColor')
    end

    return '0,0,0,0'
end

function GetPresetName(index)
    index = tonumber(index) or PRESET_SELECTION
    if not PRESET_ARRAY.presets[BUFFER + index] then return '' end

    return PRESET_ARRAY.presets[BUFFER + index].name
end

function SetPresetName(newname)
    if PRESET_SELECTION <= 0 or PRESET_SELECTION > NUM_PRESETS then return -1 end

    PRESET_ARRAY.presets[PRESET_SELECTION].name = newname

    WriteFile(FILEPATH, JSON.stringify(PRESET_ARRAY))

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

    -- An xtremely strange edge case exists where DefaultValue cannot seem to pass non-numeric arguments
    local typetable = {}
    local num_table = { ['1'] = 'r', ['2'] = 'g', ['3'] = 'b', ['4'] = 'h', ['5'] = 's', ['6'] = 'v', ['7'] = 'a', ['8'] = 'x', r = 'r', g = 'g', b = 'b', h = 'h', s = 's', v = 'v', a = 'a', x = 'x' }

    for str in string.gmatch(typestring, "([^%s])") do
       table.insert(typetable, num_table[str])
    end

    return CURRENT[SELECTION][index].value:getValues(typetable)
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

    CURRENT[SELECTION][COLOR_SELECTION].value:setValue(value,tonumber(modifier), colortype)

    SKIN:Bang('!SetVariable', CURRENT[SELECTION][COLOR_SELECTION].var, CURRENT[SELECTION][COLOR_SELECTION].value:getValues({ "r", "g", "b", "a" }))
    SKIN:Bang('!UpdateMeterGroup', 'PreviewGroup')

    return 0
end

function SelectPreset(y)
    local newSelection = BUFFER + math.floor(tonumber(y / 100) * BUFFER_AMOUNT) + 1
    if newSelection > NUM_PRESETS then return -1 end

    PRESET_SELECTION = newSelection
    SKIN:Bang('!UpdateMeterGroup', 'EditGroup')
    return 1
end

function SavePreset()
    if PRESET_SELECTION <= 0 or PRESET_SELECTION > NUM_PRESETS then return -1 end

    for k,v in pairs(CURRENT) do
        for k2,v2 in ipairs(v) do
            PRESET_ARRAY.presets[PRESET_SELECTION][v2.var] = v2.value:getValues({ "r", "g", "b", "a" })
        end
    end

    WriteFile(FILEPATH, JSON.stringify(PRESET_ARRAY))

    SKIN:Bang('!UpdateMeterGroup', 'EditGroup')
    SKIN:Bang('!UpdateMeterGroup', 'PreviewGroup')

    return 0
end

function LoadPreset()
    local preset_list = PRESET_ARRAY.presets[PRESET_SELECTION]

    for k, v in pairs(CURRENT) do
        for k2, v2 in ipairs(v) do
            CURRENT[k][k2].value:setAll(preset_list[v2.var])
            SKIN:Bang('!SetVariable', CURRENT[k][k2].var, CURRENT[k][k2].value:getValues({ "r", "g", "b", "a" }))
        end
    end

    SKIN:Bang('!UpdateMeterGroup', 'EditGroup')
    SKIN:Bang('!UpdateMeterGroup', 'PreviewGroup')

    return 0
end

function AddPreset()
    table.insert(PRESET_ARRAY.presets, JSON.null)

    NUM_PRESETS = NUM_PRESETS + 1

    for k, v in pairs(CURRENT) do
        for k2, v2 in ipairs(v) do
            PRESET_ARRAY.presets[NUM_PRESETS][v2.var] = v2.value:getValues({ "r", "g", "b", "a" })
        end
    end

    PRESET_ARRAY.presets[NUM_PRESETS].name = "<untl>"

    WriteFile(FILEPATH, JSON.stringify(PRESET_ARRAY))

    SKIN:Bang('!UpdateMeterGroup', 'EditGroup')
    SKIN:Bang('!UpdateMeterGroup', 'PreviewGroup')

    return 0
end

function RemovePreset()
    if PRESET_SELECTION <= 0 or PRESET_SELECTION > NUM_PRESETS then return -1 end

    table.remove(PRESET_ARRAY.presets, PRESET_SELECTION)
    
    NUM_PRESETS = NUM_PRESETS - 1
    PRESET_SELECTION = 0

    SKIN:Bang('!UpdateMeterGroup', 'EditGroup')
    SKIN:Bang('!UpdateMeterGroup', 'PreviewGroup')

    WriteFile(FILEPATH, JSON.stringify(PRESET_ARRAY))

    return 0
end

function ApplyChanges()
    for k,v in pairs(CURRENT) do
        for k2, v2 in ipairs(v) do
            -- print(v2.value:getValues({ "r", "g", "b", "a" }))
            SKIN:Bang('!WriteKeyValue', 'Variables', v2.var, v2.value:getValues({ "r", "g", "b", "a" }), SKIN:GetVariable('@') .. 'config.inc')
        end
    end

    SKIN:Bang('!Refresh', '*')

    return 0
end