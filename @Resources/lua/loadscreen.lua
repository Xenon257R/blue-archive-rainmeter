-- Script for loading screen animations.
local BIG_WIPE, FILL_WIPE = 1, 0

-- CITATION :https://stackoverflow.com/questions/13462001/ease-in-and-ease-out-animation-formula
local function ParametericBlend(t)
    local sqt = t * t;
    return sqt / (2.0 * (sqt - t) + 1.0)
end

function Initialize()
    return 1
end

-- Handles all tweening of the load in/out animation
function Tween(b, f)
    if b then
        BIG_WIPE = math.min(math.max(BIG_WIPE + tonumber(b), 0), 1)
        SKIN:Bang('!SetVariable', 'W_V', (ParametericBlend(BIG_WIPE)))
    end
    if f then
        FILL_WIPE = math.min(math.max(FILL_WIPE + tonumber(f), 0), 1)
        SKIN:Bang('!SetVariable', 'F_V', (ParametericBlend(FILL_WIPE)))
    end
    SKIN:Bang('!UpdateMeasure', 'RoundlineCalc')
    SKIN:Bang('!UpdateMeterGroup', 'WipeGroup')
    SKIN:Bang('!Redraw')

    return 1
end