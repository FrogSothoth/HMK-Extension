# WIP: HarnMaster Dice Mechanics (d100 Tests)

**Status:** Broken - dice animation works but result handler not called
**Last Updated:** 2026-01-27

## Goal

Implement d100 test rolls with:
1. Visual dice animation using FGU's dice system
2. Result evaluation (Success, Critical Success, Failure, Critical Failure)
3. Clickable attribute abbreviations on character sheet to trigger rolls

## HarnMaster Test Rules

```
1. Roll d100
2. Compare to target number (usually ML = Score × 5)
3. Result categories:
   - Critical Success: Roll <= target AND divisible by 5
   - Success: Roll <= target
   - Failure: Roll > target
   - Critical Failure: Roll > target AND divisible by 5
4. Special cases:
   - Roll of 95: Always Critical Failure
   - Roll of 96-100: Always Failure (never critical)
```

## What's Working

1. **Slash command registered** - `/test <target> [description]` is available
2. **Dice animation shows** - d100 appears and rolls on screen
3. **Click handlers on attributes** - Clicking STR, DEX, etc. triggers `DiceManager.rollTest()`
4. **evaluateTest() logic is correct** - The evaluation function properly categorizes results

## What's NOT Working

1. **Result handler never called** - `onTest()` function doesn't fire after dice land
2. **No result output in chat** - Only the dice animation shows, no evaluation message
3. **Error on startup** - `onDicePanelLockChanged is a nil value` (may be unrelated CoreRPG issue)

## Implementation Attempts

### Attempt 1: Custom onDiceLanded (Failed)

Tried defining `onDiceLanded(draginfo)` in the script to intercept dice results.

**Problem:** FGU doesn't automatically call `onDiceLanded` on manager scripts. This requires explicit registration or is only available on specific control types.

### Attempt 2: ActionsManager.registerResultHandler (Current - Not Working)

```lua
function onInit()
    ActionsManager.registerResultHandler("hmtest", onTest);
end

function getRoll(nTarget, sDescription)
    local rRoll = {};
    rRoll.sType = "hmtest";
    rRoll.aDice = {"d100"};
    rRoll.nMod = 0;
    rRoll.nTarget = nTarget;
    rRoll.sDesc = "[TEST] " .. (sDescription or "Test") .. " vs " .. nTarget;
    return rRoll;
end

function rollTest(nTarget, sDescription)
    local rRoll = getRoll(nTarget, sDescription);
    ActionsManager.performAction(nil, nil, rRoll);
end
```

**Problem:** The result handler `onTest()` is never called. The dice animate but then nothing happens.

## Files Involved

| File | Purpose |
|------|---------|
| `extension/scripts/dice_manager.lua` | Main dice rolling logic |
| `extension/xml/tab_attributes.xml` | Attribute abbreviation click handlers |

## Current dice_manager.lua Structure

```lua
-- Constants
CRITICAL_SUCCESS = "CS"
SUCCESS = "S"
FAILURE = "F"
CRITICAL_FAILURE = "CF"

-- Functions
evaluateTest(nRoll, nTarget)  -- Returns result category
getResultName(sResult)        -- Returns display name
getRoll(nTarget, sDescription) -- Builds roll structure
rollTest(nTarget, sDescription) -- Performs the roll
onTest(rSource, rTarget, rRoll) -- Result handler (NOT BEING CALLED)
processTestCommand(sCommand, sParams) -- /test slash command handler
onInit() -- Registers handlers
```

## Errors Observed

```
Script execution error: "onDicePanelLockChanged" is a nil value
```

This error appears on startup but may be unrelated to our dice mechanics - it seems to be a CoreRPG internal function.

## Next Steps When Resuming

1. **Check if ActionsManager exists in CoreRPG:**
   - Search references for how CoreRPG rulesets implement dice rolling
   - May need to use a different approach for extending CoreRPG

2. **Try alternative approaches:**
   - Use `Comm.throwDice()` with manual result handling via OOB messages
   - Register a custom drag type handler
   - Look at how other simple rulesets implement d100 rolls

3. **Debug ActionsManager:**
   - Add debug output to verify `ActionsManager.registerResultHandler` is called
   - Check if `ActionsManager.performAction` returns any errors
   - Verify the roll structure matches what ActionsManager expects

4. **Consult reference implementations:**
   - `references/FG-2e-PlayersOption/scripts/manager_dice_po.lua` - Uses custom dice mechanics
   - `references/CapitalGains/scripts/manager_action_resource.lua` - Uses ActionsManager pattern

5. **Consider simpler fallback:**
   - Use `math.random()` for the roll (no animation)
   - Output results directly to chat with `Comm.deliverChatMessage()`
   - Accept no visual dice until the pattern is understood

## Reference Pattern from FG-2e-PlayersOption

The reference uses `registerDiceMechanic()` to store handlers in local tables, then defines `onDiceLanded()` to dispatch to them. However, how `onDiceLanded` gets called by FGU is unclear.

```lua
-- From manager_dice_po.lua
function onInit()
    registerDiceMechanic("penDice", processPenetratingDice, processDefaultResults)
    Comm.registerSlashHandler("pdie", onPenetratingDiceSlashCommand)
end

function onDiceLanded(draginfo)
    local sDragType = draginfo.getType()
    for sType, fCallback in pairs(aDiceMechanicHandlers) do
        if sType == sDragType then
            bProcessed = fCallback(draginfo)
        end
    end
    return bProcessed
end
```

## Attribute Click Handlers (Working)

Each attribute abbreviation label has a click handler that calls `DiceManager.rollTest()`:

```xml
<label name="str_abbr">
    <script>
        function onClickDown(button, x, y)
            local nML = window.str_ml.getValue();
            DiceManager.rollTest(nML, "STR");
            return true;
        end
    </script>
</label>
```

These handlers work - they successfully call `DiceManager.rollTest()` with the correct ML value.
