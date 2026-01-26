# Search Results: # RESEARCH REQUEST

Generated: 2026-01-26
Project: Fantasy Grounds Extension Development - AI Agent Documentation Resources

## CONTEXT

We are setting up an AI-assisted development workflow for Fantasy Grounds Unity (FGU) extension development. A new developer is working on an extension and encountering challenges because AI coding agents lack comprehensive knowledge of FGU's proprietary Lua API, XML schema, and development patterns. The FGU development ecosystem is niche with sparse documentation.

We need to find existing community resources - GitHub repositories with API documentation, Lua type definition files (EmmyLua annotations), XML schemas, or comprehensive markdown documentation that could be cloned or referenced.

Technology Stack: Fantasy Grounds Unity, Lua 5.1, FGU-specific XML, VS Code with Lua Language Server

## RESEARCH QUESTIONS

### Priority 1: Critical
1. Are there GitHub repositories containing Fantasy Grounds API documentation, type definitions, or developer reference materials? Search for repos with FGU Lua globals, function signatures, or API guides.

2. Has anyone created Lua Language Server type definition files (.lua or EmmyLua annotations) for Fantasy Grounds global objects (DB, Interface, Debug, User, Window, etc.)?

3. Are there XML Schema Definition (XSD) or Document Type Definition (DTD) files for Fantasy Grounds extension XML format?

### Priority 2: Important
4. What are the most comprehensive community wikis or documentation sites for FGU extension development beyond the official Atlassian wiki?

5. Are there Fantasy Grounds extension development starter kits or boilerplate repositories on GitHub with documentation?

6. Has the FGU community created VS Code extensions or tooling with API definitions?

7. Are there community efforts to document the CoreRPG API systematically?

### Priority 3: Strategic
8. What open-source FGU extensions on GitHub are well-documented and could serve as reference implementations?

9. Are there FGU developer Discord servers where documentation efforts are coordinated?

10. Has SmiteWorks released official API documentation or developer tooling?

## SUCCESS CRITERIA
- Find repositories with API documentation or type definitions
- Identify comprehensive community documentation sources
- Determine if XML schema exists
- Compile list of well-documented open-source extensions

### Priority 1: Critical

1. **GitHub Repositories with FGU API Documentation, Type Definitions, or Developer References**  
   No comprehensive repositories containing full FGU Lua API documentation (e.g., globals like DB, Interface, Debug, User, Window), function signatures, or API guides were found. The most relevant is the **FG-Unofficial-Developers-Guild** organization (https://github.com/FG-Unofficial-Developers-Guild), which hosts 10+ open-source FGU extensions (e.g., FG-Aura-Effect for proximity-based effects, FG-Ammunition-Manager, FG-PFRPG-Malady-Tracker). These demonstrate real-world Lua/XML usage but lack centralized API docs. One repo (FG-Aura-Effect) includes a specific `manager_aura_api.lua` with extension-internal API comments. Other scattered repos like VikingStudio/FG-5E-Enhancer (https://github.com/VikingStudio/FG-5E-Enhancer) reference the "FG API" in READMEs but provide no docs. No evidence of exhaustive Lua global references.

2. **Lua Language Server Type Definition Files (EmmyLua Annotations)**  
   None found. Searches for EmmyLua (`---@type`), Lua type definitions, or Language Server configs specific to FGU globals yielded zero results. The FG-Unofficial-Developers-Guild has `FG-luacheck` (a Lua static analyzer config), useful for tooling but not type defs. Developers must infer types from CoreRPG ruleset Lua files (e.g., in FGU install dir: `rulesets/CoreRPG/scripts/`).

3. **XML Schema Definition (XSD) or DTD Files for FGU Extensions**  
   No XSD, DTD, or formal schemas exist publicly. Forum threads (e.g., on stat block imports) request them, but none are shared. XML structure is inferred from official rulesets (e.g., CoreRPG `base.xml`, `client.xml`) and extension examples in GitHub repos above. Official guidelines reference XML tags but no schema (see Atlassian wiki).

### Priority 2: Important

4. **Comprehensive Community Wikis or Documentation Sites Beyond Official Atlassian Wiki**  
   - **Fantasy Grounds Forums - Developer Theater**: Primary hub (https://www.fantasygrounds.com/forums/forumdisplay.php?45=Developer-Theater-(Modding)). Threads cover Lua scripting, XML modding, CoreRPG overrides (e.g., "Where to find information on all APIs" recommends inspecting CoreRPG Lua files, campaign DB exports). Tutorials like "[Tutorial] Creating a Basic Extension" (2014, still relevant).  
   - **Reddit r/FantasyGrounds**: Discussions on modding, extensions (e.g., lists of CoreRPG globals).  
   - **Fantasy Grounds Academy** (https://www.fantasygroundsacademy.com/): Tutorials on extensions, Lua basics. No exhaustive API.  
   Forums emphasize reverse-engineering CoreRPG/PFRPG rulesets for undocumented APIs.

5. **FGU Extension Starter Kits or Boilerplate Repos on GitHub**  
   None identified. Repos like SirMotte/FGU-Theme-Hearth (https://github.com/SirMotte/FGU-Theme-Hearth) serve as minimal XML/Lua templates for themes/extensions. Basic extension creation tutorials on forums use unzipped rulesets as starters.

6. **FGU Community VS Code Extensions or Tooling with API Definitions**  
   None found. `FG-luacheck` provides a luacheck config for VS Code/Neovim Lua linting. Recommend standard Lua Language Server + manual CoreRPG Lua imports for intellisense.

7. **Community Efforts to Document CoreRPG API Systematically**  
   No dedicated efforts. Developers reference:  
   - Official Atlassian "Developer Guide - API Reference" (https://fantasygroundsunity.atlassian.net/wiki/spaces/FGCP/pages/996644535/Developer+Guide+-+API+Reference) – partial, experimental FGU APIs (e.g., chatwindow controls).  
   - CoreRPG Lua files (`scripts/` dir) for globals/functions. Forum consensus: "Dig into CoreRPG code, extensions, reference docs." Old refdoc (https://www.fantasygrounds.com/refdoc/) mentioned but outdated/non-FGU.

### Priority 3: Strategic

8. **Well-Documented Open-Source FGU Extensions on GitHub (Reference Implementations)**  
   - **FG-Unofficial-Developers-Guild repos** (e.g., https://github.com/FG-Unofficial-Developers-Guild/FG-Aura-Effect, FG-PFRPG-Spell-Formatting): Clean Lua/XML, READMEs with compatibility (e.g., FGU v4.6.6+), ruleset support (CoreRPG, 5E, PFRPG). Great for patterns like effect managers, inventory hooks.  
   - **bakermd86/FoogleBrowser** (https://github.com/bakermd86/FoogleBrowser): Browser-style record search.  
   - **SirMotte/FGU-Theme-Hearth**: UI theme with load order notes.  
   Clone these for Lua/XML patterns (e.g., onInit, onClose handlers).

9. **FGU Developer Discord Servers**  
   - **Fantasy Grounds Academy Discord** (https://discord.gg/fgacademy): Training, AMAs (e.g., CoreRPG devs), extension discussions. 5,000+ members.  
   - **Official Fantasy Grounds Discord**: General modding chats. Kelrugem (prolific coder) shares tag. No dedicated "FGU Extension Devs" server, but forums point here for coordination.

10. **SmiteWorks Official API Documentation or Tooling**  
    Partial: Atlassian wiki (https://fantasygroundsunity.atlassian.net/wiki/spaces/FGCP/overview) has "Developer Guide" (guidelines, historical changes: https://fantasygroundsunity.atlassian.net/wiki/spaces/FGCP/pages/2179694626/Developer+Guide+-+Historical+Change+Guide), "API Reference" (experimental/client APIs), XML file refs (e.g., extension.xml tags). No full Lua API, globals list, schemas, or EmmyLua. Tooling: Forge Conversion Checker. Submission via Dropbox/SVN.

### Summary & Success Criteria
- **API Docs/Type Defs**: Partial official wiki; no community repos (fail, but extensions as proxies).  
- **Community Docs**: Forums + Academy (success).  
- **XML Schema**: Absent (fail).  
- **Open-Source Extensions**: 10+ well-structured GitHub examples (success).  
FGU's niche ecosystem relies on reverse-engineering CoreRPG + forums. For AI agents: Clone CoreRPG ruleset, parse Lua for signatures. Latest as of 2026-01-26: No major new docs; guild active into 2025.

---

## Citations

*Sources examined during agentic research:*

1. https://github.com/FG-Unofficial-Developers-Guild/FG-Aura-Effect
2. https://www.fantasygrounds.com/forums/showthread.php?43623-Overriding-CoreRPG-functions=
3. https://www.fantasygrounds.com/forums/archive/index.php/t-46890.html
4. https://www.fantasygrounds.com/forums/archive/index.php/t-72284.html
5. https://github.com/ZarestiaDev/FFd20
6. https://www.fantasygrounds.com/forums/showthread.php?60876-lua-version=
7. https://fantasygroundsunity.atlassian.net/wiki/spaces/FGCP/pages/996645668/Developer%20Guide%20-%20Extensions%20-%20Files
8. https://www.fantasygrounds.com/forums/archive/index.php/t-40833-p-2.html
9. https://www.reddit.com/r/FantasyGrounds/comments/kmhl76/fantasy_grounds_with_nonsupported_system
10. https://www.fantasygrounds.com/forums/showthread.php?84943-Learning-Lua=
11. https://www.fantasygrounds.com/forums/archive/index.php/t-50248-p-2.html
12. https://fantasygrounds.com/forums/showthread.php?p=182773
13. https://forge.fantasygrounds.com/crafter/2/view-profile
14. https://github.com/bcholmes/StarTrek2d20/issues/120
15. https://fantasygroundsunity.atlassian.net/wiki/spaces/FGCP/pages/2037547009/Developer+Guidelines
16. https://www.fantasygrounds.com/forums/showthread.php?82788-Breaking-Extensions-so-much%2Fpage6=
17. https://fantasygroundsunity.atlassian.net/wiki/spaces/FGCP/overview
18. https://www.fantasygrounds.com/forums/printthread.php?pp=10&t=20651
19. https://steamcommunity.com/app/1196310/discussions/0/4346618210297882804?l=dutch
20. https://www.fantasygrounds.com/forums/archive/index.php/t-68774.html
21. https://www.fantasygrounds.com/forums/archive/index.php/t-26775.html
22. https://www.fantasygrounds.com/forums/showthread.php?40044-community-extensions-repository=
23. https://github.com/matteoferla/tangents/blob/master/namegen.py
24. https://www.reddit.com/r/FantasyGrounds/comments/x3s4f4/why_is_fantasy_grounds_so_popular
25. https://www.fantasygrounds.com/forums/showthread.php?65259-KJ%EF%BF%BDs-Unity-4E-Extension-Emporium=
26. https://www.fantasygrounds.com/forums/showthread.php?72037-Extension-CoreRPG-display-NPC-tokens-as-portraits-in-chat=
27. https://www.fantasygrounds.com/modguide/introduction.xcp
28. https://www.fantasygrounds.com/home/QuickStartGuide.php
29. https://www.fantasygrounds.com/forums/showthread.php?72071-Heavy-performance-issues-seemingly-related-to-a-large-map%2Fpage3=
30. https://github.com/kmheffernan/SD2FG-Converter
31. https://www.youtube.com/watch?v=R_CulFJYs-M
32. https://www.fantasygrounds.com/forums/archive/index.php/t-22440.html
33. https://www.fantasygrounds.com/forums/showthread.php?72153-Delta-Green-Extension-Revised=
34. https://www.fantasygrounds.com/forums/showthread.php?23088-Character-sheet-how-to-make-a-simple-one-extended-from-CoreRPG=&styleid=5
35. https://www.youtube.com/watch?v=bSvZ3sijVho
36. https://www.reddit.com/r/FantasyGrounds/comments/lkjwwc/rant_im_one_backwards_compatibility_away_from
37. https://www.fantasygrounds.com/forums/archive/index.php/t-55797-p-3.html
38. https://www.fantasygrounds.com/forums/showthread.php?33531-help-with-Lua=
39. https://www.fantasygrounds.com/forums/showthread.php?55918-Fantasy-Grounds-to-Discord-%28Grognard-Bot%29=
40. https://github.com/VikingStudio/FG-5E-Enhancer
41. https://www.fantasygrounds.com/forums/showthread.php?77471-Undocumented-lua-functions-and-how-c-gt-lua-is-exposed-in-general=
42. https://www.fantasygrounds.com/forums/showthread.php?71815-New-to-Fantasy-Grounds-Unity=
43. https://www.reddit.com/r/FantasyGrounds/comments/13v9vtt/how_to_use_your_local_audio_files_in_the_test_fgu
44. https://www.fantasygrounds.com/forums/showthread.php?62119-Client-Side-Event-Handling=
45. https://www.fantasygrounds.com/forums/showthread.php?58226-Better-Menus-%28CoreRPG-5E-etc%29%2Fpage22=
46. https://fantasygrounds.com/forums/showthread.php?p=581567
47. https://www.fantasygrounds.com/forums/archive/index.php/t-20651.html
48. https://www.fantasygrounds.com/forums/showthread.php?69407-CoreRPG-Bartender=
49. https://www.fantasygrounds.com/forums/archive/index.php/t-40821.html
50. https://fantasygrounds.com/forums/showthread.php?79032-Fantasy-Grounds-Developer-AMA-Unveiling-the-core-basics-09-12-23=
51. https://www.youtube.com/watch?v=e6QbEDsssoo
52. https://www.fantasygrounds.com/forums/showthread.php?81330-Fantasy-Grounds-automation-v-Foundry-MIDI-QOL-etc=
53. https://github.com/SirMotte/FGU-Theme-Hearth
54. https://www.fantasygrounds.com/forums/showthread.php?64776-Creating-new-items-and-weapons=
55. https://www.fantasygrounds.com/modguide/scripting.xcp
56. https://www.fantasygrounds.com/forums/showthread.php?71379-Grid-Based-Inventory-Extension-idea-commission=
57. https://www.reddit.com/r/FantasyGrounds/comments/y44n10/fantasy_grounds_is_not_where_it_needs_to_be
58. https://www.fantasygrounds.com/forums/showthread.php?79577-Coding-and-Editing-Extensions=
59. https://www.fantasygrounds.com/forums/showthread.php?20449-Tutorial-Creating-a-Basic-Extension=
60. https://fantasygrounds.com/forums/printthread.php?page=2&pp=10&t=42348
61. https://www.fantasygrounds.com/forums/archive/index.php/t-74168.html
62. https://www.fantasygrounds.com/forums/showthread.php?81870-Stat-blocks-for-importing=
63. https://www.fantasygrounds.com/home/FantasyGroundsUnity.php
64. https://www.fantasygrounds.com/forums/showthread.php?47305-Where-to-find-information-on-all-APIs-and-functions-usable-for-custom-FG-coding=
65. https://www.fantasygrounds.com/forums/archive/index.php/t-65246.html
66. https://fantasygroundsunity.atlassian.net/wiki/spaces/FGCP/pages/996644425
67. https://www.fantasygrounds.com/forums/showthread.php?26556-Discord-server-for-the-Fantasy-Grounds-Community=
68. https://github.com/FG-Unofficial-Developers-Guild
69. https://fantasygrounds.com/forums/printthread.php?page=1&pp=10&t=43623
70. https://gist.github.com/Egor-Skriptunoff/2458547aa3b9210a8b5f686ac08ecbf0
71. https://www.fantasygrounds.com/forums/showthread.php?55918-Fantasy-Grounds-to-Discord-%28Grognard-Bot%29%2Fpage5=
72. https://www.enworld.org/threads/fantasy-grounds-unity-ks-announced.658309/post-7610726
73. https://github.com/BeeGrinder/FantasyGrounds-SW5e
74. https://www.fantasygrounds.com/forums/showthread.php?59311-Extension-repository=
75. https://forge.fantasygrounds.com/shop/items/12/view
76. https://www.fantasygrounds.com/forums/showthread.php?86389-Misconception-in-TOS-and-Discord-Mod-Abuse=
77. https://www.fantasygrounds.com/forums/showthread.php?55918-Fantasy-Grounds-to-Discord-%28Grognard-Bot%29%2Fpage4=
78. https://github.com/JustinFreitas/StealthTracker
79. https://github.com/ZarestiaDev
80. https://github.com/theoldestnoob/fg-item-generator
81. https://github.com/Imagix/uvtt2fgu
82. https://gist.github.com/fernando/cea5851396bd8874f1d789e4a171b681
83. https://www.fantasygrounds.com/forums/archive/index.php/t-59341.html
84. https://www.fantasygrounds.com/forums/archive/index.php/t-43694.html
85. https://www.fantasygrounds.com/forums/archive/index.php/t-35298.html
86. https://www.reddit.com/r/FantasyGrounds/comments/kmdsf0/list_of_corerpg_global_scripts_propertiesfunctions
87. https://www.fantasygrounds.com/forums/archive/index.php/t-70355.html
88. https://www.reddit.com/r/FantasyGrounds
89. https://fantasygroundsunity.atlassian.net/wiki/spaces/FGCP/pages/1845231641/Press+Kit+-+Fantasy+Grounds+Unity
90. https://www.reddit.com/r/FoundryVTT/comments/1ot242a/fantasy_grounds_just_went_free_how_do_you_think
91. https://www.fantasygrounds.com/forums/showthread.php?62058-Extended-Language-Fonts=
92. https://www.reddit.com/r/FantasyGrounds/comments/13erkuk/arkenforges_fantasy_grounds_unity_map_export_now
93. https://www.fantasygrounds.com/forums/showthread.php?22089-Fantasy-Grounds-Unity-engine%2Fpage148=
94. https://www.fantasygrounds.com/forums/showthread.php?75984-FGU-conflicting-with-Discord-Bot%2Fpage12=
95. https://www.fantasygrounds.com/forums/showthread.php?42221-DORCore-An-Advanced-Beta-Release-Of-A-New-Ruleset=
96. https://github.com/bakermd86/FoogleBrowser
97. https://gist.github.com/e7975509e5dc918911b5
98. https://github.com/openai/gym/commit/78c416ef7bc82...
99. https://github.com/kk49/tfgr
100. https://www.fantasygrounds.com/forums/showthread.php?77403-Module-Maker=
101. https://www.fantasygrounds.com/forums/archive/index.php/t-40833-p-3.html
102. https://www.fantasygroundsacademy.com/post/fantasy-grounds-extensions
103. https://www.fantasygrounds.com/forums/showthread.php?43751-CoreRPG-based-On-Demand-Manual-Dice-%28DM-only%29%2Fpage8=
104. https://www.fantasygrounds.com/forums/archive/index.php/t-39768.html
105. https://www.fantasygrounds.com/forums/showthread.php?58820-Integrating-custom-fonts-into-FG=
106. https://discord.do/fantasy-grounds
107. https://fantasygroundsunity.atlassian.net/wiki/spaces/FGCP/pages/2179694626/Developer+Guide+-+Historical+Change+Guide
108. https://www.fantasygrounds.com/forums/showthread.php?77483-Adding-Languages-amp-Other-Attributes=
109. http://rpgvirtualtabletop.wikidot.com/fantasy-grounds-ii



---

> **Generated by Grok Search**  
> Query: # RESEARCH REQUEST

Generated: 2026-01-26
Project: Fantasy Grounds Extension Development - AI Agent Documentation Resources

## CONTEXT

We are setting up an AI-assisted development workflow for Fantasy Grounds Unity (FGU) extension development. A new developer is working on an extension and encountering challenges because AI coding agents lack comprehensive knowledge of FGU's proprietary Lua API, XML schema, and development patterns. The FGU development ecosystem is niche with sparse documentation.

We need to find existing community resources - GitHub repositories with API documentation, Lua type definition files (EmmyLua annotations), XML schemas, or comprehensive markdown documentation that could be cloned or referenced.

Technology Stack: Fantasy Grounds Unity, Lua 5.1, FGU-specific XML, VS Code with Lua Language Server

## RESEARCH QUESTIONS

### Priority 1: Critical
1. Are there GitHub repositories containing Fantasy Grounds API documentation, type definitions, or developer reference materials? Search for repos with FGU Lua globals, function signatures, or API guides.

2. Has anyone created Lua Language Server type definition files (.lua or EmmyLua annotations) for Fantasy Grounds global objects (DB, Interface, Debug, User, Window, etc.)?

3. Are there XML Schema Definition (XSD) or Document Type Definition (DTD) files for Fantasy Grounds extension XML format?

### Priority 2: Important
4. What are the most comprehensive community wikis or documentation sites for FGU extension development beyond the official Atlassian wiki?

5. Are there Fantasy Grounds extension development starter kits or boilerplate repositories on GitHub with documentation?

6. Has the FGU community created VS Code extensions or tooling with API definitions?

7. Are there community efforts to document the CoreRPG API systematically?

### Priority 3: Strategic
8. What open-source FGU extensions on GitHub are well-documented and could serve as reference implementations?

9. Are there FGU developer Discord servers where documentation efforts are coordinated?

10. Has SmiteWorks released official API documentation or developer tooling?

## SUCCESS CRITERIA
- Find repositories with API documentation or type definitions
- Identify comprehensive community documentation sources
- Determine if XML schema exists
- Compile list of well-documented open-source extensions  
> Model: grok-4-1-fast-reasoning  
> Citations: 109 sources  
> Date: 2026-01-26 08:40:23 Local  
