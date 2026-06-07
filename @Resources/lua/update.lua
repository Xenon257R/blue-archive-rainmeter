-- Small script to compare update version of current installed version to latest available one.
local INSTALLED_VER

-- remove 'v' prefix on versions and break down into table
local function refactor(versionString)
    local a, b, c = string.match(versionString, "v(%d+)%.(%d+)%.(%d+)")

    return { a, b, c }
end

function Initialize()
    INSTALLED_VER = refactor(SKIN:GetVariable('CurrentVersion', 'v1.0.0'))
end

-- compares installed version to online version
function CompareVersions()
    local onlineVer = refactor(SKIN:GetMeasure('VersionModule'):GetStringValue())

    for i = 1, 3, 1 do
        if INSTALLED_VER[i] < onlineVer[i] then
            SKIN:Bang('!SetOption', 'DisplayUpdate', 'Formula', 1)
            SKIN:Bang('!UpdateMeasure', 'DisplayUpdate')

            print("New update found.")
            return 1
        end
    end
    return 0
end