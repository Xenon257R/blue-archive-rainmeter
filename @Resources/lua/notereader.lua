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

-- Remove suffix stars for printing a note string
local function Clean(string)
    local maximum = 3

    while maximum > 0 and string:sub(-1, -1) == "*" do
        string = string:sub(1, -2)
        maximum = maximum - 1
    end

    return string:sub(3)
end

-- Removes prefixes and suffixes and returns the resulting note string
local function FormatCheck()
    local status = false

    for i, line in ipairs(NOTES_LIST) do

        if line:sub(2,2) ~= "|" and line ~= "" then
            -- print("offender found")
            NOTES_LIST[i] = "X|" .. line
            status = true
        end
    end

    return status
end

-- Rewrites the notes.txt file with new changes
local function Rewrite(filepath)
    -- Re-open file to write
    local file = assert(io.open(filepath, "w"), "file not found or does not exist")

    for i, line in ipairs(NOTES_LIST) do
        file:write(line)
        if i < LENGTH then
            file:write("\n")
        end
    end
    file:close()
end

-- Reads the notes.txt file located in the @Resources folder
local function Read()
    -- Opens file to read
    local filepath = SKIN:GetVariable('@') .. "/notes.txt"
    local file = assert(io.open(filepath, "r"), "file not found or does not exist")

    if (file == nil) then
        return -1
    end

    -- Reads .txt file and prepares an array
    NOTES = file:read("*all")
    NOTES_LIST, LENGTH = Split(NOTES, "\n")

    -- Closes file
    file:close()

    if (FormatCheck()) then
        Rewrite(filepath)
    end

    return 1
end

function Initialize()
    -- Opens file to read
    Read()

    SCROLL = 0
    BUFFER = 5
    TOGGLE = 0
end

-- Rereads the notes.txt file per update cycle
function Update()
    Read()
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

-- Checks the status of the scroll amount of all the notes
function CheckScroll(direction, invert)
    invert = invert or 0
    if TOGGLE == 0 then return 1 end
    if direction < 0 and SCROLL <= 0 then
        return (1 + invert) % 2
    end
    if direction > 0 and SCROLL >= LENGTH - BUFFER then
        return (1 + invert) % 2
    end
    return invert
end

-- Toggles the visibility settings of the Note bubble
function SetToggle(t)
    if t == nil then
        TOGGLE = (TOGGLE + 1) % 2
        return TOGGLE
    end
    TOGGLE = t
    return TOGGLE
end

-- Returns the text string at the specified index
function ReadLine(index)
    index = index + SCROLL
    local data = NOTES_LIST[index]
    if data == nil or data == "" then return "---" end

    return Clean(data)
end

-- Returns the Status attribute of the note at the specified index
function CheckStatus(index)
    index = index + SCROLL
    local data = NOTES_LIST[index]
    if data == nil or data == "" then return "" end

    return data:sub(1, 1)
end

-- Returns the Difficulty attribute of the note at the specified index
function CheckDifficulty(index)
    index = index + SCROLL
    local data = NOTES_LIST[index]
    if data == nil or data == "" then return "" end

    if data:sub(-3, -1) == "***" then return 3 end
    if data:sub(-2, -1) == "**" then return 2 end
    if data:sub(-1, -1) == "*" then return 1 end

    return ""
end

-- Changes the status marker of the note at the specified index
function ChangeStatus(index, modifier)
    modifier = modifier or 1
    index = index + SCROLL

    local data = NOTES_LIST[index]
    if data == nil or data == "" then return "" end

    local num = tonumber(data:sub(1, 1))
    num = (num + modifier) % 10
    if num < 0 then
        num = num + 10
    end
    NOTES_LIST[index] = num .. data:sub(2)

    Rewrite(SKIN:GetVariable('@') .. "/notes.txt")

    return ""
end