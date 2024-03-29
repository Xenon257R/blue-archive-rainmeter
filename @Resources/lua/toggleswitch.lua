-- Small Lua script to cleanly hide/unhide all relevant Blue Archive widgets with a single button.
local JSON, DATA, SKIN_LIST

function Initialize()
    JSON = dofile(SKIN:GetVariable('@') .. 'lua\\lib\\jsonhandler.lua')

    DATA = JSON.readFile(SKIN:GetVariable('@') .. 'json\\layout.json')
    SKIN_LIST = JSON.filterEnabled(DATA.data)

    return 1
end

-- Manually add entries
-- NOTE: [v] and [n] are optional parameters
function AddEntry(s, m, v, n)
    v, n = v or nil, n or 'Auto'
    table.insert(SKIN_LIST, { enable = true, variant = v, name = n, skin = s, main_only = m })

    return 1
end

-- hides/unhides all relevant skins according to [func]
function ToggleCommand(func, filterMain)
    -- fades in/out the skins
    for _, s in ipairs(SKIN_LIST) do
        if not filterMain or s.main_only then
            if func == 'ToggleConfig' or (s.variant ~= nil and s.variant ~= '' and func ~= 'Toggle') then
                SKIN:Bang('!' .. func, s.skin, s.variant .. '.ini')
            else
                SKIN:Bang('!' .. func, s.skin)
            end
        end
    end

    return 1
end

-- Immediately deactivates and reactivates a specified skin if enabled
-- NOTE: Unused. Archived for future testing due to Rainmeter's extremely fickle load order post-startup depending on Windows focus
function PushBack(skin)
    for _, s in ipairs(SKIN_LIST) do
        if s.skin == skin then
            SKIN:Bang('!DeactivateConfig', s.skin)
            if (s.variant ~= nil and s.variant ~= '' and func ~= 'Toggle') then
                SKIN:Bang('!ActivateConfig', s.skin, s.variant .. '.ini')
            else
                SKIN:Bang('!ActivateConfig', s.skin)
            end

            return 1
        end
    end

    return -1
end