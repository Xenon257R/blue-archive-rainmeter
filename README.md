# Blue Archive - Rainmeter Suite
A full *Blue Archive* themed *Rainmeter* suite for your desktop. Does not come with wallpapers. This suite was built with ***form over function*** in mind and as such may fall behind more traditional, streamlined *Rainmeter* skins in terms of features. However, you're more than welcome to mix and match components of this suite with other Rainmeter Skins that are better tailored to your needs!

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
  - Includes *Rainmeter*, *Wallpaper Engine* and *Visual Settings* as defaults
- Master **Refresh** button
- Master **ToggleSwitch** button
  - Requires child button **ToggleOn** (on by default) to function properly
- Desktop (Sticky) Notes
- Audio visualizer (can be toggled)
- Discord shortcut
- Recycle Bin shortcut
- Mini Audio Player (collapsible)
- **File Explorer** shortcut
  - Variant: Manga tracker (uses the [Mangadex API](https://api.mangadex.org/docs/)) - still doubles as a **File Explorer** shortcut
- Steam Events marquee (uses the [Steam News Hub RSS Feed](https://store.steampowered.com/feeds/news/))
- YouTube Channel uploads marquee (uses the YouTube RSS Feed)
- Large taskbar tray
  - Includes a *S.C.H.A.L.E.* icon that can be used as a template
  - Includes Date & Time
  - Includes Master Audio App (of those supported by _Rainmeter_)

## Customization

This suite comes with built-in UIs to simplify the process of personalizing the Rainmeter setup beyond the loaded default. Visual settings can be directly accessed by clicking on the paint bucket icon located at the top right of your screen by default and comes with several curated presets.

`.json` files located under `@Resources\json\` hold databases that will require editing for various components. You may edit these files in an IDE or text editor manually, but a UI has been built to streamline this process for people unfamiliar with `.json` file formats or coding in general. This UI can be accessed by opening up the Context Menu of the appropriate Skin and clicking on the option _Edit Database_. The importance of these databases may vary depending on what features of the suite you choose to use. The skins that have relevant databases are as follows:

- ToggleSwitch\toggleswitch.ini
  - ToggleSwitch\ToggleOn\toggleon.ini
- SchaleFolder\mangafolder.ini
- Premium\premium.ini
- YouTubeBubble\bubble.ini
- EventBanner\eventbanner.ini
- SideApps\Notes\notes.ini

Settings beyond those provided by the UIs will require personal coding experience. The full codebase has been commented and formatted thoroughly and a breakdown of the indivdiual skins can be found (here) - hopefully, that should be enough for eager users to deconstruct how the suite works and enhance it for personal use.

## Additional Notes

The preset that comes with the `.rmskin` package will assume you have a 16:9 resolution and scale to your active window's height. This does not mean it will not work otherwise; it will just load up with subpar formatting, and it is up to you to adjust the position of skins to your specifications. Some skins such as the taskbar tray may require finer adjustments.

To reduce network consumption, every skin that connects to the internet to download information will only do it once in bulk during Rainmeter's startup. As such, displayed information such as a *YouTube* channel's latest upload should not be treated as live feed. You may manually force an information update by using the **Refresh** button, toggling on and off the suite using the **ToggleSwitch** button or refreshing Rainmeter as a whole.
- The one exception to this rule is the **Primary Banner**, which updates on its own once every hour (minute if the variant is the **User Level**).

If instead of downloading the `.rmskin` package you have decided to download the repository via `.zip` or similar as you feel that it is a better starting point to personalize this suite, you will have to download one `.dll` package separately as it only comes bundled with the `.rmskin` file. This `.dll` is the **ConfigActive** plugin written by _jsmorley_ that is used by the `eventbanner.ini` config to detect if the **Audio Visualizer** is active or not, (un)hiding itself appropriately. If you desire this behavior, you may download this plugin manually [here](https://forum.rainmeter.net/viewtopic.php?t=28720).