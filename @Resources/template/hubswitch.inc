[Variables]
@includeHubs=#@#user\hubpaths.inc
UnloadHome=[&HubScript:ToggleCommand("DeactivateConfig",true)][!ActivateConfig "BlueArchive\HomeButton"]
LoadHome=#WHome#[!DeactivateConfig "BlueArchive\List"][!DeactivateConfig "BlueArchive\HomeButton"][&HubScript:ToggleCommand("ActivateConfig",true)]
QSTS=#WQuest##UnloadHome#[!ActivateConfig "BlueArchive\List" "questlist.ini"]
RAID=#WRaid##UnloadHome#[!ActivateConfig "BlueArchive\List" "raidlist.ini"]
GRID=#WGrid##UnloadHome#[!ActivateConfig "BlueArchive\List" "aronagrid.ini"]
SHOP=#WShop##UnloadHome#[!ActivateConfig "BlueArchive\List" "shoplist.ini"]
DNGN=#WDungeon##UnloadHome#[!ActivateConfig "BlueArchive\List" "dungeonlist.ini"]
LSCR=[!ActivateConfig "BlueArchive\0_LoadScreen"][!ZPos "0" "BlueArchive\0_LoadScreen"][!Delay 600]

[HubScript]
Measure=Script
ScriptFile=#@#lua\toggleswitch.lua

[HubStartup]
Measure=Calc
Formula=1
IfEqualValue=1
IfEqualAction=[&HubScript:AddEntry("BlueArchive\ToggleSwitch",true)][&HubScript:AddEntry("BlueArchive\ToggleSwitch\ToggleOn",true)]
UpdateDivider=-1