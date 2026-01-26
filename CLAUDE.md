# HarnMaster Character Sheet Extension for Fantasy Grounds Unity

## Project Overview

This extension provides a custom character sheet for the HarnMaster RPG system running on Fantasy Grounds Unity (FGU). It extends CoreRPG with HarnMaster-specific attributes, skills, and calculations.

**Key Features:**
- 12 attributes (6 physical, 6 mental) with auto-calculated ML (Score × 5)
- 7 skill categories with SB (Skill Base) calculations
- Kethiran calendar with sunsign determination
- Combat tracking with injury/fatigue systems

## Tech Stack

- **Lua 5.1** - Sandboxed runtime (no file I/O, no external libs)
- **XML** - UI templates and windowclass definitions
- **CoreRPG** - Base ruleset being extended
- **FGU Runtime** - Fantasy Grounds Unity v5.x

## Project Structure

```
.
├── extension/                 # FGU extension source (symlink target)
│   ├── extension.xml          # Manifest - defines extension metadata and includes
│   ├── scripts/
│   │   ├── harn_manager.lua       # Main manager - lifecycle hooks, calendar/sunsign
│   │   └── bu_skills_manager.lua  # Skills manager - skill definitions and SB calcs
│   └── xml/
│       ├── strings.xml        # Localized strings (173 entries)
│       ├── charsheet.xml      # Main character sheet with tab definitions
│       ├── tab_main.xml       # Birth, family, standing, appearance
│       ├── tab_attributes.xml # Physical/mental attributes with auto-calc ML
│       ├── tab_skills.xml     # 7 skill category lists with CRUD
│       ├── tab_combat.xml     # Weapons, injuries, fatigue
│       └── tab_gear.xml       # Equipment and encumbrance
│
├── docs/                      # Development documentation
│   ├── patterns/              # FGU patterns (folder with index)
│   │   ├── index.md           # Pattern index and overview
│   │   └── layout.md          # Anchoring, positioning, responsive sizing
│   ├── macos-development-guide.md
│   ├── hmk-rules/             # HMK rulebook content
│   │   ├── extracted-sections/   # 82 markdown files (full rulebook)
│   │   └── hmk-rules.db          # SQLite database (skills, weapons, etc.)
│   ├── hmk-data/              # Structured JSON data
│   │   ├── hmk-skills.json       # 72 skills with attrs, groups, SB
│   │   ├── hmk-weapons.json      # 79 weapons with full stats
│   │   └── hmk-armor.json        # Armor data
│   ├── official-sources/      # Kelestia official aids (PDFs, spreadsheets)
│   └── research/              # Background research on HMK tools
│
├── references/                # Git submodules of working FGU extensions
└── CLAUDE.md                  # This file
```

## Development Setup (IMPORTANT)

Before making changes, verify the extension folder is linked so edits are immediately available to FGU.

### Required Link

Create a symbolic link (or directory junction on Windows) from FGU's extensions folder to this project's `extension/` directory:

```
[FGU Data Folder]/extensions/HarnMaster  →  [This Repo]/extension/
```

**FGU Data Folder locations:**
- **macOS:** `~/SmiteWorks/Fantasy Grounds/`
- **Windows:** `%APPDATA%\SmiteWorks\Fantasy Grounds\` (or check FGU settings)

### Verify Setup
1. Check that `[FGU Data Folder]/extensions/HarnMaster/extension.xml` exists and points to this repo
2. Launch FGU and load a campaign
3. Enable the "HarnMaster" extension
4. Type `/reload` in chat
5. You should see: "HarnMaster Character Sheet Extension loaded"

**Without this link, you'll need to manually copy files after every change.**

---

## Key Files

| File | Purpose |
|------|---------|
| `extension/extension.xml` | Extension manifest, file includes, script registration |
| `extension/scripts/harn_manager.lua` | Global `HarnManager` - calendar, sunsign calculations |
| `extension/scripts/bu_skills_manager.lua` | Global `SkillsManager` - skill database, SB formulas |
| `extension/xml/charsheet.xml` | Character sheet windowclass with 5-tab structure |
| `extension/xml/tab_skills.xml` | Windowlist pattern for dynamic skill lists |
| `extension/xml/strings.xml` | All UI text (labels, headers, abbreviations) |

## Development Workflow

### Reload Cycle
1. Edit files in `extension/` directory
2. Save changes
3. In FGU chat: `/reload` (or bind to hotkey)
4. Check logs for errors

### Log Monitoring

FGU writes errors to `Player.log`. The agent can read this file directly - the user doesn't need to copy/paste log contents.

**Log locations (detect platform and find automatically):**
- **Windows:** `%APPDATA%\SmiteWorks\Fantasy Grounds\logs\Player.log`
- **macOS:** `~/Library/Logs/SmiteWorks/Fantasy Grounds/Player.log`

**Agent should proactively offer to check logs** when the user reports issues like:
- "It's not working"
- "I see an error"
- "Something broke after /reload"

### Debug Output
```lua
Debug.console("Label:", variable)  -- To console/log (visible in Player.log)
Debug.chat("Message")              -- To chat window
```

## Critical Constraints

1. **No Hot Reload** - Must `/reload` entire extension after any change
2. **DB Persistence** - All character data via `DB.getValue`/`DB.setValue`
3. **No External Libs** - Sandboxed Lua, no `require`, no file I/O
4. **Lua 5.1 Only** - No `goto`, no bitwise ops, no `_ENV`
5. **Handler Cleanup** - Always `DB.removeHandler` in `onClose()`

## Documentation

| Document | Contents |
|----------|----------|
| [docs/patterns/](docs/patterns/) | FGU patterns with code examples from references |
| [docs/macos-development-guide.md](docs/macos-development-guide.md) | macOS setup, config files, debugging |

## Reference Repositories

The `references/` directory contains git submodules of well-written FGU extensions for learning:

| Submodule | Best For |
|-----------|----------|
| `FG-2e-PlayersOption` | `super.onInit()` pattern, handler cleanup |
| `FG-Aura-Effect` | Complete DB API usage, effect management |
| `CapitalGains` | Handler patterns, sync flags, modern layouts |
| `FG-CoreRPG-Moon-Tracker` | Function wrapping/replacement |

These are read-only references - don't modify them.

## HMK Game Data Resources

The `docs/` directory contains extensive HarnMaster Kethira (HMK) game data. **Use the SQLite database as the primary source** for game mechanics data.

### Primary Source: SQLite Database

**Location:** `docs/hmk-rules/hmk-rules.db`

This database contains authoritative HMK game data across 35+ tables:

| Category | Tables | Records |
|----------|--------|---------|
| **Skills** | `skills`, `skill_groups`, `attributes` | 72 skills, 7 groups, 13 attributes |
| **Combat** | `melee_weapons`, `missile_weapons`, `combat_rules` | 56 melee, 23 missile weapons |
| **Armor** | `armor_materials`, `armor_items`, `armor_suits`, `body_zones` | 33 materials, 15 body zones |
| **Character** | `occupations`, `social_classes`, `sunsigns` | 93 occupations, 29 sunsigns |
| **Calendar** | `months`, `sunsign_modifiers`, `sunsign_traits` | Kethiran calendar data |
| **Injuries** | `injury_levels`, `shock_states`, `healing_rules` | Trauma system |

**Example Queries:**

```bash
# List all skills with their attribute pairs
sqlite3 docs/hmk-rules/hmk-rules.db \
  "SELECT s.name, s.attr1, s.attr2, g.name as group_name
   FROM skills s JOIN skill_groups g ON s.skill_group_id = g.id"

# Get combat skills
sqlite3 docs/hmk-rules/hmk-rules.db \
  "SELECT name, attr1, attr2 FROM skills WHERE skill_group_id =
   (SELECT id FROM skill_groups WHERE code = 'combat')"

# List melee weapons with impact stats
sqlite3 docs/hmk-rules/hmk-rules.db \
  "SELECT name, wq, weight, impact_dice, impact_mod, impact_aspect FROM melee_weapons"

# Get sunsign modifiers for skill groups
sqlite3 docs/hmk-rules/hmk-rules.db \
  "SELECT s.name as sunsign, g.name as skill_group, m.modifier
   FROM sunsign_modifiers m
   JOIN sunsigns s ON m.sunsign_id = s.id
   JOIN skill_groups g ON m.skill_group_id = g.id"
```

### Secondary Sources

| Resource | Use Case |
|----------|----------|
| `docs/hmk-data/*.json` | Quick lookups, simpler parsing when SQL is overkill |
| `docs/hmk-rules/extracted-sections/` | Rules text reference (82 markdown files from rulebook) |
| `docs/official-sources/` | Kelestia official PDFs and spreadsheets |

### Official Sources (`docs/official-sources/`)

Kelestia Productions official aids including skill calculation spreadsheets and combat reference PDFs.

---

## Agent Instructions

### Extension Link Verification (IMPORTANT - Check Proactively)

**At the start of any development session**, verify the extension folder is properly linked to FGU.

**What to check:**
1. Locate the FGU data folder (platform-dependent, see Development Setup above)
2. Verify `[FGU Data Folder]/extensions/HarnMaster` exists
3. Verify it's a symlink/junction pointing to this repo's `extension/` subdirectory (not the repo root)
4. Verify `extension.xml` is accessible through that link

**Red flags that indicate missing/broken link:**
- User mentions "copying files" to FGU folder
- User says changes aren't appearing after `/reload`
- User asks why they have to restart FGU to see changes
- Link doesn't exist or points to wrong location
- Link points to repo root instead of `extension/` subdirectory

**If link is missing or incorrect:**
1. Remove any existing link at `[FGU Data Folder]/extensions/HarnMaster`
2. Create new symlink (macOS/Linux) or directory junction (Windows) pointing to `[repo]/extension/`
3. Verify by checking that `extension.xml` is visible through the link
4. Have user test with `/reload` in FGU

### Log Monitoring (Proactive - Don't Wait for User to Paste Logs)

**You can read FGU's log file directly.** The user does NOT need to copy/paste log contents.

**Log file locations (detect platform automatically):**
- **Windows:** `%APPDATA%\SmiteWorks\Fantasy Grounds\logs\Player.log`
- **macOS:** `~/Library/Logs/SmiteWorks/Fantasy Grounds/Player.log`

**Proactively offer to check logs when:**
- User reports "it's not working" or "I see an error"
- User says something broke after `/reload`
- User is debugging any issue with the extension
- After helping make code changes, offer to check logs after they test

**How to check:**
1. Detect the user's platform
2. Read the log file directly using the Read tool
3. Look for recent errors, warnings, or Lua stack traces
4. Report findings to the user with specific line references

**Example:** "I see an error in Player.log at line 1523: `attempt to index nil value` in `harn_manager.lua:45`. This suggests..."

### HMK Rules Questions (Use harn-guru Skill)

**When the user asks about HarnMaster Kethira game mechanics**, use the harn-guru skill at `.claude/skills/harn-guru/SKILL.md`.

**Triggers:**
- "What attributes govern X skill?"
- "How does Y work in HarnMaster?"
- "What are the rules for Z?"
- Any question about skills, weapons, combat, sunsigns, occupations, injuries

**Why this matters:** HMK differs significantly from other HarnMaster editions (HM3, HMG). Training data may have incorrect information. The harn-guru skill ensures answers come from the local SQLite database and extracted rulebook.

**Example:** If asked "What attributes govern Melee?", query the database rather than guessing:
```bash
sqlite3 docs/hmk-rules/hmk-rules.db "SELECT attr1, attr2 FROM skills WHERE name = 'Melee'"
```
Answer: DEX and AGL (not "Strength and Dexterity" as training data might suggest).

### FGU Development Questions (Use fgu-guru Skill)

**When the user asks about FGU extension development**, use the fgu-guru skill at `.claude/skills/fgu-guru/SKILL.md`.

**Triggers:**
- "How do I lay out X in FGU?"
- "What's the pattern for Y?"
- "How does anchoring work?"
- Any question about XML layouts, Lua scripting, DB operations, windowclasses

**Workflow:**
1. Check `docs/patterns/` first for documented patterns
2. If not found, search `references/` for working examples
3. Document new patterns back to the appropriate file in `docs/patterns/`

**Why this matters:** FGU APIs change between versions. Training data may be outdated. The fgu-guru skill ensures answers come from verified reference implementations in this repository.

**Example:** If asked "How do I make a field expand to fill space?", don't guess - search references:
```bash
grep -r "right offset" references/ --include="*.xml" | head -5
```
Then document the pattern in `docs/patterns/layout.md` for future reference.

### General Development Rules

1. **All extension edits go in `extension/`** - Never edit files directly in the FGU data folder.

2. **Use the appropriate skill for questions:**
   - **HMK game rules** → Use harn-guru skill (queries SQLite database)
   - **FGU development** → Use fgu-guru skill (checks docs/patterns/, then references/)

3. **Document as you learn** - When you discover a new FGU pattern from references/, add it to the appropriate file in `docs/patterns/` so future queries are simple lookups.

4. **Test with `/reload`** - After changes, user should type `/reload` in FGU chat. If this doesn't reflect changes, the link is likely broken.
