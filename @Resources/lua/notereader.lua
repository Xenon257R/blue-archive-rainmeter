-- Script that handles .txt generation and organization.
local JSON, CACHE, DATA, C

local WARN_HEADER, WARN_SUBTEXT

local FILTERED_LIST, SELECTION, NOTES
local NOTE_INDEX_LIST = { size = 0, buffer = 7, pointer = 0 }

-- splits the string [s] according to the delimiter
-- CITATION: https://www.codegrepper.com/code-examples/lua/lua+split+string+by+delimiter
local function Split(s, delimiter)
    local result = { }
    local size = 0

    for match in (s..delimiter):gmatch('(.-)'..delimiter) do
        table.insert(result, match)
        size = size + 1
    end

    return result, size
end

-- reads the respective [filename].txt file located in the @Resources folder
local function Read(filename)
    -- opens file to read
    local filepath = SKIN:GetVariable('@') .. 'notes\\' .. filename .. '.txt'

    local file = assert(io.open(filepath, 'r'), 'File not found or does not exist')

    -- reads .txt file and generates an array
    local notestring = file:read('*all')
    local notelist, _ = Split(notestring, '\n')

    -- closes file
    file:close()

    return notelist
end

-- sets the visibility of the notes according to its settings
local function SetLock()
    if FILTERED_LIST[SELECTION].sensitive then
        SKIN:Bang('!SetOption', 'WarnLock', 'W', '(150*#GScale#)')
        SKIN:Bang('!SetOption', 'WarnText', 'Text', WARN_HEADER .. '#CRLF#' .. WARN_SUBTEXT)
    else
        SKIN:Bang('!SetOption', 'WarnLock', 'W', '0')
        SKIN:Bang('!SetOption', 'WarnText', 'Text', '')
    end

    SKIN:Bang('!UpdateMeter', 'WarnLock')
    SKIN:Bang('!UpdateMeter', 'WarnText')

    return 1
end

-- sets the visibility of the up and down arrows according to the scroll and length of the notes
local function SetArrows()
    if not NOTES or FILTERED_LIST[SELECTION].sensitive or #FILTERED_LIST <= 0 then
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
    WARN_HEADER = SKIN:GetVariable('StrSideNotesWarningHeader', 'SENSITIVE DATA!')
    WARN_SUBTEXT = SKIN:GetVariable('StrSideNotesWarningSubtext', 'Open the .txt in private.')

    JSON = dofile(SKIN:GetVariable('@') .. 'lua\\lib\\jsonhandler.lua')
    CACHE = dofile(SKIN:GetVariable('@') .. 'lua\\lib\\cache.lua')
    DATA = JSON.readFile(SKIN:GetVariable('@') .. 'json\\note.json')

    C = CACHE.new(JSON.readFile(SKIN:GetVariable('@') .. 'notes\\notes.cache'))

    for k, _ in pairs(C.data) do
        C.data[tostring(k)] = false
    end

    -- Verifies tracking of .txt files in cache
    for k, v in ipairs(DATA.data) do
        DATA.data[k].file_id = string.gsub(DATA.data[k].file_id, '[%.-]', '')
        local filepath = SKIN:GetVariable('@') .. 'notes\\' .. v.file_id .. '.txt'

        local filecheck = io.open(filepath, 'r') or io.open(filepath, 'w')
        filecheck:close()

        C.data[tostring(v.file_id)] = true
    end

    -- Removes no longer tracked files
    for k, v in pairs(C.data) do
        if not v then
            os.remove(SKIN:GetVariable('@') .. 'notes\\' .. k .. '.txt')
            C.data[k] = nil
        end
    end

    JSON.writeFile(SKIN:GetVariable('@') .. 'notes\\notes.cache', C:getTable())

    FILTERED_LIST = JSON.filterEnabled(DATA.data)

    SELECTION = ((tonumber(SKIN:GetVariable('NoteSelection', 1)) - 1) % #FILTERED_LIST) + 1

    return 1
end

-- scrolls the Notes in the specified direction
function Scroll(direction)
    if NOTE_INDEX_LIST.size <= 0 then return -1 end

    NOTE_INDEX_LIST.pointer = math.max(0, math.min(NOTE_INDEX_LIST.size - (NOTE_INDEX_LIST.buffer), NOTE_INDEX_LIST.pointer + tonumber(direction)))

    SetArrows()

    return 1
end

-- returns the file name
function GetName()
    if not NOTES then return ' ' end

    return FILTERED_LIST[SELECTION].name
end

-- returns the saved name in directory
function GetTextFile()
    if not NOTES then return ' ' end

    return FILTERED_LIST[SELECTION].file_id .. '.txt'
end

-- returns the text string at the specified index
function ReadLine(index)
    if (not NOTES or FILTERED_LIST[SELECTION].sensitive) then return ' ' end

    return NOTES[tonumber(index) + NOTE_INDEX_LIST.pointer] or ' '
end

-- loads the currently selected file
function Load()
    if NOTES or #FILTERED_LIST <= 0 then return -1 end

    NOTES = Read(FILTERED_LIST[SELECTION].file_id)
    NOTE_INDEX_LIST.size, NOTE_INDEX_LIST.pointer = #NOTES, 0
    SKIN:Bang('!UpdateMeterGroup', 'NoteGroup')
    SetLock()
    SetArrows()

    return 1
end

-- unloads the currently selected file
function Unload()
    NOTES = nil
    NOTE_INDEX_LIST.size, NOTE_INDEX_LIST.pointer = 0, 0
    SetArrows()

    return 1
end

-- iterates to the next file in the collection
function NextNote()
    SELECTION = (SELECTION % #FILTERED_LIST) + 1
    Unload()
    Load()

    SKIN:Bang('!SetOption', 'Variables', 'NoteSelection', SELECTION)
    SKIN:Bang('!WriteKeyValue', 'Variables', 'NoteSelection', SELECTION)

    return 1
end

-- deletes all .txt file contents.
-- NOTE: Unused function. Only exists for archival purposes.
--       Is a redundant feature due to the Skin's startup "restoring" the deleted files, albeit empty.
function ClearCache()
    C:clearCache(function (k, _) return SKIN:GetVariable('@') .. 'notes\\' .. k .. '.txt' end)

    JSON.writeFile(SKIN:GetVariable('@') .. 'notes\\notes.cache', C:getTable())

    SKIN:Bang('!Refresh')

    return 1
end