# Search Results: # RESEARCH REQUEST

Generated: 2026-01-26
Project: Unity 6 Native Apple Silicon Threading Crash Investigation

## CONTEXT

We are debugging a reproducible crash in Fantasy Grounds Unity (FGU) v5.1.0, a Unity 6-based application running natively on Apple Silicon (not via Rosetta 2). The crash occurs when clicking the Settings button in the launcher, which triggers a network/lobby status check. The application is confirmed to be a Universal Binary with full arm64 support for all components.

The crash manifests with the error 'Thread 0x... may have been prematurely finalized' in Player.log, immediately followed by 'NETWORK STATUS: [Error]' and 'Lobby: Unable to read data from the transport connection: interrupted.' This indicates a threading violation in the network subsystem. The crash occurs within 3 seconds of the launcher scene starting.

Technology Stack: Unity Engine 6000.0.64f1, macOS 15.7.3 (Sequoia), Apple M1 Ultra (native arm64), Metal 3, Mono scripting backend, Mirror Networking

## RESEARCH QUESTIONS

### Priority 1: Critical
1. Is there a known Unity 6 (6000.x) bug where network threads crash with 'Thread may have been prematurely finalized' on macOS Sequoia (15.x) with Apple Silicon? Check Unity Issue Tracker, forums, release notes 2025-2026.

2. What Unity command-line arguments or boot.config settings control network thread behavior that might prevent this crash?

3. Are there macOS Sequoia-specific changes to network socket handling or thread scheduling affecting Unity networking?

### Priority 2: Important
4. Does Mirror Networking have known threading issues on Apple Silicon with Unity 6?

5. What environment variables affect Unity Mono runtime thread management on macOS (MONO_THREADS_SUSPEND, MONO_GC_PARAMS)?

6. Has Unity released patches for 6000.0.64f1 addressing macOS threading crashes?

### Priority 3: Strategic
7. Can disabling Unity subsystems via boot.config prevent the problematic thread creation?

8. Is there a way to force single-threaded networking or disable background network polling?

## SUCCESS CRITERIA
- Find command-line argument or config preventing network thread crash
- Identify if known Unity bug with fix timeline
- Determine correct bug reporting channel

### Priority 1: Critical

1. **Known Unity 6 (6000.x) bug with 'Thread may have been prematurely finalized' on macOS Sequoia (15.x) Apple Silicon?**  
   No confirmed Unity 6-specific bug matching this exact error in network/lobby contexts on the Unity Issue Tracker, forums, or release notes (searched up to 2026). Historical issues (e.g., Issue Tracker #1160419 from 2019) link the error to macOS GPU lightmapping kernel panics (AMD GPUs), fixed in 2019.2+ versions—unrelated to networking or Unity 6.  
   Closest match: Mono runtime GitHub issue #21009 (2021, closed 2022, *not planned*). Describes MERP (Mono Error Reporting) assertion failures (`mono-threads.c:650`) when accessing prematurely finalized threads during crashes, **10x more frequent on Apple Silicon (M1+)** vs. Intel. Triggered by foreign (non-runtime-attached) threads during signals (e.g., SIGABRT). A caretaker thread fix was implemented then rolled back (VS for Mac switched to CoreCLR). No Unity/Sequoia/networking mentions, but relevant to Mono backend + Apple Silicon threading. No 2024-2026 activity. No Fantasy Grounds Unity-specific reports matching this error.

2. **Unity command-line arguments or boot.config for network thread behavior?**  
   No direct controls for **network threads** (Mirror/Unity Transport uses .NET sockets, which spawn unmanaged threads). General threading options:  
   | Option | Description | Potential Mitigation |
   |--------|-------------|----------------------|
   | `-job-worker-count=N` (CLI or `job-worker-count=N` in boot.config) | Limits Unity Job System worker threads (default: CPU cores -1). Try `N=1` or `0` to minimize background threads. | May indirectly reduce thread contention. |
   | `-force-gfx-st` (CLI) | Forces single-threaded graphics rendering (`RenderingThreadingMode.SingleThreaded`). | Graphics-only; test for stability. |
   | boot.config | Undocumented (Unity warns against manual edits; values change per version). Supports `job-worker-count`, `data-path`, etc. No networking flags found. | Edit `<Project>/[Platform]/Data/boot.config` experimentally (backup first). |
   No Mirror-specific CLI flags. Launch app with: `./FGU.app/Contents/MacOS/Fantasy Grounds Unity -job-worker-count=1`.

3. **macOS Sequoia-specific changes to network sockets/thread scheduling?**  
   Sequoia (15.x) introduced **stricter local network access** (permission prompts for LAN/Bonjour/unicast; Unity forum post on 15.1). Firewall blocks UDP responses incorrectly (affects some apps). No thread scheduling or socket handling changes documented impacting Unity/Mono. General network issues (e.g., VPN, firewall) reported, but **no threading crashes**. "Transport connection: interrupted" aligns with socket errors (e.g., ECONNRESET), possibly exacerbated by thread finalization.

### Priority 2: Important

4. **Mirror Networking threading issues on Apple Silicon Unity 6?**  
   No known issues matching. Mirror uses thread-safe `NetworkReader/Writer` (main-thread safe per docs/forums). General Mirror threading discussions exist (e.g., authority/speed glitches), but none Apple Silicon/U6/macOS-specific. Unity 6 Netcode for GameObjects recommended as Mirror successor (videos/forums 2025).

5. **Environment variables for Unity Mono thread management (macOS)?**  
   Unity Mono supports Mono env vars (set via `launchctl` or `export` before launch):  
   | Var | Values/Usage | Potential Fix |
   |-----|--------------|---------------|
   | `MONO_THREADS_SUSPEND` | `preemptive` (default, aggressive suspend), `coop` (cooperative, safer), `hybrid`. | Try `coop` to avoid premature finalization (per Mono man pages/Xamarin). |
   | `MONO_GC_PARAMS` | `major=marksweep` (GC mode), `max-heap-size=1g` (limit heap). | Reduce GC pauses/thread pressure: `export MONO_GC_PARAMS=major=marksweep`. |
   Test: `MONO_THREADS_SUSPEND=coop ./FGU.app/Contents/MacOS/Fantasy Grounds Unity`. No Unity macOS-specific docs; derived from Mono/Xamarin.

6. **Patches for 6000.0.64f1 addressing macOS threading crashes?**  
   No. 6000.0.64f1 release notes (Dec 2025): Known issues include DX12 memory, no macOS/threads/network/Mono/Apple Silicon mentions. General macOS crash fixes in prior 6000.x (e.g., VFX Graphs), but unrelated. Upgrade to latest 6000.0.x LTS recommended.

### Priority 3: Strategic

7. **Disabling subsystems via boot.config?**  
   Undocumented; no confirmed `network=0` or threading disables. Known: `job-worker-count=0` limits jobs. Edit boot.config at risk (regenerate on rebuild).

8. **Force single-threaded networking/disable background polling?**  
   No built-in flags. UnityWebRequest/Mirror poll threaded (background downloads). Workarounds:  
   - Custom single-threaded transport (Mirror extensible).  
   - Disable lobby check in code (FGU launcher).  
   - `-force-gfx-st` + `-job-worker-count=1` approximates. No polling disable.

## Summary & Recommendations
- **Likely Cause**: Mono thread finalization bug (prevalent on Apple Silicon), triggered by network socket thread during lobby check. Not Unity 6 regression; persists from older Mono.
- **Immediate Workarounds** (test these):  
  1. CLI: `-job-worker-count=1 -force-gfx-st`  
  2. Env: `MONO_THREADS_SUSPEND=coop MONO_GC_PARAMS=major=marksweep`  
  3. Switch to IL2CPP scripting backend (Unity 6 default; avoids Mono).  
  4. Temporarily disable network/lobby in FGU code.  
- **No exact match for success criteria** (no network-specific arg/config found).  
- **Next Steps**:  
  | Action | Channel |
  |--------|---------|
  | Report reproducible crash | Unity Issue Tracker (issuetracker.unity3d.com; attach Player.log). |
  | FGU-specific | Fantasy Grounds forums (fantasygrounds.com/forums). |
  | Mirror | GitHub.com/vis2k/Mirror. |
  | Monitor | Unity 6 LTS patches (unity.com/releases). |

---

## Citations

*Sources examined during agentic research:*

1. https://discussions.unity.com/t/unity-6000-2-0f1-keep-crashing/1678260
2. https://github.com/SoftwareGuy/Ignorance
3. https://discussions.unity.com/t/macos-sequoia-repeatedly-switches-screens-when-entering-play-mode/1529669
4. https://discussions.unity.com/t/allow-specifying-command-line-arguments/701322
5. https://www.reddit.com/r/Unity3D/comments/1onqvrq/problem_with_mirror_networking
6. https://unity.com/releases/editor/whats-new/6000.0.64f1
7. https://unity.com/releases/editor/alpha/2020.1.0a23
8. https://discussions.unity.com/t/unity-2021-3-xf1-2022-3-27f1-2023-2-20f1-builds-on-macos-with-silicon-unusable/946756
9. https://www.facebook.com/BloodCloudDev/posts/version-09-of-ultimate-mirror-controller-now-available-on-unity-asset-storehttps/1578647620539189
10. https://discussions.unity.com/t/network-connection-does-not-work-when-starting-server-from-command-line/930703
11. https://blog.tedd.no/2016/10/09/investigating-unity-hang-on-second-run-multi-threading
12. https://www.tabletopsimulator.com/news/patch-notes/v14-0-public-beta-engine-upgrade-unity-6-lts
13. https://issuetracker.unity3d.com/issues/getactivebuildprofile-can-only-be-called-from-the-main-thread-crash-and-error-when-switching-from-windows-to-android-2?ampDeviceId=bd73ee3b-a36f-4585-8d3e-967cba74f006&ampSessionId=1766793600645&ampTimestamp=1766880000659
14. https://man.archlinux.org/man/mono.1.en
15. https://www.fantasygrounds.com/forums/showthread.php?85195-Apple-Silicon-support-will-be-required-in-2-years=
16. https://bugs.winehq.org/buglist.cgi?bug_status=NEEDINFO
17. https://github.com/xamarin/xamarin-android/issues/3239
18. https://toppodcast.com/podcast_feeds/destination-linux
19. https://fantasygroundsunity.atlassian.net/wiki/spaces/FGCP/overview?homepageId=996704381
20. https://forum.xojo.com/t/sequoia-new-security-entitlement-s/81329
21. https://github.com/mono/mono/issues/20283
22. https://unity.com/releases/editor/whats-new/2019.3.2f1
23. https://docs.unity.com/en-us/services/release-notes
24. https://www.fantasygrounds.com/forums/showthread.php?74547-Fantasy-Grounds-Unity-immediately-crashes-in-macOS-Ventura=
25. https://stackoverflow.com/questions/38316943/unity-tcp-socket-connection-not-working-on-mac-os-x
26. https://discussions.unity.com/t/playmode-crash-without-any-info-when-there-is-no-access-to-the-internet/766048
27. https://discussions.unity.com/t/sending-os-command-line-terminal-messages-to-unity-app/1599076
28. https://stackoverflow.com/questions/61530632/forcing-certain-code-to-always-run-on-the-same-thread
29. https://unity.com/releases/editor/beta
30. https://www.reddit.com/r/unity/comments/1et5mej/games_built_with_unity_crashes_my_mac_mini_m2_pro
31. https://discussions.unity.com/t/unity-6-x-crashes-entire-windows-arm-laptop/1696485
32. https://docs.unity3d.com/6000.3/Documentation/Manual/WhatsNewUnity6.html
33. https://github.com/game-ci/docker/issues/220
34. https://stackoverflow.com/questions/45776247/mono32-wont-work-mono64-throws-errors
35. https://discussions.unity.com/t/hard-crash-when-playing-complex-scenes-after-cve-fix/1688407
36. https://www.fantasygrounds.com/forums/showthread.php?68503-FGU-crashing%2Fpage4=
37. http://www.cisco.com/en/US/docs/voice_ip_comm/connection/2x/os_administration/guide/2xcucosagappa.html
38. https://discussions.unity.com/t/game-crashing-on-mac-os-when-leaving-focus-of-the-application/943131
39. https://pauliom.medium.com/command-line-arguments-in-unity-b30a5815cd88
40. https://discussions.unity.com/t/how-to-properly-handle-custom-networking-threading/525243
41. https://www.reddit.com/r/Unity3D/comments/103ty02/all_versions_of_unity_are_crashing_on_m1_macbooks
42. https://discussions.unity.com/t/force-single-threaded/499225
43. https://discussions.unity.com/t/trouble-testing-basic-ar-application/1633409
44. https://discussions.unity.com/t/mirror-networking-transform-and-animations-are-jittery-for-server-controlled-ai/871496
45. https://stackoverflow.com/questions/47539289/xamarin-android-how-do-you-set-the-mono-gc-params-environment-variable
46. https://discussions.unity.com/t/is-threre-a-way-to-disable-all-custom-systems-at-the-start-of-the-game/944069
47. https://discussions.unity.com/t/unity-hub-mono-framework-and-visual-studio-for-macos/748343
48. https://discussions.unity.com/t/safe-to-call-schedule-update-and-complete-job-handle-in-background-thread/897652
49. https://discussions.unity.com/t/my-webgl-file-cannot-load/1697525
50. https://unity.com/releases/editor/whats-new/2019.3.15f1
51. https://discussions.unity.com/t/setting-mono_gc_params-max-heap-size-for-debugging-out-of-memory/658229
52. https://discussions.unity.com/t/mirror-a-question-about-the-thread-safety-of-the-custom-networkreader-writer/885770
53. https://www.reddit.com/r/unity/comments/1evnens/should_i_switch_to_unity_6s_netcode_for
54. https://help.symless.com/hc/en-us/articles/35715295144593-macOS-15-Sequoia-firewall-breaks-network-connection
55. https://discussions.unity.com/t/cant-open-macos-unity-editor-6000-0-upm-connection-issues/1690867
56. https://www.facebook.com/groups/companion/posts/4171309543087364
57. https://unity.com/releases/editor/whats-new/2019.3.6
58. https://stackoverflow.com/questions/76898792/mirror-networking-in-unity-onserverscenechanged-doesnt-get-called-after-scene
59. https://issuetracker.unity3d.com/issues/osx-gpuplm-kernel-panic-slash-editor-crash-with-thread-may-have-been-prematurely-finalized-after-baking-the-scene-with-amd-gpu
60. https://unity.com/releases/editor/beta/2020.1.0b10
61. https://unity.com/releases/editor/whats-new/2019.3.14f1
62. https://docs.unity3d.com/6000.3/Documentation/ScriptReference/Rendering.RenderingThreadingMode.SingleThreaded.html
63. https://discussions.unity.com/latest?page=906
64. https://stackoverflow.com/questions/62612503/problems-with-mirror-networking-in-unity
65. https://unity.com/security/sept-2025-01
66. https://docs.unity.com/en-us/build-automation/reference/available-environment-variables
67. https://www.youtube.com/watch?v=xOldALttBZw
68. https://discussions.unity.com/t/unity-and-c-sockets/384012
69. https://www.fantasygrounds.com/forums/showthread.php?81196-How-to-correctly-install-on-OS-X=
70. https://github.com/mono/mono/issues/21009
71. https://discussions.unity.com/t/is-there-any-trick-to-enable-or-disable-multithread-rendering-at-runtime/612704
72. https://github.com/mario206/UnityReleaseNotes-latest/blob/main/merge_htmls/2019.3.md
73. https://graphic-3d.blogspot.com/2020/05/news-new-unity-20201-beta.html
74. https://github.com/MirageNet/Mirage
75. https://www.reddit.com/r/Codeweavers_Crossover/comments/1lalmrm/networking_issues_fix_guide_macos_sequoia_15x
76. https://github.com/dotnet/macios/issues/6127
77. https://www.facebook.com/groups/1000038303359383/posts/8010854005611076
78. https://discussions.unity.com/t/is-unitywebrequest-threaded-to-background/689708
79. https://www.facebook.com/groups/UnifyPowerUsers/posts/1100688924070824
80. https://unity.com/releases/editor/alpha
81. https://gamedev.stackexchange.com/questions/113096/how-to-not-freeze-the-main-thread-in-unity
82. https://docs.unity.cn/Manual/android-thread-configuration.html
83. https://docs.unity3d.com/2022.2/Documentation/Manual/EditorCommandLineArguments.html
84. https://issuetracker.unity3d.com/issues/osx-crash-on-gpuminitializeiodata-dot-cold-dot-1-when-baking-lights-in-a-scene-with-optix-denoiser
85. https://discussions.unity.com/t/how-to-avoid-long-running-background-jobs-being-executed-on-main-thread/874240
86. https://github.com/mono/mono/issues/15878
87. https://docs.unity3d.com/6000.5/Documentation/Manual/urp/upgrade-guide-unity-6.html
88. https://unity.com/releases/editor/whats-new/6000.0.0f1
89. https://discussions.unity.com/t/way-to-terminate-background-threads-in-editor-when-play-stops/568069
90. https://discussions.unity.com/t/solved-editor-launches-into-safe-mode-on-new-and-existing-projects/892205
91. https://issuetracker.unity3d.com/issues/mono-crash-on-systemnative-readdirr-when-building-for-ios-slash-android-on-a-macos-machine
92. https://docs.unity.cn/Manual/PlayerCommandLineArguments.html
93. https://discussions.unity.com/t/apple-silicon-builds-from-2020-3-21-crash-on-launch/860523
94. https://discussions.unity.com/t/osx-15-1-local-area-network-connection-request-sequoia/1564824
95. https://docs.unity3d.com/6000.3/Documentation/Manual/EditorCommandLineArguments.html
96. https://discussions.unity.com/t/1-0-8-force-serverworld-to-run-all-systems-on-main-thread-config/918041
97. https://discussions.unity.com/t/background-networking-activity-and-unity-run-loop/484367
98. https://docs.unity3d.com/es/2019.4/Manual/CommandLineArguments.html
99. https://issuetracker.unity3d.com/issues/hdrp-office-scene-hard-crash-on-macos
100. https://discussions.unity.com/t/dotsnet-high-performance-unity-ecs-networking-from-the-creator-of-mirror/788585?page=14
101. https://docs.unity3d.com/6000.3/Documentation/ScriptReference/GfxThreadingMode.html
102. https://www.fantasygrounds.com/forums/showthread.php?75530-FGU-crash-on-macOS-Monterey-12-6-M1-after-the-update%2Fpage2=
103. https://discussions.unity.com/t/info-or-docs-on-boot-config/808947
104. https://apps.apple.com/no/app/second-life/id6499226173
105. https://discussions.unity.com/t/frequent-crashes-after-script-compilation-on-unity-6000-0-24f1-with-appui-2-0-0-pre11-macos-ventura-13-0/1546166
106. https://discussions.unity.com/t/macos-build-failed-with-internal-build-system-error-after-switching-from-mono-to-il2cpp-in-6000-0-45f1/1627500
107. https://discussions.unity.com/t/build-macos-standalone-on-unity-2019-4-8-using-mono-on-big-sur-not-working/810705
108. https://platform.uno/docs/articles/external/uno.wasm.bootstrap/doc/features-environment-variables.html
109. https://www.youtube.com/watch?v=ja63QO1Imck
110. https://www.reddit.com/r/ableton/comments/1pf6znf/opening_amplitude_crashes_ableton_live_12_lite
111. https://discussions.apple.com/thread/255765230



---

> **Generated by Grok Search**  
> Query: # RESEARCH REQUEST

Generated: 2026-01-26
Project: Unity 6 Native Apple Silicon Threading Crash Investigation

## CONTEXT

We are debugging a reproducible crash in Fantasy Grounds Unity (FGU) v5.1.0, a Unity 6-based application running natively on Apple Silicon (not via Rosetta 2). The crash occurs when clicking the Settings button in the launcher, which triggers a network/lobby status check. The application is confirmed to be a Universal Binary with full arm64 support for all components.

The crash manifests with the error 'Thread 0x... may have been prematurely finalized' in Player.log, immediately followed by 'NETWORK STATUS: [Error]' and 'Lobby: Unable to read data from the transport connection: interrupted.' This indicates a threading violation in the network subsystem. The crash occurs within 3 seconds of the launcher scene starting.

Technology Stack: Unity Engine 6000.0.64f1, macOS 15.7.3 (Sequoia), Apple M1 Ultra (native arm64), Metal 3, Mono scripting backend, Mirror Networking

## RESEARCH QUESTIONS

### Priority 1: Critical
1. Is there a known Unity 6 (6000.x) bug where network threads crash with 'Thread may have been prematurely finalized' on macOS Sequoia (15.x) with Apple Silicon? Check Unity Issue Tracker, forums, release notes 2025-2026.

2. What Unity command-line arguments or boot.config settings control network thread behavior that might prevent this crash?

3. Are there macOS Sequoia-specific changes to network socket handling or thread scheduling affecting Unity networking?

### Priority 2: Important
4. Does Mirror Networking have known threading issues on Apple Silicon with Unity 6?

5. What environment variables affect Unity Mono runtime thread management on macOS (MONO_THREADS_SUSPEND, MONO_GC_PARAMS)?

6. Has Unity released patches for 6000.0.64f1 addressing macOS threading crashes?

### Priority 3: Strategic
7. Can disabling Unity subsystems via boot.config prevent the problematic thread creation?

8. Is there a way to force single-threaded networking or disable background network polling?

## SUCCESS CRITERIA
- Find command-line argument or config preventing network thread crash
- Identify if known Unity bug with fix timeline
- Determine correct bug reporting channel  
> Model: grok-4-1-fast-reasoning  
> Citations: 111 sources  
> Date: 2026-01-26 08:03:38 Local  
