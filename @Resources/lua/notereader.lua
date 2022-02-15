-- Handles all features related to the notes.txt file for Rainmeter.

-- Splits the spring according to the delimiter "s"
-- Credits to https://www.codegrepper.com/code-examples/lua/lua+split+string+by+delimiter
local function Split(s, delimiter)
    local result = { }
    local size = 0

    for match in (s..delimiter):gmatch("(.-)"..delimiter) do
        -- print(match, ": ", CheckDifficulty(match))
        table.insert(result, match)
        size = size + 1
    end

    return result, size
end

-- Reads the notes.txt file located in the @Resources folder
local function Read()
    -- Opens file to read
    local filepath = SKIN:GetVariable('@') .. "notes\\" .. SELECTION .. ".txt"
    local file = assert(io.open(filepath, "r"), "file not found or does not exist")

    if (file == nil) then
        return -1
    end

    -- Reads .txt file and prepares an array
    NOTES = file:read("*all")
    NOTES_LIST, LENGTH = Split(NOTES, "\n")

    -- Closes file
    file:close()

    return 1
end

function Initialize()

    SCROLL = 0
    BUFFER = 7

    NOTES = ""
    NOTES_LIST = { }
    NOTE_FILE_LIST = {
        todo = "todo",
    }
    LENGTH = 0
    SELECTION = SKIN:GetVariable('NoteSelection')
end

-- Handles all Load functions for the specified Notes file
function Load()
    return Read()
end

-- Resets all Loaded information on the loaded Notes file
function Reset()
    SCROLL = 0
    NOTES = ""
    NOTES_LIST = { }
    LENGTH = 0

    return 1
end

-- Changes the currently selected Notes file
function SwitchNotes()
    SELECTION = NOTE_FILE_LIST[SELECTION]
    SKIN:Bang('!SetOption', 'Variables', 'NoteSelection', SELECTION)
    SKIN:Bang('!WriteKeyValue', 'Variables', 'NoteSelection', SELECTION)
    Reset()
    Load()
    return 1
end

-- Returns the full content of the notes.txt file
function ReadRaw()
    return NOTES
end

-- Scrolls the Notes in the specified direction
function Scroll(direction)
    if direction < 0 and SCROLL > 0 then
        SCROLL = SCROLL - 1
    end
    if direction > 0 and SCROLL < LENGTH - BUFFER then
        SCROLL = SCROLL + 1
    end

    return 1
end

-- Returns the text string at the specified index
function ReadLine(index)
    index = index + SCROLL
    local data = NOTES_LIST[index]
    if data == nil or data == "" then return " " end

    return data
end

-- Returns the currently selected Note file name
function ReadHeader()
    return SELECTION
end

function UpContent()
    if (LENGTH <= BUFFER) or (SCROLL == 0) then
        return "0,0,0,0"
    end
    return "255,255,255,255"
end

function DownContent()
    if (LENGTH <= BUFFER) or (SCROLL >= LENGTH - BUFFER) then
        return "0,0,0,0"
    end
    return "255,255,255,255"
end