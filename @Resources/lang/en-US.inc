; [en-US] Language file for various UI Elements.

[Variables]
; =================
; Display Variables
; =================

; Energy
; NOTE: [%#H] will be replaced by the hours value and [%#M] the minutes. This is case sensitive.
StrEnergyRemainPower="%#Hh, %#Mm remaining."
StrEnergyDirectPower=Directly Powered!
StrEnergyMaxVal=Max Energy Value
StrEnergyDecayRate=Decay Rate (per min.)
; NOTE: [%3!i!] will be replaced by the hours value and [%2!i!] the minutes. This is case sensitive.
StrEnergyLogTime=%3!i!h, %2!i!m since login.

; EventBanner
; Steam has a limited set of supported languages. The list of supported language is as follows:
; schinese, japanese, koreana, thai, bulgarian, czech, danish, german, english, spanish, latam, greek, french, italian, indonesian, hungarian, dutch, norwegian, polish, portuguese, brazilian, romanian, russian, finnish, swedish, turkish, vietnamese, ukranian
StrSteamRegionType=english
StrSteamLoadingText=Loading...
StrSteamNoUpdateText=No Updates Found!
StrSteamNoEntry=Empty
StrSteamNoDateText=No Date

; Network/Premium
StrPremiumInOut=Bps In/Out.
StrPremiumNoData=In gacha debt.

; PrimaryBanner
; NOTE: [StrRegionISO] MUST be an ISO 639-1 standard region code for WeatherBanner to work.
StrRegionISO=en-US
StrWeatherStatDefault=Clear
StrWeatherCityDefault=SCHALE
StrWeatherCountryDefault=Kivotos

; SchaleFolder/MangaFolder
StrSchaleFolderName=File Explorer
StrSchaleFolderRightClick=<right-click>
StrMangaFolderLanguage=en
StrMangaNewChapterAlert=New Chapter(s) Available!
StrMangaFolderNoTitle=No Title
StrMangaFolderOpen=OPEN
StrMangaFolderClose=CLOSE
StrMangaFolderEmpty=EMPTY
StrMangaFolderError=ERROR
StrMangaFolderOffline=OFFLINE

; SideApps
StrSideVizName=Visualizer
StrSideNotesName=Notes
StrSideNotesWarningHeader=SENSITIVE DATA!
StrSideNotesWarningSubtext=Open the .txt in private.
StrSideNoFileAlert=No Files Found
StrSidePhoneName=Momotalk
StrSideRecycleBinFiles=Files, 
StrSideRecycleBinName=Recycle
; NOTE: Use the extra line provided below if the Recycle Bin string is too long. Otherwise, leave it blank.
StrSideRecycleBinNameExtra=Bag

; YouTubeBubble
; NOTE: [%T] will be replaced by the relevant time value. This is case sensitive.
StrYouTubeUploadString=Uploaded %T ago
; NOTE: [UploadTimes], [UploadPluralTimes] and [Punctuation] are directly correlated, i.e. the [n]th time value will be used alongside the [n]th punctuation. Exactly 6 entries are expected.
;       The values are delimited by horizontal lines (|).
;       If your language does not have plurals, match the [UploadPluralTimes] to be exactly the same as [UploadTimes].
StrYouTubeUploadTimes=min|hr|day|wk|mo.|yr
StrYouTubeUploadPluralTimes=mins|hrs|days|wks|mo.|yrs
StrYouTubeUploadPunctuation=!|!|!|.|...|...
StrYouTubeDefaultName=YouTube
StrYouTubeDefaultTitle=No Title
StrYouTubePleaseWaitMessage=Please wait a moment...
StrYouTubeNoEntriesMessage=Not Tracking Channels.
StrYouTubeUnavailability=RSS Unavailable.
StrYouTubeOfflineMessage=OFFLINE
StrYouTubeDownloadErrorMessage=ERROR
StrYouTubeConnectionErrorMessage=Connection/parse error.

; ========
; Sub Hubs
; ========

StrAronaGridActVer=Active Version
StrAronaGridAlert=Update Available!
StrDungeonListHeader=Search Query
StrDugeonListSearch=Search: 
StrQuestListAllHeader=All
StrQuestListCountLabel=Count
StrQuestListCompleteButton=Complete
StrQuestListRelistButton=Relist
StrQuestListDailyHeader=Daily
StrQuestListWeeklyHeader=Weekly
StrQuestListChallengesHeader=Challenges
StrQuestListMiscellaneousHeader=Miscellaneous
StrQuestListDailyTag=Daily
StrQuestListWeeklyTag=Weekly
StrQuestListChallengesTag=Challenges
StrQuestListMiscellaneousTag=Misc.
StrRaidListHeader=Game Select
StrRaidListAvailability=Games Available:
StrShopListDeselect=Deselect All
StrShopListOpen=Open
StrShopListSelectTotal=path(s) currently#CRLF#selected

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
StrIDSEntryPrompt=[Enter YouTube URL Here]
StrIDSNoEntry=- No ID Found -
StrIDSURL=Channel URL
StrIDSID=Channel ID
StrIDSClipAlert=Copied to Clipboard!
StrIDSTipHeader=Channel ID Tip
StrIDSDisclaimer=YouTube's code may continue to change in the future, possibly causing this tool to break again. If an output isn't generated with a valid YouTube URL, look for online tools or peek in Page Source yourself. #CRLF# #CRLF# A valid ID will always start with 'UC'.