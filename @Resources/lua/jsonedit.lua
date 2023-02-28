-- Script to handle JSON data editing for a non-programmer.
local JSON,  FILEPATH,  DATA
local FIELDS, NUM_FIELDS, NUM_ENTRIES

local SELECTION
local BUFFER, BUFFER_AMOUNT = 0, 7
local MADE_CHANGES = false
local TIP

local TYPE_DEFAULT = { string = '', number = 0, boolean = false }
local BOOL_CHANGE_STRING = { 'Disabled', 'Enabled' }

-- generates a blurb text
local function SetBlurb(text)
    SKIN:Bang('!SetOption', 'BlurbText', 'Text', text)
    SKIN:Bang('!UpdateMeter', 'BlurbText')

    SKIN:Bang('!Redraw')

    return 1
end

function Initialize()
    JSON = dofile(SKIN:GetVariable('@') .. 'lua\\lib\\jsonhandler.lua')

    FILEPATH = SKIN:GetVariable('@') .. 'json\\' .. SKIN:GetVariable('JSON') .. '.json'
    DATA = JSON.readFile(FILEPATH)
    FIELDS = DATA.struct
    NUM_FIELDS = table.getn(DATA.struct)
    NUM_ENTRIES = table.getn(DATA.data)

    SELECTION = math.min(1, NUM_ENTRIES)
    TIP = table.getn(DATA.tips)

    for i = 1, NUM_FIELDS, 1 do
        if FIELDS[i].type == 'boolean' then
            SKIN:Bang('!HideMeter', 'Entry' .. i)
        else
            SKIN:Bang('!HideMeter', 'Check' .. i)
        end
    end

    for i = (NUM_FIELDS + 1), 7, 1 do
        SKIN:Bang('!HideMeter', 'Label' .. i)
        SKIN:Bang('!HideMeter', 'Entry' .. i)
        SKIN:Bang('!HideMeter', 'Check' .. i)
    end

    return 1
end

-- returns the appropriate color to use depending on whether changes have been made
function GetSaveColor()
    if MADE_CHANGES then return SKIN:GetVariable('HighlightColor') end

    return SKIN:GetVariable('TextColor')
end

-- returns whether only numbers should be accepted in input or not
function IsOnlyNumber(index)
    if not FIELDS[index] or FIELDS[index].type ~= 'number' then return 0 end

    return 1
end

-- resizes the UI accordingly to whether the data type is boolean or not
function IsBoolean(index)
    if not FIELDS[index] then return 400 end

    if FIELDS[index].type == 'boolean' then return 20 end

    return 400
end

-- returns the appropriate color to use depending on whether the entry at index is disabled or not
function IsEnabled(index)
    if not DATA.data[BUFFER + tonumber(index)] then return '0,0,0,0' end

    if DATA.data[BUFFER + tonumber(index)].enable then return SKIN:GetVariable('TextColor') end

    return SKIN:GetVariable('OffColor')
end

-- returns the field name at specified index
function GetFieldName(index)
    if (tonumber(index) > NUM_FIELDS) then return '' end

    return string.gsub(FIELDS[tonumber(index)].label, '_', ' ')
end

-- returns the field value at specified index
function GetFieldEntry(index)
    if (tonumber(index) > NUM_FIELDS) then return '' end

    if not DATA.data[SELECTION] then return '' end
    if not DATA.data[SELECTION][FIELDS[tonumber(index)].label] or DATA.data[SELECTION][FIELDS[tonumber(index)].label] == '' then return '<empty>' end

    return DATA.data[SELECTION][FIELDS[tonumber(index)].label]
end

-- returns the field boolean value at specified index
function GetFieldBoolean(index)
    if (tonumber(index) > NUM_FIELDS) then return 0 end

    if not DATA.data[SELECTION] or not DATA.data[SELECTION][FIELDS[tonumber(index)].label] then return 0 end

    return 1
end

-- returns the name of the entry at the specified index
function GetName(index)
    index = tonumber(index)
    if not DATA.data[BUFFER + index] or not DATA.data[BUFFER + index].name then return '' end
    if DATA.data[BUFFER + index].name == '' then return '[Untitled]' end

    return DATA.data[BUFFER + index].name
end

-- returns the appropriate color depending or not whether the entry at the specified index is highlighted or not
function GetHighlight(index)
    index = tonumber(index)
    if not DATA.data[BUFFER + index] then return '0,0,0,0' end

    if BUFFER + index == SELECTION then return SKIN:GetVariable('HighlightColor') end

    return '0,0,0,0'
end

-- returns the selected entry number
function GetSelectedNumber()
    return SELECTION
end

-- returns the total number of entries
function GetTotalEntries()
    return NUM_ENTRIES
end

-- selects entry at position [x]%
function SetSelect(x)
    local newSelection = BUFFER + math.floor(tonumber(x / 100) * BUFFER_AMOUNT) + 1
    if newSelection > NUM_ENTRIES then return -1 end

    SELECTION = newSelection

    SKIN:Bang('!UpdateMeterGroup', 'EntryGroup')
    SKIN:Bang('!Redraw')

    return 1
end

-- scrolls the entry list in the vector of [num]
function Scroll(num)
    BUFFER = math.max(math.min(BUFFER + tonumber(num), NUM_ENTRIES - BUFFER_AMOUNT), 0)

    SKIN:Bang('!UpdateMeterGroup', 'EntryGroup')
    SKIN:Bang('!Redraw')

    return BUFFER
end

-- removes the selected entry and moves selection to the entry immediately before
function RemoveSelect()
    local name = DATA.data[SELECTION].name

    if name == '' then name = '[Untitled]' end

    table.remove(DATA.data, SELECTION)

    NUM_ENTRIES = NUM_ENTRIES - 1
    SELECTION = math.min(math.max(SELECTION, 1), NUM_ENTRIES)

    MADE_CHANGES = true

    SKIN:Bang('!UpdateMeterGroup', 'EntryGroup')

    return SetBlurb('Removed ' .. name .. '.')
end

-- adds a new entry right after the currently selected index
function CreateNew()
    table.insert(DATA.data, SELECTION + 1, {})

    NUM_ENTRIES = NUM_ENTRIES + 1
    SELECTION = SELECTION + 1

    for _, v in pairs(FIELDS) do
        DATA.data[SELECTION][v.label] = TYPE_DEFAULT[v.type]
    end

    MADE_CHANGES = true

    SKIN:Bang('!UpdateMeterGroup', 'EntryGroup')

    return SetBlurb('Added new empty element at index ' .. SELECTION .. '.')
end

-- moves the entry one index upwards
function MoveBack()
    if SELECTION <= 1 or NUM_ENTRIES <= 1 then return -1 end

    DATA.data[SELECTION], DATA.data[SELECTION - 1] = DATA.data[SELECTION - 1], DATA.data[SELECTION]

    SELECTION = SELECTION - 1

    MADE_CHANGES = true

    SKIN:Bang('!UpdateMeterGroup', 'EntryGroup')

    return SetBlurb('Moved ' .. DATA.data[SELECTION].name .. ' up 1 index.')
end

-- moves the entry one index downwards
function MoveForward()
    if SELECTION >= NUM_ENTRIES or NUM_ENTRIES <= 1 then return -1 end

    DATA.data[SELECTION], DATA.data[SELECTION + 1] = DATA.data[SELECTION + 1], DATA.data[SELECTION]

    SELECTION = SELECTION + 1

    MADE_CHANGES = true

    SKIN:Bang('!UpdateMeterGroup', 'EntryGroup')

    return SetBlurb('Moved ' .. DATA.data[SELECTION].name .. ' down 1 index.')
end

-- changes the currently selected entry's value at specified index
function SetValue(value, index)
    if NUM_ENTRIES <= 0 then return -1 end

    if FIELDS[tonumber(index)].type == 'number' then value = tonumber(value) end

    DATA.data[SELECTION][FIELDS[tonumber(index)].label] = value

    MADE_CHANGES = true

    SKIN:Bang('!UpdateMeterGroup', 'EntryGroup')

    return SetBlurb('Changed ' .. DATA.data[SELECTION].name .. '\'s [' .. FIELDS[tonumber(index)].label .. '] parameter.')
end

-- switches the boolean value at specified [index]
function ToggleBoolean(index)
    if NUM_ENTRIES <= 0 or not FIELDS[tonumber(index)].type == 'boolean' then return -1 end

    DATA.data[SELECTION][FIELDS[tonumber(index)].label] = not DATA.data[SELECTION][FIELDS[tonumber(index)].label]

    MADE_CHANGES = true
    local current_state = DATA.data[SELECTION][FIELDS[tonumber(index)].label] and 1 or 0

    SKIN:Bang('!UpdateMeterGroup', 'EntryGroup')

    return SetBlurb(BOOL_CHANGE_STRING[current_state + 1] .. ' ' .. DATA.data[SELECTION].name .. '\'s [' .. FIELDS[tonumber(index)].label .. '] parameter.')
end

-- save changes and applies them to the approriate skins by their group tag
function SaveChanges()
    JSON.writeFile(FILEPATH, DATA)

    MADE_CHANGES = false

    SKIN:Bang('!RefreshGroup', DATA.group)

    SKIN:Bang('!UpdateMeterGroup', 'EntryGroup')

    return SetBlurb('Saved all changes!')
end

-- generates a new tip blurb
function GenerateTip()
    TIP = (TIP % table.getn(DATA.tips)) + 1

    SetBlurb('(' .. TIP .. '/' .. table.getn(DATA.tips) .. '): ' .. DATA.tips[TIP])

    return 1
end