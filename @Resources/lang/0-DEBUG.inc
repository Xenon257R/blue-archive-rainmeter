; Language file for various UI Elements.
; NOTE: This language variation is strictly for debugging.
[Variables]
; =================
; Display Variables
; =================

; Energy
; NOTE: [%#H] will be replaced by the hours value and [%#M] the minutes. This is case sensitive.
StrEnergyRemainPower="TIME_LEFT: %#HH, %#MM"
StrEnergyDirectPower=NO_TIMEVAL
StrEnergyMaxVal=NEW_MAX_VAL
StrEnergyDecayRate=DECAY_PER_MIN
; NOTE: [%3!i!] will be replaced by the hours value and [%2!i!] the minutes. This is case sensitive.
StrEnergyLogTime=LOG_TIME %3!i!H, %2!i!M

; EventBanner
; Steam has a limited set of supported languages. The list of supported language is as follows:
; schinese, japanese, koreana, thai, bulgarian, czech, danish, german, english, spanish, latam, greek, french, italian, indonesian, hungarian, dutch, norwegian, polish, portuguese, brazilian, romanian, russian, finnish, swedish, turkish, vietnamese, ukranian
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
StrWeatherStatDefault=CLEAR
StrWeatherCityDefault=SCHALE
StrWeatherCountryDefault=KIVOTOS

; SchaleFolder
StrSchaleFolderName=WIN_DIR
StrSchaleFolderRightClick=RIGHT_CLICK_FILLER

; Sideapps
StrSideVizName=VISUALIZER
StrSideNotesName=NOTES
StrSideNoFileAlert=NO_NOTES_FOUND
StrSidePhoneName=MOMOTALK
StrSideRecycleBinFiles=FILES_
StrSideRecycleBinName=RECYCLE
; NOTE: Use the extra line provided below if the Recycle Bin string is too long. Otherwise, leave it blank.
StrSideRecycleBinNameExtra=

; YouTubeBubble
; NOTE: [%T] will be replaced by the relevant time value. This is case sensitive.
StrYouTubeUploadString=UPLOAD_%T_AGO
; NOTE: [UploadTimes], [UploadPluralTimes] and [Punctuation] are directly correlated, i.e. the [n]th time value will be used alongside the [n]th punctuation. Exactly 6 entries are expected.
;       The values are delimited by horizontal lines (|).
;       If your language does not have plurals, match the [UploadPluralTimes] to be exactly the same as [UploadTimes].
StrYouTubeUploadTimes=MN|HR|DY|WK|MO|YR
StrYouTubeUploadPluralTimes=MN|HR|DY|WK|MO|YR
StrYouTubeUploadPunctuation=!|~|.|,|...|?
StrYouTubeDefaultName=YOUTUBE
StrYouTubeDefaultTitle=NO_TITLE
StrYouTubePleaseWaitMessage=PLEASE_WAIT
StrYouTubeNoEntriesMessage=NO_CHANNEL_IN_LIST
StrYouTubeUnavailability=RSS_OFFLINE
StrYouTubeOfflineMessage=OFFLINE
StrYouTubeDownloadErrorMessage=ERROR
StrYouTubeConnectionErrorMessage=CONNECT_ERROR

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
StrIDSEntryPrompt=[INPUT_DATA_HERE]
StrIDSNoEntry=- NO_ID_FOUND -
StrIDSURL=URL_BELOW
StrIDSID=ID_BELOW
StrIDSClipAlert=CLIP_ALERT
StrIDSTipHeader=ID_TOOL_TIP
StrIDSDisclaimer=TOOL_DISCLAIMER