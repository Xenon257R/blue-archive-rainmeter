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
; Steam has a limited set of supported languages. The list of supported language is as follows (last updated Jan 1 2025):
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
StrSettingEyedropper=Eyedropper Tool

; GlobalScalarSettings
StrGScaleAuto=The suite is currently automated to generate a scalar from your screen resolution's height.
StrGScaleManual=The scalar has been changed manually and will no longer auto-scale. Values are limited between [#MinScaleInput# - #MaxScaleInput#], inclusive.
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

; MusicSettings
StrMSHeader=NowPlaying
StrMSWelcomeMessage=< Hover over an ID on the left to see its supported players.
StrMSActiveAppend=is currently active.
StrMSWebNowPlayingBlurb=•This option uses the WebNowPlaying plugin, supporting various web-based music services.
StrMSFilepathOverride=Filepath Override
StrMSTooltipHeader=Specifying a Filepath Override
StrMSTooltipBody=This section is for overriding the filepath "OpenPlayer" executes with Rainmeter's MusicPlayer plugin. The same can be done in rewiring the "MusicApp" skin under "Execution" with Rainmeter bangs, and is the preferred option if using the "Web" player.
StrMSInfoHeader=NowPlaying Support
StrMSInfoTooltip=Supported types of NowPlaying will continue to update as Rainmeter changes, so this list may become outdated. #CRLF##CRLF# If an option does not appear to be working (outside of Web, which has its own documentation), DOUBLE-CLICK this info icon to open the "Fully supported players" list on the official Rainmeter webpage to check the most up-to-date information.

; PhoneSettings
StrPSImage=IMAGE
StrPSDisplayName=DISPLAY NAME
StrPSProcess=PROCESS
StrPSExecution=EXECUTION

; TimeoutSettings
StrTOSHeader=Timeout Value
StrTOSSec=sec
StrTOSTooltip=Setting the value to 0 or less will disable the timeout feature.

; VISettings
StrVISHeader=Visualizer Settings
StrVisBarType=BAR TYPE
StrVISFullBar=Full Bar
StrVISLinear=Linear
StrVISSquare=Square
StrVISCircle=Circle
StrVISDiamond=Diamond
StrVISWidth=WIDTH
StrVISHeight=HEIGHT
StrVISPixelSize=PIXEL SIZE
StrVISGapRatio=GAP RATIO
StrVISGradientAngle=G. ANGLE
StrVISGradientPoint=G. POINT
StrVISFontSize=FONT SIZE
StrVISContrast=CONTRAST

; Lang Settings
StrLangHeader=Language
StrLangTooltip=Open Language Folder

; ==============
; Edit Variables
; ==============

PaintColorHeader=Color Settings
PaintStyleHeader=Style Settings
PaintBannerSample=Blue Archive
PaintAppSample=SCHALE
PaintBubbleSample=[K]ivotos
PaintRGB=RGB
PaintHSV=HSV
PaintA=A
PaintHex=(#) HEX
PaintImportPrompt=[Paste Exported String Here]
PaintSFX=SFX
PaintTooltipFontDir=Open Font Directory
PaintTooltipApply=Apply Changes
PaintTooltipEyedropper=Eyedropper Tool
PaintTooltipSave=Save All Changes
PaintTooltipCreate=Create New Preset
PaintTooltipRemove=Remove Selected Preset
PaintTooltipExport=Export Preset String
PaintTooltipImport=Import Preset String
PaintTooltipDiscard=Discard All Unsaved Changes
PaintStyleDefault=<empty>

; [%v] will be replaced by the value that is being edited.
;      [%v] is Used by: PaintSetBlurbChangeValue, PaintSetBlurbLoadPreset, PaintSetBlurbDeletedPreset, PaintSetBlurbExportSuccess, PaintSetBlurbImportSuccess
; [%o] will be replaced by the old value.
;      [%o] is Used by: PaintSetBlurbChangePreset, PaintSetBlurbChangeValue
; [%n] will be replaced by the new value.
;      [%n] is Used by: PaintSetBlurbChangePreset, PaintSetBlurbChangeValue
PaintBlurbReloaded=Color & Style settings (re)loaded.
PaintSetBlurbChangePreset=Changed preset name from %o to %n.
PaintSetBlurbChangeValue=%v's value changed from [%o] to [%n].
PaintSetBlurbLoadPreset=Loaded %v preset.
PaintSetBlurbCreatePreset=Created and selected new untitled default preset.
PaintSetBlurbDeletedPreset=Deleted %v preset.
PaintSetBlurbSaved=Saved all changes!
PaintSetBlurbExportFail=Export failed. The selected preset is using one or more reserved characters: '&' and/or '#'.
PaintSetBlurbExportSuccess=Exported selected preset [%v] onto clipboard.
PaintSetBlurbImportFail=Imported string is incompatible or corrupted.
PaintSetBlurbImportSuccess=Successfully imported [%v] preset.
PaintActiveEyedropper=Selecting color with Eyedropper Tool...
PaintCancelEyedropper=Canceled Eyedropper Tool.
PaintWaitingImport=Waiting for import string... (Input box may not appear due to native InputText limitations, if so click button again)
PaintAbortImport=Import dismissed.
PaintMute=Muted all sound effects. Changes will be applied after refresh.
PaintUnmute=Enabled all sound effects. Changes will be applied after refresh.
PaintWarn1=Changes you have made haven't been saved. Applying changes will refresh this skin, discarding all changes.
PaintWarn2=Rainmeter makes it hard to refresh all skins BUT one. It is advised to save your changes before loading a preset.
PaintWarn3=SAVE YOUR PRESETS. The button is highlighted and located to the right of the eyedropper tool.
PaintWarn4=You WILL lose unsaved changes. Are you sure about loading the preset now?
PaintWarn5=Only the applied and previously saved presets can be recovered. This is your last warning!

PaintLegendBanner=Banner
PaintLegendHeaderText=Header Text
PaintLegendInset=Inset
PaintLegendBrightHighlight=Highlight
PaintLegendWealth=Full Highlight
PaintLegendBarOne=Primary Color
PaintLegendBarTwo=Fade Color
PaintLegendShadow=Shadow
PaintLegendC1=Top
PaintLegendC2=Middle
PaintLegendC3=Bottom
PaintLegendC4=Extraneous
PaintLegendC5=Inner Border
PaintLegendC6=Outer Border
PaintLegendC7=Shadow
PaintLegendTray=Tray
PaintLegendTrayShadow=Shadow
PaintLegendTrayText=Text
PaintLegendCharm=Charm Color
PaintLegendCharmBorder=Charm Border
PaintLegendStop=Stop Color
PaintLegendStopBorder=Stop Border
PaintLegendOff=Off Color
PaintLegendOffBorder=Off Border
PaintLegendPopUpBackground=Background
PaintLegendPopUpText=Text
PaintLegendPopUpHighlight=HighlightText
PaintLegendPrimary=PrimaryFont
PaintLegendSecondary=SecondaryFont
PaintLegendPopUpCap=PopUpCap
PaintLegendSkewX=SkewX
PaintLegendRoundness=Roundness
PaintLegendShadowAngle=ShadowAngle

PaintBlurbCount=15
PaintBlurb1=This Settings UI launches with no preset selected - it instead loads your active style.
PaintBlurb2=Newly created presets will always start with the Blue Archive default settings.
PaintBlurb3=You can copy presets or save an active, unsaved style by exporting it and importing it back in.
PaintBlurb4=You can navigate to different color sections by clicking on the elements in the top right section.
PaintBlurb5=The Audio Visualizer skin has further style settings detached from this UI. Find it in its context menu!
PaintBlurb6=The eyedropper tool is not perfect. If you want numerically equal colors it is best to transfer hex values.
PaintBlurb7=Due to the structure of app icons, it is advised (but not mandated) to NOT use transparency for its colors.
PaintBlurb8=App Icons can have their color assignments rearranged through a UI accessed from their context menu.
PaintBlurb9=This UI does not support dragging elements. Scrub (scroll) numeric values for fine tuning.
PaintBlurb10=Scroll your mousewheel over numeric values to scrub them by ±1. [Shadow Angle] will scrub by ±45.
PaintBlurb11=A [Shadow Angle] value of 0 will instead put the shadow right underneath instead of at an angle of 0°/360°.
PaintBlurb12=All numeric values have minimum and maximum values. "Bad" values will get clamped.
PaintBlurb13=Third-party fonts still need to be manually installed. Get there by clicking on the Folder icon.
PaintBlurb14=Invalid or not-yet-installed fonts will be defaulted to Arial by Rainmeter.
PaintBlurb15="&" and "#" characters are reserved for export. They work locally, but try to avoid using them.

; ==============
; JSON Variables
; ==============

JSONUntitled=[Untitled]
JSONNoChanges=No changes made.
JSONCreate=Create New Entry
JSONDelete=Remove Selected Entry
JSONDiscard=Discard All Unsaved Changes
JSONSave=Save & Apply Changes
JSONSavedReturn=Saved and applied all changes!
; [%v] is the value being edited. This is case sensitive.
; [%e] is the entry being edited. This is case sensitive.
; [%d] is the index in which the entry is placed. This is case sensitive.
JSONRemoved=Removed %v.
JSONAdded=Added new empty element at index %d.
JSONMovedUp=Moved %v up 1 index.
JSONMovedDown=Moved %v down 1 index.
JSONModified=Changed %e's [%v] parameter.
JSONActivate=Enabled %e's [%v] parameter.
JSONDeactivate=Disabled %e's [%v] parameter.

JSON_name=Name
JSON_enable=Enable
JSON_aronagrid_dimensions=Dimensions
JSON_aronagrid_image=Image
JSON_aronagrid_class=Class
JSON_aronagrid_execution=Execution
JSON_dungeonlist_description=Description
JSON_dungeonlist_image=Image
JSON_dungeonlist_base_url=Base URL
JSON_layout_skin=Skin
JSON_layout_variant=Variant
JSON_layout_main_only=Main Only
JSON_manga_use_name=Use Name
JSON_manga_id=ID
JSON_note_file_id=File ID
JSON_note_sensitive=Sensitive
JSON_premium_image=Image
JSON_premium_seed=Seed
JSON_premium_maximum=Maximum
JSON_premium_pullcost=Pull Cost
JSON_premium_message=Message
JSON_questlist_class=Class
JSON_questlist_description=Description
JSON_questlist_count=Count
JSON_raidlist_subtext=Subtext
JSON_raidlist_image=Image
JSON_raidlist_launch_text=Launch Text
JSON_raidlist_execution=Execution
JSON_shoplist_image=Image
JSON_shoplist_launch_cost=Launch Cost
JSON_shoplist_path=Path
JSON_steamevent_id=ID
JSON_youtube_use_name=Use Name
JSON_youtube_font_face=Font Face
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