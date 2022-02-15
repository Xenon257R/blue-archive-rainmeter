-- Small script to remember affiliation configurations.
function Initialize()
    SELECTION = SKIN:GetVariable('Selection', 'academies')

    CATEGORY = {
        academies = SKIN:GetVariable('Academy', 'SCHALE'),
        factions = SKIN:GetVariable('Faction', 'Universal')
    }

    POINTER = {
        academies = "factions",
        factions = "academies"
    }
end

function GetAffiliation()
    return SKIN:GetVariable('@') .. SELECTION .. "\\" .. CATEGORY[SELECTION] .. ".png"
end

function ToggleSelection()
    SELECTION = POINTER[SELECTION]
    SKIN:Bang('!WriteKeyValue', 'Variables', 'Selection', SELECTION)
    return 1
end