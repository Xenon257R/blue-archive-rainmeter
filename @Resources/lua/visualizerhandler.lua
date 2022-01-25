-- Small Lua script to cleanly adjust the position of the handler when the suite is loaded or unloaded
function Initialize()
    -- The following values are extracted literally to avoid the edge case of sinking to the bottom of the desktop
    -- They may be assigned in the audiovisualizer.ini configuration folder under [Variables]
    X_POS = SKIN:GetVariable('XPos', 0)
    Y_POS = SKIN:GetVariable('YPos', 0)
end

-- Adjusts the skin relative to its original position
-- NOTE: The "original position" is immutable; it does not change every call to the new position
function Adjust(xMove, yMove)
    SKIN:MoveWindow(X_POS + xMove, Y_POS + yMove)
    return 1
end