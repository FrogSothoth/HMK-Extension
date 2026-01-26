---
name: harn-guru
description: Use when questions arise about HarnMaster Kethira (HMK) game rules, mechanics, skills, attributes, combat, sunsigns, occupations, or any game system data. Activates for "how does X work in HarnMaster", "what attributes govern Y skill", "HMK rules for Z".
---

# Harn Guru

## Overview

Answer HarnMaster Kethira (HMK) game system questions using **local repository data only**. Never rely on training data or general knowledge about HarnMaster - editions differ significantly (HM3, HMG, HMK have incompatible rules).

**Database location:** `docs/hmk-rules/hmk-rules.db`

## CRITICAL: Query Workflow

```
┌─────────────────────────────────────────────────────────────┐
│  1. IDENTIFY QUESTION TYPE                                  │
│     Is this a lookup (skill stats, weapon data) or          │
│     an explanation (how does X work)?                       │
└─────────────────────────────────────────────────────────────┘
                            │
            ┌───────────────┴───────────────┐
            ▼                               ▼
┌───────────────────────┐       ┌───────────────────────────┐
│  LOOKUP QUERY         │       │  EXPLANATION QUERY        │
│  Use structured tables│       │  Use sections table       │
│  (skills, weapons,    │       │  with 2-step retrieval    │
│  armor, sunsigns...)  │       │                           │
└───────────────────────┘       └───────────────────────────┘
            │                               │
            ▼                               ▼
┌───────────────────────┐       ┌───────────────────────────┐
│  Direct query:        │       │  Step A: Query metadata   │
│  SELECT ... FROM      │       │  SELECT id, title,        │
│  skills/weapons/etc   │       │  summary, topics,         │
│                       │       │  when_to_reference        │
│                       │       │  FROM sections WHERE...   │
└───────────────────────┘       └───────────────────────────┘
                                            │
                                            ▼
                                ┌───────────────────────────┐
                                │  Step B: Fetch content    │
                                │  SELECT content FROM      │
                                │  sections WHERE id = ?    │
                                │  (only for best match)    │
                                └───────────────────────────┘
```

**Always query local data. Never guess from memory.**

---

## Path 1: Lookup Queries (Structured Data)

### ⚠️ IMPORTANT: Verify Schema Before Querying

**Don't assume table structure.** Before querying an unfamiliar table, run:
```sql
.schema tablename
```
This prevents errors from incorrect column assumptions.

### Key Table Schemas

```sql
-- SKILLS: 72 skills with governing attributes
CREATE TABLE skills (
    id INTEGER PRIMARY KEY,
    name TEXT UNIQUE NOT NULL,
    skill_group_id INTEGER REFERENCES skill_groups(id),
    attr1 TEXT,  -- First governing attribute (e.g., 'DEX')
    attr2 TEXT,  -- Second governing attribute (e.g., 'AGL')
    sunsign_bonus TEXT,
    notes TEXT
);

-- SKILL_GROUPS: 7 groups (N/C/X/P/L/S/E)
CREATE TABLE skill_groups (
    id INTEGER PRIMARY KEY,
    code TEXT UNIQUE NOT NULL,  -- N, C, X, P, L, S, E
    name TEXT NOT NULL,
    description TEXT
);

-- SUNSIGNS: 12 zodiac signs with date ranges
CREATE TABLE sunsigns (
    id INTEGER PRIMARY KEY,
    symbol TEXT NOT NULL,      -- e.g., 'Tree', 'Eagle'
    name TEXT NOT NULL,        -- e.g., 'Ùlándus', 'Hírien'
    day_start INTEGER NOT NULL,
    day_end INTEGER NOT NULL,
    description TEXT
);

-- SUNSIGN_MODIFIERS: Denormalized! One row per sunsign, columns per skill group
CREATE TABLE sunsign_modifiers (
    id INTEGER PRIMARY KEY,
    sunsign TEXT NOT NULL,     -- Name, not ID!
    nature INTEGER DEFAULT 0,
    craft INTEGER DEFAULT 0,
    combat INTEGER DEFAULT 0,
    physical INTEGER DEFAULT 0,
    lore INTEGER DEFAULT 0,
    social INTEGER DEFAULT 0
);

-- MELEE_WEAPONS: 56 weapons with combat stats
CREATE TABLE melee_weapons (
    id INTEGER PRIMARY KEY,
    name TEXT UNIQUE NOT NULL,
    category TEXT,             -- Axes, Clubs, Flails, Knives, Polearms, Shields, Swords
    wq INTEGER,                -- Weapon Quality
    weight REAL,
    price INTEGER,
    impact_dice INTEGER,       -- Number of d6
    impact_mod INTEGER,        -- Modifier to impact
    impact_aspect TEXT,        -- B/E/P (Blunt/Edged/Piercing)
    traits TEXT,               -- Comma-separated
    attack_mod INTEGER DEFAULT 0,
    defense_mod INTEGER DEFAULT 0,
    notes TEXT
);
```

### Common Queries

| Question Type | Example Query |
|---------------|---------------|
| Skill attributes | `SELECT name, attr1, attr2 FROM skills WHERE name = 'Melee'` |
| Skills by group | `SELECT s.name, s.attr1, s.attr2 FROM skills s JOIN skill_groups g ON s.skill_group_id = g.id WHERE g.code = 'X'` |
| Weapon stats | `SELECT name, impact_dice, impact_mod, impact_aspect FROM melee_weapons WHERE name LIKE '%sword%'` |
| Missile weapons | `SELECT name, range_short, range_medium FROM missile_weapons` |
| Armor values | `SELECT name, av_blunt, av_edged, av_pierce FROM armor_materials` |
| Sunsign dates | `SELECT name, symbol, day_start, day_end FROM sunsigns` |
| Sunsign bonuses | `SELECT * FROM sunsign_modifiers WHERE sunsign = 'Ùlándus'` |
| All sunsign mods | `SELECT sunsign, nature, craft, combat, physical, lore, social FROM sunsign_modifiers` |
| Occupations | `SELECT name, social_class FROM occupations` |
| Attributes | `SELECT abbrev, name, category FROM attributes` |

### Quick Reference

**Skill Group Codes:** N=Nature, C=Craft, X=Combat, P=Physical, L=Lore, S=Social, E=Esoteric

**Attribute Abbreviations:**
- Physical: STR, END, DEX, AGL, PER, CML
- Mental: AUR, WIL, REA, CRE, EMP, ELO
- Derived: VOI (Voice)

---

## Path 2: Explanation Queries (Rules & Procedures)

For "how does X work?" questions, use the `sections` table with **two-step retrieval** to minimize context usage.

### Step A: Query Metadata First

```sql
-- Find relevant sections WITHOUT loading full content
SELECT id, title, word_count, summary, topics, when_to_reference
FROM sections
WHERE topics LIKE '%keyword%'
   OR when_to_reference LIKE '%keyword%'
   OR summary LIKE '%keyword%'
ORDER BY word_count ASC;
```

**Review the summaries** to identify the most relevant section. The `when_to_reference` column tells you exactly when each section is useful.

### Step B: Fetch Only What You Need

```sql
-- Load full content for the single best match
SELECT content FROM sections WHERE id = 'ch2-persona';
```

### Sections Table Schema

| Column | Purpose |
|--------|---------|
| `id` | Section identifier (e.g., 'ch2-persona', 'ch5-combat') |
| `title` | Human-readable title |
| `chapter` | Chapter number (NULL for appendices) |
| `summary` | 1-2 paragraph description of contents |
| `topics` | JSON array of relevant keywords |
| `when_to_reference` | Guidance on when this section answers questions |
| `content_type` | 'rules', 'reference', 'flavor', 'tables' |
| `word_count` | Size indicator (prefer smaller sections) |
| `content` | Full markdown text (fetch only when needed) |

### Section ID Patterns

| Pattern | Contents |
|---------|----------|
| `ch2-*` | Character creation, birth, family, occupations, persona |
| `ch3-*` | Skills system, skill descriptions |
| `ch4-*` | Weapons, armor, possessions |
| `ch5-*` | Combat, injury, healing, travel, adventure |
| `ch6-*` | Magic, mysteries, religions |
| `ch7-*` | Bestiary, creatures |
| `ch8-*` | Campaign, GM advice |
| `app-*` | Appendices (regions, languages, character detail) |

---

## Example Workflows

### Example 1: Lookup Query
**Q: "What attributes govern the Physician skill?"**

```sql
SELECT name, attr1, attr2 FROM skills WHERE name = 'Physician';
```
→ "According to the HMK database, Physician uses REA and PER."

**One query. Done.**

---

### Example 2: Explanation Query
**Q: "How does attribute generation work during character creation?"**

**Step A - Find relevant sections:**
```sql
SELECT id, title, word_count, summary
FROM sections
WHERE topics LIKE '%attribute%'
  AND (when_to_reference LIKE '%character creation%'
       OR when_to_reference LIKE '%generation%')
ORDER BY word_count ASC;
```

Result shows `ch2-persona` (4707 words) with summary mentioning "physical and mental attributes (12 total)" and "mechanics for attribute testing."

**Step B - Fetch content:**
```sql
SELECT content FROM sections WHERE id = 'ch2-persona';
```

→ Summarize the relevant portions, citing "From ch2-persona (Persona)..."

**Two queries. Minimal context.**

---

### Example 3: Combined Query
**Q: "What combat skills are there and how does melee combat work?"**

**Part 1 - Lookup the skills:**
```sql
SELECT s.name, s.attr1, s.attr2
FROM skills s
JOIN skill_groups g ON s.skill_group_id = g.id
WHERE g.code = 'X';
```

**Part 2 - Find combat rules explanation:**
```sql
SELECT id, title, summary FROM sections
WHERE topics LIKE '%combat%' AND content_type LIKE '%rules%';
```

Then fetch content from the most relevant section.

---

## Red Flags - You're Doing It Wrong

- ❌ Assuming table schema without checking (use `.schema tablename` first)
- ❌ Reading markdown files directly from `extracted-sections/` folder
- ❌ Fetching section `content` before checking `summary` and `topics`
- ❌ Answering without querying local data first
- ❌ Saying "In HarnMaster..." from memory
- ❌ Guessing attribute pairs instead of querying
- ❌ Not citing the data source

## Green Flags - You're Doing It Right

- ✅ Checking `.schema tablename` for unfamiliar tables before querying
- ✅ Using the schemas documented above for common tables
- ✅ Querying structured tables for specific data
- ✅ Using metadata to find sections before loading content
- ✅ Loading only the most relevant section's content
- ✅ Citing sources: "According to the HMK database..." or "From ch5-combat..."
- ✅ Keeping context usage minimal
