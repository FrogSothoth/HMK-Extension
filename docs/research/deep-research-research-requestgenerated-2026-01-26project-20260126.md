# Fantasy Grounds Unity Extension Development on macOS: Environment & Workflow Report

## Executive Summary
Developing extensions for Fantasy Grounds Unity (FGU) on macOS requires a specific workflow to overcome the platform's sandboxed architecture. Unlike modern web or application development environments that support hot-module replacement or live code injection, FGU relies on a traditional **Edit-Save-Reload** cycle. There is no external API or IPC socket to programmatically control the FGU client from an IDE.

The most efficient workflow on macOS involves three key components:
1.  **VS Code** configured with the Lua Language Server (LuaLS) targeting Lua 5.1, using a custom `.luarc.json` to recognize FGU globals.
2.  **Terminal** running a `tail -f` command on the `Player.log` file to stream debug output to a secondary monitor or window in real-time, bypassing the intrusive in-game console.
3.  **In-App Automation** using the `/reload` command assigned to a hotkey (e.g., F1) to instantly refresh the environment after saving changes.

While third-party tools like **Ruleset Wizard** offer advanced GUI-based development, they are Windows-native and require virtualization (Parallels/Crossover) on Apple Silicon. For a native macOS setup, a code-centric approach using VS Code and shell utilities is the standard and most robust method.

---

## 1. Core Architecture & Limitations

### 1.1. The Sandbox Environment
Fantasy Grounds Unity is a closed, sandboxed environment built on the Unity engine. It utilizes **Lua 5.1** for scripting and **XML** for interface and data definitions.
*   **No External API:** FGU does not expose a REST API, WebSocket, or IPC interface for external control [cite: 1]. External tools cannot inject code, trigger reloads, or query game state directly.
*   **Lua Version:** The scripting engine is strictly Lua 5.1. It does not support newer Lua 5.2+ features (like `_ENV` or `goto`) or C-module loading (`require` is limited to internal scripts) [cite: 2, 3].
*   **Security:** The environment restricts file I/O and OS-level commands to prevent malicious extensions from harming the host system [cite: 1].

### 1.2. The Reload Mechanism
The primary mechanism for applying code changes is the **Ruleset Reload**.
*   **Command:** `/reload` (typed in chat).
*   **Scope:** This reloads the entire ruleset and all active extensions. It re-parses all XML and re-initializes all Lua scripts [cite: 4, 5].
*   **State Persistence:** The database (`db.xml`) persists across reloads, but local Lua variables and temporary UI states are reset. `onInit()` functions run again.
*   **Hot Reload:** There is **no support** for hot-reloading individual files. Changing a single line of code requires a full `/reload` cycle to take effect [cite: 4].

---

## 2. macOS Development Environment Setup

### 2.1. File System Locations
On macOS, FGU data is stored in a hidden library folder. For easy access, you should create a symlink or sidebar shortcut to this directory.

| Item | macOS Path |
| :--- | :--- |
| **Data Directory** | `~/Library/SmiteWorks/Fantasy Grounds/` [cite: 6] |
| **Logs (Unity)** | `~/Library/Logs/SmiteWorks/FantasyGrounds/Player.log` [cite: 7] |
| **Extensions** | `~/Library/SmiteWorks/Fantasy Grounds/extensions/` |

**Setup Step:**
Open Terminal and run the following to open the folder in Finder:
```bash
open "~/Library/SmiteWorks/Fantasy Grounds/"
```
*Recommendation:* Drag the `extensions` folder to your Finder sidebar for quick access.

### 2.2. VS Code Configuration
Visual Studio Code is the recommended IDE. To support FGU's specific Lua dialect and globals, you must configure the **Lua** extension (by sumneko/LuaLS).

**Recommended Extensions:**
1.  **Lua** (sumneko.lua): Provides Intellisense, linting, and syntax checking.
2.  **XML** (Red Hat): For XML validation and formatting.

**Workspace Configuration (`.luarc.json`):**
Create a `.luarc.json` file in the root of your extension project to define FGU globals and enforce Lua 5.1 compatibility. This prevents the IDE from flagging standard FGU API calls (like `DB`, `Interface`, `Comm`) as errors [cite: 8, 9].

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

### 2.3. Real-Time Log Monitoring
Instead of relying on the in-game console window (which obscures the UI), use the macOS Terminal to "tail" the log file. This provides a secondary, real-time stream of debug information on a separate screen or window [cite: 10, 11].

**Command:**
```bash
tail -f ~/Library/Logs/SmiteWorks/FantasyGrounds/Player.log
```
*   **Pro Tip:** Use a terminal with highlighting (like iTerm2) to colorize lines containing `[Error]` or `[Warning]` for better visibility.

---

## 3. Optimized Development Workflow

### 3.1. The "Fast Reload" Loop
To minimize friction during iteration, automate the reload process within the client [cite: 4, 5].

1.  **Unpacked Extension:** Do not zip your extension during development. Create a folder (e.g., `extensions/MyExtension/`) and place your `extension.xml` there. FGU loads unpacked folders natively, saving the "zip and rename" step [cite: 4, 12].
2.  **Hotkey Setup:**
    *   Launch FGU and load your campaign.
    *   Type `/reload` in the chat box but **do not press Enter**.
    *   Drag the text from the chat entry box to a hotkey slot (e.g., F1) at the bottom of the screen.
3.  **Iteration Cycle:**
    *   **Edit** code in VS Code.
    *   **Save** (Cmd+S).
    *   **Press F1** in FGU.
    *   **Watch** the Terminal `tail` output for errors.

### 3.2. Debugging Techniques
Since there is no remote debugger or breakpoint support [cite: 13], debugging relies on print tracing and introspection.

*   **Debug API:** Use `Debug.console("Label:", variable)` to output to the log.
*   **Stack Traces:** Use `Debug.printstack()` to trace function call origins [cite: 14].
*   **Chat Output:** Use `Debug.chat()` to print directly to the chat window if you need to see values alongside game output [cite: 14].
*   **Introspection:** Since you cannot inspect objects at runtime with a debugger, write a helper function to dump table contents to the console recursively.

**Example Debug Helper:**
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
```

---

## 4. External Tools & Frameworks

### 4.1. Ruleset Wizard (Compatibility Note)
**Ruleset Wizard** is a popular third-party IDE that provides a visual designer for FGU windows and automates XML generation [cite: 15].
*   **macOS Status:** It is a Windows application. It does **not** have a native macOS version.
*   **Workaround:** It runs successfully on macOS using **Parallels Desktop** or **CrossOver** [cite: 16, 17]. If you prefer a GUI-driven approach over hand-coding XML, this is the best tool, but it adds overhead to the setup.

### 4.2. Boilerplates & Templates
There is no official "create-react-app" style CLI for FGU. The standard practice is to copy an existing, simple extension or use a minimal `extension.xml` template [cite: 18].

**Minimal `extension.xml` Template:**
```xml
<?xml version="1.0" encoding="iso-8859-1"?>
<root version="4.0" release="1">
    <properties>
        <name>My Extension Name</name>
        <version>1.0</version>
        <author>Your Name</author>
        <description>Description of what this does</description>
        <ruleset>
            <name>CoreRPG</name> <!-- Works with 5E, PFRPG, etc. -->
        </ruleset>
        <loadorder>100</loadorder>
    </properties>
    <base>
        <!-- Include scripts and XML files here -->
        <script name="MyGlobalScript" file="scripts/my_script.lua" />
    </base>
</root>
```

### 4.3. Version Control (Git)
*   Initialize a Git repository in your extension folder.
*   **Ignore:** Do not commit the `campaigns` or `cache` folders if you are versioning a whole data directory. Only version the `extensions/MyExtension` folder.
*   **Release:** Use a build script (shell script or Python) to zip the folder contents (excluding `.git` and `.vscode`) into a `.ext` file for distribution [cite: 5].

---

## 5. Best Practices & Strategic Considerations

### 5.1. Handling Updates & Compatibility
FGU updates can break extensions, particularly those that override core files.
*   **Layering:** Use the `merge` attribute in XML (e.g., `merge="join"` or `merge="replace"`) to modify specific parts of a window without replacing the entire file. This reduces conflicts when the core ruleset updates [cite: 4].
*   **Hooking:** Instead of overwriting global script functions, "hook" them. Store the original function in a variable, define your new function, and call the original function within it (if appropriate).
    ```lua
    local originalOnInit = nil;
    function onInit()
        if User.getRulesetName() == "5E" then
            originalOnInit = CharacterList.onInit;
            CharacterList.onInit = myCustomOnInit;
        end
    end
    ```
*   **Testing:** Monitor the **Laboratory** forum threads for beta releases of FGU to test extensions against upcoming changes [cite: 18].

### 5.2. Testing Without Production Risk
*   **Sandbox Campaign:** Never develop in your actual game campaign. Create a dedicated "Dev_Sandbox" campaign.
*   **Console Check:** Always check the console (`/console`) immediately after loading. Warnings about "anchors" or "windowclasses" often indicate XML errors that might not crash the app but will break UI layout [cite: 4].
*   **Isolation:** If testing interaction with other extensions, enable them one by one.

### 5.3. Documentation Sources
Documentation is fragmented. The most reliable source is often the code itself.
1.  **Official Wiki:** Good for high-level concepts and API lists [cite: 19, 20].
2.  **CoreRPG.pak:** Unpack `CoreRPG.pak` (rename to .zip and extract) in the `rulesets` folder. This is the base layer for almost all FGU rulesets. Searching this code is the definitive way to see how API calls are implemented in practice [cite: 19].
3.  **Community Forums:** The "Workshop" subforum is where active developers discuss undocumented behaviors [cite: 21].

## Summary of Recommendations
| Component | Recommendation |
| :--- | :--- |
| **IDE** | VS Code + Lua Extension + XML Extension |
| **Config** | `.luarc.json` targeting Lua 5.1 with FGU globals |
| **Logs** | `tail -f ~/Library/Logs/SmiteWorks/FantasyGrounds/Player.log` |
| **Reload** | F1 Hotkey assigned to `/reload` |
| **Structure** | Unpacked folder in `extensions/` directory |
| **Reference** | Extracted `CoreRPG` ruleset files |

**Sources:**
1. [reddit.com](https://vertexaisearch.cloud.google.com/grounding-api-redirect/AUZIYQFIbCKl9ctnSSGs7jM0OSCtQ7yfGlQ_ceU5XD7NHZgOQX4roXGmECgsDTtcBvCsrYUeycBlUwad2EAiI-Mlo7BZCEwboC1jFk2FeaviiRJdkXVvUiVBfzNT4pZAfC15R0QZrZv3JiGu3R9nEia4yZ14ls0uO4XcVK97ZaZ3DjuQrzfvGv6iw1SlTuX1O8swwfCXcfw2LNQn0ZUiMDt8)
2. [fantasygrounds.com](https://vertexaisearch.cloud.google.com/grounding-api-redirect/AUZIYQHL5I0lYN0Eh6ONt96tsde9ctrlQE_v6QD5FptoZT3L2xnKxvsdFbTjD33IoEwnlCzAEAAIxchi65l5DcNt6kqufiSUCHctP9qFEOmU5w0bJFBG7dZmWI5J3t3xdJD_pVy9WhRD39MQX7f99g==)
3. [fantasygrounds.com](https://vertexaisearch.cloud.google.com/grounding-api-redirect/AUZIYQH8qo7y_SuC3HZYIiYeTxjbd06o5Tf9ibxWJ4zIcIYbVgA-uQBvCYomraBKC5yqVxB_JZ0juPdiRTzznXehwHxs0k_86JDGDcGvvyiksO5IeSqVDsVaoG-4Qm0jo9q6r4C-QQJk_egQiWx83vaRb7PqiZRMV2_Jc7aoBAw0)
4. [youtube.com](https://vertexaisearch.cloud.google.com/grounding-api-redirect/AUZIYQEi5tJzRzKLOK7fsE_W3SnmLC2gTiAiRQy4CxVv70WoNQ7pYKx3uv3IQmMsbABSlqcMBQdIFKIpcssqm5wkhUlcrUPRkuesZyZMXjJQ9sflZqHswluOlz32eaj6lqMGkBkZ)
5. [fantasygrounds.com](https://vertexaisearch.cloud.google.com/grounding-api-redirect/AUZIYQHwczUDGHobufM9Krimxo95tpvWPFQwNJ6_fyLBaNWTQSDm-6jmxX-LGAgB68WVAni5G4L6oIUELbFNl3t5SRqd1_k1wuQ0cJLfgvmwTkGcx12NOV5Wd1Z3NOtMCr4h2pdnj1Mtvrwy5VwaBiCyr0AfYDGyuwfUH5yCsw==)
6. [atlassian.net](https://vertexaisearch.cloud.google.com/grounding-api-redirect/AUZIYQH6OuzZMTUu8G-XGA9KsGA-xLkP2vVQ_eipR09dlxr4UIFlpDmviY4eWyLVFaXJfT2lsaMNbka1fYYfOX9uherY4UkRHDXr7BPe20e11jtJLKijv54ey3MXGXMHmqRV8zY6Rs26FiHNVm6EopczWj0GKUZ1U8eXGBs4CbqZgM2wZKWQt8sLYZbz0Hp0eaP1PJxYBDKpCmQekCS0lz2kQBdL6oGX-Pdy5PNKSsEqRwBj)
7. [fantasygrounds.com](https://vertexaisearch.cloud.google.com/grounding-api-redirect/AUZIYQGowYmdcf0an5BejcjVdjjRPirEMSqNHEOAJfyU6AkZBTBETv0vcagaKHVs6mmBo9vh5jjggDeke5ty_0EAwFAbke1dfYYasKs9pVnMuwWWQROjWTghB5n0sF9rVqjyycQWYihaXOiRDz-AxDmeV1UetBjOmoggRT-sSMOVghVYYgzCQi8qgmyDG2_426tp5C7WG_g9BmZPBAMHQPs2T5YapL8vZ18Chu5_DUYt6Spv0rZsm4LmWo6d3A==)
8. [github.io](https://vertexaisearch.cloud.google.com/grounding-api-redirect/AUZIYQHL0_3sAgiK9RbJdl5JcSPldeKUkyv-dCV3GpKCeYFxokK64HNcmlHAhmPgiXJwZUGeliokU2z3xy-c-vblnYwhViGJH91SGs2WYyHp9Urjl6ZrKt-2a2uxD-nlyHRicwHC)
9. [github.com](https://vertexaisearch.cloud.google.com/grounding-api-redirect/AUZIYQE2GBGHUhQWTpZxw06nr1szSWInXYSNLdW1zev-DGPjuZ891614ynQINVN4gHjF-iWFOyAs8RlKDEIz0EYgSdeu-tBwxsqJAdrxZmGYWLkokLr_dawV6OXD8oc1LON89NIVYXRFTMw3ycT1wJvju5wKfSB3tUhKeCuwMQ==)
10. [theknightsofu.com](https://vertexaisearch.cloud.google.com/grounding-api-redirect/AUZIYQHdpD-ZZIW8nVuvDlewa9vIKZ1CnGk--HnGu6UEHvlZbvou_aFYWUR57wwCqkVZPbbU3rjVpX3OAYlhRq0IH6dqcxkIx1QKPc0qRWeE5DxdSOOVwG76nzl31pgRPO7QfHASQKA_3CsxiYIg)
11. [medium.com](https://vertexaisearch.cloud.google.com/grounding-api-redirect/AUZIYQE-5w4zoD_jYhBio1lwb8r0CieGKXKwf77G1C6sBq4_0C9XVIXJmf6ejPOT_i-vqRuXAhGOKEeKOJxLxflr6fWEwPQ0d1pUg7KqbebONRQ1FSlTTG1qxQhn9v6pxrKVZGuY40ou3OwbCXeL2nbv5dsbDHaaL79N-Wyy9dmnTkIpGqpxMfd9FpOs42tTnNXkgJNa)
12. [fantasygrounds.com](https://vertexaisearch.cloud.google.com/grounding-api-redirect/AUZIYQE6SJiljQ3UYnjMTBiiBWHA9CpQk4fUUnpaWdLowFGoZ1bGBGrY_yGwtU3c6djNSc63jpMm5jMdCP93qmMbQSmCjUGYrYTvSSR8JM1hMDCZlwRppOyU50eVIGqpEW1RSfZMQL-BsQWxwhxRDNY=)
13. [reddit.com](https://vertexaisearch.cloud.google.com/grounding-api-redirect/AUZIYQHrPfmRmnyryhZzkyELg_M1AJpOp59s8h3Z-jyfRUQPyhLm9r41DFDxc49ZMyUkTDMcD95kgLLLaTjdhNwR9UA6nm3ONuy10UDcDChCXupgLuF_MfcuELwP6JmJ5G0IpKKVBpY-9zR-q9bByIJ5Q4SU0OtMGTfEoWcQu_NRdw0H-Eq9Er9GJ0r3rgvRn2c1gbsnq_nYqLf1ltSDFJC_w29C)
14. [fantasygrounds.com](https://vertexaisearch.cloud.google.com/grounding-api-redirect/AUZIYQFgP6_9Z7VmnrpACN9st8ifECXERf-Ww_jq3WrXcg6t3cAYTQCVAmjxeEceqYfzzIwweORSEQsCU-ayDh-QaNV7AN3Dz3WzfU3SfsnObl4uuavdY1_-y2Rk0spQVuBat9wl7FeHbpilgs2OGdKkw7HeOa-9EWpwsZmcsr2kLARW)
15. [rulesetwizard.com](https://vertexaisearch.cloud.google.com/grounding-api-redirect/AUZIYQEw6xpT-FYgxDnQ5daLkkuveYGrALTLozQBeYwqokNFb1AMXmCcBltyesKsCLk5VIQGUUc24zuDex0GtsgRAuFGz4mo1HJU9Zz8TPAtzV26DGEaqFU=)
16. [fantasygrounds.com](https://vertexaisearch.cloud.google.com/grounding-api-redirect/AUZIYQGHZ_MW9qBr0uu29ECbw5dtyim10ZxsCv5qhGza7fAcLHmuZDGXsNjuc-lfTp72AsRdCsbNOZbpOOgoEY7gEzYjsy5IXrlC6aefbg146pl9mnbSHYddozyIkApOEVubE_plk8PXlXmMvbekbpgWnVqBTrOm5G4Yzy9b0juwx1N_am5PYlc=)
17. [fantasygrounds.com](https://vertexaisearch.cloud.google.com/grounding-api-redirect/AUZIYQGQPW3bHhAYqgLV6dM_qJ8Cu9-LxlCqIUiJY3YgEUh5oYyoxMHbRV5hoxCdAgK5wGysK6CSR_qqAHmFPxJoY9tcCmZ0tcQouUBS-LzsBcUX9o7tIbO9BqzGgcNQMDQzfS8UPRmr_-F7qbPZt_plaTa2znWNa5vhyLRGuyVd-qPBVq_uwh59Qd1Wvn9kMusE8zlijmlslt8mjgEdNwYwoh3KaRf71kBDVOZWlRh0DfT3oA==)
18. [atlassian.net](https://vertexaisearch.cloud.google.com/grounding-api-redirect/AUZIYQEPwIzCb5I_BYXZ9bJMPG3gfX-pRQLyl5FzzxPe1J48xrwVwRMDMJhFnHzy30_3kExoR-jwOvTGsmRc6HANNG-JmMt-iiLN8P41esiiqFLXcz6eIM24RzLbJPfREiw8VjvGumYbsklLQoMSvCVpyX-ZGcDO9HQM6zjMs1WSsw6Oy-aMFeKOvrV24qT5JHw4__u_oh1jgqdapf7mOq2b0d7xVB88mfOj)
19. [fantasygrounds.com](https://vertexaisearch.cloud.google.com/grounding-api-redirect/AUZIYQE3hTA-x63Y9vBA2-FhPEldKA6d4TcenDCSz5ROglETF2cv1Ry2ddptHP80U8PBCs8BWerA5OmDqHIbe8L3Yj_zOKFXU2vfp6Et9CVuJjfXievQiYo4vsSi8pBRCPwLkpem8ocJKruVuuhL9DoRQO5yoS_HI2L8grI3OKN3OfpoCRzrcv6nrzTfuBecEKa4E4cpLmkKa0-ydqqQmfQ8CIaYCNViX44DD_s8rf1TA0GB6H7uz-C6chjMvJkOY7sr5EfY)
20. [atlassian.net](https://vertexaisearch.cloud.google.com/grounding-api-redirect/AUZIYQF7Gl9V_OTayeIBhgLfMsKjCdtp87sMHw3znBsCxi18zuLU1btPqccz6iUILw3RxD1oC7FXXFSSSOkb2ThobqRehoX5dHLJ8tI3di9naYlr5jnOmyIbH2Q_c3dcCzlSQL0j0aFKVsGpsjtQ-BktJo5EZarcBirXgaRe2aemT7SPjTAupaUJgDTTMxZzvqBa4ctBZoAw)
21. [fantasygrounds.com](https://vertexaisearch.cloud.google.com/grounding-api-redirect/AUZIYQGP3xds5JxWanNEEL8ELTLe8C8kx9hQNK727iGTo42wwOF_zB8W0XJ_n-lfM4I1Jzca-x2u3ACYshwQWEIHQIt2lygPdwy9azTRJlGDrqa9aZbG4NLlFJWdFY1dZj1h3RGGwLr_lyYZSlXfQADwfltkETHrRWIaTnMapocK9Q==)


---

> **Generated by Gemini Deep Research**  
> Query: # RESEARCH REQUEST

Generated: 2026-01-26
Project: Fantasy Grounds Extension Development Environment & Workflow

## CONTEXT

We are setting up a development environment for building Fantasy Grounds Unity (FGU) extensions on macOS. The project is a continuation of existing extension work. We have FGU v5.1.0 on Mac Studio with Apple M1 Ultra. We need to establish an efficient developer workflow for creating and testing extensions without manual app restarts and reload cycles.

Fantasy Grounds extensions are built with Lua 5.1 scripting and XML for UI/data definitions. The traditional development loop involves editing files, using /reload in the app, and checking the in-app console. This is slow. We need to discover: (1) if there's an API or socket interface to communicate with a running FGU instance, (2) how to set up hot-reloading or live refresh, (3) external tooling for real-time log monitoring, (4) IDE integrations for FG Lua/XML, and (5) best practices from experienced developers.

Technology Stack: Fantasy Grounds Unity v5.1.0, Lua 5.1 (sandboxed), XML, macOS on Apple Silicon, VS Code

## RESEARCH QUESTIONS

### Priority 1: Critical
1. Does Fantasy Grounds Unity expose any API, socket interface, or IPC mechanism that allows external tools to communicate with a running instance? Can extensions be reloaded programmatically, logs streamed externally, or commands sent to the client?

2. What is the most efficient development loop for FG extension developers? How do experienced developers iterate without constantly restarting? Is there hot-reload for individual Lua scripts or XML files?

3. How can FG's debug console output and logs be monitored externally in real-time? Is there a way to tail logs from outside the app?

### Priority 2: Important
4. What IDE extensions, plugins, or configurations are recommended for Fantasy Grounds Lua/XML development? VS Code extensions for FG-specific Lua APIs, XML schema validation?

5. What external tools or utilities do FG extension developers commonly use? File watchers, build scripts, testing frameworks, debugging proxies?

6. Is there documentation for Fantasy Grounds' internal Lua API beyond the official wiki? Community API references, type definitions, autocomplete configs?

7. How do developers test extensions without affecting production campaigns? Sandbox modes, test campaigns, mock data approaches?

### Priority 3: Strategic
8. Are there Fantasy Grounds development frameworks, boilerplates, or starter templates with modern tooling?

9. What is the workflow for debugging complex issues? Beyond Debug.console(), are there advanced techniques like remote debugging?

10. How do developers handle version compatibility when FG releases updates?

## SUCCESS CRITERIA
- Identify if real-time log monitoring is possible
- Find the fastest reload/refresh workflow
- Discover any API or automation capabilities
- Compile recommended tools and IDE configurations
- Document ideal FG extension development setup for macOS  
> Duration: 1047.94s (17.5 min)  
> Agent: deep-research-pro-preview-12-2025  
> Date: 2026-01-26 08:00:09 Local  
