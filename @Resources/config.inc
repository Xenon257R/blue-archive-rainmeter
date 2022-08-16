; Configuration file for global variables used by multiple skins.
[Variables]
; ------------------
; Desktop Resolution
; ------------------
BaseWidth=1920
; BaseHeight=1080
DesiredWidth=1920
; DesiredHeight=864
GScale=(#DesiredWidth#/#BaseWidth#)
; GScaleY=(#DesiredHeight# / #BaseHeight#)
; ---------------
; Global Elements
; ---------------
IconSize=(100*#GScale#)
IconPress=(87.5*#GScale#)
IconPadding=(37.5*#GScale#)
AppSize=(112.5*#GScale#)
AppPress=(100*#GScale#)
AppHalfWidth=(61.25*#GScale#)
TrayColor=255,255,255,222
DebugColor=0,0,255,0
MiniIconSize=(43.75*#GScale#)
OptionsHeight=(62.5*#GScale#)
OptionsSize=(93.75*#GScale#)
OptionsEdge=(8.75*#GScale#)
SinglePadding=(75*#GScale#)
OptionsPadding=#SinglePadding#,0,0,0
OptionsTextSize=(20*#GScale#)
DropShadowOffset=(5*#GScale#)
ShadowColor=0,0,0,66
Click=[Play "#@#sound\UI_Button_Touch.wav"]
; ------------------------------
; File Directory String Literals
; ------------------------------
; -- NOTE: Quotations are a bit finnicky with Rainmeter variables and command lines, so avoid them as much as possible
ExplorerFilepath=C:\
ResourceMonitorFilepath=C:\Windows\System32\resmon.exe
WallpaperEngineFilepath=C:\
; RainmeterFilepath=!Manage
TasksFilepath=#@#notes.txt
DiscordFilepath=C:\
DiscordParameters=--processStart Discord.exe
; RecycleBinFilepath=!CommandMeasure "RecycleBinStats" "OpenBin"
ApplicationsFilepath=C:\
EmulatorsFilepath=C:\
FirefoxFilepath=C:\
KeePassFilepath=C:\
SteamFilepath=C:\Program Files (x86)\Steam\steam.exe
TorFilepath=C:\
VSCodeFilepath=C:\
DriveFilepath=shell:::{20D04FE0-3AEA-1069-A2D8-08002B30309D}
; ------------------------------
; Miscellaneous
; ------------------------------
Username=USERNAME
Academy=SCHALE
Faction=Universal
MajSoulID=000000000
BlueArchiveID=000000000
AzurLaneID=000000000

[TextStyle]
FontFace=Noto Sans
FontColor=0,0,0,255
FontWeight=700
StringAlign=Center
AntiAlias=1

[PopUpStyle]
Meter=String
FontFace=RSU
FontSize=(30*#GScale#)
FontColor=255,255,255,255
H=(50*#GScale#)
ClipString=1
SolidColor=0,0,255,122
StringAlign=LeftCenter
AntiAlias=1
Hidden=1

[NoteStyle]
Meter=String
Hidden=1
Group=NoteGroup
ClipString=2
FontFace=RSU
FontColor=255,255,255,255
FontSize=20
; X is indent
X=(10*#GScale#)
H=(31.25*#GScale#)
W=(350*#GScale#)
FontWeight=100
StringAlign=Left
AntiAlias=1
InlineSetting=Color | 80,197,249,255
InlinePattern=(\[.*\])
InlineSetting2=Color | 80,197,249,255
InlinePattern2=([\d]*)
InlineSetting3=Color | 80,197,249,255
InlinePattern3=[\d]*([,\.])[\d]
TrailingSpaces=1