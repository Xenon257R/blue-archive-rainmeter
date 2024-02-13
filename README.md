![BA Suite Showcase GIF](@Resources/_meta/preview.gif)

<sub>Sources for the wallpaper are listed [at the end of the README](https://github.com/Xenon257R/blue-archive-rainmeter#showcase-wallpaper-sources).</sub>

# Blue Archive - Rainmeter Suite
A full *Blue Archive* themed *Rainmeter* suite for your desktop. Does not come with wallpapers. This suite was built with ***form over function*** in mind and as such may fall behind more traditional, streamlined *Rainmeter* skins in terms of easily customizable and optimized features.

Before use, it is advised to carefully read through every skin's **Information** tag and understand the features of each one to see which skins and variants are best suited for you.

## Feature List
- Primary Banner displaying user level (decorative)
  - Variant: Weather display (uses [Weather.com](https://weather.com)'s API)
- Battery life display
  - Variant: Login duration display (partially decorative)
- Free storage space counter
- Daily pseudo-random premium currency generator (decorative)
  - Variant: Network In/Out speed display
- General Options tray
  - Includes *Resource Monitor*, *Rainmeter* and *Style Settings* as defaults
- Master **Refresh** button
- Master **ToggleSwitch** button
  - Requires child button **ToggleOn** (on by default) to function properly
- Desktop "Sticky" Notes
- Audio visualizer (can be toggled)
- Social App of choice shortcut
- Recycle Bin shortcut
- Mini Audio Player (collapsible)
  - **v1.1.0** - Now supports [WebNowPlaying](https://github.com/keifufu/WebNowPlaying-Redux-Rainmeter) out the box; external plugins as specified by the documentation is still required for full functionality
- **File Explorer** shortcut
  - Variant: Manga tracker (uses the [Mangadex API](https://api.mangadex.org/docs/)) - still doubles as a **File Explorer** shortcut
  - **v1.1.0** - Both variants have a slot for a right-click function editable in the context menu
- *Steam News* marquee (uses the [Steam News Hub RSS Feed](https://store.steampowered.com/feeds/news/))
- *YouTube* channel uploads marquee (uses the YouTube RSS Feed)
- Large taskbar tray
  - Includes a *SCHALE* icon that can be used as a template
    - also has simplified version
  - Displays Date & Time
  - Includes Master Audio App (of those supported by _Rainmeter_ and WebNowPlaying)
- **v1.1.0** - [List/Grid Submenus]((https://github.com/Xenon257R/blue-archive-rainmeter#sub-hubs))
  - Arona Main Hub style **System Grid**, best used for OS Shortcuts, System Metrics, etc.
  - Sora Angel 24 Shop style **Bookmarks and Shortcuts List**, best used as both webpage bookmarks and general directory shortcuts
  - Momoka Daily Dungeon style **Search Engine List**, best used for search engine shortcuts
  - Rin Weekly Raid style **Game List**, best used as a game catalogue/launcher hub
  - Ayumu Tasks style **Task List**, best used for tracking progress and completion of achieveable goals
    - Dailies and weeklies automatically reset appropriately
  - Aoi - no style, but her L2D wallpaper from the wallpaper collection can be mix & matched with any of the above styles as you wish

The suite also comes with a small set of default icons for common *Windows* directories, popular web browsers, several _Rainmeter_ supported music players and halos of various *Blue Archive* characters.

## Installation and Setting Up
This suite has been tested for Windows 10 and *Rainmeter* version **4.5.17** and above.

As this is not your typical modular skin and instead a fully fleshed-out suite, it will require a little bit of patience to set up.
1. You will first need the latest version of *Rainmeter* which you can get on [their official website](https://www.rainmeter.net/)
2. Download the latest version of the suite in the [Releases page here](https://github.com/Xenon257R/blue-archive-rainmeter/releases)
3. Install the skin by double clicking the `.rmskin` file
4. At this point, you can refer to one of two (or both!) webpages to complete your setup:
   - The [Beginner's Guide](https://steamcommunity.com/sharedfiles/filedetails/?id=2864554818) on *Steam Guides*, serving as a tutorial to those who may be unfamiliar or inexperienced with *Rainmeter*
     - Will go partially in-depth about the optional *Wallpaper Engine* component as well
   - The [GitHub Wiki](https://github.com/Xenon257R/blue-archive-rainmeter/wiki), serving as a manual that goes in-depth for individual skins
5. And you're done!

## Customization
This suite comes with built-in UIs to simplify the process of personalizing the *Rainmeter* setup beyond the loaded default. This includes visual settings, database settings, global scaling, and more! Refer to the documentation on either of the webpages mentioned above to see how each skin can be customized, or you can poke around buttons and context menus and find out from your own curiosity.

## Sub Hubs
![BA Suite Sub Hub Showcase GIF](@Resources/_meta/preview2.gif)

<sub>The full WallpaperEngine collection showcased here is listed [at the end of the README](https://github.com/Xenon257R/blue-archive-rainmeter#showcase-wallpaper-sources).</sub>

With the **v1.1.0 Update**, the suite now comes with submenus! They are inactive by default and are meant to be used as secondary UIs and can be ignored if you do not intend to use it. The `.rmskin` installation will come with a layout for a Sub Hub if your intent is to use it as your primary, unchanging configuration. Their intended purpose is for `List` skins, as they are more interactive - and more importantly, large - to be directly integrated to the main layout. Not to mention, in the actual *Blue Archive* game, they *are* submenus, so might as well commit to the part!

To properly utilize them, you must write specific commands and bind them to `MouseAction`s. Further details can be found in both the *Steam Guide* and the *GitHub Wiki*.

## Custom App Icons
[This GoogleDrive](https://drive.google.com/drive/folders/1OVEtbCvVYwbtnVyXGevAI2oaCRHt1O_t) currently contains all icons plus custom/specialty icons that didn't have a reason to be in the installation package. Most new icons will be added to this Drive so that the repository doesn't become bloated with just new icon releases and is free from the risk of getting too large.

I've written a spritesheet breakdown for the complex app icons that this suite utilizes in both the Steam Guide and the Wiki in their respective TrayApps sections, and hopefully it explains things well enough that you can draw up your own!

If you are unable to draw your own adaptive assets and would like to request one, you are welcome to open an Issue with the `icon request` label with the icon you would like to be re-themed for this suite. I cannot promise I will deliver 100% - my artistic skills are near strictly geometric shapes, so simpler icons will be easier for me to tackle as opposed to highly detailed ones. However, I will make sure I give a response so you know whether I'm tackling it or not!

## Additional Notes
The presets that comes with the `.rmskin` package will assume you have a 16:9 resolution and scale to your active window's height. This does not mean it will not work otherwise; it will still make its best attempt for the initial setup and in theory should only fail spectacularly if you have a narrow screen. It is up to you to adjust the position and size of skins to your specifications.

To reduce network consumption, every skin that connects to the internet to download information will only do it once in bulk during Rainmeter's startup and when at least an hour has elapsed since the last check. As such, displayed information such as a *YouTube* channel's latest upload should not be treated as live feed.
- The one exception to this rule is the **Primary Banner**, which updates on its own once every hour (minute if the variant is the **User Level**).

This suite does **NOT** intend to serve as a full replacement of various services such as the [Steam News Hub](https://store.steampowered.com/news/) as it does not aim to replicate their full feature list - it is just miniature widget for tracking updates. Treat skins like YouTubeBubble as a fancy, themed bookmark and nothing more.

## Credits

- [Weather.com V3 JSON](https://forum.rainmeter.net/viewtopic.php?f=118&t=34628#p171501) - JSMorley
- [ConfigActive Plugin](https://github.com/jsmorley/ConfigActive) - JSMorley
- [CursorColor Plugin](https://github.com/jsmorley/PluginColorCursor) - JSMorley
- [WebNowPlaying Plugin](https://github.com/keifufu/WebNowPlaying-Redux-Rainmeter) - keifufu

**Disclaimer:** This suite is a fan-made project inspired by *Blue Archive* and not directly affiliated with it. Copyright remains with the developer and publisher of *Blue Archive*: Nexon, NAT GAMES and Yostar.

### Showcase Wallpaper Sources
- [Blue Archive Konuri Maki - Fully Interactive L2D](https://steamcommunity.com/sharedfiles/filedetails/?id=2945479388) by Xenon257R
  - Is also part of the Mini-Collection listed below
- [Pokémon HM03 (Surf)](https://steamcommunity.com/sharedfiles/filedetails/?id=2869069229) by ITZAH
- [도기코기 DoggieCorgi](https://steamcommunity.com/sharedfiles/filedetails/?id=1661383396) by (Han)dals and stgoindol
- [Bell Tower / Pokemon Heartgold](https://steamcommunity.com/sharedfiles/filedetails/?id=2292763401) by JD
- [Evangelion Beserk Mode](https://steamcommunity.com/sharedfiles/filedetails/?id=1626467688) by T1T0
- [*Bliss*](https://en.wikipedia.org/wiki/Bliss_(image)), photograph by Charles O'Rear
---
- [Fully Interactive Blue Archive L2D Mini-Collection](https://steamcommunity.com/sharedfiles/filedetails/?id=2956165539) by Xenon257R