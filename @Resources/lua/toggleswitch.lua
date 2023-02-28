-- Small Lua script to cleanly hide/unhide all relevant Blue Archive widgets with a single button.
local JSON, DATA, SKIN_LIST

function Initialize()
    JSON = dofile(SKIN:GetVariable('@') .. 'lua\\lib\\jsonhandler.lua')

    DATA = JSON.readFile(SKIN:GetVariable('@') .. 'json\\layout.json')
    SKIN_LIST = JSON.filterEnabled(DATA.data)

    -- enforced entry [ToggleSwitch] to make sure at the minimum, it turns itself on/off
    table.insert(SKIN_LIST, { enable = true, variant = 'toggleswitch', name = 'Built-In Toggle', skin = 'BlueArchive\\ToggleSwitch' })

    return 1
end

-- hides/unhides all relevant skins according to [func]
function ToggleCommand(func)
    -- fades in/out the skins
    for _, s in ipairs(SKIN_LIST) do
        if s.variant ~= nil and s.variant ~= '' then
            SKIN:Bang('!' .. func .. 'Config', s.skin, s.variant .. '.ini')
        else
            SKIN:Bang('!' .. func .. 'Config', s.skin)
        end
    end

    return 1
end