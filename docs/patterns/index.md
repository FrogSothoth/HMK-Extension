# FGU Development Patterns

This folder contains verified patterns extracted from working reference implementations in `references/`. Each pattern file focuses on a specific concept.

## How to Use This Documentation

```
┌─────────────────────────────────────────────────────────────┐
│  1. Check this index for the relevant pattern file          │
└─────────────────────────────────────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────────┐
│  2. Read the specific pattern file                          │
│     (e.g., layout.md for anchoring questions)               │
└─────────────────────────────────────────────────────────────┘
                            │
            ┌───────────────┴───────────────┐
            ▼                               ▼
┌───────────────────────┐       ┌───────────────────────────┐
│  Pattern found?       │       │  Pattern not found?       │
│  Use it, cite source  │       │  Research in references/  │
└───────────────────────┘       │  Add to appropriate file  │
                                └───────────────────────────┘
```

## Pattern Files

| File | Contents | Status |
|------|----------|--------|
| [layout.md](layout.md) | Anchoring, positioning, containers, responsive sizing | 8 patterns |
| [lifecycle.md](lifecycle.md) | Script registration, onInit, onClose, super calls, handler cleanup, inline vs external | 6 patterns |
| [game-data.md](game-data.md) | Static game data organization (skills, weapons, lookup tables) | 2 patterns |
| [database.md](database.md) | DB.getValue, DB.setValue, DB.addHandler, cross-field reactivity | 4 patterns |
| [windowlist.md](windowlist.md) | Dynamic lists, datasource binding | *not yet documented* |
| [strings.md](strings.md) | Localization, string resources | *not yet documented* |

## Rules

1. **Never add patterns from memory or training data**
2. **Every pattern must cite a specific file and line numbers**
3. **Code examples must be exact copies, not simplified/edited**
4. **Include verification date for re-checking**
5. **Keep patterns project-agnostic** - no "Usage in this project" sections

## Separation of Concerns

**These pattern files are general FGU development reference material.**

They should be useful to anyone working on FGU extensions, not just this project. Code review findings, project-specific issues, and implementation notes belong in separate documents (e.g., `docs/extension-code-review.md`).

## Pattern Format

Each pattern should follow this format:

```markdown
### Pattern Name

**Problem:** What problem does this solve?

**Source:** `references/RepoName/path/to/file.ext` (lines X-Y)

**Verified:** YYYY-MM-DD

\```xml
<!-- Exact code copied from source file -->
\```

**Key Points:**
- Point 1
- Point 2
```

## Reference Repositories

| Repository | Path | Best For |
|------------|------|----------|
| FG-2e-PlayersOption | `references/FG-2e-PlayersOption/` | Lifecycle hooks, super calls |
| CapitalGains | `references/CapitalGains/` | DB operations, layouts |
| FG-Aura-Effect | `references/FG-Aura-Effect/` | Complex managers |
| FG-CoreRPG-Moon-Tracker | `references/FG-CoreRPG-Moon-Tracker/` | Function wrapping |

## Search Commands

```bash
# Find XML patterns
grep -r "keyword" references/ --include="*.xml"

# Find Lua patterns
grep -r "keyword" references/ --include="*.lua"

# Read specific file
cat references/RepoName/path/to/file.ext
```
