# WIP: Auto-Recalculate Skill Bases on Attribute Change

**Status:** Paused - handlers fire but SB values don't visually update
**Last Updated:** 2026-01-26

## Goal

When any attribute score changes, automatically recalculate all Skill Base (SB) values using `SkillsManager.recalculateAllSB()`.

## What's Working

1. **SkillsManager.onInit() now fires** - Fixed by changing `function SkillsManager.onInit()` to global `function onInit()` in skills_manager.lua
2. **DB.addHandler registers successfully** - Console shows handlers being added for all 13 attribute fields
3. **onAttributeChanged callback fires** - When attribute values change, the handler is triggered
4. **recalculateAllSB function exists and is accessible** - No longer showing as nil

## What's NOT Working

- **SB values don't visually update** in the Skills tab after attribute changes
- The function appears to run (based on logs) but the UI doesn't reflect changes

## Possible Causes to Investigate

1. **DB.setValue may be writing but UI not refreshing** - The skill list windowclass may need to be notified to refresh
2. **Timing issue** - The skills tab may have already loaded its values before the recalculation
3. **Skill nodes may not have att1/att2 populated** - Check if skills have their attribute fields set
4. **Different database paths** - The paths used in recalculateAllSB may not match actual skill storage

## Files Modified

| File | Changes |
|------|---------|
| `extension/scripts/skills_manager.lua` | Changed `function SkillsManager.onInit()` to `function onInit()` (line 10) |
| `extension/xml/charsheet.xml` | Added DB.addHandler calls in script block for all 13 attributes |
| `extension/xml/tab_attributes.xml` | Added `<source>` bindings to all numberfields; added recalculateAllSB calls in onValueChanged |

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

1. Add debug output inside `recalculateAllSB` to see:
   - How many skill groups are found
   - How many skills are in each group
   - Whether att1/att2 values exist on skills
   - What SB values are being calculated and written

2. Check the actual database structure:
   - Open FGU console and inspect `charsheet.id-00001.physicalskills` (or similar)
   - Verify skills have `att1`, `att2`, `sb` fields

3. Consider alternative approaches:
   - Force UI refresh after updating DB values
   - Use `DB.addHandler` on the skill list to trigger window refresh
   - Call a refresh method on the skills windowlist

## Reference Pattern

See `docs/patterns/database.md` for the DB.addHandler pattern used.
