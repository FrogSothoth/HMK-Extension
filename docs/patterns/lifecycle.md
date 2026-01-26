# Lifecycle Patterns

Patterns for FGU extension initialization, script registration, and cleanup.

---

## Script Registration

### All Scripts Must Be Registered in extension.xml

**Problem:** Lua scripts in FGU extensions are not automatically loaded. A script file that exists in the extension directory but is not registered in `extension.xml` is dead code - it will never be executed.

**Sources:**
- `references/FG-Aura-Effect/extension.xml` (lines 39-46) - 7 scripts, all registered
- `references/CapitalGains/extension.xml` (lines 43-49) - 7 scripts, all registered
- `references/FG-2e-PlayersOption/extension.xml` (lines 36-77) - 42 scripts, all registered
- `references/FG-CoreRPG-Moon-Tracker/extension.xml` (line 21) - 1 script, registered

**Verified:** 2026-01-26

**Example from FG-Aura-Effect:**
```xml
<base>
	<script name="AuraEffect" file="scripts/manager_effect_aura.lua" />
	<script name="AuraEffectTriggers" file="scripts/aura_triggers.lua" />
	<script name="AuraEffectSilencer" file="scripts/silent_auras.lua" />
	<script name="AuraFactionConditional" file="scripts/faction_conditional.lua" />
	<script name="AuraToken" file="scripts/manager_token_aura.lua" />
	<script name="AuraTracker" file="scripts/manager_aura_tracker.lua" />
	<script name="AuraAPI" file="scripts/manager_aura_api.lua" />
	<!-- ... -->
</base>
```

**Example from FG-2e-PlayersOption (showing many scripts):**
```xml
<base>
	<!-- ... other includes ... -->
	<script name="PlayerOptionManager" file="scripts/manager_po.lua"/>
	<script name="DiceManagerPO" file="scripts/manager_dice_po.lua"/>
	<script name="ActionHealPO" file="scripts/manager_action_heal_po.lua" />
	<script name="ActionDamagePO" file="scripts/manager_action_damage_po.lua" />
	<script name="ActionAttackPO" file="scripts/manager_action_attack_po.lua" />
	<script name="CombatManagerPO" file="scripts/manager_combat_po.lua" />
	<!-- ... 36 more scripts ... -->
</base>
```

**Key Points:**
- The `name` attribute becomes a global table accessible throughout FGU (e.g., `AuraEffect.someFunction()`)
- The `file` attribute is the path relative to the extension root
- There is NO mechanism to "include", "require", or "dofile" other Lua scripts - FGU's sandbox prevents this
- Script `onInit()` functions are called in load order when the extension loads
- Script `onClose()` functions are called when the extension unloads

**Why FGU works this way:**
- FGU runs in a sandboxed Lua 5.1 environment
- Standard Lua mechanisms like `require`, `dofile`, and `loadfile` are disabled
- All scripts must be explicitly declared so FGU can control the loading order and lifecycle

**Detecting dead code:**
1. List all `.lua` files in the extension: `ls extension/scripts/*.lua`
2. Search for `<script` tags in extension.xml
3. Any `.lua` file not listed in a `<script>` tag is dead code

---

## onInit Pattern

**Problem:** What should go in `onInit()` and in what order?

**Verified:** 2026-01-26

### The Standard Order

Based on analysis of 15+ reference scripts, `onInit()` typically follows this order:

1. **Call super (if extending)** - `super.onInit()` or guarded version
2. **Register handlers** - `DB.addHandler()`, event handlers, callbacks
3. **Initial calculations** - Call update functions once to set initial state

**Source:** `references/FG-2e-PlayersOption/campaign/scripts/char_main.lua` (lines 1-29)

```lua
function onInit()
    -- 1. Call super first
    super.onInit();

    -- 2. Register handlers
    local node = getDatabaseNode();
    DB.addHandler(DB.getPath(node, "inventorylist.*.carried"), "onUpdate", updateArmor);
    DB.addHandler(DB.getPath(node, "inventorylist.*.hpLost"), "onUpdate", updateArmor);
    DB.addHandler(DB.getPath(node, "inventorylist.*.properties"), "onUpdate", updateArmor);
    DB.addHandler(DB.getPath(node, "fatigue.multiplier"), "onUpdate", updateFatigueFactor);
    DB.addHandler(DB.getPath(node, "abilities.comeliness.percentbase"), "onUpdate", updateComeliness);
    -- ... more handlers ...
    DB.addHandler(DB.getPath(node, "abilities.honor.score"), "onUpdate", updateHonor);
    DB.addHandler(DB.getPath(node, "classes.*.level"), "onUpdate", updateHonor);

    -- 3. Initial calculations (handlers don't fire on registration)
    updateComeliness(node);
    updateFatigueFactor();
    updateArmor();
end
```

**Key Points:**
- Handlers are registered AFTER `super.onInit()` because the parent may set up the data structure
- Initial calculation calls are needed because `DB.addHandler` doesn't fire on registration
- Pass the correct node to update functions (may need adjustment for initial load vs. handler callback)

### Manager Script onInit

Manager scripts (registered via `<script>` in extension.xml) have simpler initialization.

**Source:** `references/CapitalGains/scripts/manager_resource.lua` (lines 14-27)

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
```

**Key Points:**
- No `super.onInit()` call (manager scripts have no parent)
- `Session.IsHost` check for host-only functionality
- `Interface.onDesktopInit` for delayed initialization after desktop loads
- Handlers added after desktop init may need to iterate existing records

---

## onClose and Handler Cleanup

**Problem:** When are `onClose()` and handler cleanup actually required? What happens if handlers aren't cleaned up?

**Verified:** 2026-01-26

### The Rule: Cleanup is Required When Resources Are Registered

| Resource Type | Cleanup Required | Cleanup Method |
|---------------|------------------|----------------|
| `DB.addHandler()` | **Yes** | `DB.removeHandler()` with exact same parameters |
| `Token.addEventHandler()` | **Yes** | `Token.removeEventHandler()` |
| `CombatManager.setCustom*()` | **Yes** | `CombatManager.removeCustom*()` |
| Function wrapping (storing original) | **Yes** | Restore original function |
| `OptionsManager.registerCallback()` | **Yes** | `OptionsManager.unregisterCallback()` |
| One-time setup (Debug.chat, etc.) | **No** | N/A |
| Static data initialization | **No** | N/A |

### Pattern 1: DB Handler Cleanup (Window Scripts)

When a window script registers `DB.addHandler()` in `onInit()`, it MUST remove them in `onClose()`.

**Source:** `references/FG-2e-PlayersOption/campaign/scripts/char_main.lua` (lines 1-47)

```lua
function onInit()
    super.onInit();

    local node = getDatabaseNode();
    DB.addHandler(DB.getPath(node, "inventorylist.*.carried"), "onUpdate", updateArmor);
    DB.addHandler(DB.getPath(node, "inventorylist.*.hpLost"), "onUpdate", updateArmor);
    DB.addHandler(DB.getPath(node, "inventorylist.*.properties"), "onUpdate", updateArmor);
    DB.addHandler(DB.getPath(node, "fatigue.multiplier"), "onUpdate", updateFatigueFactor);
    DB.addHandler(DB.getPath(node, "abilities.comeliness.percentbase"), "onUpdate", updateComeliness);
    -- ... 8 more handlers for comeliness ...
    DB.addHandler(DB.getPath(node, "abilities.honor.score"), "onUpdate", updateHonor);
    DB.addHandler(DB.getPath(node, "classes.*.level"), "onUpdate", updateHonor);

    updateComeliness(node);
    updateFatigueFactor();
    updateArmor();
end

function onClose()
    local nodeChar = getDatabaseNode();
    DB.removeHandler(DB.getPath(nodeChar, "abilities.honor.score"), "onUpdate", updateHonor);
    DB.removeHandler(DB.getPath(nodeChar, "classes.*.level"), "onUpdate", updateHonor);
    DB.removeHandler(DB.getPath(nodeChar, "abilities.comeliness.percentbase"), "onUpdate", updateComeliness);
    -- ... remove ALL handlers added in onInit, in reverse order ...
    DB.removeHandler(DB.getPath(nodeChar, "inventorylist.*.carried"), "onUpdate", updateArmor);
    DB.removeHandler(DB.getPath(nodeChar, "inventorylist.*.hpLost"), "onUpdate", updateArmor);
    DB.removeHandler(DB.getPath(nodeChar, "inventorylist.*.properties"), "onUpdate", updateArmor);
    super.onClose();
end
```

**Key Points:**
- Every `DB.addHandler()` in `onInit()` MUST have a matching `DB.removeHandler()` in `onClose()`
- Parameters must match exactly: path, event type, callback function
- `super.onClose()` is called AFTER removing handlers (if extending a class)

### Pattern 2: DB Handler Cleanup (Manager Scripts)

Manager scripts follow the same pattern but may organize handlers differently.

**Source:** `references/CapitalGains/scripts/manager_resource.lua` (lines 14-33, 43-58)

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
- Symmetric add/remove functions help maintain consistency
- `onClose()` iterates over all registered actors to remove their handlers
- Manager scripts don't call `super.onClose()` (no parent class)

### Pattern 3: Function Wrapping Cleanup

When wrapping/replacing built-in functions, restore the original in `onClose()`.

**Source:** `references/FG-Aura-Effect/scripts/manager_token_aura.lua` (lines 145-158)

```lua
local linkToken = nil

function onInit()
    if Session.IsHost then
        Token.addEventHandler('onDelete', onDelete)

        linkToken = TokenManager.linkToken
        TokenManager.linkToken = customLinkToken
    end
end

function onClose()
    if Session.IsHost then
        TokenManager.linkToken = linkToken
    end
end
```

**Source:** `references/CapitalGains/scripts/manager_combat_cg.lua` (lines 6-19)

```lua
local resetHealthOriginal;

function onInit()
    if Session.IsHost then
        resetHealthOriginal = CombatManager2.resetHealth;
        CombatManager2.resetHealth = resetHealth;

        CombatManager.setCustomDeleteCombatantHandler(onCombatantDeleted);
    end
end

function onClose()
    CombatManager.removeCustomDeleteCombatantHandler(onCombatantDeleted);
end
```

**Key Points:**
- Store original function reference in module-level variable
- Restore original in `onClose()` to prevent issues with extension reload
- Custom handlers registered via `setCustom*()` have matching `removeCustom*()` methods

### Pattern 4: Options Callback Cleanup

**Source:** `references/FG-2e-PlayersOption/campaign/scripts/char_ability_details.lua` (lines 1-10)

```lua
function onInit()
    OptionsManager.registerCallback(PlayerOptionManager.sAddComeliness, onComelinessOptionChanged);
    OptionsManager.registerCallback(PlayerOptionManager.sEnableHonor, onHonorOptionChanged);
    -- ... initialization ...
end

function onClose()
    OptionsManager.unregisterCallback(PlayerOptionManager.sAddComeliness, onComelinessOptionChanged);
    OptionsManager.unregisterCallback(PlayerOptionManager.sEnableHonor, onHonorOptionChanged);
end
```

### When onClose() is NOT Needed

Many manager scripts have `onInit()` but NO `onClose()` because they only do one-time setup.

**Source:** `references/FG-2e-PlayersOption/scripts/manager_po.lua` (lines 38-58)

```lua
function onInit()
    OptionsManager.registerOption2("PARTY_AUTOGROUP", true, "option_header_game",
        "option_label_PARTY_AUTOGROUP", "option_entry_cycler",
        { labels = "option_val_on", values = "on", baselabel = "option_val_off",
        baseval = "off", default = "off" });

    OptionsManager.registerOption2("PARTY_AUTOHOLD", true, "option_header_game",
        -- ... option registration ...
    );

    -- No DB.addHandler calls, no function wrapping
    -- Therefore no onClose() needed
end
```

**Examples without onClose() (from `references/FG-2e-PlayersOption/scripts/`):**
- `manager_action_heal_po.lua` - Only wraps ActionHeal functions
- `manager_ability_scores_po.lua` - Only defines helper functions
- `manager_char_po.lua` - Only wraps CharManager functions
- `manager_combat_calc_po.lua` - Only initializes static data
- `manager_data_po.lua` - Only registers data module info

### What Happens Without Cleanup?

**Consequences of not cleaning up handlers:**

1. **Memory leaks**: Handlers continue to reference callback functions even after the window/control is destroyed
2. **Stale callbacks**: Callbacks fire on nodes that no longer have associated UI
3. **Errors on reload**: When using `/reload`, old handlers remain registered, leading to duplicate callbacks or nil reference errors
4. **Ghost updates**: Data changes trigger handlers for windows that no longer exist

**Why cleanup matters for extensions specifically:**
- Extensions can be enabled/disabled mid-session
- `/reload` command re-initializes extensions without full restart
- Without cleanup, handlers accumulate with each reload

### Decision Tree: Do I Need onClose()?

```
Does your script register any of these in onInit()?
├── DB.addHandler()
│   └── YES → Need onClose() with DB.removeHandler()
│
├── Token.addEventHandler()
│   └── YES → Need onClose() with Token.removeEventHandler()
│
├── CombatManager.setCustom*()
│   └── YES → Need onClose() with CombatManager.removeCustom*()
│
├── Function wrapping (original = X.func; X.func = myFunc)
│   └── YES → Need onClose() to restore original
│
├── OptionsManager.registerCallback()
│   └── YES → Need onClose() with unregisterCallback()
│
└── None of the above (only Debug.chat, static data, etc.)
    └── NO → onClose() is unnecessary
```

### Empty onClose() Stubs

An empty `onClose()` like this:

```lua
function onClose()
    -- Cleanup
end
```

Is **harmless but unnecessary**. It serves no purpose unless handlers will be added later. Options:

1. **Remove it entirely** if no handlers are planned
2. **Keep it as a placeholder** with a clear TODO comment if handlers will be added

Neither option causes issues - it's purely a code cleanliness decision.

---

## super.onInit() / super.onClose() Pattern

**Problem:** When extending FGU windowclasses with `merge="join"` or adding scripts to built-in controls, you may need to call the parent class's `onInit()` and `onClose()` methods. When is this required vs optional?

**Verified:** 2026-01-26

### The Rule: It Depends on What You're Extending

| Context | super exists? | Call super? |
|---------|---------------|-------------|
| Manager script (registered via `<script name="X" file="..."/>` in extension.xml) | No | N/A - no parent class |
| New windowclass (no `merge` attribute) | No | N/A - calling super would error |
| Extended windowclass (`merge="join"` or `merge="merge"`) | Yes | **Yes** - use guard check |
| Inline script on built-in control (`<combobox>`, `<numberfield>`, etc.) | Yes | **Yes** - use guard check |

### Pattern 1: Extended Windowclass (merge="join")

When extending an existing windowclass with `merge="join"`, **always call super.onInit()** to ensure the parent's initialization runs.

**Source:** `references/FG-2e-PlayersOption/campaign/scripts/char_main.lua` (lines 1-29)

```lua
function onInit()
    super.onInit();

    local node = getDatabaseNode();
    DB.addHandler(DB.getPath(node, "inventorylist.*.carried"), "onUpdate", updateArmor);
    -- ... more handlers ...
end

function onClose()
    local nodeChar = getDatabaseNode();
    DB.removeHandler(DB.getPath(nodeChar, "inventorylist.*.carried"), "onUpdate", updateArmor);
    -- ... more handler removals ...
    super.onClose();
end
```

**XML definition** (`references/FG-2e-PlayersOption/campaign/record_char_main.xml`, line 9-10):
```xml
<windowclass name="charsheet_main" merge="join">
    <script file="campaign/scripts/char_main.lua" />
```

**Key Points:**
- `merge="join"` means this extends an existing windowclass
- `super.onInit()` is called FIRST (before adding handlers)
- `super.onClose()` is called LAST (after removing handlers)
- Handlers added in `onInit()` must be removed in `onClose()`

### Pattern 2: Defensive Guard Check

When you're not certain whether a parent class exists (common in theme extensions that may apply to multiple rulesets):

**Source:** `references/FG-CoreRPG-Moon-Tracker/utility/scripts/calendar_log.lua` (lines 18-21)

```lua
function onInit()
    if super and super.onInit then
        super.onInit()
    end

    nSelMonth = DB.getValue('calendar.current.month', 0)
    nSelDay = DB.getValue('calendar.current.day', 0)
    -- ... rest of initialization ...
end
```

**Source:** `references/FGU-Theme-Hearth/common/scripts/setTwoStateButtonColors.lua` (lines 1-4)

```lua
function onInit()
    if super and super.onInit then
        super.onInit()
    end
    setStateColor(0, ColorManager.COLOR_SECONDARY_FOREGROUND, ...);
end
```

**Key Points:**
- `if super and super.onInit then` guards against nil reference errors
- Use this pattern when extending controls that may not have an `onInit()` defined
- Theme extensions commonly use this because they may extend different base rulesets

### Pattern 3: Inline Script on Built-in Control

When adding behavior to a built-in control (like `<combobox>`), the control type has a parent implementation.

**Source:** General pattern for inline scripts on built-in controls

```xml
<combobox name="agegroup">
    <anchored to="agegroup_label" position="righthigh" offset="5,0" width="100" height="20" />
    <frame name="fielddark" offset="7,5,7,5" />
    <unsorted />
    <script>
        function onInit()
            super.onInit();
            addItems({"Young", "Mature", "Old"});
        end
    </script>
</combobox>
```

**Key Points:**
- Built-in controls like `<combobox>` have their own `onInit()` that must be called
- `super.onInit()` ensures the combobox is properly initialized before adding items

### Pattern 4: New Windowclass (No merge - NO super call)

When creating a completely new windowclass (no `merge` attribute), there is no parent class.

**Source:** General pattern - new windowclass without `merge` attribute

```xml
<windowclass name="my_custom_tab">
    <script>
        function onInit()
            -- NO super.onInit() - this is a new class with no parent
            initializeFields();
        end

        function initializeFields()
            -- ... implementation ...
        end
    </script>
    <sheetdata>
        <!-- ... controls ... -->
    </sheetdata>
</windowclass>
```

**Key Points:**
- No `merge` attribute = completely new windowclass
- Calling `super.onInit()` here would cause a nil reference error
- Only call super when extending an existing class

### Pattern 5: Manager Scripts (No super exists)

Scripts registered directly in `extension.xml` have no parent class.

**Source:** `references/CapitalGains/scripts/manager_resource.lua` (lines 14-21)

```lua
function onInit()
    if Session.IsHost then
        CombatManager.setCustomTurnStart(onTurnStart);
        CombatManager.setCustomTurnEnd(onTurnEnd);

        Interface.onDesktopInit = onDesktopInit;
    end
end
```

**Registration** (`references/CapitalGains/extension.xml`):
```xml
<script name="ResourceManager" file="scripts/manager_resource.lua" />
```

**Key Points:**
- Manager scripts are standalone global tables
- They have no parent class - `super` doesn't exist
- No `onInit()` call needed or possible

### Summary: Decision Tree

```
Does your script extend something?
├── NO (new windowclass, manager script)
│   └── Do NOT call super - it doesn't exist
│
└── YES (merge="join", merge="merge", or inline on built-in control)
    ├── Are you certain super.onInit exists?
    │   ├── YES → call super.onInit() directly
    │   └── NO  → use guard: if super and super.onInit then
    │
    └── For onClose:
        ├── Call super.onClose() AFTER removing your handlers
        └── Use guard if uncertain: if super and super.onClose then
```

---

## Inline Scripts vs External Lua Files

**Problem:** When should script logic be placed in inline `<script>` blocks within XML vs external `.lua` files referenced via `<script file="..."/>`?

**Verified:** 2026-01-26

### The Pattern: Size and Complexity Determine Location

Reference implementations show a clear pattern based on code complexity:

| Script Size | Location | Typical Use Case |
|-------------|----------|------------------|
| 1-5 lines | Inline `<script>` block | Single event handler, simple delegation |
| 6-20 lines | Either (preference varies) | Simple windowlist customization, state toggle |
| 20+ lines | External `.lua` file | Complex logic, DB handlers, multiple functions |

### Evidence: CapitalGains Extension

**Inline scripts for simple handlers (1-7 lines):**

**Source:** `references/CapitalGains/campaign/record_char_actions.xml` (lines 6-14)

```xml
<button_iedit name="actions_iedit">
	<script>
		function onValueChanged()
			if super and super.onValueChanged then
				super.onValueChanged();
			end
			local bEditMode = (getValue() == 1);
			window.contents.subwindow.resources.subwindow.list.update(bEditMode);
		end
	</script>
</button_iedit>
```

**Source:** `references/CapitalGains/campaign/record_char_actions.xml` (lines 68-81)

```xml
<windowlist name="list">
	<script>
		function addEntry(bFocus)
			local w = createWindow();
			if bFocus then
				w.name.setFocus();
			end
			return w;
		end
		function update(bEditMode)
			for _,w in pairs(getWindows()) do
				w.idelete.setVisibility(bEditMode);
			end
		end
	</script>
	<!-- ... rest of windowlist config ... -->
</windowlist>
```

**External file for complex logic (82 lines with handlers):**

**Source:** `references/CapitalGains/campaign/record_resource.xml` (line 5)

```xml
<windowclass name="resource_item">
	<margins control="3,0,3,5" />
	<script file="campaign/scripts/resource_item.lua" />
	<!-- ... sheetdata ... -->
</windowclass>
```

The external file `references/CapitalGains/campaign/scripts/resource_item.lua` contains 82 lines with:
- Module-level state variables
- `onInit()` with DB handler registration
- `onClose()` with handler cleanup
- Multiple callback functions

### Evidence: FG-2e-PlayersOption Extension

**Small inline scripts for button handlers:**

**Source:** `references/FG-2e-PlayersOption/campaign/record_char_main.xml` (lines 116-121)

```xml
<buttoncontrol name="remove_fatigue_button" insertafter="specialdef">
	<anchored ... />
	<icon normal="button_page_prev" />
	<script>
		function onButtonPress()
			window.decreaseFatigue();
		end
	</script>
</buttoncontrol>
```

**External file for windowclass with handlers (296 lines):**

**Source:** `references/FG-2e-PlayersOption/campaign/record_char_main.xml` (line 10)

```xml
<windowclass name="charsheet_main" merge="join">
	<script file="campaign/scripts/char_main.lua" />
	<sheetdata>
		<!-- ... controls ... -->
	</sheetdata>
</windowclass>
```

The external file `references/FG-2e-PlayersOption/campaign/scripts/char_main.lua` contains 296 lines with:
- `onInit()` registering 15+ DB handlers
- `onClose()` removing all handlers
- 15+ update/utility functions

### Evidence: FGU-Theme-Hearth Extension

Theme extensions use inline scripts for template-level customizations.

**Source:** `references/FGU-Theme-Hearth/rulesets/corerpg_compilation.xml` (lines 17-22)

```xml
<template name="button_ichat">
	<button_icon name="button_ichat">
		<anchored ... />
		<icon normal="content_chat" />
		<tooltip textres="record_chat" />
		<script>
			function onButtonPress()
				RecordShareManager.onShareButtonPressed(window);
			end
		</script>
	</button_icon>
</template>
```

### Key Points

1. **Both patterns are valid** - Reference extensions use inline and external scripts appropriately
2. **Complexity is the deciding factor**, not a blanket rule
3. **External files provide benefits when scripts are large:**
   - Proper Lua syntax highlighting in editors
   - Easier debugging (line numbers in errors are clearer)
   - Reusable across multiple XML files
   - Cleaner separation of concerns
4. **Inline scripts are appropriate for:**
   - Simple event handlers that delegate to window/manager functions
   - Small `addEntry()` customizations for windowlists
   - Template-level overrides (1-5 lines)

### When to Move to External Files

Move to external `.lua` file when:
- Script exceeds ~20 lines
- Script registers DB handlers (requires cleanup)
- Script contains reusable game logic
- Script contains static data tables
- Multiple functions with interdependencies

Keep inline when:
- Single simple event handler
- Delegates to window or manager functions
- Control-specific customization (e.g., `addEntry()`)
- Template override (1-5 lines)

