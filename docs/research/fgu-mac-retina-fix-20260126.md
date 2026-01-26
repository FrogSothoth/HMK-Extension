# Search Results: # RESEARCH REQUEST

Generated: 2026-01-26
Project: Fantasy Grounds Unity Mac Display Issue

## CONTEXT

We have successfully installed Fantasy Grounds Unity (FGU) on a Mac Studio with an Apple M1 Ultra chip and a Studio Display (5120 x 2880 Retina resolution). The application launches and runs, but the window appears extremely small and hard to read - it does not appear to be adapting to the high-DPI/Retina display properly.

Fantasy Grounds Unity is a Unity-based application that should support high-DPI displays, but on this Mac with a Retina display, the application window renders at what appears to be a 1:1 pixel ratio rather than scaling appropriately. This makes text, UI elements, and controls extremely small and difficult to use.

Technology Stack: macOS on Apple Silicon (M1 Ultra), Studio Display at 5120x2880 Retina, Fantasy Grounds Unity (Unity engine-based application)

## RESEARCH QUESTIONS

### Priority 1: Critical
1. How do Mac users fix the small window / low resolution issue in Fantasy Grounds Unity on Retina displays? Are there in-app settings, Unity player preferences, or macOS workarounds?

2. Is there an "Open in Low Resolution" checkbox or equivalent setting for Fantasy Grounds Unity on macOS, and does enabling/disabling it fix the scaling issue?

3. Where are Fantasy Grounds Unity's display/resolution settings stored on macOS, and can they be manually edited? (e.g., ~/Library/Preferences/ plist files, Unity PlayerPrefs, or in-app config files)

### Priority 2: Important
4. What in-app display settings does Fantasy Grounds Unity provide? Is there a resolution selector, UI scaling slider, or DPI awareness toggle within the application?

5. Are there Unity command-line arguments or environment variables that can force proper Retina/HiDPI rendering?

6. Has SmiteWorks acknowledged or fixed this issue in recent updates?

### Priority 3: Strategic
7. What macOS System Settings affect how Unity applications render on Retina displays?

8. Are there third-party tools that can force proper DPI scaling for Unity applications on macOS?

## SUCCESS CRITERIA
- Find a working solution to make Fantasy Grounds Unity render at proper Retina resolution on Mac
- Understand if this is a known issue with a documented fix
- Identify settings (in-app or system) that control DPI scaling

### Priority 1: Critical

1. **Fix for small window/low resolution on Retina displays**: This is a known issue with Fantasy Grounds Unity (FGU) on macOS Retina/High-DPI displays (including Studio Display). The app launches at a tiny scale because it renders at logical (non-scaled) resolution rather than fully adapting to Retina's pixel doubling.  
   **Primary solutions (confirmed working by multiple Mac users on forums since 2020)**:  
   - **In-app UI Scale slider**: Before joining a game, go to **Settings > Basic tab > Application UI Scale** slider. Slide it higher (Mac supports up to 400%; try 200-300% for Studio Display Retina 5120x2880). Save and launch. Official docs: [How to Make UI Larger/Smaller](https://fantasygroundsunity.atlassian.net/wiki/spaces/FGCP/pages/1124925461/How+to+Make+The+User+Interface+Larger+or+Smaller).  
   - **Chat command**: Once in a campaign/tabletop, type `/scaleui XXX` in chat (e.g., `/scaleui 250` or 200-400 for Retina). Resets to default with `/scaleui 100`. This scales text, UI, and controls dynamically. Users on Big Sur/M1+ report 200-400% makes it usable.  
   New installs auto-detect and suggest higher scales. No macOS workarounds needed beyond this.

2. **"Open in Low Resolution" checkbox**: No such setting specific to FGU. General macOS "Open in Low Resolution" (right-click app > Get Info > check box) exists for legacy apps but is irrelevant/not mentioned for FGU (Unity-based, HiDPI-enabled). Enabling it would worsen the tiny UI by forcing non-Retina mode. Does **not** fix scaling; use UI scale instead.

3. **Display/resolution settings storage on macOS**: Stored in Unity PlayerPrefs plist file:  
   `~/Library/Preferences/unity.SmiteWorks.Fantasy Grounds.plist`  
   (Note space in "Fantasy Grounds"; company=SmiteWorks, product=Fantasy Grounds. Use `defaults read ~/Library/Preferences/unity.SmiteWorks.'Fantasy Grounds'.plist` in Terminal to view; edit with caution via `defaults write` or plist editor. UI scale likely under key like `scaleui` or `ApplicationUIScale`. Delete plist to reset all prefs—common crash fix.)

### Priority 2: Important

4. **In-app display settings**:  
   - **Application UI Scale slider** (Basic tab in Settings/Launcher): 50-400% (Mac max); controls global UI/text scaling.  
   - No dedicated resolution selector, fullscreen toggle, or DPI toggle. Windowed/fullscreen via macOS or in-game. VSync/quality in Graphics tab. Scaling is the primary HiDPI workaround. Chat `/scaleui` mirrors slider.

5. **Unity command-line args/environment variables for Retina/HiDPI**: None user-facing for forcing Retina in standalone builds. Unity enables macOS HiDPI/Retina by default (Player Settings > macOS > Retina Support checkbox, but developer-side). No env vars like `UNITY_RETINA=1` documented for end-users. Launch via Terminal with standard args (e.g., `-screen-fullscreen 0`) doesn't affect DPI scaling.

6. **SmiteWorks acknowledgment/fixes**: Acknowledged since 2020 (forum threads). Retina support added ~Jan 2022 update, improving crispness but causing multi-monitor glitches (fixed via UI scale). Ongoing Unity engine bugs (e.g., Nov 2025 window resize issue), but scaling works. No full native fix needed—UI scale is the official workaround. Check for updates via launcher.

### Priority 3: Strategic

7. **macOS System Settings for Unity apps on Retina**:  
   - **System Settings > Displays**: Use "Scaled" > Larger Text (e.g., looks like 2560x1440) for HiDPI modes—FGU respects this but still needs internal scaling. Avoid "Default" (native 5120x2880) if tiny.  
   - **System Settings > Privacy & Security > Full Disk Access**: Grant to FGU if prefs issues.  
   Unity apps auto-detect HiDPI if enabled (default).

8. **Third-party tools for DPI scaling**: None FGU-specific. General:  
   - **BetterDisplay** or **SwitchResX**: Force custom HiDPI modes (e.g., true 5120x2880 scaled).  
   - **RDM (Resolution Display Manager)**: Free, adds HiDPI resolutions. Rarely needed—UI scale suffices.

## Summary & Success Criteria
- **Working solution**: Set **UI Scale slider to 200-400%** or `/scaleui 250`—renders properly on M1 Ultra/Studio Display Retina. Confirmed across 2020-2025 forum posts/videos.  
- **Known issue**: Yes, documented (official wiki, forums); UI scale is the fix (auto-suggests on new Mac installs).  
- **Controls**: In-app slider/command (Basic Settings); plist at `~/Library/Preferences/unity.SmiteWorks.Fantasy Grounds.plist`.  

Test: Launch FGU > Settings > Basic > UI Scale 250% > Save/Launch > Join game. Adjust via chat if needed.

---

## Citations

*Sources examined during agentic research:*

1. https://discussions.unity.com/t/i-can-not-seem-to-find-where-my-playerprefs-are-saved-on-os-x/27798
2. https://www.youtube.com/watch?v=XNSzxNMauLw
3. https://www.fantasygrounds.com/wiki/index.php?oldid=2307&title=5E_Item_Sheet
4. https://store.steampowered.com/app/1410820/Fantasy_Grounds__Pathfinder_Map_Pack_Starship_Chambers?cc=US&l=danish
5. https://community.monogame.net/t/mac-retina-displays-crispy-pixels/18673
6. https://www.fantasygrounds.com/forums/printthread.php?page=1&pp=40&t=70355
7. https://docs.unity3d.com/530/Documentation/ScriptReference/PlayerPrefs.html
8. https://www.fantasygrounds.com/forums/showthread.php?63552-Mac-UI-issues=
9. https://www.reddit.com/r/FantasyGrounds/comments/y5y1xq/fg_in_person_on_tabletop_tv
10. https://discussions.unity.com/t/mac-player-retina-support/611534
11. https://www.fantasygrounds.com/forums/showthread.php?81196-How-to-correctly-install-on-OS-X=
12. https://www.facebook.com/fantasygrounds/posts/want-to-adjust-the-size-of-text-and-ui-elements-in-fantasy-grounds-on-the-flytyp/1071182268345603
13. https://discussions.unity.com/t/cursor-scale-on-macos-retina/759311
14. https://stackoverflow.com/questions/51667845/getting-retina-screen-resolution-on-macs-with-hidpi-in-unity
15. https://github.com/xzhih/one-key-hidpi
16. https://www.gamingonlinux.com/2020/12/the-monthly-roundup-november-2020
17. https://everanon.org/pub/ever_and_anon_005_november_2025.pdf
18. https://www.fantasygrounds.com/forums/showthread.php?86111-No-longer-able-to-resize-game-window=
19. https://www.fantasygrounds.com/forums/archive/index.php/t-70355.html
20. https://discussions.unity.com/t/where-can-i-see-all-the-playerprefs-created-in-the-editor/826800
21. https://discussions.unity.com/t/where-playerprefs-store-on-android-project/455989
22. https://discussions.unity.com/t/wrong-resolution-on-macbook-pro-2021/897140
23. https://www.reddit.com/r/FantasyGrounds/comments/iyqk6z/issues_with_mac_on_fgc_any_better_on_fgu
24. https://www.reddit.com/r/FoundryVTT/comments/msvvbk/problems_with_image_resolution_scaling_on_mac
25. https://docs.unity.cn/2021.2/Documentation/Manual/PlayerSettings-macOS.html
26. https://www.fantasygrounds.com/forums/archive/index.php/t-36043-p-4.html
27. https://www.fantasygrounds.com/forums/showthread.php?64254-FGU-Looks-small-on-Mac-Big-Sur=
28. https://www.fantasygrounds.com/forums/archive/index.php/t-22440.html
29. https://www.fantasygrounds.com/forums/showthread.php?64547-Screen-size=
30. https://www.fantasygrounds.com/forums/archive/index.php/t-68774.html
31. https://store.steampowered.com/app/1410910/Fantasy_Grounds__Pathfinder_Map_Pack_Starship_Corridors?l=danish&snr=1_5_9__316_4
32. https://www.reddit.com/r/FantasyGrounds/comments/1lue9pc/how_to_add_a_map_and_custom_tokens
33. https://stackoverflow.com/questions/67768335/unity-i-deleted-the-game-but-the-playerprefs-are-still-there
34. https://discussions.unity.com/t/playerprefs-not-saved-in-mac-standalone-need-help-to-reprod/380556
35. https://www.facebook.com/groups/FantasyGroundsDnD/posts/10158751308168643
36. https://www.fantasygrounds.com/forums/showthread.php?63640-Mac-text-size=
37. https://discussions.unity.com/t/mac-playerprefs-working-saving-and-loading-fine-but-cant-find-the-file/481417
38. https://docs.unity3d.com/2022.1/Documentation/Manual/PlayerSettings-macOS.html
39. https://www.fantasygrounds.com/forums/showthread.php?77478-Mouse-pointer-and-screen-DPI-problems=
40. https://www.facebook.com/groups/172284679509931/posts/30688049707506694
41. https://www.reddit.com/r/hackintosh/comments/rvywuj/is_there_a_way_to_force_hidpi_on_external_displays
42. https://discussions.unity.com/t/mac-retina-support-what-does-it-really-do/793768
43. https://docs.unity3d.com/2023.2/Documentation/Manual/PlayerSettings-macOS.html
44. https://www.fantasygrounds.com/forums/showthread.php?72269-Retina-Display=
45. https://gg.deals/dlc/fantasy-grounds-infestation-at-devils-glade
46. https://fantasygroundsunity.atlassian.net/wiki/spaces/FGCP/pages/1124925461/How+to+Make+The+User+Interface+Larger+or+Smaller
47. https://discussions.unity.com/t/editor-ui-needs-to-improve-and-support-high-dpi/698797
48. https://intellij-support.jetbrains.com/hc/en-us/articles/360007994999-HiDPI-configuration
49. https://www.fantasygrounds.com/forums/showthread.php?64538-Display-settings=
50. https://www.youtube.com/watch?v=YIIzSaswIOU
51. https://www.reddit.com/r/btd6/comments/1ek59q7/add_support_for_retina_resolutions_on_macos
52. https://www.youtube.com/watch?v=QjCOf4lsfFQ
53. https://discussions.unity.com/t/having-playerprefs-problems-as-they-do-not-store-nor-can-i-find-it-mac/527680
54. https://www.fantasygrounds.com/forums/showthread.php?76183-Can-t-update-FG-on-Mac=
55. https://www.fantasygrounds.com/forums/showthread.php?79450-Fantasy-Grounds-Unity-crashing-on-launch-on-Macbook-Pro-%28m1-pro-16-gig%29=
56. https://discussions.unity.com/t/where-does-unity-store-its-settings/511257
57. https://www.fantasygrounds.com/forums/showthread.php?77849-Tips-to-make-Fantasy-Grounds-Unity-run-better-on-my-Mac=
58. https://www.fantasygrounds.com/forums/showthread.php?63383-Tiny-display-on-Mac=
59. https://discussions.unity.com/t/webgl-standalone-instant-fps-drop-when-using-display-scaling-mac-with-retina-etc/691535
60. https://www.fantasygrounds.com/forums/showthread.php?78055-How-to-change-resolution-or-zoom-out-the-screen=
61. https://www.fantasygrounds.com/forums/archive/index.php/t-47051-p-2.html
62. https://www.fantasygrounds.com/forums/archive/index.php/f-107.html
63. https://www.fantasygrounds.com/forums/archive/index.php/t-70355-p-2.html
64. https://www.fantasygrounds.com/forums/showthread.php?74653-FGU-on-Mac-crashes-upon-launch-Monterey-and-Intel=
65. https://discussions.apple.com/thread/253300259
66. https://site.dmsguild.com/browse/pub/8957/Dungeon-Masters-Guild?filters=0_0_45395_0_0_0_45545_0&sort=3a&src=fid45545
67. https://docs.unity3d.com/2020.1/Documentation/ScriptReference/PlayerPrefs.html
68. https://discussions.unity.com/t/hidpi-support-missing/596364
69. https://docs.unity3d.com/2022.3/Documentation/Manual/PlayerSettings-macOS.html
70. https://www.reddit.com/r/MacOS/comments/qh2e3u/urgent_no_open_in_low_resolution_mode_in_monterey
71. https://fantasygroundsunity.atlassian.net/wiki/spaces/FGCP/pages/2020999207
72. https://discussions.unity.com/t/editor-ui-scaling-in-macos/799251
73. https://forums.obsidian.net/topic/76821-broken-resolution-scaling-on-osx-macbook-pro-w-retina



---

> **Generated by Grok Search**  
> Query: # RESEARCH REQUEST

Generated: 2026-01-26
Project: Fantasy Grounds Unity Mac Display Issue

## CONTEXT

We have successfully installed Fantasy Grounds Unity (FGU) on a Mac Studio with an Apple M1 Ultra chip and a Studio Display (5120 x 2880 Retina resolution). The application launches and runs, but the window appears extremely small and hard to read - it does not appear to be adapting to the high-DPI/Retina display properly.

Fantasy Grounds Unity is a Unity-based application that should support high-DPI displays, but on this Mac with a Retina display, the application window renders at what appears to be a 1:1 pixel ratio rather than scaling appropriately. This makes text, UI elements, and controls extremely small and difficult to use.

Technology Stack: macOS on Apple Silicon (M1 Ultra), Studio Display at 5120x2880 Retina, Fantasy Grounds Unity (Unity engine-based application)

## RESEARCH QUESTIONS

### Priority 1: Critical
1. How do Mac users fix the small window / low resolution issue in Fantasy Grounds Unity on Retina displays? Are there in-app settings, Unity player preferences, or macOS workarounds?

2. Is there an "Open in Low Resolution" checkbox or equivalent setting for Fantasy Grounds Unity on macOS, and does enabling/disabling it fix the scaling issue?

3. Where are Fantasy Grounds Unity's display/resolution settings stored on macOS, and can they be manually edited? (e.g., ~/Library/Preferences/ plist files, Unity PlayerPrefs, or in-app config files)

### Priority 2: Important
4. What in-app display settings does Fantasy Grounds Unity provide? Is there a resolution selector, UI scaling slider, or DPI awareness toggle within the application?

5. Are there Unity command-line arguments or environment variables that can force proper Retina/HiDPI rendering?

6. Has SmiteWorks acknowledged or fixed this issue in recent updates?

### Priority 3: Strategic
7. What macOS System Settings affect how Unity applications render on Retina displays?

8. Are there third-party tools that can force proper DPI scaling for Unity applications on macOS?

## SUCCESS CRITERIA
- Find a working solution to make Fantasy Grounds Unity render at proper Retina resolution on Mac
- Understand if this is a known issue with a documented fix
- Identify settings (in-app or system) that control DPI scaling  
> Model: grok-4-1-fast-reasoning  
> Citations: 73 sources  
> Date: 2026-01-26 07:23:55 Local  
