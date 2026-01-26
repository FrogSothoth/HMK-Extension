# Database Patterns

Patterns for FGU database operations including handlers, value changes, and cross-field reactivity.

---

## DB Handler Basics

### DB.addHandler / DB.removeHandler Pattern

**Problem:** How to watch for changes to database fields and react to those changes (e.g., when an attribute changes, recalculate derived values like skills).

**Sources:**
- `references/FG-2e-PlayersOption/campaign/scripts/char_main.lua` (lines 1-54) - Character sheet with multiple dependent calculations
- `references/CapitalGains/scripts/manager_resource.lua` (lines 43-59) - Manager-level handlers with wildcards

**Verified:** 2026-01-26

**Example from FG-2e-PlayersOption (window script context):**
```lua
function onInit()
    super.onInit();

    local node = getDatabaseNode();
    DB.addHandler(DB.getPath(node, "inventorylist.*.carried"), "onUpdate", updateArmor);
    DB.addHandler(DB.getPath(node, "inventorylist.*.hpLost"), "onUpdate", updateArmor);
    DB.addHandler(DB.getPath(node, "inventorylist.*.properties"), "onUpdate", updateArmor);
    -- ... options callbacks ...
    DB.addHandler(DB.getPath(node, "fatigue.multiplier"), "onUpdate", updateFatigueFactor);
    DB.addHandler(DB.getPath(node, "abilities.comeliness.percentbase"), "onUpdate", updateComeliness);
    DB.addHandler(DB.getPath(node, "abilities.comeliness.percentbasemod"), "onUpdate", updateComeliness);
    -- ... more handlers ...
    updateComeliness(node);
    updateFatigueFactor();
    updateArmor();
end

function onClose()
    local nodeChar = getDatabaseNode();
    DB.removeHandler(DB.getPath(nodeChar, "abilities.honor.score"), "onUpdate", updateHonor);
    DB.removeHandler(DB.getPath(nodeChar, "classes.*.level"), "onUpdate", updateHonor);
    -- ... remove ALL handlers added in onInit ...
    super.onClose();
end

function updateComeliness(node)
    local nodeChar = node.getChild("....");
    -- Handle first-time load where node path is different
    if (nodeChar == nil and node.getPath():match("^charsheet%.id%-%d+$")) then
        nodeChar = node;
    end
    local dbAbility = AbilityScorePO.updateComeliness(nodeChar);
    comeliness_effects.setTooltipText(dbAbility.effects_TT);
end
```

**Example from CapitalGains (manager script context):**
```lua
function addResourceHandlers(nodeActor)
    local sActorPath = ActorManager.getCreatureNodeName(nodeActor);
    DB.addHandler(sActorPath .. ".resources.*.current", "onUpdate", synchronizeResourceField);
    DB.addHandler(sActorPath .. ".resources.*.limit", "onUpdate", synchronizeResourceField);

    DB.addHandler(sActorPath .. ".resources.*.share.*.record", "onUpdate", onUpdateSharedResource);
    DB.addHandler(sActorPath .. ".resources.*.share.*.record", "onDelete", onDeleteSharedResource);
end

function removeResourceHandlers(nodeActor)
    local sActorPath = ActorManager.getCreatureNodeName(nodeActor);
    DB.removeHandler(sActorPath .. ".resources.*.current", "onUpdate", synchronizeResourceField);
    DB.removeHandler(sActorPath .. ".resources.*.limit", "onUpdate", synchronizeResourceField);

    DB.removeHandler(sActorPath .. ".resources.*.share.*.record", "onUpdate", onUpdateSharedResource);
    DB.removeHandler(sActorPath .. ".resources.*.share.*.record", "onDelete", onDeleteSharedResource);
end
```

**Key Points:**
- `DB.addHandler(path, event, callback)` - Register handler
- `DB.removeHandler(path, event, callback)` - Unregister handler (MUST match exactly)
- Common events: `"onUpdate"`, `"onChildUpdate"`, `"onChildAdded"`, `"onChildDeleted"`, `"onDelete"`
- Wildcard `*` matches any single node level in the path
- `DB.getPath(node, "subpath")` constructs full path from a node
- Handler callback receives the node that changed as first argument
- **CRITICAL:** Every handler added in `onInit()` MUST be removed in `onClose()`

**Event Types:**
| Event | Triggers When |
|-------|---------------|
| `onUpdate` | Value of the node changes |
| `onChildUpdate` | Any direct child's value changes |
| `onChildAdded` | A new child node is created |
| `onChildDeleted` | A child node is deleted |
| `onDelete` | The node itself is about to be deleted |

---

## Cross-Field Dependent Calculations

### Pattern: Attribute Changes Update Derived Values

**Problem:** When a base value changes (e.g., attribute score), derived values (e.g., skill bases) should automatically recalculate.

**Source:** `references/FG-2e-PlayersOption/campaign/scripts/char_main.lua` (lines 15-24, 56-62)

**Verified:** 2026-01-26

**Example - Multiple fields trigger same update function:**
```lua
function onInit()
    super.onInit();
    local node = getDatabaseNode();

    -- Watch multiple comeliness-related fields, all trigger same recalc
    DB.addHandler(DB.getPath(node, "abilities.comeliness.percentbase"), "onUpdate", updateComeliness);
    DB.addHandler(DB.getPath(node, "abilities.comeliness.percentbasemod"), "onUpdate", updateComeliness);
    DB.addHandler(DB.getPath(node, "abilities.comeliness.percentadjustment"), "onUpdate", updateComeliness);
    DB.addHandler(DB.getPath(node, "abilities.comeliness.percenttempmod"), "onUpdate", updateComeliness);
    DB.addHandler(DB.getPath(node, "abilities.comeliness.base"), "onUpdate", updateComeliness);
    DB.addHandler(DB.getPath(node, "abilities.comeliness.basemod"), "onUpdate", updateComeliness);
    DB.addHandler(DB.getPath(node, "abilities.comeliness.adjustment"), "onUpdate", updateComeliness);
    DB.addHandler(DB.getPath(node, "abilities.comeliness.tempmod"), "onUpdate", updateComeliness);

    -- Also watch honor score and class levels for honor calculation
    DB.addHandler(DB.getPath(node, "abilities.honor.score"), "onUpdate", updateHonor);
    DB.addHandler(DB.getPath(node, "classes.*.level"), "onUpdate", updateHonor);

    -- Run calculations once on init
    updateComeliness(node);
end

function updateHonor(node)
    -- Navigate from changed node up to character node
    local nodeChar = node.getChild("....");
    -- Handle edge case where node IS the character (first-time load)
    if (nodeChar == nil and node.getPath():match("^charsheet%.id%-%d+$")) then
        nodeChar = node;
    end
    AbilityScorePO.updateHonor(nodeChar);
end
```

**Key Points:**
- Multiple source fields can trigger the same recalculation function
- The callback receives the changed node, use `node.getChild("....")` to navigate to parent
- Always handle the edge case where the node path differs during initialization
- Call the update function once in `onInit()` to ensure initial values are correct
- Wildcard patterns like `"classes.*.level"` let you watch all entries in a list

---

## Synchronization Flag Pattern

### Pattern: Prevent Infinite Handler Loops

**Problem:** When handlers modify fields that other handlers watch, you can create infinite loops.

**Source:** `references/CapitalGains/scripts/manager_resource.lua` (lines 61-83)

**Verified:** 2026-01-26

**Example:**
```lua
local bSynchronizing = false;

function synchronizeResourceField(nodeField)
    if bSynchronizing then
        return;
    end
    bSynchronizing = true;

    local sFieldName = nodeField.getPath():match("([^%.@]+)$");
    local sFieldType = nodeField.getType();
    local fieldValue = nodeField.getValue();
    local nodeResource = nodeField.getChild("..");
    local sResource = DB.getValue(nodeResource, "name");

    for _,nodeShare in pairs(DB.getChildren(nodeResource, "share")) do
        local sRecord = DB.getValue(nodeShare, "record");
        local nodeResourceMatch = DB.findNode(sRecord);
        if nodeResourceMatch then
            DB.setValue(nodeResourceMatch, sFieldName, sFieldType, fieldValue);
        end
    end

    bSynchronizing = false;
end
```

**Key Points:**
- Use a module-level flag (`local bSynchronizing`) to track when sync is in progress
- Check the flag at the start of the handler and return early if already synchronizing
- Set the flag before making changes, clear it after
- This prevents Handler A triggering Handler B which triggers Handler A again

---

## Handler Context: Window vs Manager

### Window Script Context

Handlers in window scripts (attached via `<script>` in XML windowclass):
- Have access to `getDatabaseNode()` for the window's data node
- Have access to UI controls via `window.controlname` or direct name
- Register in `onInit()`, unregister in `onClose()`
- Limited to the lifetime of that window instance

**Source:** `references/FG-2e-PlayersOption/campaign/scripts/char_main.lua`

### Manager Script Context

Handlers in global manager scripts (registered in extension.xml):
- Typically watch broader paths with wildcards
- May use `Interface.onDesktopInit` to set up handlers after desktop loads
- Must track which actors/records have handlers attached
- Longer lifetime - often the entire session

**Source:** `references/CapitalGains/scripts/manager_resource.lua` (lines 14-33)

**Example:**
```lua
function onInit()
    if Session.IsHost then
        CombatManager.setCustomTurnStart(onTurnStart);
        CombatManager.setCustomTurnEnd(onTurnEnd);

        Interface.onDesktopInit = onDesktopInit;
    end
end

function onDesktopInit()
    for _,nodeCombatant in pairs(CombatManager.getCombatantNodes()) do
        addResourceHandlers(nodeCombatant);
    end
end

function onClose()
    for _,nodeCombatant in pairs(CombatManager.getCombatantNodes()) do
        removeResourceHandlers(nodeCombatant);
    end
end
```

