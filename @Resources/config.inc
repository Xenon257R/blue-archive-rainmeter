; Configuration file for global variables used by multiple skins.
[Variables]
IconSize=80
IconPress=70
IconPadding=30
AppSize=90
AppPress=80
AppHalfWidth=50
TrayColor=255,255,255,222
DebugColor=0,0,255,0
MiniIconSize=35
OptionsHeight=50
OptionsSize=75
OptionsEdge=7
SinglePadding=60
OptionsPadding=#SinglePadding#,0,0,0
OptionsTextSize=16
DropShadowOffset=3
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

[TextStyle]
FontFace=Noto Sans
FontColor=0,0,0,255
FontWeight=700
StringAlign=Center
AntiAlias=1

[PopUpStyle]
Meter=String
FontFace=RSU
FontSize=24
FontColor=255,255,255,255
H=40
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
FontSize=16
X=10  ; indent
H=25
W=280
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