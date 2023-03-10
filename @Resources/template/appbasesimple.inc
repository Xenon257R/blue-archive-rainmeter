; Shortcut to an Applications directory.
[Rainmeter]
Group=TrayApp
Update=-1
DefaultUpdateDivider=-1
AccurateText=1
SkinWidth=(120*#GScale#)
SkinHeight=(150*#GScale#)
ContextTitle=Rewire App
ContextAction=[!WriteKeyValue Variables ParentFolder "#CURRENTCONFIG#" "#ROOTCONFIGPATH#\0_Settings\AppSettings\simplesettings.ini"][!WriteKeyValue Variables ParentConfig "#CURRENTPATH##CURRENTFILE#" "#ROOTCONFIGPATH#\0_Settings\AppSettings\simplesettings.ini"][!ActivateConfig "BlueArchive\0_Settings\AppSettings" "simplesettings.ini"][!Move ((#CURRENTCONFIGX#)-(100*#GScale#)) (#CURRENTCONFIGY#-(250*#GScale#)) "BlueArchive\0_Settings\AppSettings"][!Refresh "BlueArchive\0_Settings\AppSettings"]
ContextTitle2=[#ContextName[#Animation]] Shine
ContextAction2=[!WriteKeyValue Variables Animation ((#Animation#%2)+1) "#@#template\appbasesimple.inc"][!RefreshGroup TrayApp]

[Variables]
@includeConfig=#@#user\config.inc
TrayAppSize=(100*#GScale#)
PressMargin=0
PressAction=[!SetVariable PressMargin "(5*#GScale#)"][!UpdateMeterGroup AppGroup][!Redraw]
DepressAction=[!SetVariable PressMargin "0"][!UpdateMeterGroup AppGroup][!Redraw]
ImageFile=simple\schale.png
Execution=[!Manage]
AppName=SCHALE
Interval=25
P1=0.0
P2=0.05
P3=0.15
P4=0.3
P5=0.5
P6=0.7
P7=0.85
P8=0.95
P9=1.0
1P=#P1#
ContextName1=Disable
ContextName2=Enable
Anim1=[!CommandMeasure ShineAction "Execute 1"]
Anim2=
Animation=2

[DebugContainer]
Meter=Shape
Shape=Rectangle 0,0,(120*#GScale#),(150*#GScale#) | #Debug#

[Name]
Meter=String
Group=Master
FontFace=#PrimaryFont#
FontSize=(18*#GScale#)
FontWeight=700
FontColor=#TextColor#
StringAlign=CenterCenter
ClipString=1
InlineSetting=Color | 0,0,0,0
InlinePattern=(^_*)
InlineSetting2=Color | 0,0,0,0
InlinePattern2=(_*$)
Text=#AppName#
X=(60*#GScale#)
Y=(120*#GScale#)
W=(120*#GScale#)
H=(70*#GScale#)
AntiAlias=1

[AppIcon]
Meter=Image
Group=Master | AppGroup
ImageName=#@#assets\icons\#ImageFile#
PreserveAspectRatio=1
X=((10*#GScale#)+#PressMargin#)
Y=#PressMargin#
W=(#TrayAppSize#-(#PressMargin#*2))
H=(#TrayAppSize#-(#PressMargin#*2))
DynamicVariables=1

[PressHitbox]
Meter=Shape
Group=Master
Shape=Rectangle 0,0,#TrayAppSize#,#TrayAppSize# | #Hitbox#
X=(10*#GScale#)
Y=0
LeftMouseDownAction=#Click##PressAction#
LeftMouseUpAction=#Execution##DepressAction#
MouseOverAction=[#Anim[#Animation]]
MouseLeaveAction=#DepressAction#

[NameLengthCheck]
Meter=String
Group=Master
FontFace=#PrimaryFont#
FontSize=(18*#GScale#)
FontWeight=700
FontColor=0,0,0,0
StringAlign=CenterCenter
Text=#AppName#
X=(60*#GScale#)
Y=(120*#GScale#)
AntiAlias=1

[NamePixelLength]
Measure=Calc
Group=FunctionMaster
Formula=1
IfCondition=([NameLengthCheck:W] > (120*#GScale#)) || ([NameLengthCheck:H] > (40*#GScale#))
IfTrueAction=[!SetOption Name FontSize "(14*#GScale#)"][!Redraw]
DynamicVariables=1

[FlareContainer]
Meter=Image
Group=Master | AppGroup
ImageName=#@#assets\icons\#ImageFile#
PreserveAspectRatio=1
X=((10*#GScale#)+#PressMargin#)
Y=#PressMargin#
W=(#TrayAppSize#-(#PressMargin#*2))
H=(#TrayAppSize#-(#PressMargin#*2))
DynamicVariables=1

[ShineFlare]
Meter=Shape
Group=Master
Shape=Rectangle (#TrayAppSize#*-0.4),0,(#TrayAppSize#*0.25),#TrayAppSize# | Fill Color 255,255,255,180 | StrokeWidth 0 | Skew -45,0
Shape2=Rectangle (#TrayAppSize#*-0.5),0,(#TrayAppSize#*0.05),#TrayAppSize# | Fill Color 255,255,255,200 | StrokeWidth 0 | Skew -45,0
Container=FlareContainer
X=(#TrayAppSize#*#1P#*1.5)
DynamicVariables=1
Hidden=1

[ShineAction]
Measure=Plugin
Plugin=ActionTimer
ActionList1=1_1 | Wait #Interval# | 1_2 | Wait #Interval# | 1_3 | Wait #Interval# | 1_4 | Wait #Interval# | 1_5 | Wait #Interval# | 1_6 | Wait #Interval# | 1_7 | Wait #Interval# | 1_8 | Wait #Interval# | 1_9 | Wait 1000
1_1=[!SetVariable 1P "#P1#"][!UpdateMeter ShineFlare][!ShowMeter ShineFlare][!Redraw]
1_2=[!SetVariable 1P "#P2#"][!UpdateMeter ShineFlare][!Redraw]
1_3=[!SetVariable 1P "#P3#"][!UpdateMeter ShineFlare][!Redraw]
1_4=[!SetVariable 1P "#P4#"][!UpdateMeter ShineFlare][!Redraw]
1_5=[!SetVariable 1P "#P5#"][!UpdateMeter ShineFlare][!Redraw]
1_6=[!SetVariable 1P "#P6#"][!UpdateMeter ShineFlare][!Redraw]
1_7=[!SetVariable 1P "#P7#"][!UpdateMeter ShineFlare][!Redraw]
1_8=[!SetVariable 1P "#P8#"][!UpdateMeter ShineFlare][!Redraw]
1_9=[!SetVariable 1P "#P9#"][!UpdateMeter ShineFlare][!HideMeter ShineFlare][!Redraw]
IgnoreWarnings=1
