-- Small Lua script to cleanly hide/unhide all relevant Blue Archive widgets with a single button

function Initialize()
    JSON = dofile(SKIN:GetVariable('@') .. 'lua/lib/jsonhandler.lua')

    DATA = JSON.readFile(SKIN:GetVariable('@') .. 'json/layout.json')
    SKIN_LIST = JSON.filterEnabled(DATA.data)

    return 1
end

-- Hides/Unhides all relevant skins
function ToggleCommand(func)
    -- Fades in/out the skins
    for i, s in ipairs(SKIN_LIST) do
        if s.variant ~= nil and s.variant ~= '' then
            SKIN:Bang('!' .. func .. 'Config', s.skin, s.variant .. '.ini')
        else
            SKIN:Bang('!' .. func .. 'Config', s.skin)
        end
    end

    return 1
end