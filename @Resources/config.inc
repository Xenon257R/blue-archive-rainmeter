; Configuration file for global variables used by multiple skins.
[Variables]
; -------------------------
; Desktop Resolution (16:9)
; -------------------------
; BaseWidth=1920
; DesiredWidth=1920
GScale=1*(#WORKAREAWIDTH#/1920)
; ---------------
; Global Elements
; ---------------
; NOTE: [ShadowAngle] is strictly an "Editor only" variable. If this variable is directly tampered with,
; this variable will have no effect whatsoever until [colorsettings.ini] "applies" it and modifies
; the [ShadowX] and [ShadowY] values appropriately.
ShadowAngle=315
ShadowX=1
ShadowY=1
ShadowDepth=5
SX=(#ShadowX#*#ShadowDepth#*#GScale#)
SY=(#ShadowY#*#ShadowDepth#*#GScale#)
DropShadowOffset=(#ShadowDepth#*#GScale#)
Click=[Play "#@#sound\UI_Button_Touch.wav"]
; --------
; Hitboxes
; --------
; Debug=Fill Color 0,122,0,122 | StrokeWidth 1 | Stroke Color 0,122,0,255
; Hitbox=Fill Color 122,0,0,122 | StrokeWidth 1 | Stroke Color 122,0,0,255
Debug=Fill Color 0,122,0,0 | StrokeWidth 0
Hitbox=Fill Color 0,0,0,1 | StrokeWidth 0
; ------
; Colors
; ------
BannerColor=19,52,83,255
HeaderTextColor=255,255,255,255
InsetColor=44,76,115,255
BrightHighlightColor=80,255,255,255
WealthColor=237,203,60,255
; ------
BarColor1=131,213,243,255
BarColor2=255,255,255,255
AudioShadowColor=120,140,185,200
; ------
C1=22,147,222,255
C2=39,203,252,255
C3=167,248,255,255
C4=255,255,255,255
C5=47,80,109,255
C6=255,255,255,255
C7=47,80,109,255
C8=247,168,187,255
CharmBorderColor=110,25,67,255
StopColor=239,64,67,255
StopBorderColor=100,10,10,255
OffColor=122,122,122,255
OffBorderColor=61,61,61,255
; ------
TrayColor=255,255,255,222
ShadowColor=0,0,0,66
TextColor=32,60,93,255
; ------
PopUpColor=31,64,101,222
PopUpTextColor=255,255,255,255
HighlightColor=50,201,255,255
PopUpCap=Round
; ------
PrimaryFont=Noto Sans
SecondaryFont=RSU
FancyFont=Fredoka One
SkewX=-10
SkewY=0
Roundness=5
Edgeround=(#Roundness#*#GScale#)
FullSkew=#SkewX#,#SkewY#

[TrayAppStyle]
FontFace=#PrimaryFont#
FontColor=#TextColor#
FontSize=(18*#GScale#)
X=(87.5*#GScale#)
Y=(100*#GScale#)
W=(175*#GScale#)
ClipString=1
FontWeight=700
StringAlign=Center
AntiAlias=1

[SideAppStyle]
FontFace=#PrimaryFont#
FontColor=#TextColor#
StringEffect=Border 
FontEffectColor=#TrayColor#
FontSize=(18*#GScale#)
FontWeight=700
StringAlign=CenterBottom
AntiAlias=1

[PopUpStyle]
Meter=String
FontFace=#SecondaryFont#
FontSize=(28*#GScale#)
FontColor=#PopUpTextColor#
H=(50*#GScale#)
ClipString=1
StringAlign=LeftCenter
AntiAlias=1
Hidden=1
