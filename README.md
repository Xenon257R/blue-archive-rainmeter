# Blue Archive - Rainmeter Suite
A full *Blue Archive* themed *Rainmeter* suite for your desktop. Does not come with wallpapers. This suite was built with ***form over function*** in mind and as such may fall behind more traditional, streamlined *Rainmeter* skins in terms of easily customizable features.

Before use, it is advised to carefully read through every skin's **Information** tag and understand the features of each one to see which skins and variants are best suited for you.

## Feature List
- Primary Banner displaying user level (decorative)
  - Variant: Weather display (uses [Weather.com](https://weather.com)'s API)
- Battery life display
  - Variant: Login duration display (partially decorative)
- Free storage space counter
- Network In/Out speed display
  - Daily pseudo-random premium currency generator (decorative)
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
- **File Explorer** shortcut
  - Variant: Manga tracker (uses the [Mangadex API](https://api.mangadex.org/docs/)) - still doubles as a **File Explorer** shortcut
- *Steam News* marquee (uses the [Steam News Hub RSS Feed](https://store.steampowered.com/feeds/news/))
- *YouTube* channel uploads marquee (uses the YouTube RSS Feed)
- Large taskbar tray
  - Includes a *SCHALE* icon that can be used as a template
    - also has simplified version
  - Displays Date & Time
  - Includes Master Audio App (of those supported by _Rainmeter_)

The suite also comes with a small set of default icons for common *Windows* directories, popular web browsers, several _Rainmeter_ supported music players and halos of various *Blue Archive* characters.

## Installation and Setting Up
As this is not your typical modular skin and instead a fully fleshed-out suite, it will require a little bit of patience to set up.
1. First, download the latest version of the suite here: [put link here]
2. Install the skin by double clicking the .rmskin file
3. At this point, you can either refer to one of two webpages to complete your setup:
   - The Beginner's Guide on *Steam Guides*, serving as a tutorial to those who may be unfamiliar or inexperienced with *Rainmeter*
   - The GitHub Wiki, serving as a manual that goes in-depth for individual skins
4. And you're done!

## Customization
This suite comes with built-in UIs to simplify the process of personalizing the *Rainmeter* setup beyond the loaded default. This includes visual settings, database settings, global scaling, and more! Refer to the documentation on either of the webpages mentioned above to see how each skin can be customized, or you can poke around buttons and context menus and find out from your own curiosity.

## Additional Notes
The preset that comes with the `.rmskin` package will assume you have a 16:9 resolution and scale to your active window's height. This does not mean it will not work otherwise; it will still make its best attempt for the initial setup and in theory should only fail spectacularly if you have a narrow screen. It is up to you to adjust the position and size of skins to your specifications.

To reduce network consumption, every skin that connects to the internet to download information will only do it once in bulk during Rainmeter's startup and when at least an hour as elapsed since the last check. As such, displayed information such as a *YouTube* channel's latest upload should not be treated as live feed.
- The one exception to this rule is the **Primary Banner**, which updates on its own once every hour (minute if the variant is the **User Level**).

## Credits

- [Weather.com V3 JSON](https://forum.rainmeter.net/viewtopic.php?f=118&t=34628#p171501) - JSMorley
- [ConfigActive Plugin](https://github.com/jsmorley/ConfigActive) - JSMorley
- [CursorColor Plugin](https://github.com/jsmorley/PluginColorCursor) - JSMorley

**Disclaimer:** This skin, fully inspired by _Blue Archive_, is a fan-made project and not directly affiliated with it. All rights remain with the developer and publisher of *Blue Archive*: NAT GAMES and Yostar.