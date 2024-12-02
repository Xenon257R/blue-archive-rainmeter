; Language file for various UI Elements.
; NOTE: This language variation is strictly for debugging.
[Variables]
; =================
; Display Variables
; =================

; Energy
; NOTE: [%#H] will be replaced by the hours value and [%#M] the minutes.
StrEnergyRemainPower="TIME_LEFT: %#HH, %#MM"
StrEnergyDirectPower=NO_TIMEVAL
StrEnergyMaxVal=NEW_MAX_VAL
StrEnergyDecayRate=DECAY_PER_MIN
; NOTE: [%3!i!] will be replaced by the hours value and [%2!i!] the minutes.
StrEnergyLogTime=LOG_TIME %3!i!H, %2!i!M

; EventBanner
; Steam has a limited set of supported languages. To get a list of codes, refer to steamlang.txt in the @Resources/lang directory.
StrRegionType=english

; List
StrAronaGridActVer=INSTALL_VER
StrAronaGridAlert=NEW_VER
StrDungeonListHeader=SEARCH_HEADER
StrQuestListAllHeader=ALL_TAB
StrQuestListDailyHeader=DAILY_TAB
StrQuestListWeeklyHeader=WEEKLY_TAB
StrQuestListChallengesHeader=HARD_TAB
StrQuestListMiscellaneousHeader=MISC_TAB
StrRaidListHeader=GAME_HEADER
StrRaidListAvailability=GAME_AVAILABILITY
StrShopListDeselect=DESELECT
StrShopListOpen=OPEN
StrShopListSelectTotal=QUANTITY_SELECT#CRLF#TOTAL

; Premium
StrPremiumInOut=BPS IN_OUT

; PrimaryBanner
; NOTE: [StrRegionISO] MUST be an ISO 639-1 standard region code for WeatherBanner to work.
StrRegionISO=en-US
StrWeatherStatDefault=Clear
StrWeatherCityDefault=SCHALE
StrWeatherCountryDefault=Kivotos

; SchaleFolder
StrSchaleFolderName=WIN_DIR
StrSchaleFolderRightClick=RIGHT_CLICK_FILLER

; Sideapps
StrSideVizName=VISUALIZER
StrSideNotesName=NOTES
StrSideNoFileAlert=NO_NOTES_FOUND
StrSidePhoneName=MOMOTALK
StrSideRecycleBinName=RECYCLE
; NOTE: Use the extra line provided below if the Recycle Bin string is too long. Otherwise, leave it blank.
StrSideRecycleBinNameExtra=

; =============
; Dev Variables
; =============

; AppSettings
StrSettingImageFile=IMG_STR
StrSettingDisplayName=DSP_STR
StrSettingExecution=EXE_STR
StrSettingColorDefault=DFT_STR

; GlobalScalarSettings
StrGScaleAuto=AUTO TEXT
StrGScaleManual=MANUAL_TEXT
StrGScaleHeader=G_SCALE
StrGScaleTipHeader=TIP_HEADER
StrGScaleAdvice=1920X1080_RES
StrGScaleTooltip=RESTORE_BUTTON

; HubSettings
StrHubSettingsHeader=HUBSWITCH_EDITOR
StrHubSettingsEmpty=EMPTY_FILLER
StrHubSettingsSetWallpaper=WIN_BUILT_IN_DOC
StrHubSettingsWallpaperEngine=WALLPAPERENGINE_DOC

; WeatherComCodes
StrWeatherCodeSearch=SEARCH_LOC
StrWeatherCodeSetLoc=SET_LOC_TO

; IDScraper
StrIDSURL=URL_BELOW
StrIDSID=ID_BELOW
StrIDSClipAlert=CLIP_ALERT
StrIDSTipHeader=ID_TOOL_TIP
StrIDSDisclaimer=TOOL_DISCLAIMER