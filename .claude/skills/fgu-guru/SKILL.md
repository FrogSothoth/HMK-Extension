---
name: fgu-guru
description: Use when questions arise about Fantasy Grounds Unity (FGU) extension development, XML layouts, Lua scripting, DB operations, windowclasses, anchoring, or any FGU API patterns. Activates for "how do I lay out X in FGU", "what's the pattern for Y", "FGU XML/Lua question".
---

# FGU Guru

## Overview

Answer Fantasy Grounds Unity extension development questions using **local repository documentation and reference implementations only**. Never rely on training data - FGU APIs change between versions and training data may be outdated or incorrect.

## The Living Documentation Pattern

`docs/patterns/` is a **folder of living documents** that grows through verified research:

1. **First time** a pattern is needed → Research it → Document it
2. **Future queries** for that pattern → Simple lookup

This means:
- Early questions require more research
- The documentation becomes more valuable over time
- Every pattern is verified and trustworthy
- Training data is never used

## CRITICAL: Query Workflow

```
┌─────────────────────────────────────────────────────────────┐
│  1. CHECK docs/patterns/index.md                            │
│     Find the relevant pattern file for this topic           │
└─────────────────────────────────────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────────┐
│  2. READ the specific pattern file                          │
│     (e.g., layout.md for anchoring questions)               │
└─────────────────────────────────────────────────────────────┘
                            │
            ┌───────────────┴───────────────┐
            ▼                               ▼
┌───────────────────────┐       ┌───────────────────────────┐
│  PATTERN FOUND        │       │  PATTERN NOT FOUND        │
│  Use it, cite source  │       │  Search references/       │
└───────────────────────┘       │  Document in pattern file │
                                └───────────────────────────┘
```

**Never answer from training data. Always cite a specific file.**

---

## Common Mistakes from Training Data

Training data often suggests incorrect patterns for FGU. Watch for these specific wrong assumptions:

| Wrong Assumption | Correct Pattern (see layout.md) |
|------------------|--------------------------------|
| "Use CSS-like flexbox" | FGU uses anchor-based positioning |
| "Set width/height for all elements" | Use `<left>` + `<right>` for responsive sizing |
| "Position with absolute x,y offsets" | Use `to="sibling"` + `position="righthigh"` |
| "Controls auto-refresh from DB" | Must use `DB.addHandler` + explicit `setValue()` |
| "Copy patterns from extension/ code" | Verify against `docs/patterns/` or `references/` first |

**Always verify patterns against `docs/patterns/` or `references/` before implementing.**

---

## WARNING: Extension Code May Contain Anti-Patterns

**Do NOT blindly copy from the `extension/` folder.** The extension codebase has evolved over time and may contain:

- Outdated approaches that have been superseded
- Anti-patterns that work but aren't best practice
- Incomplete implementations from WIP features
- Patterns that were never verified against references

**Always verify against `docs/patterns/` or `references/`, not the existing extension code.**

---

## Step 1: Check Local Documentation

**Primary source:** `docs/patterns/`

| File | Contents | Status |
|------|----------|--------|
| `index.md` | Overview, links to all pattern files | Start here |
| `layout.md` | Anchoring, positioning, containers, responsive sizing, templates, lists, Lua sizing | **30+ patterns** |
| `database.md` | DB.getValue, DB.setValue, DB.addHandler, cross-field reactivity | **4 patterns** |
| `lifecycle.md` | Script registration, onInit, onClose, super calls, handler cleanup | **6 patterns** |
| `game-data.md` | Static game data organization (skills, weapons, lookup tables) | **2 patterns** |
| `windowlist.md` | Dynamic lists, datasource binding | *not yet documented* |
| `strings.md` | Localization, string resources | *not yet documented* |

**Search for patterns:**
```bash
# Search all pattern files
grep -ri "keyword" docs/patterns/

# Search specific file
grep -i "keyword" docs/patterns/layout.md
```

If the pattern is documented, use it and cite the source file mentioned in the docs.

---

## CRITICAL: Handler Cleanup Rule

Every `DB.addHandler()` in `onInit()` **MUST** have a matching `DB.removeHandler()` in `onClose()`.

```lua
-- In onInit()
DB.addHandler(sPath, "onUpdate", onFieldChanged);

-- In onClose() - REQUIRED!
DB.removeHandler(sPath, "onUpdate", onFieldChanged);
```

**Failure to clean up handlers causes:**
- Memory leaks
- Stale callbacks firing on destroyed windows
- Duplicate callbacks after `/reload`
- Ghost updates on non-existent UI elements

See `docs/patterns/lifecycle.md` for the complete pattern with examples.

---

## Step 2: Search Reference Implementations

If not in docs, search the reference repositories in `references/`:

| Repository | Best For |
|------------|----------|
| `FG-2e-PlayersOption` | Lifecycle hooks, `super.onInit()`, handler cleanup |
| `CapitalGains` | DB operations, sync flags, windowlist, modern layouts |
| `FG-Aura-Effect` | Complex managers, options registration |
| `FG-CoreRPG-Moon-Tracker` | Function wrapping/replacement |

### Search Commands

**Find XML patterns:**
```bash
# Search for anchoring patterns
grep -r "anchored" references/ --include="*.xml" | head -20

# Search for specific position values
grep -r "position=\"righthigh\"" references/ --include="*.xml"

# Search for windowlist usage
grep -r "<windowlist" references/ --include="*.xml" -A 10
```

**Find Lua patterns:**
```bash
# Search for DB operations
grep -r "DB.getValue" references/ --include="*.lua" | head -20

# Search for handler patterns
grep -r "DB.addHandler" references/ --include="*.lua" -A 3

# Search for lifecycle hooks
grep -r "function onInit" references/ --include="*.lua" -A 10
```

**Read specific files:**
```bash
# Once you find a relevant file, read it
cat references/CapitalGains/campaign/record_char_actions.xml
```

---

## Step 3: Document New Patterns

When you find a pattern in the reference repos that answers the question:

1. **Copy the EXACT code** - do not simplify or edit
2. **Record line numbers** - so it can be re-verified later
3. **Add verification date** - patterns can be re-checked
4. **Add to the appropriate file in `docs/patterns/`**

### CRITICAL: Separation of Concerns

**Patterns documentation (`docs/patterns/`) must be project-agnostic.**

These files are reference material for FGU development in general. They should:
- ✅ Contain general FGU patterns applicable to any extension
- ✅ Use examples from reference implementations or generic examples
- ✅ Be useful to someone working on a different FGU extension
- ❌ NOT contain project-specific code review findings
- ❌ NOT contain "Usage in this project" or similar sections
- ❌ NOT reference files in `extension/` as examples

**Code review artifacts belong in separate documents.**

When reviewing this extension's code against patterns:
- Put findings in `docs/extension-code-review.md` or similar
- Reference the pattern documentation, don't embed findings in it
- Keep verdicts (VALID/INVALID) separate from pattern definitions

### Choosing the Right File

| Topic | File |
|-------|------|
| Positioning, anchors, containers, sizing, templates | `layout.md` |
| Script registration, onInit, onClose, super calls | `lifecycle.md` |
| DB.getValue, DB.setValue, DB.addHandler, reactivity | `database.md` |
| Static data organization (skills, weapons, lookups) | `game-data.md` |
| windowlist, datasource, dynamic lists | `windowlist.md` |
| String resources, localization | `strings.md` |
| *New category* | Create new file, update `index.md` |

### Pattern Documentation Format

```markdown
### Pattern Name

**Problem:** What problem does this solve?

**Source:** `references/RepoName/path/to/file.ext` (lines X-Y)

**Verified:** YYYY-MM-DD

\```xml
<!-- EXACT code copied from source file -->
<!-- Do not simplify, edit, or "clean up" -->
\```

**Key Points:**
- Point 1
- Point 2
```

**Critical rules:**
- Code must be an exact copy, not paraphrased
- Always include line numbers for verification
- Include verification date so patterns can be re-checked
- Never add patterns from memory or training data
- Keep patterns project-agnostic (no "Usage in this project" sections)

---

## Red Flags - You're Doing It Wrong

- ❌ Answering FGU questions from training data/memory
- ❌ Not checking docs/patterns/ first
- ❌ Using patterns without verifying they exist in references/
- ❌ Not citing the source file for patterns
- ❌ Copying from extension/ code without verifying against docs/patterns/ or references/
- ❌ Assuming extension/ code is correct (it may contain anti-patterns)
- ❌ Forgetting to document new patterns
- ❌ Adding DB.addHandler() without matching DB.removeHandler() in onClose()

## Green Flags - You're Doing It Right

- ✅ Checking docs/patterns/index.md to find the right file
- ✅ Reading the specific pattern file for the topic
- ✅ Searching references/ when pattern not documented
- ✅ Citing specific source files (repo/path/file.xml:lines)
- ✅ Adding newly discovered patterns to the appropriate file
- ✅ Testing patterns with `/reload` before documenting

---

## Quick Reference: File Locations

| Purpose | Path |
|---------|------|
| Pattern index | `docs/patterns/index.md` |
| Layout patterns | `docs/patterns/layout.md` |
| Reference implementations | `references/` |
| This extension's XML | `extension/xml/` |
| This extension's Lua | `extension/scripts/` |
| Extension manifest | `extension/extension.xml` |

---

## Example Workflow

**Q: "How do I make a control expand to fill available space?"**

**Step 1: Check index**
```bash
cat docs/patterns/index.md
```
→ Layout questions → `layout.md`

**Step 2: Check layout.md**
```bash
grep -i "fill\|expand\|responsive" docs/patterns/layout.md
```
→ Found "Responsive Fill (Expand to Container)" pattern

**Step 3: Read the pattern**
→ Pattern is documented with source: `references/CapitalGains/campaign/record_resource.xml` (lines 66-72)

**Step 4: Answer with citation**
→ "To make a control fill available space, use anchors on both left and right edges. See the 'Responsive Fill' pattern in `docs/patterns/layout.md`, verified from `references/CapitalGains/campaign/record_resource.xml` lines 66-72."
