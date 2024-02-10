-- Script for music player animations.
local TWEEN, ANIM

function Initialize()
    TWEEN = dofile(SKIN:GetVariable('@') .. 'lua\\lib\\tween.lua')
    ANIM = TWEEN.new(0.1, { 0, 1, 1 })

    return 1
end

function Scroll(a, b, c)
    return ANIM:scroll(tonumber(a), tonumber(b),  tonumber(c))
end

function GetStep(index)
    return ANIM:getFrame(tonumber(index), 'p')
end