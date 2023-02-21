
local function SetBlurb(msg)
    if msg then
        BLURB = msg
    elseif MADE_CHANGES then
        BLURB = "You have unsaved changes."
    else
        BLURB = "No changes made."
    end

    SKIN:Bang('!UpdateMeterGroup', 'EntryGroup')
    return 1
end

function Initialize()
    JSON = dofile(SKIN:GetVariable('@') .. 'lua/lib/jsonhandler.lua')

    FILEPATH = SKIN:GetVariable('@') .. 'json/' .. SKIN:GetVariable('JSON') .. '.json'
    DATA = JSON.readFile(FILEPATH)
    FIELDS = DATA.struct
    NUM_FIELDS = table.getn(DATA.struct)
    NUM_ENTRIES = table.getn(DATA.data)

    SELECTION = math.min(1, NUM_ENTRIES)
    BUFFER = 0
    BUFFER_AMOUNT = 7
    MADE_CHANGES = false
    BLURB = "No changes made."

    TYPE_DEFAULT = { string = "", number = 0, boolean = false }
    BOOL_CHANGE_STRING = { "Disabled", "Enabled" }

    for i = 1, NUM_FIELDS, 1 do
        if FIELDS[i].type == "boolean" then
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

function GetSaveColor()
    if MADE_CHANGES then return SKIN:GetVariable('HighlightColor') end

    return SKIN:GetVariable('TextColor')
end

function IsOnlyNumber(index)
    if not FIELDS[index] or FIELDS[index].type ~= "number" then return 0 end

    return 1
end

function GetFieldName(index)
    if (tonumber(index) > NUM_FIELDS) then return '' end

    return string.gsub(FIELDS[tonumber(index)].label, "_", " ")
end

function GetFieldEntry(index)
    if (tonumber(index) > NUM_FIELDS) then return '' end

    if not DATA.data[SELECTION] then return "" end
    if not DATA.data[SELECTION][FIELDS[tonumber(index)].label] or DATA.data[SELECTION][FIELDS[tonumber(index)].label] == "" then return "<empty>" end

    return DATA.data[SELECTION][FIELDS[tonumber(index)].label]
end

function GetFieldBoolean(index)
    if (tonumber(index) > NUM_FIELDS) then return 0 end

    if not DATA.data[SELECTION] or not DATA.data[SELECTION][FIELDS[tonumber(index)].label] then return 0 end

    return 1
end

function GetName(index)
    index = tonumber(index)
    if not DATA.data[BUFFER + index] or not DATA.data[BUFFER + index].name then return '' end
    if DATA.data[BUFFER + index].name == '' then return '[Untitled]' end

    return DATA.data[BUFFER + index].name
end

function GetHighlight(index)
    index = tonumber(index)
    if not DATA.data[BUFFER + index] then return "0,0,0,0" end

    if BUFFER + index == SELECTION then return SKIN:GetVariable("HighlightColor") end

    return "0,0,0,0"
end

function GetSelectedNumber()
    return SELECTION
end

function GetTotalEntries()
    return NUM_ENTRIES
end

function GetBlurb()
    return BLURB
end

function IsBoolean(index)
    if not FIELDS[index] then return 400 end

    if FIELDS[index].type == "boolean" then return 20 end

    return 400
end

function SetSelect(x)
    local newSelection = BUFFER + math.floor(tonumber(x / 100) * BUFFER_AMOUNT) + 1
    if newSelection > NUM_ENTRIES then return -1 end

    SELECTION = newSelection
    SetBlurb()
    return 1
end

function Scroll(num)
    BUFFER = math.max(math.min(BUFFER + tonumber(num), NUM_ENTRIES - BUFFER_AMOUNT), 0)

    SKIN:Bang('!UpdateMeterGroup', 'EntryGroup')
    return BUFFER
end

function IsChanged()
    if MADE_CHANGES then return 255 end
    return 0
end

function IsEnabled(index)
    if not DATA.data[BUFFER + tonumber(index)] then return "0,0,0,0" end

    if DATA.data[BUFFER + tonumber(index)].enable then return SKIN:GetVariable("TextColor") end

    return "180,180,180,255"
end

function RemoveSelect()
    local name = DATA.data[SELECTION].name

    if name == '' then name = '[Untitled]' end

    table.remove(DATA.data, SELECTION)
    
    NUM_ENTRIES = NUM_ENTRIES - 1
    SELECTION = math.min(math.max(SELECTION, 1), NUM_ENTRIES)

    MADE_CHANGES = true
    return SetBlurb("Removed " .. name .. ".")
end

function CreateNew()
    table.insert(DATA.data, SELECTION + 1, {})

    NUM_ENTRIES = NUM_ENTRIES + 1
    SELECTION = SELECTION + 1

    for k, v in pairs(FIELDS) do
        DATA.data[SELECTION][v.label] = TYPE_DEFAULT[v.type]
    end

    MADE_CHANGES = true
    return SetBlurb("Added new empty element at index " .. SELECTION .. ".")
end

function MoveBack()
    if SELECTION <= 1 or NUM_ENTRIES <= 1 then return -1 end

    DATA.data[SELECTION], DATA.data[SELECTION - 1] = DATA.data[SELECTION - 1], DATA.data[SELECTION]

    SELECTION = SELECTION - 1

    MADE_CHANGES = true
    return SetBlurb("Moved " .. DATA.data[SELECTION].name .. " up 1 index.")
end

function MoveForward()
    if SELECTION >= NUM_ENTRIES or NUM_ENTRIES <= 1 then return -1 end

    DATA.data[SELECTION], DATA.data[SELECTION + 1] = DATA.data[SELECTION + 1], DATA.data[SELECTION]

    SELECTION = SELECTION + 1

    MADE_CHANGES = true
    return SetBlurb("Moved " .. DATA.data[SELECTION].name .. " down 1 index.")
end

function SetValue(value, index)
    if NUM_ENTRIES <= 0 then return -1 end

    DATA.data[SELECTION][FIELDS[tonumber(index)].label] = value

    MADE_CHANGES = true
    return SetBlurb("Changed " .. DATA.data[SELECTION].name .. "'s [" .. FIELDS[tonumber(index)].label .. "] parameter.")
end

function ToggleBoolean(index)
    if NUM_ENTRIES <= 0 or not FIELDS[tonumber(index)].type == "boolean" then return -1 end

    DATA.data[SELECTION][FIELDS[tonumber(index)].label] = not DATA.data[SELECTION][FIELDS[tonumber(index)].label]

    MADE_CHANGES = true
    local current_state = DATA.data[SELECTION][FIELDS[tonumber(index)].label] and 1 or 0
    return SetBlurb(BOOL_CHANGE_STRING[current_state + 1] .. " " .. DATA.data[SELECTION].name .. "'s [" .. FIELDS[tonumber(index)].label .. "] parameter.")
end

function SaveChanges()
    JSON.writeFile(FILEPATH, DATA)

    MADE_CHANGES = false
    return SetBlurb("Saved all changes!")
end