-- Splits the string [s] according to the delimiter
-- Credits to https://www.codegrepper.com/code-examples/lua/lua+split+string+by+delimiter
local function Split(s, delimiter)
    local result = { }
    local size = 0

    for match in (s..delimiter):gmatch("(.-)"..delimiter) do
        table.insert(result, match)
        size = size + 1
    end

    return result, size
end

-- Reads the respective [filename].txt file located in the @Resources folder
local function Read(filename)
    -- Opens file to read
    local filepath = SKIN:GetVariable('@') .. "notes\\" .. filename .. ".txt"

    local file = assert(io.open(filepath, "r"), "file not found or does not exist")

    -- Reads .txt file and generates an array
    local notestring = file:read("*all")
    local notelist, _ = Split(notestring, "\n")

    -- Closes file
    file:close()

    return notelist
end

-- Sets the visibility of the notes according to its settings
local function SetLock()
    if FILTERED_LIST[SELECTION].sensitive then
        SKIN:Bang('!SetOption', 'WarnLock', 'W', '(150*#GScale#)')
        SKIN:Bang('!SetOption', 'WarnText', 'Text', 'SENSITIVE DATA!#CRLF#Open the .txt in private.')
    else
        SKIN:Bang('!SetOption', 'WarnLock', 'W', '0')
        SKIN:Bang('!SetOption', 'WarnText', 'Text', '')
    end

    SKIN:Bang('!UpdateMeter', 'WarnLock')
    SKIN:Bang('!UpdateMeter', 'WarnText')

    return 1
end

-- Sets the visibility of the up and down arrows according to the scroll and length of the notes
local function SetArrows()
    if not NOTES or FILTERED_LIST[SELECTION].sensitive or table.getn(FILTERED_LIST) <= 0 then
        SKIN:Bang('!HideMeterGroup', 'ArrowGroup')
        SKIN:Bang('!UpdateMeterGroup', 'ArrowGroup')
        return 0
    end

    local up, down = NOTE_INDEX_LIST.pointer <= 0, NOTE_INDEX_LIST.pointer + NOTE_INDEX_LIST.buffer >= NOTE_INDEX_LIST.size

    if up then
        SKIN:Bang('!HideMeter', 'UpArrow')
        SKIN:Bang('!HideMeter', 'UpHitbox')
    else
        SKIN:Bang('!ShowMeter', 'UpArrow')
        SKIN:Bang('!ShowMeter', 'UpHitbox')
    end

    if down then
        SKIN:Bang('!HideMeter', 'DownArrow')
        SKIN:Bang('!HideMeter', 'DownHitbox')
    else
        SKIN:Bang('!ShowMeter', 'DownArrow')
        SKIN:Bang('!ShowMeter', 'DownHitbox')
    end
    
    SKIN:Bang('!UpdateMeterGroup', 'ArrowGroup')

    return 1
end

function Initialize()
    JSON = dofile(SKIN:GetVariable('@') .. 'lua/lib/jsonhandler.lua')
    DATA = JSON.readFile(SKIN:GetVariable('@') .. 'json/note.json')

    -- Verifies tracking of .txt files in cache
    for k, v in pairs(DATA.cache) do
        DATA.cache[k] = false
    end
    for k, v in ipairs(DATA.data) do
        local filepath = SKIN:GetVariable('@') .. "notes\\" .. v.filename .. ".txt"
        local filecheck = io.open(filepath, "r")

        if not filecheck then
            filecheck = io.open(filepath, "w")
        end

        filecheck:close()
        DATA.cache[v.filename] = true
    end
    JSON.writeFile(SKIN:GetVariable('@') .. 'json/note.json', DATA)

    -- [TODO] Write context menu option: ClearCache()

    FILTERED_LIST = JSON.filterEnabled(DATA.data)

    SELECTION = ((tonumber(SKIN:GetVariable('NoteSelection', 1)) - 1) % table.getn(FILTERED_LIST)) + 1
    NOTES = nil
    NOTE_INDEX_LIST = { size = 0, buffer = 7, pointer = 0 }

    BUFFER = 7

    return 1
end

-- Scrolls the Notes in the specified direction
function Scroll(direction)
    if NOTE_INDEX_LIST.size <= 0 then return -1 end

    NOTE_INDEX_LIST.pointer = math.max(0, math.min(NOTE_INDEX_LIST.size - (NOTE_INDEX_LIST.buffer), NOTE_INDEX_LIST.pointer + tonumber(direction)))

    SetArrows()

    return 1
end

-- Returns the file name
function GetName()
    if not NOTES then return ' ' end

    return FILTERED_LIST[SELECTION].filename
end

-- Returns the text string at the specified index
function ReadLine(index)
    if (not NOTES or FILTERED_LIST[SELECTION].sensitive) then return ' ' end

    return NOTES[tonumber(index) + NOTE_INDEX_LIST.pointer] or ' '
end

-- Loads the currently selected file
function Load()
    if NOTES or table.getn(FILTERED_LIST) <= 0 then return -1 end

    NOTES = Read(FILTERED_LIST[SELECTION].filename)
    NOTE_INDEX_LIST.size, NOTE_INDEX_LIST.pointer = table.getn(NOTES), 0
    SKIN:Bang('!UpdateMeterGroup', 'NoteGroup')
    SetLock()
    SetArrows()

    return 1
end

-- Unloads the currently selected file
function Unload()
    NOTES = nil
    NOTE_INDEX_LIST.size, NOTE_INDEX_LIST.pointer = 0, 0
    SetArrows()

    return 1
end

-- Iterates to the next file in the collection
function NextNote()
    SELECTION = (SELECTION % table.getn(FILTERED_LIST)) + 1
    Unload()
    Load()

    SKIN:Bang('!SetOption', 'Variables', 'NoteSelection', SELECTION)
    SKIN:Bang('!WriteKeyValue', 'Variables', 'NoteSelection', SELECTION)

    return 1
end

-- Deletes unused .txt files identified by a [false] flag
function ClearCache()
    for k, v in pairs(DATA.cache) do
        if not v then
            os.remove(SKIN:GetVariable('@') .. "notes\\" .. k .. ".txt")
            DATA.cache[k] = nil
        end
    end

    JSON.writeFile(SKIN:GetVariable('@') .. 'json/note.json', DATA)

    return 1
end