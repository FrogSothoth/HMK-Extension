# HarnMaster Extension Code Review

**Review Date:** 2026-01-26
**Methodology:** Each finding was verified against reference implementations in `references/` using the fgu-guru skill workflow. No findings are based on training data assumptions.

---

## Summary

| # | Issue | Verdict | Priority |
|---|-------|---------|----------|
| 1 | Script not registered | **VALID** | Must Fix |
| 2 | Duplicated skill data | **VALID** | Must Fix |
| 3 | No cross-field reactivity | **VALID** | Must Fix |
| 4 | Missing super.onInit() | **INVALID** | N/A |
| 5 | Empty onClose() | **PARTIALLY VALID** | Low |
| 6 | `<disabled />` vs `<invisible />` | **PARTIALLY VALID** | Low |
| 7 | Fixed positioning | **PARTIALLY VALID** | Low |
| 8 | Inline scripts too large | **PARTIALLY VALID** | Low |

---

## Issue 1: Script Not Registered (VALID)

**Finding:** `bu_skills_manager.lua` exists but is not registered in `extension.xml`, making it dead code.

**Evidence:** Searched all 5 reference extensions - every single Lua file is registered in extension.xml. FGU's sandboxed environment has no `require`, `dofile`, or `loadfile` - scripts can only be loaded via `<script>` tags.

**Current State:**
```xml
<!-- extension/extension.xml line 30 -->
<script name="HarnManager" file="scripts/harn_manager.lua" />
<!-- bu_skills_manager.lua is NOT registered -->
```

**Impact:**
- `SkillsManager` global table never exists
- `SkillsManager.onInit()` never runs
- All 72 skill definitions and SB calculation functions are inaccessible
- The `tab_skills.xml` cannot call `SkillsManager` functions

**Fix Required:**
```xml
<script name="SkillsManager" file="scripts/bu_skills_manager.lua" />
```

**Pattern Reference:** See `docs/patterns/lifecycle.md` → "Script Registration"

---

## Issue 2: Duplicated Skill Data (VALID)

**Finding:** Skill data exists in two places with different formats and different subsets.

**Evidence:** Reference extensions store game data in ONE place (Lua managers). XML does not contain duplicate data tables.

**Current State:**

| Location | Skills | Format |
|----------|--------|--------|
| `bu_skills_manager.lua` | 72 skills | `{name, category, att1, att2, multiple}` |
| `tab_skills.xml` onInit() | ~24 skills | `{name, base}` where base="CML:EMP" |

**Impact:**
- Data out of sync - 72 vs 24 skills
- Different formats prevent programmatic sync
- Changes require editing two files
- `tab_skills.xml` doesn't use `SkillsManager` (which is dead code anyway)

**Fix Required:**
1. Register `SkillsManager` (Issue 1)
2. Remove hardcoded skills from `tab_skills.xml`
3. Have `tab_skills.xml` call `SkillsManager.getSkillsByCategory()` or similar

**Pattern Reference:** See `docs/patterns/game-data.md` → "Single Source of Truth"

---

## Issue 3: No Cross-Field Reactivity (VALID)

**Finding:** When attribute scores change, skill SB values are not recalculated.

**Evidence:** Reference extensions use `DB.addHandler()` to watch source fields and trigger dependent calculations. See `FG-2e-PlayersOption/campaign/scripts/char_main.lua` which watches 8 comeliness fields to trigger `updateComeliness()`.

**Current State:**
- `tab_attributes.xml` has inline `onValueChanged()` for ML calculation (Score × 5) - this works
- NO handlers watch attribute changes to update skill SB values
- `SkillsManager.updateAllSkillSB()` exists but is never called (dead code)

**Impact:**
- User changes STR from 12 to 14
- Skills using STR (Jumping, Masonry, Metalcraft, etc.) keep stale SB values
- User must manually recalculate or close/reopen character sheet

**Fix Required:**
1. Add DB handlers in character sheet window to watch all 12 attribute `*_score` fields
2. On any attribute change, call `SkillsManager.updateAllSkillSB(nodeChar)`
3. Add matching `DB.removeHandler()` calls in `onClose()`

**Pattern Reference:** See `docs/patterns/database.md` → "Cross-Field Dependent Calculations"

---

## Issue 4: Missing super.onInit() (INVALID)

**Finding:** Original review claimed `harn_tab_main` should call `super.onInit()`.

**Evidence:** Researched when super calls are required:
- New windowclass (no `merge` attribute) → No super exists, calling it would error
- Extended windowclass (`merge="join"`) → Must call super
- Inline script on built-in control → Must call super

**Current State:**
- `harn_tab_main` is a NEW windowclass (no `merge` attribute) → Correctly skips super
- Combobox inline scripts DO call `super.onInit()` → Correct because they extend built-in combobox

**Verdict:** The code is correct. No changes needed.

**Pattern Reference:** See `docs/patterns/lifecycle.md` → "super.onInit() / super.onClose() Pattern"

---

## Issue 5: Empty onClose() (PARTIALLY VALID)

**Finding:** `harn_manager.lua` has an empty `onClose()` function.

**Evidence:** Reference scripts only need `onClose()` when they register resources that require cleanup (DB handlers, event handlers, function wrapping, etc.).

**Current State:**
```lua
function onClose()
    -- Cleanup
end
```

- Currently registers NO handlers
- Therefore cleanup is unnecessary
- Empty stub is harmless but unnecessary

**Verdict:**
- **Now:** Empty `onClose()` is fine
- **Future:** If/when handlers are added, cleanup will be required

**Recommendation:** Either remove the empty function or add a more specific TODO comment.

**Pattern Reference:** See `docs/patterns/lifecycle.md` → "onClose and Handler Cleanup"

---

## Issue 6: `<disabled />` vs `<invisible />` (PARTIALLY VALID)

**Finding:** Zero-size anchor controls use `<disabled />` instead of `<invisible />`.

**Evidence:** Reference extensions use `<invisible />` for anchor controls (CapitalGains, Moon-Tracker). `<disabled />` is semantically for controls that shouldn't accept input, not for hiding.

**Current State (6 occurrences):**
```xml
<genericcontrol name="leftanchor">
    <anchored position="insidetopleft" offset="0,2" width="0" height="0" />
    <disabled />  <!-- Should be <invisible /> -->
</genericcontrol>
```

**Affected Files:**
- `tab_skills.xml` (line 15)
- `tab_gear.xml` (lines 14, 46)
- `tab_combat.xml` (lines 15, 89, 163)

**Impact:** Functionally works (zero-size controls render nothing anyway), but semantically incorrect.

**Verdict:** Low priority. Change to `<invisible />` when editing these files for other reasons.

**Pattern Reference:** See `docs/patterns/layout.md` → "Invisible Anchor Points"

---

## Issue 7: Fixed Positioning (PARTIALLY VALID)

**Finding:** Frames use absolute pixel offsets that could cause clipping.

**Evidence:** Reference extensions use BOTH fixed and responsive positioning. Fixed is appropriate for predictable-size controls. The specific issue is frames positioned with absolute offsets.

**Current State:**
```xml
<frame_char name="physical_frame">
    <anchored position="insidetopleft" offset="0,0" width="280" height="220" />
</frame_char>
<frame_char name="mental_frame">
    <anchored position="insidetopleft" offset="300,0" width="280" height="220" />
</frame_char>
```

**Impact:** If window is narrower than 580px, `mental_frame` gets clipped.

**Better Approach:**
```xml
<frame_char name="mental_frame">
    <anchored to="physical_frame" position="righthigh" offset="20,0" width="280" height="220" />
</frame_char>
```

Or add minimum window size:
```xml
<sizelimits>
    <minimum width="600" height="400" />
</sizelimits>
```

**Verdict:** Low priority. Current code works within normal window sizes.

**Pattern Reference:** See `docs/patterns/layout.md` → "Fixed vs Responsive Sizing"

---

## Issue 8: Inline Scripts Too Large (PARTIALLY VALID)

**Finding:** `tab_skills.xml` has ~58 lines of inline Lua.

**Evidence:** Reference extensions use inline scripts for small handlers (1-20 lines) and external files for complex logic (20+ lines, especially with DB handlers).

**Current State:**
| File | Inline Lines | Verdict |
|------|--------------|---------|
| `tab_skills.xml` | ~58 | Worth moving to external file |
| `tab_main.xml` | ~15 | Acceptable |
| `tab_combat.xml` | ~19 | Acceptable |

**Impact:**
- Harder to debug (unclear line numbers in errors)
- No syntax highlighting in XML editor
- Contains static data that belongs in a manager

**Verdict:** The `tab_skills.xml` script contains initialization logic AND static skill data - this exceeds reference norms. The data should move to `SkillsManager`, and the init logic could become a simple call to the manager.

**Pattern Reference:** See `docs/patterns/lifecycle.md` → "Inline Scripts vs External Lua Files"

---

## Recommended Fix Order

### Must Fix (Before Adding Features)

1. **Register `bu_skills_manager.lua`** in `extension.xml`
   - Single line change
   - Unblocks all other fixes

2. **Remove duplicate skill data from `tab_skills.xml`**
   - Have it call `SkillsManager` instead
   - Consolidates to single source of truth

3. **Add attribute → skill reactivity**
   - Add DB handlers watching `*_score` fields
   - Call `SkillsManager.updateAllSkillSB()` on change
   - Add cleanup in `onClose()`

### Should Fix (Code Quality)

4. **Change `<disabled />` to `<invisible />`** on anchor controls (6 files)

5. **Anchor `mental_frame` to `physical_frame`** instead of absolute offset

### Consider (Low Priority)

6. **Move `tab_skills.xml` initialization to external Lua** or simplify by using `SkillsManager`

---

## Files Affected

| File | Issues |
|------|--------|
| `extension/extension.xml` | #1 (missing script registration) |
| `extension/scripts/bu_skills_manager.lua` | #1, #2, #3 (needs to be used) |
| `extension/xml/tab_skills.xml` | #2, #6, #8 (duplicate data, disabled, inline script) |
| `extension/xml/tab_attributes.xml` | #3 (needs to trigger skill updates) |
| `extension/xml/tab_combat.xml` | #6 (disabled anchors) |
| `extension/xml/tab_gear.xml` | #6 (disabled anchors) |
| `extension/xml/charsheet.xml` | #7 (consider sizelimits) |
