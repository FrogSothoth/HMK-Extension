# Fantasy Grounds Developer Resources

This document tracks useful resources for FGU extension development, particularly for AI-assisted development workflows.

## Official Resources

| Resource | URL | Description |
|----------|-----|-------------|
| **FGU Developer Wiki** | https://fantasygroundsunity.atlassian.net/wiki/spaces/FGCP/overview | Official documentation hub |
| **Developer Guidelines** | https://fantasygroundsunity.atlassian.net/wiki/spaces/FGCP/pages/2037547009/Developer+Guidelines | Extension submission guidelines |
| **API Reference (Partial)** | https://fantasygroundsunity.atlassian.net/wiki/spaces/FGCP/pages/996644535/Developer+Guide+-+API+Reference | Experimental/client APIs |
| **Historical Change Guide** | https://fantasygroundsunity.atlassian.net/wiki/spaces/FGCP/pages/2179694626/Developer+Guide+-+Historical+Change+Guide | Breaking changes by version |
| **Extension Files Reference** | https://fantasygroundsunity.atlassian.net/wiki/spaces/FGCP/pages/996645668/Developer+Guide+-+Extensions+-+Files | extension.xml structure |

## Community Organizations

### FG-Unofficial-Developers-Guild (GitHub)

**URL:** https://github.com/FG-Unofficial-Developers-Guild

Primary community organization for open-source FGU extensions. Well-structured repos demonstrating real-world Lua/XML patterns.

| Repository | Description | Useful For |
|------------|-------------|------------|
| FG-Aura-Effect | Proximity-based aura effects | Effect management, API patterns |
| FG-Ammunition-Manager | Ammo tracking | Inventory hooks |
| FG-PFRPG-Malady-Tracker | Disease/affliction tracking | Database patterns |
| FG-PFRPG-Spell-Formatting | Spell display formatting | UI customization |
| FG-luacheck | Lua linter configuration | VS Code tooling |

### Individual Developer Repos

| Repository | URL | Description |
|------------|-----|-------------|
| FG-5E-Enhancer | https://github.com/VikingStudio/FG-5E-Enhancer | 5E enhancements |
| FGU-Theme-Hearth | https://github.com/SirMotte/FGU-Theme-Hearth | UI theme example |
| FoogleBrowser | https://github.com/bakermd86/FoogleBrowser | Record browser |
| StealthTracker | https://github.com/JustinFreitas/StealthTracker | Combat tracking |

## Community Forums & Discussion

| Resource | URL | Description |
|----------|-----|-------------|
| **Developer Theater Forum** | https://www.fantasygrounds.com/forums/forumdisplay.php?45 | Primary dev discussion |
| **Fantasy Grounds Academy** | https://www.fantasygroundsacademy.com/ | Tutorials, guides |
| **FG Academy Discord** | https://discord.gg/fgacademy | 5,000+ members, dev chat |
| **r/FantasyGrounds** | https://reddit.com/r/FantasyGrounds | Community discussions |

## Tutorials & Guides

| Resource | URL | Description |
|----------|-----|-------------|
| **Creating a Basic Extension** | https://www.fantasygrounds.com/forums/showthread.php?20449 | Classic tutorial (still relevant) |
| **CoreRPG Globals List** | https://reddit.com/r/FantasyGrounds/comments/kmdsf0 | Community-compiled globals |
| **Overriding CoreRPG Functions** | https://www.fantasygrounds.com/forums/showthread.php?43623 | Function hooking patterns |

## What Doesn't Exist (Gaps)

These resources would be valuable but don't exist publicly:

- [ ] **Lua Type Definitions** - No EmmyLua annotations for FGU globals
- [ ] **XML Schema/DTD** - No formal schema for extension XML
- [ ] **Comprehensive API Docs** - No complete function reference
- [ ] **VS Code Extension** - No FGU-specific IDE tooling with API defs

## Character Sheet Extensions (Reference Implementations)

*Extensions that create custom character sheets - useful patterns for HarnMaster:*

| Repository | URL | Description |
|------------|-----|-------------|
| **CapitalGains** | https://github.com/MeAndUnique/CapitalGains | Adds "Resources" section to PC/NPC character sheets |
| **FG-2e-PlayersOption** | https://github.com/drplote/FG-2e-PlayersOption | AD&D 2e extension modifying PC sheet Actions tab |
| **Siefer-DnD4e** | https://github.com/jawillia/Siefer-DnD4e-fg-class-extension- | DnD 4e class extension with sheet integration |
| **SD2FG-Converter** | https://github.com/kmheffernan/SD2FG-Converter | Shadowdark RPG character sheet converter |
| **FG-SW5e** | https://github.com/BeeGrinder/FantasyGrounds-SW5e | Star Wars 5e mod with sheet modifications |
| **FG-Path-of-War** | https://github.com/SoxMax/FG-Path-of-War-Enhancements | Pathfinder sheet additions |

### MoreCore Base

**MoreCore** is a foundational extension for generic/custom rulesets with flexible character sheets. While not directly on GitHub, it has derivatives:
- https://github.com/mesfoliesludiques/morecore-urban-shadows

Many custom rulesets (including the older HârnMaster 3) are built on MoreCore.

## HarnMaster / HARN System Resources

### HârnMaster 3.5E Ruleset (RECOMMENDED)

**Status:** Beta (as of July 2025)
**Developer:** Mephisto (with Columbia Games permission)
**Platform:** Fantasy Grounds Unity

This is the most current and actively developed HârnMaster implementation:

- **Forum Thread:** https://www.fantasygrounds.com/forums/showthread.php?85452-HârnMaster-3-5E
- **Forge Shop:** https://forge.fantasygrounds.com/shop/items/?search=harnmaster
- **Features:** Custom character sheet, skill rolls, d100 mechanics
- **Notes:** Early access beta; some skill roll bugs reported; community excited

### HârnMaster 3 Ruleset (MoreCore-based, Legacy)

**Status:** Functional but incomplete (2019)
**Developer:** GunnarGreybeard
**Platform:** Fantasy Grounds (MoreCore base)

Older implementation, useful for reference:

- **Forum Thread:** https://www.fantasygrounds.com/forums/showthread.php?50103-HârnMaster-3-Ruleset-(built-on-MoreCore)
- **Notes:** Built on MoreCore foundation; good for understanding flexible sheet patterns

### Additional HARN Resources

- **Blog Post (2017):** https://bloodybohemianearspooninn.com/2017/02/11/harnmaster-and-fantasy-grounds-vtt
- **Forum Discussion:** https://www.fantasygrounds.com/forums/showthread.php?46821-Harn-master

---

## Local Resources

### CoreRPG Source (Extract Locally)

The definitive API reference is the CoreRPG ruleset itself:

```bash
# Location after FGU install
~/SmiteWorks/Fantasy Grounds/rulesets/CoreRPG.pak

# Extract (it's a zip file)
cp CoreRPG.pak CoreRPG.zip
unzip CoreRPG.zip -d CoreRPG-extracted/
```

Key directories:
- `scripts/` - Lua globals and managers
- `base.xml` - Base UI definitions
- `client.xml` - Client-side definitions

### This Project's Structure

```
HMK-Extension/
├── extension/             # FGU extension source (symlink target)
│   ├── extension.xml      # Extension manifest
│   ├── scripts/
│   │   └── harn_manager.lua   # Main Lua script
│   └── xml/
│       ├── strings.xml        # String resources
│       ├── charsheet.xml      # Character sheet definition
│       └── tab_*.xml          # Tab content definitions
├── docs/
│   ├── macos-development-guide.md
│   ├── developer-resources.md (this file)
│   └── research/
└── references/            # Git submodules of example extensions
```

---

## Reference Repositories (Local)

The `references/` directory contains cloned open-source FGU extensions for learning patterns. This directory is git-ignored (not committed to this repo).

### Included References

| Repository | Purpose | Key Files to Study |
|------------|---------|-------------------|
| **FG-Aura-Effect** | Effect management, API patterns | `scripts/manager_aura*.lua` |
| **CapitalGains** | Character sheet resource section | `scripts/`, `campaign/` |
| **FG-2e-PlayersOption** | Tab modifications, house rules | `scripts/`, `cta/` |
| **FG-CoreRPG-Moon-Tracker** | Simple CoreRPG extension | `scripts/`, `utility/` |
| **FGU-Theme-Hearth** | UI theming, XML patterns | `common/`, `rulesets/` |

### Cloning This Repository (for new developers)

The reference repos are included as **git submodules**. When cloning this project:

```bash
# Option 1: Clone with submodules in one command
git clone --recursive https://github.com/YOUR_USERNAME/HMK-Extension.git

# Option 2: If already cloned without --recursive
git submodule update --init --recursive
```

### Updating References

To pull latest changes from all reference repos:

```bash
git submodule update --remote --merge
```

Or update a specific one:

```bash
cd references/FG-Aura-Effect && git pull origin main
```

---

*Last Updated: 2026-01-26*
