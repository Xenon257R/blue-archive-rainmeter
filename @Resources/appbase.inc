; Shortcut to an Applications directory.
[Rainmeter]
Update=50
DefaultUpdateDivider=-1
AccurateText=1
ContextTitle=Rewire App
ContextAction=[!WriteKeyValue Variables ParentFolder "#CURRENTCONFIG#" "#ROOTCONFIGPATH#TrayApps\0_AppSettings\appsettings.ini"][!WriteKeyValue Variables ParentConfig "#CURRENTPATH##CURRENTFILE#" "#ROOTCONFIGPATH#TrayApps\0_AppSettings\appsettings.ini"][!ActivateConfig "BlueArchive\TrayApps\0_AppSettings" "appsettings.ini"][!Move ((#CURRENTCONFIGX#)-(100*#GScale#)) (#CURRENTCONFIGY#-(200*#GScale#)) "BlueArchive\TrayApps\0_AppSettings"][!Refresh "BlueArchive\TrayApps\0_AppSettings"]
SkinWidth=(175*#GScale#)
SkinHeight=(145*#GScale#)

[Variables]
@includeConfig=#@#config.inc
TrayAppSize=(100*#GScale#)
PressMargin=0
ShadowCast=(12.5*#GScale#)
PressAction=[!SetVariable PressMargin "(5*#GScale#)"][!UpdateMeterGroup AppGroup]
DepressAction=[!SetVariable PressMargin "0"][!UpdateMeterGroup AppGroup]
ImageFolder=rainmeter
Execution=[!Manage]
AppName=Rainmeter
Color1=1
Color2=2
Color3=3
Color4=4
Color5=5
Color6=6
Color7=7

[DebugContainer]
Meter=Shape
Shape=Rectangle 0,0,(175*#GScale#),(150*#Gscale#) | #Debug#

[TrayIconStyle]
Group=Master | AppGroup
W=(#TrayAppSize#-(#PressMargin#*2))
H=(#TrayAppSize#-(#PressMargin#*2))
X=((37.5*#GScale#)+#PressMargin#)
Y=#PressMargin#
PreserveAspectRatio=1
DynamicVariables=1

[AppIconShadow]
Meter=Image
MeterStyle=TrayIconStyle
Y=(#PressMargin#+#ShadowCast#)
ImageName=#@#assets/icons/#ImageFolder#/s.png
ImageTint=[#C[#Color7]]

[AppIcon6]
Meter=Image
MeterStyle=TrayIconStyle
ImageName=#@#assets/icons/#ImageFolder#/6.png
ImageTint=[#C[#Color6]]

[AppIcon5]
Meter=Image
MeterStyle=TrayIconStyle
ImageName=#@#assets/icons/#ImageFolder#/5.png
ImageTint=[#C[#Color5]]

[AppIcon4]
Meter=Image
MeterStyle=TrayIconStyle
ImageName=#@#assets/icons/#ImageFolder#/4.png
ImageTint=[#C[#Color4]]

[AppIcon3]
Meter=Image
MeterStyle=TrayIconStyle
ImageName=#@#assets/icons/#ImageFolder#/3.png
ImageTint=[#C[#Color3]]

[AppIcon2]
Meter=Image
MeterStyle=TrayIconStyle
ImageName=#@#assets/icons/#ImageFolder#/2.png
ImageTint=[#C[#Color2]]

[AppIcon1]
Meter=Image
MeterStyle=TrayIconStyle
ImageName=#@#assets/icons/#ImageFolder#/1.png
ImageTint=[#C[#Color1]]

[PressHitbox]
Meter=Shape
Group=Master
Shape=Rectangle 0,0,(100*#GScale#),(100*#GScale#) | #Hitbox#
X=(37.5*#GScale#)
Y=0
LeftMouseDownAction=#Click##PressAction#
LeftMouseUpAction=#Execution##DepressAction#
MouseLeaveAction=#DepressAction#

[Name]
Meter=String
Group=Master
MeterStyle=TrayAppStyle
Text=#AppName#