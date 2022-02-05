-- Small Lua script to cleanly hide/unhide all relevant Blue Archive widgets with a single button
function Initialize()
    -- The following values are extracted literally to avoid the edge case of rising to the top of the desktop
    -- They may be assigned in the toggleswitch.ini configuration folder under [Variables]
    X_POS = SKIN:GetVariable('XPos', 0)
    Y_POS = SKIN:GetVariable('YPos', 0)
    X_POS_MOVE = SKIN:GetVariable('XPosMove', 0)
    Y_POS_MOVE = SKIN:GetVariable('YPosMove', 0)

    -- Variants can be specified in the corresponding index in VARIANT_LIST
    SKIN_LIST = {
        "BlueArchive\\Currency",
        "BlueArchive\\Energy",
        "BlueArchive\\Options",
        "BlueArchive\\Premium",
        "BlueArchive\\SchaleFolder",
        "BlueArchive\\RefreshButton",
        "BlueArchive\\SideApps\\Audio",
        "BlueArchive\\SideApps\\Discord",
        "BlueArchive\\SideApps\\RecycleBin",
        "BlueArchive\\SideApps\\Tasks",
        "BlueArchive\\TrayApps\\Applications",
        "BlueArchive\\TrayApps\\Emulators",
        "BlueArchive\\TrayApps\\Firefox",
        "BlueArchive\\TrayApps\\KeePass",
        "BlueArchive\\TrayApps\\Steam",
        "BlueArchive\\TrayApps\\TorBrowser",
        "BlueArchive\\TrayApps\\VSCode",
        "BlueArchive\\TrayApps\\AIMP",
        "BlueArchive\\Tray",
        "BlueArchive\\UserBanner"
    }

    VARIANT_LIST = { [2] = "uptime.ini" }

    FUNCTION_LIST = { "Deactivate", "Activate" }
    STATE = 0
end

-- Hides/Unhides all relevant skins
function ToggleCommand(s)
    local f = FUNCTION_LIST[STATE + 1]

    if s ~= nil and s ~= STATE then
        return 0
    end

    STATE = (STATE + 1) % 2

    if s ~= nil then
        f = FUNCTION_LIST[s + 1]
        STATE = (s + 1) % 2
    end

    -- Fades in/out the skins
    for i, skin in ipairs(SKIN_LIST) do
        if VARIANT_LIST[i] ~= nil then
            SKIN:Bang('!' .. f .. 'Config', skin, VARIANT_LIST[i])
        else
            SKIN:Bang('!' .. f .. 'Config', skin)
        end
    end

    -- Repositions the button
    Adjust()

    -- changes the toggle icon
    SKIN:Bang('!ToggleMeter', 'ToggleOffImage')
    SKIN:Bang('!ToggleMeter', 'ToggleOnImage')
    SKIN:Bang('!ToggleMeter', 'ToggleHiddenHitbox')
    SKIN:Bang('!ToggleMeterGroup', 'ToggleBoxGroup')

    if (STATE == 1) then
        SKIN:Bang('!HideMeter', 'ToggleOnImage')
        SKIN:Bang('!HideMeter', 'ToggleOnSwitch')
        SKIN:Bang('!HideMeter', 'ToggleOnSwitchShadow')
    end

    return 1
end

-- Adjusts the skin relative to its original position
-- NOTE: The "original position" is immutable; it does not change every call to the new position
function Adjust()
    SKIN:MoveWindow(X_POS + (X_POS_MOVE * STATE), Y_POS + (Y_POS_MOVE * STATE))
    return 1
end