-- Script to handle JSON data editing for a non-programmer.
local JSON, FILENAME, FILEPATH, DATA
local FIELDS

local SELECTION
local BUFFER, BUFFER_AMOUNT = 0, 7
local MADE_CHANGES = false
local TIP_DATA = {}
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

    FILENAME = SKIN:GetVariable('JSON')
    FILEPATH = SKIN:GetVariable('@') .. 'json\\' .. FILENAME .. '.json'
    DATA = JSON.readFile(FILEPATH)
    FIELDS = DATA.struct

    SELECTION = math.min(1, #DATA.data)

    for i = 1, SKIN:GetVariable('TIP_' .. FILENAME .. 'Count', 0), 1 do
        table.insert(TIP_DATA, SKIN:GetVariable(('TIP_' .. FILENAME .. tostring(i)), '[No Tip]'))
    end

    if #TIP_DATA <= 0 then table.insert(TIP_DATA, "No tips are available for this .json file.") end
    TIP = #TIP_DATA

    for i = 1, #DATA.struct, 1 do
        if FIELDS[i].type == 'boolean' then
            SKIN:Bang('!HideMeter', 'Entry' .. i)
        else
            SKIN:Bang('!HideMeter', 'Check' .. i)
        end
    end

    for i = (#DATA.struct + 1), 7, 1 do
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
    if (tonumber(index) > #DATA.struct) then return '' end

    local internalLabel = FIELDS[tonumber(index)].label

    -- reserved (and expected) labels for every .json file
    if ((internalLabel == 'name') or (internalLabel == 'enable')) then return SKIN:GetVariable('JSON_' .. internalLabel, '[default_null]') end

    return SKIN:GetVariable('JSON_' .. FILENAME .. '_' .. FIELDS[tonumber(index)].label, '[null]')
    -- return string.gsub(FIELDS[tonumber(index)].label, '_', ' ')
end

-- returns the field value at specified index
function GetFieldEntry(index)
    if (tonumber(index) > #DATA.struct) then return '' end

    if not DATA.data[SELECTION] then return '' end
    if not DATA.data[SELECTION][FIELDS[tonumber(index)].label] or DATA.data[SELECTION][FIELDS[tonumber(index)].label] == '' then return '<empty>' end

    return DATA.data[SELECTION][FIELDS[tonumber(index)].label]
end

-- returns the field boolean value at specified index
function GetFieldBoolean(index)
    if (tonumber(index) > #DATA.struct) then return 0 end

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
    return #DATA.data
end

-- selects entry at position [x]%
function SetSelect(x)
    local newSelection = BUFFER + math.floor(tonumber(x / 100) * BUFFER_AMOUNT) + 1
    if newSelection > #DATA.data then return -1 end

    SELECTION = newSelection

    SKIN:Bang('!UpdateMeterGroup', 'EntryGroup')
    SKIN:Bang('!Redraw')

    return 1
end

-- scrolls the entry list in the vector of [num]
function Scroll(num)
    BUFFER = math.max(math.min(BUFFER + tonumber(num), #DATA.data - BUFFER_AMOUNT), 0)

    SKIN:Bang('!UpdateMeterGroup', 'EntryGroup')
    SKIN:Bang('!Redraw')

    return BUFFER
end

-- removes the selected entry and moves selection to the entry immediately before
function RemoveSelect()
    local name = DATA.data[SELECTION].name

    if name == '' then name = '[Untitled]' end

    table.remove(DATA.data, SELECTION)

    SELECTION = math.min(math.max(SELECTION, 1), #DATA.data)

    MADE_CHANGES = true

    SKIN:Bang('!UpdateMeterGroup', 'EntryGroup')

    return SetBlurb(string.gsub(SKIN:GetVariable('JSONRemoved', 'Removed %v.'), '%%v', name))
end

-- adds a new entry right after the currently selected index
function CreateNew()
    table.insert(DATA.data, SELECTION + 1, {})

    SELECTION = SELECTION + 1

    for _, v in pairs(FIELDS) do
        DATA.data[SELECTION][v.label] = TYPE_DEFAULT[v.type]
    end

    MADE_CHANGES = true

    SKIN:Bang('!UpdateMeterGroup', 'EntryGroup')

    return SetBlurb(string.gsub(SKIN:GetVariable('JSONAdded', 'Added new empty element at index %d.'), '%%d', SELECTION))
end

-- moves the entry one index upwards
function MoveBack()
    if SELECTION <= 1 or #DATA.data <= 1 then return -1 end

    DATA.data[SELECTION], DATA.data[SELECTION - 1] = DATA.data[SELECTION - 1], DATA.data[SELECTION]

    SELECTION = SELECTION - 1

    MADE_CHANGES = true

    SKIN:Bang('!UpdateMeterGroup', 'EntryGroup')

    return SetBlurb(string.gsub(SKIN:GetVariable('JSONMovedUp', 'Moved up %v.'), '%%v', DATA.data[SELECTION].name))
end

-- moves the entry one index downwards
function MoveForward()
    if SELECTION >= #DATA.data or #DATA.data <= 1 then return -1 end

    DATA.data[SELECTION], DATA.data[SELECTION + 1] = DATA.data[SELECTION + 1], DATA.data[SELECTION]

    SELECTION = SELECTION + 1

    MADE_CHANGES = true

    SKIN:Bang('!UpdateMeterGroup', 'EntryGroup')

    return SetBlurb(string.gsub(SKIN:GetVariable('JSONMovedDown', 'Moved down %v.'), '%%v', DATA.data[SELECTION].name))
end

-- changes the currently selected entry's value at specified index
function SetValue(value, index)
    if #DATA.data <= 0 then return -1 end

    if FIELDS[tonumber(index)].type == 'number' then value = tonumber(value) end

    DATA.data[SELECTION][FIELDS[tonumber(index)].label] = value

    MADE_CHANGES = true

    SKIN:Bang('!UpdateMeterGroup', 'EntryGroup')

    local blurb = SKIN:GetVariable('JSONModified', 'Changed %v of %e.')
    blurb = string.gsub(blurb, '%%v', FIELDS[tonumber(index)].label)
    blurb = string.gsub(blurb, '%%e', DATA.data[SELECTION].name)

    return SetBlurb(blurb)
end

-- switches the boolean value at specified [index]
function ToggleBoolean(index)
    if #DATA.data <= 0 or not FIELDS[tonumber(index)].type == 'boolean' then return -1 end

    DATA.data[SELECTION][FIELDS[tonumber(index)].label] = not DATA.data[SELECTION][FIELDS[tonumber(index)].label]

    MADE_CHANGES = true
    local current_state = DATA.data[SELECTION][FIELDS[tonumber(index)].label] and 1 or 0

    SKIN:Bang('!UpdateMeterGroup', 'EntryGroup')

    local blurb = SKIN:GetVariable('JSONDeactivate', 'Disable %v.')
    if (current_state == 1) then blurb = SKIN:GetVariable('JSONActivate', 'Enable %v.') end
    blurb = string.gsub(blurb, '%%v', FIELDS[tonumber(index)].label)
    blurb = string.gsub(blurb, '%%e', DATA.data[SELECTION].name)

    return SetBlurb(blurb)
end

-- save changes and applies them to the approriate skins by their group tag
function SaveChanges()
    JSON.writeFile(FILEPATH, DATA)

    MADE_CHANGES = false

    SKIN:Bang('!RefreshGroup', DATA.group)

    SKIN:Bang('!UpdateMeterGroup', 'EntryGroup')

    return SetBlurb(SKIN:GetVariable('JSONSavedReturn', 'Saved and applied.'))
end

-- generates a new tip blurb
function GenerateTip()
    TIP = (TIP % #TIP_DATA) + 1

    SetBlurb('(' .. TIP .. '/' .. #TIP_DATA .. '): ' .. TIP_DATA[TIP])

    return 1
end