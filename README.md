# HarnMaster Character Sheet for Fantasy Grounds Unity

A custom character sheet extension for the [HarnMaster Kethira (HMK)](https://www.kelestia.com/) RPG system, built for [Fantasy Grounds Unity](https://www.fantasygrounds.com/).

> **This project is set up for Claude Code.** Your AI assistant can help with setup, answer HMK rules questions from the local database, find code patterns, and write extension code. Don't hesitate to ask for help at any step.

---

## What Is This Project?

This project creates a **character sheet extension** for Fantasy Grounds Unity (FGU) that supports the HarnMaster Kethira tabletop RPG. FGU is a virtual tabletop application, and extensions customize how it handles different game systems.

**What we're building:**
- A character sheet with HMK's 12 attributes, 7 skill categories, and combat tracking
- Automatic calculations (Mastery Level = Score × 5, Skill Base from attribute pairs)
- Sunsign determination from the Kethiran calendar

**The technology:**
- **Lua 5.1** - The scripting language FGU uses (sandboxed, no external libraries)
- **XML** - Defines the UI layout (character sheet tabs, fields, buttons)
- **CoreRPG** - FGU's base ruleset that we extend

---

## Project Organization

This repository is organized to support both **development** and **learning**:

```
.
├── extension/           # THE ACTUAL EXTENSION (this is what FGU loads)
│   ├── extension.xml    # Manifest - tells FGU what to load
│   ├── scripts/         # Lua code (game logic, calculations)
│   └── xml/             # UI definitions (character sheet layout)
│
├── docs/                # LEARNING RESOURCES
│   ├── patterns/        # "How do I do X in FGU?" - code patterns
│   ├── hmk-rules/       # HMK game rules (database + markdown)
│   ├── hmk-data/        # Structured game data (JSON)
│   └── official-sources/# Kelestia's official PDFs and spreadsheets
│
├── references/          # EXAMPLE EXTENSIONS TO LEARN FROM
│   ├── FG-2e-PlayersOption/   # Great for: lifecycle patterns
│   ├── CapitalGains/          # Great for: database handlers
│   ├── FG-Aura-Effect/        # Great for: complex managers
│   └── FG-CoreRPG-Moon-Tracker/ # Great for: function wrapping
│
├── .claude/skills/      # AI ASSISTANT SKILLS
│   ├── harn-guru/       # Answers HMK rules questions from local data
│   └── fgu-guru/        # Answers FGU development questions from patterns/references
│
├── CLAUDE.md            # Instructions for AI coding assistants
└── README.md            # This file
```

### Why This Structure?

| Folder | Purpose | When You'll Use It |
|--------|---------|-------------------|
| `extension/` | The code FGU actually runs | Every time you make changes |
| `docs/patterns/` | FGU coding patterns with examples | When you're stuck on "how do I..." |
| `docs/hmk-rules/` | HMK game rules database | When you need game mechanics info |
| `references/` | Working extensions to study | When learning new patterns |
| `.claude/skills/` | AI assistant capabilities | When asking rules or FGU dev questions |

---

## Getting Started

> **Using Claude Code?** You don't need to run these commands yourself. Just ask Claude to help you set up the project - it can clone the repo, create the symbolic link, and verify everything is working. Say something like: *"Help me set up this project for FGU development on Windows"*

### Step 1: Clone the Repository

```bash
git clone https://github.com/your-username/HMK-Extension.git
cd HMK-Extension
git submodule update --init --recursive   # Downloads reference extensions
```

### Step 2: Link to Fantasy Grounds

FGU needs to find our extension. We create a **symbolic link** so FGU sees our `extension/` folder.

> **Let Claude help:** Ask *"Create the symbolic link from my extension folder to FGU"* - Claude can detect your platform and create the correct link.

**Find your FGU data folder:**
- **Windows:** `%APPDATA%\SmiteWorks\Fantasy Grounds\`
- **macOS:** `~/SmiteWorks/Fantasy Grounds/`

**Create the link:**

| Platform | Command (run from repo root) |
|----------|------------------------------|
| **Windows** | `mklink /D "%APPDATA%\SmiteWorks\Fantasy Grounds\extensions\HarnMaster" "%CD%\extension"` |
| **macOS/Linux** | `ln -s "$(pwd)/extension" ~/SmiteWorks/Fantasy\ Grounds/extensions/HarnMaster` |

**Verify it worked:**
1. Check that `[FGU Data Folder]/extensions/HarnMaster/extension.xml` exists
2. Launch FGU, load any campaign, enable "HarnMaster" extension
3. You should see: "HarnMaster Extension loaded (HMK-Extension)"

### Step 3: Development Workflow

```
Edit code in extension/  →  Type /reload in FGU chat  →  See changes
```

That's it. The symbolic link means FGU always sees your latest edits.

**If changes don't appear after `/reload`:**
- Your symbolic link is probably broken
- Ask Claude: *"Check if my FGU extension link is set up correctly"*

---

## Learning FGU Development

> **Claude is your pair programmer.** When you're stuck, describe what you're trying to do: *"I need to add a new field that auto-calculates from two other fields"* - Claude will check docs/patterns/ and reference extensions to show you how.

Claude has access to a **fgu-guru** skill that searches local patterns and reference implementations. Ask naturally:

- *"How do I make a field expand to fill available space?"*
- *"What's the pattern for handling database changes?"*
- *"How does anchoring work in FGU XML?"*

Claude will search verified local code rather than guessing from training data.

### Start Here: docs/patterns/

**Location:** `docs/patterns/` (folder with multiple pattern files)

These documents show you how to do common things in FGU with working code examples:
- How to read/write character data (DB.getValue/DB.setValue)
- How to create calculated fields (onValueChanged)
- How to make lists that add/remove items (windowlist)
- How to clean up properly (handler removal in onClose)

**Every example includes its source file** so you can see it in context.

### Learn From Working Extensions

The `references/` folder contains real, working FGU extensions. When `docs/patterns/` isn't enough, study these:

| Extension | What to Learn | Key Files to Read |
|-----------|---------------|-------------------|
| **FG-2e-PlayersOption** | Lifecycle hooks, `super.onInit()` pattern | `campaign/scripts/char_main.lua` |
| **CapitalGains** | Database handlers, preventing feedback loops | `scripts/manager_resource.lua` |
| **FG-Aura-Effect** | Complex manager patterns | `scripts/manager_effect_aura.lua` |
| **FG-CoreRPG-Moon-Tracker** | Wrapping existing functions | `scripts/manager_moon.lua` |

**How to explore them:**

Ask Claude to help you find patterns:
- *"Show me how CapitalGains handles database updates"*
- *"Find an example of onInit/onClose in the reference extensions"*
- *"How does FG-Aura-Effect register its handlers?"*

Claude will search the reference code and explain what it finds.

These are **read-only references** - don't edit them, just learn from them.

---

## HMK Game Rules Reference

When implementing game mechanics, you need accurate HMK rules data. **Don't guess from memory** - HMK differs from other HarnMaster editions (HM3, HMG).

### Just Ask Claude

Claude has access to a **harn-guru** skill that queries the local HMK database. Just ask naturally:

- *"What attributes govern the Melee skill?"*
- *"How does the injury system work?"*
- *"What's the Skill Base formula for Physician?"*

Claude will query the local database and rulebook files rather than guessing from training data.

**Why this matters:** Training data might say Melee uses "Strength and Dexterity" (wrong). The actual HMK rules say it uses **DEX and AGL**. Claude's harn-guru skill queries our local database to get the correct answer.

### Query the Database Directly

The SQLite database at `docs/hmk-rules/hmk-rules.db` is the authoritative source:

```bash
# What skills are in the Combat group?
sqlite3 docs/hmk-rules/hmk-rules.db \
  "SELECT name, attr1, attr2 FROM skills WHERE skill_group_id = 3"

# What are all the attributes?
sqlite3 docs/hmk-rules/hmk-rules.db \
  "SELECT abbrev, name, category FROM attributes"

# Weapon stats
sqlite3 docs/hmk-rules/hmk-rules.db \
  "SELECT name, wq, impact_dice, impact_mod FROM melee_weapons"
```

### Other Data Sources

| Resource | What It Contains | When to Use |
|----------|------------------|-------------|
| `docs/hmk-rules/hmk-rules.db` | 35+ tables of game data | Primary source for mechanics |
| `docs/hmk-rules/extracted-sections/` | Full rulebook as markdown | When you need rules *explanations* |
| `docs/hmk-data/*.json` | Skills, weapons, armor as JSON | Quick lookups, simpler parsing |
| `docs/official-sources/` | Kelestia PDFs and spreadsheets | Official character sheets, formulas |

---

## Quick Reference

### Key Files in extension/

| File | What It Does |
|------|--------------|
| `extension.xml` | Manifest - defines what files to load |
| `scripts/harn_manager.lua` | Calendar, sunsign calculations |
| `scripts/skills_manager.lua` | Skill operations, SB calculations |
| `scripts/skills_data.lua` | All 72 skills with governing attributes |
| `xml/charsheet.xml` | Main character sheet structure |
| `xml/tab_*.xml` | Individual tab layouts |
| `xml/strings.xml` | All UI text (labels, etc.) |

### Common Commands

```bash
# Reload extension in FGU (type in FGU chat)
/reload

# Query game data
sqlite3 docs/hmk-rules/hmk-rules.db "YOUR QUERY"
```

**Checking for errors:** Ask Claude *"Check the FGU logs for errors"* - it can read the log file directly and tell you what went wrong. No need to copy/paste logs.

### Debug in Lua

```lua
Debug.console("Label:", variable)  -- Output to log file
Debug.chat("Message")              -- Output to FGU chat
```
