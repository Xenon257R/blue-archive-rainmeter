[Variables]
@includeHubs=#@#user\hubpaths.inc
UnloadHome=[&HubScript:ToggleCommand("DeactivateConfig",true)][!ActivateConfig "#ROOTCONFIG#\HomeButton"]
LoadHome=#WHome#[!DeactivateConfig "#ROOTCONFIG#\List"][!DeactivateConfig "#ROOTCONFIG#\HomeButton"][&HubScript:ToggleCommand("ActivateConfig",true)]
QSTS=#WQuest##UnloadHome#[!ActivateConfig "#ROOTCONFIG#\List" "questlist.ini"]
RAID=#WRaid##UnloadHome#[!ActivateConfig "#ROOTCONFIG#\List" "raidlist.ini"]
GRID=#WGrid##UnloadHome#[!ActivateConfig "#ROOTCONFIG#\List" "aronagrid.ini"]
SHOP=#WShop##UnloadHome#[!ActivateConfig "#ROOTCONFIG#\List" "shoplist.ini"]
DNGN=#WDungeon##UnloadHome#[!ActivateConfig "#ROOTCONFIG#\List" "dungeonlist.ini"]
LSCR=[!ActivateConfig "#ROOTCONFIG#\0_LoadScreen"][!ZPos "0" "#ROOTCONFIG#\0_LoadScreen"][!Delay 600]

[HubScript]
Measure=Script
ScriptFile=#@#lua\toggleswitch.lua

[HubStartup]
Measure=Calc
Formula=1
IfEqualValue=1
IfEqualAction=[&HubScript:AddEntry("#ROOTCONFIG#\ToggleSwitch",true)][&HubScript:AddEntry("#ROOTCONFIG#\ToggleSwitch\ToggleOn",true)]
UpdateDivider=-1