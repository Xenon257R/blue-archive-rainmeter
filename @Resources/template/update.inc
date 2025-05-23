[Variables]
CurrentVersion=v1.2.2
UpdateAvailableAction=

[VersionModule]
Measure=WebParser
URL=https://github.com/Xenon257R/blue-archive-rainmeter/releases.atom
RegExp=(?siU)<entry>.*<link.*releases\/tag\/(.*)"\/>
Substitute="":"#CurrentVersion#"
FinishAction=[!EnableMeasure CompareVer][!UpdateMeasure CompareVer]
StringIndex=1

[CurrentVerNum]
Measure=String
String=#CurrentVersion#
RegExpSubstitute=1
Substitute="^v(\d)\.(\d)\.(\d)":"\1\2\3"

; NOTE: This comparison is shorthand and thus does not accurately identify certain version numbers (e.g. v1.2.19 is incorrectly identified as a greater version than v1.3.0). Update with caution.
[CompareVer]
Measure=String
String=[&VersionModule]
Substitute="v":"",".":""
IfCondition=[CompareVer]>[CurrentVerNum]
IfTrueAction=#UpdateAvailableAction#
DynamicVariables=1
Disabled=1