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
; Steam has a limited set of supported languages. The list of supported language is as follows (last updated Jan 1 2025):
; schinese, japanese, koreana, thai, bulgarian, czech, danish, german, english, spanish, latam, greek, french, italian, indonesian, hungarian, dutch, norwegian, polish, portuguese, brazilian, romanian, russian, finnish, swedish, turkish, vietnamese, ukranian
StrSteamRegionType=english
StrSteamLoadingText=LOADING-
StrSteamNoUpdateText=NO_UPDATE
StrSteamNoEntry=EMPTY
StrSteamNoDateText=NO_DATE

; Network/Premium
StrPremiumInOut=BPS IN_OUT
StrPremiumNoData=NO_GACHA_DATA

; PrimaryBanner
; NOTE: [StrRegionISO] MUST be an ISO 639-1 standard region code for WeatherBanner to work.
StrRegionISO=en-US
StrWeatherStatDefault=CLEAR
StrWeatherCityDefault=SCHALE
StrWeatherCountryDefault=KIVOTOS

; SchaleFolder/MangaFolder
StrSchaleFolderName=WIN_DIR
StrSchaleFolderRightClick=RIGHT_CLICK_FILLER
StrMangaFolderLanguage=en
StrMangaNewChapterAlert=NEW_CHAPTER_ALERT
StrMangaFolderNoTitle=No Title
StrMangaFolderOpen=>OPN
StrMangaFolderClose=>CLS
StrMangaFolderEmpty=>MTY
StrMangaFolderError=>ERR
StrMangaFolderOffline=>OFFLN

; SideApps
StrSideVizName=VISUALIZER
StrSideNotesName=NOTES
StrSideNotesWarningHeader=WARN
StrSideNotesWarningSubtext=OPEN_.txt_WITH_CAUTION
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

; ========
; Sub Hubs
; ========

StrAronaGridActVer=INSTALL_VER
StrAronaGridAlert=NEW_VER
StrDungeonListHeader=SEARCH_HEADER
StrDugeonListSearch=SEARCH>>
StrQuestListAllHeader=ALL_TAB
StrQuestListCountLabel=COUNT
StrQuestListCompleteButton=FINISH
StrQuestListRelistButton=RELIST
StrQuestListDailyHeader=DAILY_TAB
StrQuestListWeeklyHeader=WEEKLY_TAB
StrQuestListChallengesHeader=HARD_TAB
StrQuestListMiscellaneousHeader=MISC_TAB
StrQuestListDailyTag=DAILY_TAG
StrQuestListWeeklyTag=WEEKLY_TAG
StrQuestListChallengesTag=HARD_TAG
StrQuestListMiscellaneousTag=MISC_TAG
StrRaidListHeader=GAME_HEADER
StrRaidListAvailability=GAME_AVAILABILITY
StrShopListDeselect=DESELECT
StrShopListOpen=OPEN
StrShopListSelectTotal=QUANTITY_SELECT#CRLF#TOTAL

; =============
; Dev Variables
; =============

; AppSettings
StrSettingImageFile=IMG_STR
StrSettingDisplayName=DSP_STR
StrSettingExecution=EXE_STR
StrSettingColorDefault=DFT_STR
StrSettingEyedropper=EYEDROPPER

; GlobalScalarSettings
StrGScaleAuto=AUTO TEXT
StrGScaleManual=MANUAL_TEXT#CRLF#INPUT_LIMIT [#MinScaleInput# - #MaxScaleInput#]
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

; MusicSettings
StrMSHeader=NOWPLAY
StrMSWelcomeMessage=< WELCOME PROMPT
StrMSActiveAppend=IS_ACTIVE
StrMSWebNowPlayingBlurb=WEBNOW BLURB
StrMSFilepathOverride=FILEPATH_INPUT
StrMSTooltipHeader=FILEPATH_TOOLTIP_HEADER
StrMSTooltipBody=FILEPATH_TOOLTIP_BODY
StrMSInfoHeader=NOWPLAYING_TOOLTIP
StrMSInfoTooltip=NOWPLAYING_TOOLTIP_BODY

; PhoneSettings
StrPSImage=IMG
StrPSDisplayName=DISPLAY
StrPSProcess=PRCS
StrPSExecution=EXEC

; TimeoutSettings
StrTOSHeader=SET_TIMEOUT
StrTOSSec=s
StrTOSTooltip=TIMEOUT_TOOLTIP

; VISettings
StrVISHeader=VIZ_SETTINGS
StrVisBarType=BAR_TYPE
StrVISFullBar=FULL
StrVISLinear=LIN
StrVISSquare=SQR
StrVISCircle=CRC
StrVISDiamond=DMD
StrVISWidth=WTH
StrVISHeight=HGT
StrVISPixelSize=PXL_SIZE
StrVISGapRatio=GAP_RATIO
StrVISGradientAngle=GRD_NGL
StrVISGradientPoint=GRD_PNT
StrVISFontSize=FONT_PT
StrVISContrast=CTRST

; Lang Settings
StrLangHeader=LANG
StrLangTooltip=OPEN_LANG_DIR

; ==============
; Edit Variables
; ==============

PaintColorHeader=COLOR_SET
PaintStyleHeader=STYLE_SET
PaintBannerSample=B_ARCHIVE
PaintAppSample=SCHALE
PaintBubbleSample=[K]IVOTOS
PaintRGB=RGB
PaintHSV=HSV
PaintA=A
PaintHex=(#) HEX
PaintImportPrompt=[PASTE_VAL]
PaintSFX=SND
PaintTooltipFontDir=OPEN
PaintTooltipApply=APPLY
PaintTooltipEyedropper=EYEDROPPER
PaintTooltipSave=SAVE
PaintTooltipCreate=CREATE
PaintTooltipRemove=REMOVE
PaintTooltipExport=EXPORT
PaintTooltipImport=IMPORT
PaintTooltipDiscard=DISCARD
PaintStyleDefault=<EMPTY>

; [%v] will be replaced by the value that is being edited. Is case sensitive.
;      [%v] is Used by: PaintSetBlurbChangeValue, PaintSetBlurbLoadPreset, PaintSetBlurbDeletedPreset, PaintSetBlurbExportSuccess, PaintSetBlurbImportSuccess
; [%o] will be replaced by the old value. Is case sensitive.
;      [%o] is Used by: PaintSetBlurbChangePreset, PaintSetBlurbChangeValue
; [%n] will be replaced by the new value. Is case sensitive.
;      [%n] is Used by: PaintSetBlurbChangePreset, PaintSetBlurbChangeValue
PaintBlurbReloaded=STYLE_INIT
PaintSetBlurbChangePreset=NAME_CHANGE %o -> %n
PaintSetBlurbChangeValue=%v: [%o] -> [%n]
PaintSetBlurbLoadPreset=LOAD %v.
PaintSetBlurbCreatePreset=CREATED_NEW
PaintSetBlurbDeletedPreset=DELETED %v
PaintSetBlurbSaved=SAVED
PaintSetBlurbExportFail=EXPORT_FAILURE
PaintSetBlurbExportSuccess=EXPORT SUCCESS - %v
PaintSetBlurbImportFail=IMPORT_FAILURE
PaintSetBlurbImportSuccess=IMPORT_SUCCESS - %v
PaintActiveEyedropper=WAITING_COLORPICK...
PaintCancelEyedropper=CANCELED_COLORPICK
PaintWaitingImport=WAITING_IMPORT
PaintAbortImport=ABORT_IMPORT
PaintMute=CHANGEMODE_MUTE
PaintUnmute=CHANGEMODE_UNMUTE
PaintWarn1=WARNING 1
PaintWarn2=WARNING 2
PaintWarn3=WARNING 3
PaintWarn4=BIG_WARNING 1
PaintWarn5=LAST_BIG_WARNING

PaintLegendBanner=BANNER
PaintLegendHeaderText=HEADER
PaintLegendInset=INSET
PaintLegendBrightHighlight=HIGHLIGHT
PaintLegendWealth=FULL_HL
PaintLegendBarOne=PRIMARY
PaintLegendBarTwo=SECONDARY
PaintLegendShadow=SHADOW
PaintLegendC1=TOP
PaintLegendC2=MIDDLE
PaintLegendC3=BOTTOM
PaintLegendC4=EXTRA
PaintLegendC5=INNER_LINE
PaintLegendC6=OUTER_LINE
PaintLegendC7=SHADOW
PaintLegendTray=TRAY
PaintLegendTrayShadow=SHADOW
PaintLegendTrayText=TEXT
PaintLegendCharm=CHARM
PaintLegendCharmBorder=CHARM_OUTLINE
PaintLegendStop=STOP
PaintLegendStopBorder=STOP_OUTLINE
PaintLegendOff=OFF
PaintLegendOffBorder=OFF_OUTLINE
PaintLegendPopUpBackground=BACKGROUND
PaintLegendPopUpText=TEXT
PaintLegendPopUpHighlight=HIGHLIGHT
PaintLegendPrimary=PRIMARY
PaintLegendSecondary=SECONDARY
PaintLegendPopUpCap=POPUPCAP
PaintLegendSkewX=SKEW
PaintLegendRoundness=ROUNDNESS
PaintLegendShadowAngle=CAST_ANGLE

PaintBlurbCount=3
PaintBlurb1=TIP 1
PaintBlurb2=TIP 2
PaintBlurb3=TIP 3
; PaintBlurb4=[ENDPOINT]
; PaintBlurb5=The Audio Visualizer skin has further style settings detached from this UI. Find it in its context menu!
; PaintBlurb6=The eyedropper tool is not perfect. If you want numerically equal colors it is best to transfer hex values.
; PaintBlurb7=Due to the structure of app icons, it is advised (but not mandated) to NOT use transparency for its colors.
; PaintBlurb8=App Icons can have their color assignments rearranged through a UI accessed from their context menu.
; PaintBlurb9=This UI does not support dragging elements. Scrub (scroll) numeric values for fine tuning.
; PaintBlurb10=Scroll your mousewheel over numeric values to scrub them by ±1. [Shadow Angle] will scrub by ±45.
; PaintBlurb11=A [Shadow Angle] value of 0 will instead put the shadow right underneath instead of at an angle of 0°/360°.
; PaintBlurb12=All numeric values have minimum and maximum values. "Bad" values will get clamped.
; PaintBlurb13=Third-party fonts still need to be manually installed. Get there by clicking on the Folder icon.
; PaintBlurb14=Invalid or not-yet-installed fonts will be defaulted to Arial by Rainmeter.
; PaintBlurb15="&" and "#" characters are reserved for export. They work locally, but try to avoid using them.

; ==============
; JSON Variables
; ==============

JSONUntitled=[UNTL]
JSONNoChanges=NO_CHANGE
JSONCreate=CREATE
JSONDelete=REMOVE
JSONDiscard=DISCARD
JSONSave=SAVE_AND_APPLY
JSONSavedReturn=SAVED
; [%v] is the value being edited. This is case sensitive.
; [%e] is the entry being edited. This is case sensitive.
; [%d] is the index in which the entry is placed. This is case sensitive.
JSONRemoved=REMOVED %v
JSONAdded=ADDED_AT %d
JSONMovedUp=MOVE_UP %v
JSONMovedDown=MOVE_DOWN %v
JSONModified=CHANGE %e: %v
JSONActivate=ENABLE %e: %v
JSONDeactivate=DISABLE %e: %v

JSON_name=NAME
JSON_enable=ACTIVE
JSON_aronagrid_dimensions=DIMENSION
JSON_aronagrid_image=IMG
JSON_aronagrid_class=CLASS
JSON_aronagrid_execution=EXEC
JSON_dungeonlist_description=DSCR
JSON_dungeonlist_image=IMG
JSON_dungeonlist_base_url=URL
JSON_layout_skin=SKIN
JSON_layout_variant=VAR
JSON_layout_main_only=MAIN_ONLY
JSON_manga_use_name=USE_NAME
JSON_manga_id=MANGA_ID
JSON_note_file_id=FILE_ID
JSON_note_sensitive=SECRET
JSON_premium_image=IMG
JSON_premium_seed=SEED
JSON_premium_maximum=MAX
JSON_premium_pullcost=COST
JSON_premium_message=MSG
JSON_questlist_class=CLASS
JSON_questlist_description=DSCR
JSON_questlist_count=COUNT
JSON_raidlist_subtext=SUBTXT
JSON_raidlist_image=IMG
JSON_raidlist_launch_text=TEXT
JSON_raidlist_execution=EXEC
JSON_shoplist_image=IMG
JSON_shoplist_launch_cost=COST
JSON_shoplist_path=PATH
JSON_steamevent_id=ID
JSON_youtube_use_name=USE_NAME
JSON_youtube_font_face=FONT
JSON_youtube_id=ID

; ====
; Tips
; ====

TIP_aronagridCount=7
TIP_aronagrid1=Up to a maximum of 12 entries can be created - any additional entries will be ignored. Bad/non-functioning elements still count towards the 12 if they are enabled.
TIP_aronagrid2=The dimensions parameter follows the structure of [x,y,w,h] without the brackets. X and Y are 0-indexed.
TIP_aronagrid3=Two special classes called [version] and [resources] exist. Specifying an entry with one of the two classes will enable unique features.
TIP_aronagrid4=Each special class may only be instanced once. The first entry that specifies itself of the class is given precedence.
TIP_aronagrid5=The [Execution] parameter follows the same syntax as a Rainmeter bang. The brackets must be omitted.
TIP_aronagrid6=If replicating a Rainmeter bang, only one bang is permitted with the start/end brackets omitted. If you need more than 1 Bang for your Path, it is probably unsuited for this environment.
TIP_aronagrid7=Button Image assets will treat @Resources\assets\largebuttons as its root directory. Store any image assets you would like to use in that folder.

TIP_dungeonlistCount=3
TIP_dungeonlist1=The string [%x] can be placed in the [Base URL] parameter where the search query will be substituted into.
TIP_dungeonlist2=Only a maximum of 3 entries can be enabled at a single time. Further entries are completely ignored.
TIP_dungeonlist3=Search Engine Image assets will treat @Resources\assets\searchicons as its root directory. Store any image assets you would like to use in that folder.

TIP_layoutCount=10
TIP_layout1=This is the MOST important database to maintain if you are using the ToggleSwitch. Remember to add every skin and the variant you use here so it gets properly switched on and off.
TIP_layout2=Order matters! The script goes down the list, (de)activating each skin one by one, effectively ignoring any load order values you used in Rainmeter. Bottommost skins first, topmost skins last.
TIP_layout3=Use backslash (\) and not forwardslash (/). Rainmeter automatically escapes the backslash so you don't (and shouldn't) type it twice.
TIP_layout4=The [Skin] parameter will start its pathfinding from the [Rainmeter\Skins] folder which by default should be installed in [Documents].
TIP_layout5=The [Variant] field can be left empty if the skin has only one variant. Empty entries will be displayed as "<empty>".
TIP_layout6=For [Variant], do NOT to append your entry with [.ini].
TIP_layout7=The [ToggleSwitch] and [ToggleOn] skins have hardcoded behaviors to be enabled/disabled. Putting them in the database is an unnecessary redundancy.
TIP_layout8=[Main Only] is a boolean parameter to specify whether or not a skin should only be active in the main hub.
TIP_layout9=TrayApps, regardless of the [Main Only] value are forced to be hidden in Sub Hubs. The only exception to this rule is the MusicApp. This behavior is enforced by the Tray skin.
TIP_layout10=TrayApps should have [Main Only] Toggled OFF. This is due to Rainmeter's overlapping skin issues when they are unloaded and reloaded live and has been addressed in the backend.

TIP_mangaCount=3
TIP_manga1=To adhere to the usage of the Mangadex API, there is an internal limit of 15 entries. Having more than 15 active manga entries will cause all manga entries beyond it to be ignored.
TIP_manga2=A valid manga id is a hexadecimal string in the format:#CRLF#[********-****-****-****-************]#CRLF#You can extract it from the manga's Home Page URL.
TIP_manga3=The order of your entries matter! Put your favorite ones up top so they're the first pages in your list.

TIP_noteCount=5
TIP_note1=DO NOT USE THIS SKIN TO STORE SENSITIVE INFORMATION. There is a SINGULAR feature that warns you about marked files so they are not immediately leaked, but it is NOT proper security. Store your passwords elsewhere.
TIP_note2=The [File ID] will only accept a numeric input. Rainmeter may permit negative and decimal numbers, but the script will simply ignore those characters (i.e. 123 is the same as -1.23), so keep that in mind.
TIP_note3=Changing/removing the last occurence of a File ID after its initial creation will destroy the file and all its contents, so do so with caution.
TIP_note4=If you wish to not use a file but save it for future use, disable the entry instead of outright deleting it so the file is preserved.
TIP_note5=Multiple entries can share the same File ID, linking them to the same .txt file. Why you would want to do that, I do not know.

TIP_premiumCount=7
TIP_premium1=The image parameter will start its pathfinding from the [@Resources\assets\currency] directory. It will be most convenient to put new image assets there.
TIP_premium2=Use "%p" in your message to substitute the total pulls in its place (e.g. 0-%p pulls today).
TIP_premium3=Do not put punctuation in your message. The script will automatically append the message with a period if it rolls <50% and an exclamation mark otherwise.
TIP_premium4=Some gacha games have multiple types of currencies for pulls. This widget is not smart enough to mix them, so you will have to pick one or make individual entries for each currency.
TIP_premium5=Some gacha games have discounted prices for multi-pulls. The best way to handle this is to set the [pullcost] to the cost of the multi-pull and specify in the [message] that it is a multi-pull.
TIP_premium6=You do not need to write in the exact values from the respective game into the fields. If for example you have a stash of 70,000 pyroxenes you're willing to spend, you can set that as the maximum.
TIP_premium7=While this skin was built with gacha games in mind, you can use this skin's framework to "resolve" any daily randomness with custom values such as a daily coinflip or your breakfast budget.

TIP_questlistCount=5
TIP_questlist1=The three predefined classes are "daily", "weekly" and "challenges". Using these classes will properly filter them in their respective tabs.
TIP_questlist2=Any non-specific class will be categorized under the Miscellaneous tab.
TIP_questlist3=An empty class string will be labeled as "Misc."
TIP_questlist4=Count should be a positive, non-zero integer.
TIP_questlist5=Dailies will automatically reset at midnight local time, and Weeklies will reset midnight once Saturday rolls over to Sunday.

TIP_raidlistCount=4
TIP_raidlist1="Disabled" entries will still be rendered, but grayed out. Attempts to launch a disabled game will be ignored.
TIP_raidlist2=The [Execution] parameter follows the same syntax as a Rainmeter bang. The brackets must be omitted.
TIP_raidlist3=If replicating a Rainmeter bang, only one bang is permitted with the start/end brackets omitted. If you need more than 1 Bang for your Path, it is probably unsuited for this environment.
TIP_raidlist4=Image assets will treat [@Resources\assets\gamebanners] as its root directory. Store any image assets you would like to use in that folder.

TIP_shoplistCount=7
TIP_shoplist1=While intended primarily for browser bookmarks and filepath shortcuts, any Rainmeter Bang (with brackets removed) will work in the [Path] parameter.
TIP_shoplist2=If replicating a Rainmeter bang, only one bang is permitted with the start/end brackets omitted. If you need more than 1 Bang for your Path, it is probably unsuited for this environment.
TIP_shoplist3=[Launch Cost] may be a non-numeric value and serve no functional purpose.
TIP_shoplist4=Local filepaths will always be marked with a shortcut icon.
TIP_shoplist5=Big Icon Image assets will treat [@Resources\assets\shopitems] as its root directory. Store any image assets you would like to use in that folder.
TIP_shoplist6=The [Path] parameter follows the same syntax as a Rainmeter bang. The brackets must be omitted.
TIP_shoplist7=If the link is found to be a browser path, its favicon will be downloaded and archived to be used as a currency icon. Otherwise, it will be identified as a shortcut.

TIP_steameventCount=2
TIP_steamevent1=The Steam ID of a game is a numeric value that can be found in the game's Home Page URL. For example, Team Fortress 2's ID is [440].
TIP_steamevent2=Steam's RSS feed follows the same georestrictions as the game. Double-check if the Steam game is available in your region before making an active entry for it.

TIP_youtubeCount=3
TIP_youtube1=Youtube RSS feeds work with a channel's UID. You can find a helper tool in the context menu of the YouTube skin where you can put in a channel's home page URL to extract the UID.
TIP_youtube2=There is an internal limit of 15 entries before they get ignored. This limit exists primarily so that the Scroll UI doesn't spill outside the skin boundaries.
TIP_youtube3=Order matters! Once all set up, you can quickly navigate between channels with the scroll bar if you organize your list properly and remember where each channel is indexed.