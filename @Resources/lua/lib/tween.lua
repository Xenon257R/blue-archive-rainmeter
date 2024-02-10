local tween = {}
tween.__index = tween

function tween.new(tweenStep, initArray)
    local o = setmetatable({}, tween)

    o.tweenStep = tweenStep or 0.1

    o.values = initArray or {}

    return o
end

-- CITATION :https://stackoverflow.com/questions/13462001/ease-in-and-ease-out-animation-formula
local function parametericBlend(t)
    local sqt = t * t;
    return sqt / (2.0 * (sqt - t) + 1.0)
end

-- handles tweening intervals
function tween:scroll(...)
    for i = 1, arg.n do
        local v = tonumber(arg[i])
        if (v >= -1 and v <= 1) then
            self.values[i] = math.min(self.values[i] + (self.tweenStep * v), 1.0)
        else
            self.values[i] = math.max(math.min(v, 1), 0)
        end
    end

    return arg.n
end

-- gets the current animation frame
function tween:getFrame(index, t, offset)
    t = t or 'l'
    offset = offset or 0
    if t == 'p' then return parametericBlend(self.values[index]) + offset end

    return self.values[index] + offset
end

return tween