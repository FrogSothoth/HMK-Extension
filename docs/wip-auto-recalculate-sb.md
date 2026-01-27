# WIP: Auto-Recalculate Skill Bases on Attribute Change

**Status:** Paused - handlers fire but SB values don't visually update
**Last Updated:** 2026-01-27

## Goal

When any attribute score changes, automatically recalculate all Skill Base (SB) values using `SkillsManager.recalculateAllSB()`.

## Current Behavior

- SB values **do update** when the skill entry loses focus (via `onLoseFocus` handler in the name field)
- SB values **do NOT update automatically** when attributes change
- User must manually interact with each skill to trigger recalculation

## What's Working

1. **SkillsManager.onInit() now fires** - Fixed by changing `function SkillsManager.onInit()` to global `function onInit()` in skills_manager.lua
2. **DB.addHandler registers successfully** - Console shows handlers being added for all 13 attribute fields
3. **onAttributeChanged callback fires** - When attribute values change, the handler is triggered
4. **recalculateAllSB function exists and is accessible** - No longer showing as nil
5. **Manual SB calculation works** - When skill name field loses focus, SB is correctly calculated

## What's NOT Working

- **SB values don't visually update** in the Skills tab after attribute changes
- The function appears to run (based on logs) but the UI doesn't reflect changes
- This is a reactive update problem, not a calculation problem

## Possible Causes to Investigate

1. **DB.setValue may be writing but UI not refreshing** - The skill list windowclass may need to be notified to refresh
2. **Timing issue** - The skills tab may have already loaded its values before the recalculation
3. **Skill nodes may not have att1/att2 populated** - Check if skills have their attribute fields set
4. **Different database paths** - The paths used in recalculateAllSB may not match actual skill storage
5. **Window binding issue** - The `<source>` tag may cache the value at load time

## Files Involved

| File | Purpose |
|------|---------|
| `extension/scripts/skills_manager.lua` | Contains `recalculateAllSB()` function |
| `extension/xml/tab_attributes.xml` | Attribute score fields with `onValueChanged` that calls recalculateAllSB |
| `extension/xml/tab_skills.xml` | Skill entry template with SB field using `<source>sb</source>` |

## Debug Output Observed

```
SkillsManager: onInit() called
  SkillsManager table exists: true
  recalculateAllSB exists: true
  calculateSB exists: true

Registering attribute handlers for: charsheet.id-00001
  Adding handler for: charsheet.id-00001.str_score
  [... handlers for all 13 attributes ...]

onAttributeChanged fired for: charsheet.id-00001.wil_score
  Character node: charsheet.id-00001
  Calling recalculateAllSB
```

## Next Steps When Resuming

1. **Add verbose debug output inside `recalculateAllSB`** to see:
   - How many skill groups are found
   - How many skills are in each group
   - Whether att1/att2 values exist on skills
   - What SB values are being calculated and written

2. **Check the actual database structure:**
   - Open FGU console and inspect `charsheet.id-00001.socialskills` (or similar)
   - Verify skills have `att1`, `att2`, `sb` fields
   - Use `DB.getChildren()` to enumerate skills

3. **Force UI refresh approaches to try:**
   - Call `window.resetMenuItems()` or similar refresh method
   - Use `Interface.requestRefresh()` if available
   - Try adding a `DB.addHandler` on the skill's sb field in the windowclass
   - Consider using `control.setValue()` instead of just `DB.setValue()`

4. **Alternative implementation:**
   - Instead of batch update, add individual handlers for each skill's att1/att2 fields
   - Have each skill entry watch its governing attributes

## Reference Pattern

See `docs/patterns/database.md` for the DB.addHandler pattern used.
