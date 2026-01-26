# Search Results: # RESEARCH REQUEST: HarnMaster Kethira (HMK) Open Source Implementations

## CONTEXT

We are building a Rules Assistant chatbot and eventual web-based VTT for HarnMaster Kethira (HMK), published by Kelestia Productions in 2024. This is a comprehensive 437-page tabletop RPG rulebook. We have successfully extracted structured data from the PDF into a SQLite database.

**Current Situation:**
We discovered an excellent open source FoundryVTT implementation for HarnMaster 3rd Edition (HM3) at github.com/toastygm/HarnMaster-3-FoundryVTT. However, HM3 is a DIFFERENT edition from HMK - the rules, stats, and mechanics differ. We cannot directly use HM3 data for our HMK project.

**Technical Challenge:**
We need to find any existing open source implementations, character tools, or structured data files specifically for HarnMaster Kethira (HMK) - the 2024 Kelestia Productions edition. This would save significant development effort.

**Why Research is Needed:**
HarnMaster has multiple editions (HM1, HM2, HM3, HMG/Gold, HMK) with different publishers and rules. Most online resources target older editions. We need current 2024-2026 information about HMK-specific digital tools.

## RESEARCH QUESTIONS

### Priority 1: Critical
1. Are there any FoundryVTT, Roll20, Fantasy Grounds, or other VTT modules specifically for HarnMaster Kethira (HMK) 2024 edition?
2. Are there any open source GitHub/GitLab repositories with HMK character generators, dice rollers, combat calculators, or data files?
3. Does Kelestia Productions provide any official digital tools, APIs, or structured data exports for HMK?

### Priority 2: Important  
4. What digital tools does the HMK/Kelestia/Harn community currently use? Check lythia.com, kelestia.com, and Harn forums.
5. Are there any community-built spreadsheets, Google Sheets, or databases with HMK weapon stats, skills, or spell data?
6. What is the relationship between HM3 and HMK? Are they similar enough that HM3 tools could be adapted?

### Priority 3: Strategic
7. Are there any Discord servers, Reddit communities, or forums where HMK digital tool development is discussed?
8. Has anyone attempted to create HMK automation tools and shared their work publicly?
9. What file formats (JSON, XML, CSV) are commonly used in Harn community data sharing?

## SEARCH TERMS
- "HarnMaster Kethira" FoundryVTT
- "HarnMaster Kethira" Roll20
- "HMK" character generator
- Kelestia Productions digital tools
- site:github.com HarnMaster Kethira
- site:lythia.com HMK tools
- HarnMaster Kethira 2024 VTT

### Priority 1: Critical

1. **VTT Modules for HMK (FoundryVTT, Roll20, Fantasy Grounds, etc.)**:
   - **FoundryVTT**: One unofficial module exists: *HarnMaster Kethira Basic Items* (https://foundryvtt.com/packages/sohl-kethira-basic, v0.5.3, for Foundry v12+). It is a **content pack** (not a full system), providing basic items, actors, skills, spells, sunsigns, gods, and HârnWorld assets. Designed as an add-on for the *Song of Heroic Lands* system (v0.5.6). Requires owning the HMK rulebook (Kelestia.com). Open source (project source available via manifest, but no public GitHub link). No full HMK system module yet.
     - Private development hinted at: A GitHub issue (https://github.com/foundryvtt/foundryvtt-cli/issues/41) references a local repo `~/dev/github/HarnMaster-Kethira-FoundryVTT` for packing HMK possessions/items, but it is **not public**.
     - Hexaèdre (https://hexaedre.com) notes active development of a FoundryVTT system (as of Sep 2024), with HMK macros available (https://hexaedre.com/hmk06). No release yet; community polls ongoing in HârnMaster Foundry VTT Discord.
   - **Roll20**: No HMK module. Kelestia Productions plans an official character sheet for late 2024/early 2025 (per Roll20 forum: https://app.roll20.net/forum/post/12025075/new-harnmaster-rpg).
   - **Fantasy Grounds**: No HMK module found. General interest in Kelestia forums (https://www.kelestia.com/node/1066), but nothing specific.
   - No modules for other VTTs (e.g., Tableplop). HM3 (not HMK) has a full open-source FoundryVTT system (https://github.com/toastygm/HarnMaster-3-FoundryVTT).

2. **Open Source GitHub/GitLab Repos (Character Generators, Dice Rollers, Combat Calculators, Data Files)**:
   - **None found publicly**. Searches (site:github.com "HarnMaster Kethira" OR HMK) returned unrelated repos (e.g., Haskell tools) or HM3-only. The private FoundryVTT HMK repo mentioned above is not accessible. No HMK-specific character generators, dice rollers, or data files on GitHub/GitLab.

3. **Kelestia Official Digital Tools/APIs/Structured Data**:
   - **No APIs, VTT modules, or machine-readable exports (JSON/XML/CSV)**. Official aids are free PDFs/spreadsheets only (https://www.kelestia.com/aidsntools):
     | Download | Contents |
     |----------|----------|
     | **HMK Document Package** (hmk_documents.zip) | Fillable/auto-calc PDFs: 8 character sheets (BW/Color/EHS variants); HMK_Weapons.pdf; HMK_Combat_Sequences.pdf; HMK_Campaign_Calendar.pdf; Readme. Spreadsheets: HMK_character_skill_calculations.xlsx (skill ML calcs), HMK_Armour_Builder.xlsx (armor suits). |
     | **On the Silver Way Quickstart** | Adventure PDF, maps, 4 fillable 1-page pregens + blank sheet. |
   - Focus: Printable aids for character creation/play. No automation tools or data dumps.

### Priority 2: Important

4. **HMK/Kelestia/Hârn Community Digital Tools**:
   - Primary sites: kelestia.com (forums, aids), lythia.com (no HMK tools found), Facebook Hârn group (https://www.facebook.com/groups/7250630358), RPGnet (https://forum.rpg.net/index.php?threads/anyone-using-the-new-harnmaster-rules-hmk.922435), Reddit (r/harn, r/rpg).
   - Key tool: **HMK Toolkit** (https://hexaedre.com/apps/hmk) - macOS-only app (Sequoia+). Features: Assisted char-gen (sunsigns/traits/DPs/regions/Shek-Pvar/alchemy), auto-sheets (encumbrance/injuries/fatigue), combat tracker (EMLs/shields), initiative, trekking/weather/calendar, price cyclopedia (1k+ items), PDF export. **Not open source**. Community support via Discord. (Also linked in phd20 forum: https://forum.phd20.com/t/harnmaster-kethira-tool/74).
   - HM3 tools (e.g., FoundryVTT) dominate older communities.

5. **Community Spreadsheets/Google Sheets/Databases (Weapons/Skills/Spells)**:
   - Official: HMK_character_skill_calculations.xlsx, HMK_Armour_Builder.xlsx (Kelestia).
   - Community: Facebook mentions HMG/HMK spreadsheets (e.g., armor tabs). Scribd has HMK char sheets (https://www.scribd.com/document/788271516/HMK-CharSheet-EHS-Color). Archadestower blog has hybrid HM3.75 sheet borrowing HMK attributes (http://archadestower.blogspot.com/2024/10/harnmaster-375-character-sheet.html). No public Google Sheets/databases with full stats/spells.

6. **HM3 vs. HMK Relationship/Adaptability**:
   - **Distinct editions**: HMK (Kelestia 2024, evolved from HMG) is more detailed/"fiddly" (6 mental attributes vs. HM3's 3; 2 skill base attributes vs. 3; expanded combat/injuries/encumbrance/magic). HM3 (Columbia Games) is "quicker/smoother." Not directly compatible—HM3 tools/data can't be ported without heavy rework (e.g., attribute mismatches). Community consensus: HMK for immersion, HM3 for speed (Facebook/RPGnet/Reddit).

### Priority 3: Strategic

7. **Discord/Reddit/Forums for HMK Tool Development**:
   - **Discords**: Kelestia official (https://discord.gg/2yUvAScCWC), HârnMaster Foundry VTT (polls on HMK support; LFG channels). Active for HMK campaigns/tools.
   - **Reddit**: r/harn (HMK solo campaigns, weather generators), r/rpg (general mentions, no tools).
   - **Forums**: kelestia.com (HMK threads), RPGnet (WIR HMK), Roll20 (HM3 sheets), phd20 (toolkit shares).

8. **HMK Automation Attempts**:
   - Hexaèdre: Closed-source macOS toolkit + Foundry macros/system in dev.
   - ToastyGM: HMK Basic Items module (Foundry).
   - Private: HarnMaster-Kethira-FoundryVTT repo.
   - No public shares of generators/calculators beyond official sheets.

9. **Common File Formats in Hârn Data Sharing**:
   - **PDF** (sheets/refs), **XLS/XLSX** (calcs/builders). No JSON/CSV/XML found. Community favors printables; VTT packs use Foundry's internal formats.

**Overall**: No public open-source HMK implementations (huge opportunity for your project). Kelestia focuses on print/PDF aids; community tools are nascent/closed-source. HM3 resources can't substitute due to rules diffs. Check Discords for collabs.

---

## Citations

*Sources examined during agentic research:*

1. https://www.kelestia.com/hmk-preview-6
2. https://www.youtube.com/watch?v=Sqmw6ukNIGA
3. https://www.reddit.com/r/rpg/comments/1qgecij/whats_the_most_intuitive_yet_crunchy_system
4. http://rpgreview.net/files/rpgreview_23.pdf
5. https://hexaedre.com/hmk06
6. https://github.com/MCP-Mirror/hmk_attio-mcp-server
7. https://github.com/mboes/hmk
8. https://www.yumpu.com/en/document/view/17065651/harnmastertm-bellsouthpwpnet
9. https://www.facebook.com/groups/7250630358/posts/10161695582375359
10. https://www.kelestia.com/node/1066
11. https://www.reddit.com/r/rpg/comments/1jqth04/help_finding_a_system_for_my_survival_game
12. https://www.kelestia.com/hmkresources
13. https://rss.com/podcasts/mindyourmanors
14. https://github.com/hmk
15. https://forum.rpg.net/index.php?threads%2Fwir-harnmaster-kethira.924367%2F=
16. https://forum.phd20.com/t/harnmaster-kethira-tool/74
17. https://hexaedre.com/hmk
18. https://app.roll20.net/forum/post/10189325/harnmaster3-big-sheet-update
19. https://www.kelestia.com/node/1120
20. http://archadestower.blogspot.com/2024/10/harnmaster-375-character-sheet.html
21. https://www.kelestia.com/taxonomy/term/36
22. https://www.facebook.com/groups/7250630358/posts/10158649386580359
23. https://github.com/toastygm/HarnMaster-3-FoundryVTT
24. https://forum.rpg.net/index.php?threads%2Fanyone-using-the-new-harnmaster-rules-hmk.922435%2F=
25. https://www.scribd.com/document/632779496/Harn-Frequently-Asked-Questions-HarnFAQ-Archive-19-Sep-2005
26. https://app.roll20.net/forum/post/12025075/new-harnmaster-rpg
27. https://www.youtube.com/watch?v=yxUy63JoL0g
28. https://www.reddit.com/r/oscilloscope/comments/1p6fd6q/is_the_hanmatek_dso1102s_any_good_what_else_under
29. https://akhelas.com/2023/11/10/review-harnworld
30. https://foundryvtt.com/packages/sohl-kethira-basic
31. https://www.reddit.com/r/harn/comments/1740kkv/new_to_harn_looking_for_the_most_active_forums
32. https://github.com/MCP-Mirror/hmk_box-mcp-server
33. https://hexaedre.com/hmk01
34. https://www.facebook.com/groups/7250630358/posts/10159256962385359
35. https://www.reddit.com/r/androidwatchfaces/comments/12sxwxu/last_night_hmk_posted_his_hmk_234_watch_face_and
36. https://www.kelestia.com/node/293
37. https://www.reddit.com/r/harn/comments/1irs1g3/h%C3%A2rnmaster_weather_generator
38. https://github.com/Homebrew/brew/actions/runs/20770371705
39. https://www.scribd.com/document/502507428/Harnlore-01
40. https://www.sec.gov/Archives/edgar/data/1433995/000119312509212744/0001193125-09-212744.txt
41. https://www.reddit.com/r/rpg/comments/1e8uqui/need_advice_on_which_version_of_harn_to_use
42. https://pmc.ncbi.nlm.nih.gov/articles/PMC8190084
43. https://podcasts.apple.com/us/podcast/melee-combat-demo-in-harnmaster-kethira/id1723247540?i=1000688171397
44. https://www.kelestia.com/node/1134
45. https://www.reddit.com/r/rpg/comments/1gk71gj/which_games_previous_edition_you_think_its_better
46. https://www.reddit.com/r/diyelectronics/comments/1p6fcoq/is_the_hanmatek_dso1102s_any_good_what_else_under
47. https://www.youtube.com/watch?v=nz0FZUkqD1M
48. https://www.kelestia.com/node/1168
49. https://basicroleplaying.org/blogs/entry/391-mythras-modern-modern-skills-for-a-modern-world
50. https://www.kelestia.com/node/1156
51. https://www.facebook.com/story.php?id=100071562715424&story_fbid=639242825137802
52. https://dice.camp/@kelestia/113978649308251991
53. https://www.kelestia.com/?page=4
54. https://github.com/hmk/box-mcp-server
55. https://www.reddit.com/r/harn/comments/1hvtpaj/i_just_started_my_h%C3%A2rnmaster_hmk_solo_campaign
56. https://dice.camp/@hexaedre
57. https://www.youtube.com/watch?v=cU0lNhk8xQA
58. https://foundryvtt.com/packages/hm3
59. https://forum.rpg.net/index.php?tags%2Fharnmaster%2F=
60. https://www.kelestia.com/aidsntools/silverway
61. https://foundryvtt.com/packages/modules?page=63
62. https://www.facebook.com/groups/7250630358/posts/10162034315085359
63. https://www.nobleknight.com/P/2148289469/HarnMaster---Roleplaying-in-the-World-of-Kethira-Collectors-Edition?srsltid=AfmBOoq_XIuTAQXhF2vMGbAyIfg_I4cSZ_xgFHM798P1zaFjPPTtUVj2
64. https://github.com/mboes/hmk/activity
65. https://www.kelestia.com/?page=1
66. https://github.com/foundryvtt/foundryvtt-cli/issues/41
67. https://hexaedre.com/apps/hmk
68. https://sggamma2.files.wordpress.com/2018/10/cg4001-harnmaster-3rd-edition.pdf
69. https://www.youtube.com/watch?v=-Yfq1z3SONI
70. https://www.kelestia.com/aidsntools
71. https://www.kelestia.com/node/1024
72. https://www.fantasygrounds.com/forums/showthread.php?53924-Harnmaster=
73. https://www.kelestia.com/
74. https://files.spawningpool.net/docs/Vault2.0.-.TTRPG-Gamebooks/Harn/Harn%20-%20Harnview%20Master%20Module.pdf
75. https://www.facebook.com/groups/7250630358/posts/10158120022995359
76. https://www.facebook.com/groups/7250630358/posts/10162602308930359
77. https://github.com/metorial/mcp-containers/blob/main/catalog/hmk/box-mcp-server/box-mcp-server/README.md
78. https://foundryvtt.com/packages/tag/content?page=30
79. https://www.scribd.com/document/788271516/HMK-CharSheet-EHS-Color
80. https://www.reddit.com/r/rpg/comments/1nohetp/west_marches_hexploration_kind_of
81. https://www.reddit.com/r/rpg/comments/1ougug1/what_have_your_favorite_new_ttrpgs_been_lately
82. https://www.reddit.com/r/rpg/comments/13cjbn3/this_absurdly_detailed_tool_will_generate_you_a
83. https://www.kelestia.com/hmk-pdf
84. https://www.kelestia.com/harnmaster
85. https://www.reddit.com/r/harn



---

> **Generated by Grok Search**  
> Query: # RESEARCH REQUEST: HarnMaster Kethira (HMK) Open Source Implementations

## CONTEXT

We are building a Rules Assistant chatbot and eventual web-based VTT for HarnMaster Kethira (HMK), published by Kelestia Productions in 2024. This is a comprehensive 437-page tabletop RPG rulebook. We have successfully extracted structured data from the PDF into a SQLite database.

**Current Situation:**
We discovered an excellent open source FoundryVTT implementation for HarnMaster 3rd Edition (HM3) at github.com/toastygm/HarnMaster-3-FoundryVTT. However, HM3 is a DIFFERENT edition from HMK - the rules, stats, and mechanics differ. We cannot directly use HM3 data for our HMK project.

**Technical Challenge:**
We need to find any existing open source implementations, character tools, or structured data files specifically for HarnMaster Kethira (HMK) - the 2024 Kelestia Productions edition. This would save significant development effort.

**Why Research is Needed:**
HarnMaster has multiple editions (HM1, HM2, HM3, HMG/Gold, HMK) with different publishers and rules. Most online resources target older editions. We need current 2024-2026 information about HMK-specific digital tools.

## RESEARCH QUESTIONS

### Priority 1: Critical
1. Are there any FoundryVTT, Roll20, Fantasy Grounds, or other VTT modules specifically for HarnMaster Kethira (HMK) 2024 edition?
2. Are there any open source GitHub/GitLab repositories with HMK character generators, dice rollers, combat calculators, or data files?
3. Does Kelestia Productions provide any official digital tools, APIs, or structured data exports for HMK?

### Priority 2: Important  
4. What digital tools does the HMK/Kelestia/Harn community currently use? Check lythia.com, kelestia.com, and Harn forums.
5. Are there any community-built spreadsheets, Google Sheets, or databases with HMK weapon stats, skills, or spell data?
6. What is the relationship between HM3 and HMK? Are they similar enough that HM3 tools could be adapted?

### Priority 3: Strategic
7. Are there any Discord servers, Reddit communities, or forums where HMK digital tool development is discussed?
8. Has anyone attempted to create HMK automation tools and shared their work publicly?
9. What file formats (JSON, XML, CSV) are commonly used in Harn community data sharing?

## SEARCH TERMS
- "HarnMaster Kethira" FoundryVTT
- "HarnMaster Kethira" Roll20
- "HMK" character generator
- Kelestia Productions digital tools
- site:github.com HarnMaster Kethira
- site:lythia.com HMK tools
- HarnMaster Kethira 2024 VTT  
> Model: grok-4-1-fast-reasoning  
> Citations: 85 sources  
> Date: 2026-01-19 06:30:19 Local  
