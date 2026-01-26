# Fantasy Grounds Unity Development Guide for macOS

This guide documents the setup and workflow for developing Fantasy Grounds Unity (FGU) extensions on macOS, specifically tested on Apple Silicon (M1/M2/M3) with high-DPI Retina displays.

## Table of Contents

- [Known Issues](#known-issues)
- [Initial Setup](#initial-setup)
- [Configuration Files](#configuration-files)
- [Development Environment](#development-environment)
- [Development Workflow](#development-workflow)
- [Debugging](#debugging)
- [Best Practices](#best-practices)
- [Troubleshooting](#troubleshooting)

---

## Known Issues

### Settings Panel Crash (Apple Silicon + High-DPI Display)

**Affected:** Mac Studio, MacBook Pro, and other Apple Silicon Macs with Retina or external 5K displays (e.g., Apple Studio Display)

**Symptom:** Clicking the Settings button in the FGU launcher causes an immediate crash. The `Player.log` shows:
```
Thread 0x... may have been prematurely finalized
NETWORK STATUS: [Error]
Launcher scene exiting.
```

**Root Cause:** This is a Mono runtime threading bug that occurs 10x more frequently on Apple Silicon compared to Intel. The bug is triggered when the Settings UI initializes its network checking thread. This is a SmiteWorks/Unity bug that cannot be fixed by users.

**Workaround:** Configure all settings via config files directly (see [Configuration Files](#configuration-files)). The Settings button should be avoided entirely on affected hardware.

**Status:** Bug should be reported to SmiteWorks via the [House of Healing forum](https://www.fantasygrounds.com/forums/forumdisplay.php?107-The-House-of-Healing-Unity).

### UI Scaling on Retina Displays

**Symptom:** Application window appears extremely small and hard to read on high-DPI displays.

**Solution:** Set `UIScale=250` (or appropriate value for your display) in `fguser.conf`. See [Configuration Files](#configuration-files).

---

## Initial Setup

### Required Permissions

FGU requires the following macOS permissions (System Settings > Privacy & Security):

| Permission | Required For |
|------------|--------------|
| **Full Disk Access** | `FantasyGroundsUpdater.app` and `FGUpdaterEngine.app` - Required for updates |
| **Input Monitoring** | Hotkey support |
| **Local Network** | Multiplayer functionality |

### Installation Paths

| Item | Path |
|------|------|
| Application | `/Applications/SmiteWorks/Fantasy Grounds/FantasyGrounds.app` |
| Updater | `/Applications/SmiteWorks/Fantasy Grounds/FantasyGroundsUpdater.app` |
| Data Directory | `~/SmiteWorks/Fantasy Grounds/` |
| Extensions | `~/SmiteWorks/Fantasy Grounds/extensions/` |
| Campaigns | `~/SmiteWorks/Fantasy Grounds/campaigns/` |
| Rulesets | `~/SmiteWorks/Fantasy Grounds/rulesets/` |

### Verifying Installation

Check the binary architecture (should show both x86_64 and arm64 for native Apple Silicon):
```bash
lipo -archs "/Applications/SmiteWorks/Fantasy Grounds/FantasyGrounds.app/Contents/MacOS/Fantasy Grounds"
# Expected output: x86_64 arm64
```

---

## Configuration Files

Since the Settings panel crashes on Apple Silicon with high-DPI displays, all configuration must be done via config files.

### File Locations

All config files are in `~/Library/Preferences/SmiteWorks/`:

```
~/Library/Preferences/SmiteWorks/
├── fantasygrounds.conf    # Application/server settings
├── fglauncher.conf        # Launcher state
└── fguser.conf            # Client/user settings
```

### fguser.conf (Client Settings)

This is the primary file for user preferences.

```ini
UIScale=250
networkDiceAllowed=on
UserColor=#FF000000
UserDiceBodyColor=#FF000000
UserDiceTextColor=#FFFFFFFF
UserDiceSkinIndex=0
```

| Key | Description | Values |
|-----|-------------|--------|
| `UIScale` | UI scaling percentage (critical for Retina) | `100`-`400` (try `250` for 5K displays) |
| `networkDiceAllowed` | Allow networked dice rolling | `on` / `off` |
| `UserColor` | User color in ARGB hex | `#AARRGGBB` |
| `UserDiceBodyColor` | Dice body color | `#AARRGGBB` |
| `UserDiceTextColor` | Dice text color | `#AARRGGBB` |
| `UserDiceSkinIndex` | Selected dice skin | Integer |

### fantasygrounds.conf (Application Settings)

```ini
DataDir=/Users/yourname/SmiteWorks/Fantasy Grounds
ExamplesInstalled=True
UserName=YourUsername
Password=<hashed>
ImageQuality=1
DiceSkins=94,95,96,97,98,99,100,101,102,103,106,107,108,109
```

| Key | Description | Values |
|-----|-------------|--------|
| `DataDir` | Data directory path | Absolute path |
| `ImageQuality` | Image quality setting | `0`=Low, `1`=Medium, `2`=High |
| `UserName` | FG account username | String |
| `Password` | Hashed password | String (do not edit) |

### fglauncher.conf (Launcher State)

```ini
NetworkVersion=20251111
DataVersion=20251111
EULA=2020-11-17
LastSession=Test
```

Generally does not need manual editing.

---

## Development Environment

### VS Code Setup

**Required Extensions:**
1. **Lua** (sumneko.lua) - Intellisense, linting, syntax checking
2. **XML** (Red Hat) - XML validation and formatting

**Workspace Configuration:**

Create `.luarc.json` in your extension project root:

```json
{
    "$schema": "https://raw.githubusercontent.com/LuaLS/vscode-lua/master/setting/schema.json",
    "runtime": {
        "version": "Lua 5.1",
        "path": ["?.lua", "?/init.lua"]
    },
    "diagnostics": {
        "globals": [
            "window", "subwindow", "DB", "Interface", "Comm", "User",
            "Debug", "ChatManager", "ModifierStack", "Input", "KeyboardManager",
            "OptionsManager", "StringManager", "UtilityManager", "xml"
        ],
        "disable": ["lowercase-global"]
    },
    "workspace": {
        "library": [],
        "checkThirdParty": false
    }
}
```

### Log Monitoring

Stream debug output to a separate terminal window:

```bash
tail -f ~/Library/Logs/SmiteWorks/Fantasy\ Grounds/Player.log
```

**Pro Tip:** Use iTerm2 with triggers to colorize `[Error]` and `[Warning]` lines.

### Extension Structure

Create unpacked extensions during development (no zipping needed):

```
~/SmiteWorks/Fantasy Grounds/extensions/
└── MyExtension/
    ├── extension.xml
    ├── scripts/
    │   └── my_script.lua
    └── graphics/
        └── icon.png
```

### Minimal extension.xml Template

```xml
<?xml version="1.0" encoding="iso-8859-1"?>
<root version="4.0" release="1">
    <properties>
        <name>My Extension Name</name>
        <version>1.0</version>
        <author>Your Name</author>
        <description>Description of what this does</description>
        <ruleset>
            <name>CoreRPG</name>
        </ruleset>
        <loadorder>100</loadorder>
    </properties>
    <base>
        <script name="MyGlobalScript" file="scripts/my_script.lua" />
    </base>
</root>
```

---

## Development Workflow

### The Edit-Save-Reload Cycle

FGU does not support hot-reloading individual files. All changes require a full reload.

1. **Edit** code in VS Code
2. **Save** (Cmd+S)
3. **Reload** in FGU (see below)
4. **Watch** terminal for errors

### Setting Up a Reload Hotkey

1. Launch FGU and load your development campaign
2. Type `/reload` in the chat box (do not press Enter)
3. Drag the text from the chat entry to a hotkey slot (e.g., F1)
4. Now press F1 to reload your extension instantly

### Important Limitations

- **No External API:** FGU does not expose any IPC, socket, or REST interface
- **No Hot Reload:** Cannot reload individual Lua scripts or XML files
- **Lua 5.1 Only:** No Lua 5.2+ features (no `_ENV`, `goto`, bitwise operators)
- **Sandboxed:** No file I/O or OS commands from Lua scripts

---

## Debugging

### Debug API

```lua
-- Output to console/log
Debug.console("Label:", variable)

-- Print to chat window
Debug.chat("Message")

-- Print stack trace
Debug.printstack()
```

### Table Dump Helper

```lua
function dump(o)
   if type(o) == 'table' then
      local s = '{ '
      for k,v in pairs(o) do
         if type(k) ~= 'number' then k = '"'..k..'"' end
         s = s .. '['..k..'] = ' .. dump(v) .. ','
      end
      return s .. '} '
   else
      return tostring(o)
   end
end

-- Usage:
Debug.console("myTable:", dump(myTable))
```

### In-Game Console

Type `/console` in chat to open the debug console window. However, the external `tail -f` approach is often more convenient as it doesn't obscure the game UI.

---

## Best Practices

### Version Compatibility

FGU updates can break extensions. Minimize breakage by:

1. **Use merge attributes** instead of replacing entire files:
   ```xml
   <windowclass name="charsheet" merge="join">
       <!-- Only modify specific elements -->
   </windowclass>
   ```

2. **Hook functions** instead of overwriting:
   ```lua
   local originalOnInit = nil
   function onInit()
       originalOnInit = SomeClass.onInit
       SomeClass.onInit = myCustomOnInit
   end

   function myCustomOnInit()
       -- Your code here
       if originalOnInit then
           originalOnInit()
       end
   end
   ```

### Testing

- **Use a sandbox campaign:** Never develop in production campaigns
- **Check console immediately:** After loading, run `/console` to check for XML/anchor warnings
- **Isolate extensions:** Test with other extensions disabled first

### API Reference

Official documentation is limited. Best sources:

1. **Official Wiki:** High-level concepts and API lists
2. **CoreRPG Source:** Extract `CoreRPG.pak` (rename to .zip) from the `rulesets` folder - this is the definitive reference
3. **Community Forums:** The Workshop subforum has undocumented behavior discussions

---

## Troubleshooting

### App Won't Update

**Symptom:** Updater fails or app won't install

**Solution:** Grant Full Disk Access to both:
- `/Applications/SmiteWorks/Fantasy Grounds/FantasyGroundsUpdater.app`
- `/Applications/SmiteWorks/Fantasy Grounds/FGUpdaterEngine/FGUpdaterEngine.app`

### UI Too Small

**Symptom:** Everything appears tiny on Retina display

**Solution:** Edit `~/Library/Preferences/SmiteWorks/fguser.conf`:
```ini
UIScale=250
```

Adjust value as needed (200-300 typical for 5K displays).

### Settings Crashes App

**Symptom:** Clicking Settings immediately crashes

**Status:** Known bug on Apple Silicon + high-DPI displays. No user-side fix available.

**Workaround:** Use config files for all settings. See [Configuration Files](#configuration-files).

### Extension Not Loading

**Checklist:**
1. Is `extension.xml` valid XML? (check for encoding issues)
2. Is the extension folder in `~/SmiteWorks/Fantasy Grounds/extensions/`?
3. Is the extension enabled in the campaign?
4. Check `/console` for error messages
5. Check `Player.log` via `tail -f`

### Crash on Launch

**Try these in order:**
1. Delete Unity preferences:
   ```bash
   rm ~/Library/Preferences/unity.SmiteWorks.Fantasy\ Grounds.plist
   ```
2. Reset SmiteWorks preferences (backup first):
   ```bash
   mv ~/Library/Preferences/SmiteWorks ~/Library/Preferences/SmiteWorks.backup
   ```
3. Reboot Mac
4. Reinstall via updater

---

## Technical Details

### Verified Environment

This guide was tested on:
- **Hardware:** Mac Studio (Apple M1 Ultra) + Apple Studio Display (5120x2880)
- **OS:** macOS 15.7.3 (Sequoia)
- **FGU Version:** v5.1.0 (2026-01-23)
- **Unity Engine:** 6000.0.64f1

### Binary Architecture

FGU v5.1.0 is a Universal Binary running natively on Apple Silicon:
- Main executable: Universal (x86_64 + arm64)
- All bundled libraries: Universal (Mono, Unity, Lua, SkiaSharp)

The Settings crash is NOT a Rosetta issue - it's a native arm64 threading bug.

---

## Resources

- [Fantasy Grounds Forums](https://www.fantasygrounds.com/forums/)
- [House of Healing (Bug Reports)](https://www.fantasygrounds.com/forums/forumdisplay.php?107-The-House-of-Healing-Unity)
- [FGU Wiki](https://fantasygroundsunity.atlassian.net/wiki/)
- [Workshop Forum (Development)](https://www.fantasygrounds.com/forums/forumdisplay.php?40-Workshop)
