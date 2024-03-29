-- Handles driver plug-ins and their storage space details.
local FORMAT_LIST = { '', 'k', 'M', 'G', 'T', 'P' }
local CURRENT_DRIVER = 1
local DRIVER_STRING = 'CDEFGHIJKLMNOPQRSTUVWXYZAB'

-- check if a file or directory exists in this path
-- CITATION: https://stackoverflow.com/questions/1340230/check-if-directory-exists-in-lua
local function Exists(file)
    local ok, err, code = os.rename(file, file)
    if not ok then
        if code == 13 then
            -- Permission denied, but it exists
            return true
        end
    end

    return ok, err
end

function Initialize()
    return 1
end

-- formats a number string to have commas
-- CITATION: https://stackoverflow.com/questions/10989788/format-integer-in-lua
function FormatIntString(number)
    local suffix = 1
    while number >= 1000000 and suffix <= 6 do
        number = number / 1024
        suffix = suffix + 1
    end

    local _, _, minus, int, _ = tostring(number):find('([-]?)(%d+)([.]?%d*)')

    -- reverse the int-string and append a comma to all blocks of 3 digits
    int = int:reverse():gsub('(%d%d%d)', '%1,')

    -- reverse the int-string back remove an optional comma and put the
    -- optional minus and fractional part back
    return minus .. int:reverse():gsub("^,", "") .. ' ' .. FORMAT_LIST[suffix] .. 'B'
end

-- selects the next drive alphabetically, wrapping back to C: if no further drive is found
function NextDrive()
    for i = CURRENT_DRIVER + 1, #DRIVER_STRING do
        if Exists(string.sub(DRIVER_STRING, i, i) .. ':\\') then
            CURRENT_DRIVER = i
            return CURRENT_DRIVER
        end
    end

    CURRENT_DRIVER = 1

    return 1
end

-- returns the current Driver that is selected
function CurrentDrive()
    if not Exists(string.sub(DRIVER_STRING, CURRENT_DRIVER, CURRENT_DRIVER) .. ':\\') then NextDrive() end

    return string.sub(DRIVER_STRING, CURRENT_DRIVER, CURRENT_DRIVER) .. ':'
end