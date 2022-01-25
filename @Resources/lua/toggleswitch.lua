-- Small Lua script to cleanly hide/unhide all relevant Blue Archive widgets with a single button
function Initialize()
    SKIN_LIST = { "BlueArchive\\Currency", "BlueArchive\\Energy", "BlueArchive\\Options", "BlueArchive\\Premium", "BlueArchive\\SchaleFolder",
        "BlueArchive\\SideApps\\Audio", "BlueArchive\\SideApps\\Discord", "BlueArchive\\SideApps\\RecycleBin", "BlueArchive\\SideApps\\Tasks",
        "BlueArchive\\TrayApps\\Applications", "BlueArchive\\TrayApps\\Emulators", "BlueArchive\\TrayApps\\Firefox",
        "BlueArchive\\TrayApps\\KeePass", "BlueArchive\\TrayApps\\Steam", "BlueArchive\\TrayApps\\TorBrowser", "BlueArchive\\TrayApps\\VSCode",
        "BlueArchive\\Tray", "BlueArchive\\UserBanner" }

    FUNCTION_LIST = { "Hide", "Show" }
    STATE = 0
end

-- Hides/Unhides all relevant skins
function ToggleCommand()
    local f = FUNCTION_LIST[STATE + 1]

    -- Fades in/out the skins
    STATE = (STATE + 1) % 2
    for _, skin in ipairs(SKIN_LIST) do
        SKIN:Bang('!' .. f .. 'Fade', skin)
    end

    -- changes the toggle icon
    SKIN:Bang('!ToggleMeter', 'ToggleOffImage')
    SKIN:Bang('!ToggleMeter', 'ToggleOnImage')
    SKIN:Bang('!ToggleMeter', 'ToggleHiddenHitbox')
    SKIN:Bang('!ToggleMeterGroup', 'ToggleBoxGroup')
    return 1
end