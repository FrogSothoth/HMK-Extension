# Game Data Organization Patterns

Patterns for organizing static game data (skills, weapons, armor, attributes, etc.) in FGU extensions.

---

## Pattern: Single Source of Truth in Lua Manager

**Problem:** Where should static game data (skill definitions, weapon stats, lookup tables) be stored? Should it be in XML, Lua, or both?

**Source:**
- `references/FG-2e-PlayersOption/scripts/data_common_po.lua` (lines 1-81)
- `references/FG-2e-PlayersOption/scripts/manager_crit_hm.lua` (lines 1-13, 596-627)

**Verified:** 2026-01-26

### Pattern A: Inline Static Tables with onInit() Population

From `data_common_po.lua` lines 1-81:

```lua
aDefaultArmorVsDamageTypeModifiers = {};
aHitLocations = {};
aDefaultRaceSizes = {};
aCritCharts = {};
aDefaultWeaponSizes = {};
aDefaultCreatureTypesByName = {};
aDefaultCreatureTypesByType = {};
aNaturalWeapons = {};
aDefaultArmorDamageReduction = {};
aDefaultArmorHp = {};
aThac0ByHd = {};
aStrength = {};
aDexterity = {};
aWisdom = {};
aConstitution = {};
aCharisma = {};
aIntelligence = {};
aComeliness = {};
aHonorDice = {};
aHonorThresholdsByLevel = {};
aCalledShotModifiers = {};
aHackmasterCalledShotsRanges = {};

-- complete fighters handbook armor penalities
cfhArmorPenalties = {
    ["robes"] = 0,
    ["garments"] = 0,
    ["studded leather"] = -1,
    -- ... more entries
};
function onInit()

    initializeDefaultArmorVsDamageTypeModifiers();
    initializeHitLocations();
    initializeDefaultRaceSizes();
    initializelocationCategorys();
    initializeDefaultWeaponSizes();
    initializeDefaultCreatureTypes();
    initializeNaturalWeapons();
    initializeDefaultArmorDamageReduction();
    initializeDefaultArmorHp();
    initializeStats();
    initializeThac0ByHd();
    initializeHonor();
    initializeCalledShots();

    table.insert(DataCommon.powertypes, "phantasm");

end
```

### Pattern B: Large Tables Built in onInit()

From `manager_crit_hm.lua` lines 1-13 and 596-627:

```lua
local aHackingCritMatrix = {};
local aCrushingCritMatrix = {};
local aPuncturingCritMatrix = {};
local aCritLocations = {};

function onInit()
    buildHackingCritMatrix();
    buildCrushingCritMatrix();
    buildPuncturingCritMatrix();
    buildCritLocationInfo();

    Comm.registerSlashHandler("hmcrit", onCritCommand)
end

-- Later in file (line 596):
function buildHackingCritMatrix()
    aHackingCritMatrix["Foot, top"] = {};
    aHackingCritMatrix["Foot, top"][1] = {
        db = 1
    };
    aHackingCritMatrix["Foot, top"][2] = {
        db = 1
    };
    -- ... hundreds more entries
```

### How Data Is Accessed

From multiple files in `references/FG-2e-PlayersOption/scripts/`:

```lua
-- manager_action_check_po.lua line 48
for sValue, penalty in pairs(DataCommonPO.cfhArmorPenalties) do

-- manager_hit_location_po.lua lines 17, 41
for i, aHitLocationInfo in pairs(DataCommonPO.aHitLocations[sDefenderType]) do
local rHitLocation = DataCommonPO.aHitLocations[sDefenderType][nHitLocationRoll];

-- manager_action_attack_po.lua line 60
nTHACO = DataCommonPO.aThac0ByHd[sHitDice];

-- manager_ability_scores_po.lua line 289-294
dbAbility.hitadj = DataCommonPO.aStrength[nScore][1];
dbAbility.dmgadj = DataCommonPO.aStrength[nScore][2];
dbAbility.weightallow = DataCommonPO.aStrength[nScore][3];
```

**Key Points:**

1. **All game data lives in Lua managers** - XML files do NOT contain duplicate game data tables
2. **Tables are declared empty at file scope** - Then populated in `onInit()` functions
3. **Global access via registered script name** - e.g., `DataCommonPO.aStrength[nScore]`
4. **XML only handles UI** - It does NOT define skill lists, weapon stats, etc.
5. **Initialization order matters** - Data must be populated before other managers try to access it

**Why This Pattern:**

- Single source of truth prevents sync issues
- Lua is better for complex data structures than XML
- Easy to query and manipulate programmatically
- Can split into multiple managers by domain (skills, weapons, armor)

---

## Anti-Pattern: Duplicated Data in XML and Lua

**Problem:** Having the same game data defined in both XML script blocks AND Lua manager files.

**Example of the problem:**

A skills manager defines 72 skills:
```lua
SkillsManager.allSkills = {
    { name = "Charm", category = "social", att1 = "CML", att2 = "EMP", multiple = 3 },
    { name = "Command", category = "social", att1 = "WIL", att2 = "ELO", multiple = 2 },
    -- ... more skills
};
```

But an XML tab defines a partial list separately in its onInit():
```lua
function onInit()
    initializeSkillCategory("socialskills", {
        {name="Charm", base="CML:EMP"},
        {name="Command", base="WIL:ELO"},
        -- ... more skills (partial list, different format)
    });
```

**Why This Is Problematic:**

1. **Data can get out of sync** - Change one place, forget the other
2. **Partial data** - Different subsets in different places
3. **Different formats** - Prevents programmatic sync
4. **Harder to maintain** - Updates require editing multiple files
5. **Wastes space** - Same data stored twice

**Correct Solution:**

Have XML call the Lua manager to get data:

```lua
-- In XML script block
function onInit()
    -- Get skills from the single source of truth
    local socialSkills = SkillsManager.getSkillsByCategory("social")
    initializeSkillCategory("socialskills", socialSkills)
end
```

Or have the manager handle initialization entirely:

```lua
-- In manager.lua
function onInit()
    -- Manager registers itself to handle character skill initialization
    CharacterManager.registerOnCharacterInit(initializeCharacterSkills)
end
```

---

## Related Patterns

- See `lifecycle.md` for script registration and `onInit()` patterns
- See `database.md` for DB.getValue/setValue patterns (character data, not game data)
