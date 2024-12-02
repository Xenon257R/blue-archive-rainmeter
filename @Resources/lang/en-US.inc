; [en-US] Language file for various UI Elements.

[Variables]
; =================
; Display Variables
; =================

; Energy
; NOTE: [%#H] will be replaced by the hours value and [%#M] the minutes.
StrEnergyRemainPower="%#Hh, %#Mm remaining."
StrEnergyDirectPower=Directly Powered!
StrEnergyMaxVal=Max Energy Value
StrEnergyDecayRate=Decay Rate (per min.)
; NOTE: [%3!i!] will be replaced by the hours value and [%2!i!] the minutes.
StrEnergyLogTime=%3!i!h, %2!i!m since login.

; EventBanner
; Steam has a limited set of supported languages. To get a list of codes, refer to steamlang.txt in the @Resources/lang directory.
StrRegionType=english

; List
StrAronaGridActVer=Active Version
StrAronaGridAlert=Update Available!
StrDungeonListHeader=Search Query
StrQuestListAllHeader=All
StrQuestListDailyHeader=Daily
StrQuestListWeeklyHeader=Weekly
StrQuestListChallengesHeader=Challenges
StrQuestListMiscellaneousHeader=Miscellaneous
StrRaidListHeader=Game Select
StrRaidListAvailability=Games Available
StrShopListDeselect=Deselect All
StrShopListOpen=Open Selected
StrShopListSelectTotal=path(s) currently#CRLF#selected

; Premium
StrPremiumInOut=Bps In/Out.

; PrimaryBanner
; NOTE: [StrRegionISO] MUST be an ISO 639-1 standard region code for WeatherBanner to work.
StrRegionISO=en-US
StrWeatherStatDefault=Clear
StrWeatherCityDefault=SCHALE
StrWeatherCountryDefault=Kivotos

; SchaleFolder
StrSchaleFolderName=File Explorer
StrSchaleFolderRightClick=<right-click>

; Sideapps
StrSideVizName=Visualizer
StrSideNotesName=Notes
StrSideNoFileAlert=No Files Found
StrSidePhoneName=Momotalk
StrSideRecycleBinName=Recycle
; NOTE: Use the extra line provided below if the Recycle Bin string is too long. Otherwise, leave it blank.
StrSideRecycleBinNameExtra=Bag

; =============
; Dev Variables
; =============

; AppSettings
StrSettingImageFile=Image File
StrSettingDisplayName=Dislay Name
StrSettingExecution=Execution
StrSettingColorDefault=DEFAULT

; GlobalScalarSettings
StrGScaleAuto=The suite is currently automated to generate a scalar from your screen resolution's height.
StrGScaleManual=The scalar has been changed manually in the past and will no longer update itself.
StrGScaleHeader=G. Scalar
StrGScaleTipHeader=Quick Tip!
StrGScaleAdvice=A value of 1 is best suited for a resolution that is exactly 1080 pixels in height and at least 1920 pixels in width.
StrGScaleTooltip=Restore Automatic Scaling (from height)

; HubSettings
StrHubSettingsHeader=Hub Switch Functions
StrHubSettingsEmpty=<Empty>
StrHubSettingsSetWallpaper=!SetWallpaper
StrHubSettingsWallpaperEngine=WallpaperEngine CLI

; WeatherComCodes
StrWeatherCodeSearch=Search For Location
StrWeatherCodeSetLoc=Click here to set the Latitude and Longitude for

; IDScraper
StrIDSURL=Channel URL
StrIDSID=Channel ID
StrIDSClipAlert=Copied to Clipboard!
StrIDSTipHeader=Channel ID Tip
StrIDSDisclaimer=YouTube's code may continue to change in the future, possibly causing this tool to break again. If an output isn't generated with a valid YouTube URL, look for online tools or peek in Page Source yourself. #CRLF# #CRLF# A valid ID will always start with 'UC'.